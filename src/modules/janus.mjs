"use strict";

import config from './config.mjs';

/* Auth model, schema deltas and design rationale: see DevNotes.md
   ("KAORI-DB-NOTE", Geo). */

const DEPED_SUFFIX = `@${(config.janus?.depedDomain || 'deped.gov.ph').toLowerCase()}`;
const MAX_ALT_LOGINS = config.janus?.maxAltLogins ?? 3;

/* ----------------------------------------------------------------------------
 * ENUM id-maps (Duke follow-up to KAORI-DB-NOTE action item #1).
 * `User.status`, `User.user_type`, `User_Login.provider`, and
 * `OAuth_Account.provider` are TINYINT FKs, NOT native ENUMs. Source of truth
 * is the table COMMENTs + Inserts-tab rows in DB-ERD.mwb.
 * App code must use these ids in SQL; the string helpers below keep the
 * public method signatures stable (accept 'active' etc., resolve to id).
 * Prefer `loadEnumMaps(db)` at runtime over these static defaults when the
 * DB is reachable, so future rows need no code change.
 * ----------------------------------------------------------------------------
 */
export const USER_STATUS = Object.freeze({ unspecified: 0, active: 1, inactive: 2, separated: 3 });
export const USER_TYPE = Object.freeze({ unspecified: 0, external: 1, employee: 2 });
export const OAUTH_PROVIDER = Object.freeze({ unspecified: 0, local: 1, google: 2, ms365: 3 });
export const UNLINK_STATUS = Object.freeze(['pending', 'approved', 'rejected']);

export function userStatusId(status) {
    const id = USER_STATUS[String(status || '').toLowerCase()];
    if (id === undefined) throw new Error(`Unknown status: ${status}`);
    return id;
}

export function userTypeId(type) {
    const id = USER_TYPE[String(type || '').toLowerCase()];
    if (id === undefined) throw new Error(`Unknown user_type: ${type}`);
    return id;
}

export function oAuthProviderId(provider) {
    const key = String(provider || '').toLowerCase();
    const alias = key === 'microsoft365' || key === 'microsoft_365' ? 'ms365' : key;
    const id = OAUTH_PROVIDER[alias];
    if (id === undefined) throw new Error(`Unknown provider: ${provider}`);
    return id;
}

/** Refresh id-maps from the ENUM tables so new rows need no code change. */
export async function loadEnumMaps(db) {
    if (!db) return { USER_STATUS, USER_TYPE, OAUTH_PROVIDER };
    const maps = { USER_STATUS: { ...USER_STATUS }, USER_TYPE: { ...USER_TYPE }, OAUTH_PROVIDER: { ...OAUTH_PROVIDER } };
    try {
        const [statusRows] = await db.query('SELECT `status`, `name` FROM `ENUM_User_Status`');
        for (const r of statusRows || []) maps.USER_STATUS[String(r.name || '').toLowerCase().split(' ')[0]] = r.status;
    } catch { /* keep static defaults when tables are not seeded yet */ }
    try {
        const [typeRows] = await db.query('SELECT `user_type`, `name` FROM `ENUM_User_Type`');
        for (const r of typeRows || []) maps.USER_TYPE[String(r.name || '').toLowerCase()] = r.user_type;
    } catch { /* keep static defaults */ }
    try {
        const [provRows] = await db.query('SELECT `provider`, `name` FROM `ENUM_OAuth_Provider`');
        for (const r of provRows || []) {
            const n = String(r.name || '').toLowerCase();
            maps.OAUTH_PROVIDER[n.includes('microsoft') ? 'ms365' : n] = r.provider;
        }
    } catch { /* keep static defaults */ }
    return maps;
}

export function normalizeEmail(email) {
    return String(email || '').trim().toLowerCase();
}

export function isDepEdEmail(email) {
    return normalizeEmail(email).endsWith(DEPED_SUFFIX);
}

export function emailLoginWarning(email) {
    if (isDepEdEmail(email)) {
        return `DepEd accounts (${DEPED_SUFFIX}) cannot sign in with email + password. Please use "Sign in with DepEd Google" or "Sign in with Microsoft 365" instead.`;
    }
    return '';
}

export default class janus {
    app_name = 'IHRMIS';
    module_name = 'Joint Authentication and Navigation for Unified Services';
    module_shortname = 'JANUS';

    #ihrmis_app = null;
    #logger = null;
    #controller = null;
    #janus_url = '';

    // Known role codes (model-canonical: Role.code rows). Refreshed from the
    // Role table via loadRoles() once the database is online; the static
    // defaults below apply until then.
    seedRoles = ['JOB_APPLICANT', 'EXT_USER', 'REG_EMP', 'HRMO', 'SYS_ADMIN', 'TOP_MGMT'];

    constructor(ihrmis_app) {
        this.#ihrmis_app = ihrmis_app;
        this.#logger = this.#ihrmis_app.getLogger(this);
        this.#controller = this.#ihrmis_app.getController(this);
        this.#janus_url = `${config.baseDir}/janus`;
        this.#setupRoutes();
    }

    #db() {
        try {
            return this.#ihrmis_app?.getDatabase?.(this) ?? null;
        } catch {
            return null;
        }
    }

    #setupRoutes() {
        if (!this.#controller) return;
        const b = this.#janus_url;
        const renderLogin = (req, res) => {
            this.#logger?.info(`JANUS login page: ${req.method} ${req.url}`);
            res.render('login31', {
                baseDir: config.baseDir,
                username: req.body?.username || '',
                password: '',
                error: '',
                warning: '',
            });
        };
        const passport = (provider) => (req, res) => {
            this.#logger?.info(`JANUS SSO start: provider=${provider}`);
            res.status(501).render('error', {
                baseDir: config.baseDir, app_name: config.shortname, statusCode: 501,
                message: `${provider} sign-in is not configured yet (see config.oidc).`,
            });
        };
        try {
            this.#controller.addCustomRoute('get', `${b}/login`, renderLogin);
            this.#controller.addCustomRoute('post', `${b}/login`, this.#handleEmailLogin.bind(this));
            this.#controller.addCustomRoute('get', `${b}/logout`, (req, res) => res.redirect(`${b}/login`));
            this.#controller.addCustomRoute('get', `${b}/signup`, (req, res) => res.render('login31', {
                baseDir: config.baseDir, username: '', password: '', error: '', warning: 'Signup uses email verification (pending SMTP config).',
            }));
            this.#controller.addCustomRoute('post', `${b}/signup`, this.#handleSignup.bind(this));
            this.#controller.addCustomRoute('get', `${b}/auth/google`, passport('google'));
            this.#controller.addCustomRoute('get', `${b}/auth/ms365`, passport('ms365'));
            this.#controller.addCustomRoute('get', `${b}/forgot`, (req, res) => res.render('login31', {
                baseDir: config.baseDir, username: '', password: '', error: '', warning: 'Password reset via email link (pending SMTP config).',
            }));
        } catch (err) {
            this.#logger?.error(`JANUS route setup failed: ${err?.message ?? String(err)}`);
        }
    }

    async #handleEmailLogin(req, res) {
        const username = normalizeEmail(req.body?.username);
        const warning = emailLoginWarning(username);
        if (warning) {
            this.#logger?.warn(`JANUS email-login blocked for DepEd address: ${username}`);
            return res.status(400).render('login31', {
                baseDir: config.baseDir, username, password: '', error: '', warning,
            });
        }
        this.#logger?.info(`JANUS email-login attempt: ${username}`);
        return res.status(501).render('login31', {
            baseDir: config.baseDir, username, password: '',
            error: 'Email sign-in is not fully wired yet (pending User_Login tables + argon2).',
            warning: '',
        });
    }

    async #handleSignup(req, res) {
        const username = normalizeEmail(req.body?.username);
        const warning = emailLoginWarning(username);
        if (warning) {
            return res.status(400).render('login31', {
                baseDir: config.baseDir, username, password: '', error: '', warning,
            });
        }
        this.#logger?.info(`JANUS signup attempt: ${username}`);
        return res.status(501).render('login31', {
            baseDir: config.baseDir, username, password: '',
            error: 'Signup email verification is pending (SMTP + Verification_Token).',
            warning: '',
        });
    }

    // --- Auth primitives (DB integration behind #db(); validation is live) ---

    login(username, signInMethod) {
        const email = normalizeEmail(username);
        if (signInMethod === 'email' && isDepEdEmail(email)) {
            throw new Error(emailLoginWarning(email));
        }
        if (!['email', 'google', 'ms365'].includes(signInMethod)) {
            throw new Error(`Unknown sign-in method: ${signInMethod}`);
        }
        return { email, signInMethod };
    }

    verifyPassword(username, password) { // for email logins only
        const email = normalizeEmail(username);
        const warning = emailLoginWarning(email);
        if (warning) throw new Error(warning);
        if (!password) throw new Error('Password is required.');
        this.#logger?.info(`JANUS verifyPassword (stub): ${email}`);
        return false;
    }

    verifyToken(username, token) { // legacy DepEd token hook; prefer verifyOAuthUser
        if (!token) throw new Error('Token is required.');
        this.#logger?.info(`JANUS verifyToken (stub): ${normalizeEmail(username)}`);
        return false;
    }

    logout() {
        // Session destroy happens in route layer (express-session store).
        this.#logger?.info('JANUS logout');
    }

    /** Refresh known role codes from the Role table once the DB is online.
     *  Keeps static defaults when unreachable, mirroring loadEnumMaps(). */
    async loadRoles(db) {
        const source = db ?? this.#db();
        if (!source) return [...this.seedRoles];
        try {
            const [rows] = await source.query('SELECT `code` FROM `Role`');
            const codes = (rows || []).map((r) => r.code).filter(Boolean);
            if (codes.length) this.seedRoles = codes;
        } catch {
            /* keep static defaults */
        }
        return [...this.seedRoles];
    }

    // --- User management; username should be an email address ---

    signup(username) { // for email sign-ups only; sends email to specified email address with verification link
        const email = normalizeEmail(username);
        const warning = emailLoginWarning(email);
        if (warning) throw new Error(warning);
        this.#logger?.info(`JANUS signup (stub): ${email}`);
    }

    addUser(username) { // for user management by System Admin; sends email to specified email address with verification link
        const email = normalizeEmail(username);
        const warning = emailLoginWarning(email);
        if (warning) throw new Error(warning);
        this.#logger?.info(`JANUS addUser (stub): ${email}`);
    }

    verifyUser(username, token, newPassword) { // token is identified in the URL
        if (!token) throw new Error('Verification token is required.');
        if (!newPassword) throw new Error('New password is required.');
        this.#logger?.info(`JANUS verifyUser (stub): ${normalizeEmail(username)}`);
    }

    verifyOAuthUser(username, token, provider) { // token from identity provider
        const email = normalizeEmail(username);
        const providerId = oAuthProviderId(provider); // throws on unknown; 'google'->2, 'ms365'->3
        if (!['google', 'ms365'].includes(String(provider).toLowerCase())) throw new Error(`Unknown provider: ${provider}`);
        if (!isDepEdEmail(email)) throw new Error(`Only ${DEPED_SUFFIX} accounts may use ${provider} sign-in.`);
        if (!token) throw new Error('IdP token is required.');
        this.#logger?.info(`JANUS verifyOAuthUser (stub): ${email} via ${provider} (provider_id=${providerId})`);
        return false;
    }

    linkOAuthAccount(userId, provider, subject, depedEmail) {
        // Both Google and MS365 DepEd accounts may link to the SAME user.
        const providerId = oAuthProviderId(provider);
        if (![OAUTH_PROVIDER.google, OAUTH_PROVIDER.ms365].includes(providerId)) throw new Error(`Unknown provider: ${provider}`);
        if (!isDepEdEmail(depedEmail)) throw new Error(`Only ${DEPED_SUFFIX} addresses can be linked via ${provider}.`);
        this.#logger?.info(`JANUS linkOAuthAccount (stub): user=${userId} ${provider}:${normalizeEmail(depedEmail)} (provider_id=${providerId})`);
    }

    requestUnlink(userId, oauthId) {
        // Account unlinking: user requests, sysadmin approves (users.link.approve right).
        this.#logger?.info(`JANUS unlink requested (stub): user=${userId} oauth=${oauthId}`);
    }

    approveUnlink(requestId, approverId, approve = true) {
        // Unlink_Request.status is a native ENUM('pending','approved','rejected') — no id-map needed.
        if (!UNLINK_STATUS.includes(approve ? 'approved' : 'rejected')) throw new Error('Invalid unlink decision.');
        this.#logger?.info(`JANUS unlink ${approve ? 'approved' : 'rejected'} (stub): req=${requestId} by=${approverId}`);
    }

    changePassword(username, oldPassword, newPassword) { // for email logins only
        const email = normalizeEmail(username);
        const warning = emailLoginWarning(email);
        if (warning) throw new Error(warning);
        if (!newPassword) throw new Error('New password is required.');
        this.#logger?.info(`JANUS changePassword (stub): ${email}`);
    }

    addLogin(userId, email) { // add alternative email for login use (max 3 alts, non-DepEd only)
        const alt = normalizeEmail(email);
        const warning = emailLoginWarning(alt);
        if (warning) throw new Error(warning);
        this.#logger?.info(`JANUS addLogin (stub): user=${userId} alt=${alt} (limit ${MAX_ALT_LOGINS}, provider_id=${OAUTH_PROVIDER.local})`);
    }

    removeLogin(userId, email) {
        this.#logger?.info(`JANUS removeLogin (stub): user=${userId} email=${normalizeEmail(email)}`);
    }

    addRole(username, role) {
        if (!this.seedRoles.includes(role) && !/^[A-Z0-9_]+$/.test(String(role || ''))) {
            throw new Error(`Unknown role: ${role}`);
        }
        this.#logger?.info(`JANUS addRole (stub): ${normalizeEmail(username)} <- ${role}`);
    }

    removeRole(username, role) {
        this.#logger?.info(`JANUS removeRole (stub): ${normalizeEmail(username)} -/-> ${role}`);
    }

    assignRight(username, right, granted = true) {
        // A user with rights.assign may modify others' rights (limited scope);
        // roles.assign may assign/remove both rights and roles.
        this.#logger?.info(`JANUS assignRight (stub): ${normalizeEmail(username)} ${granted ? '+=' : '-='} ${right}`);
    }

    mergeUsers(username1, username2, mergedData = {}) { // USE WITH CAUTION
        this.#logger?.warn(`JANUS mergeUsers (stub): ${normalizeEmail(username1)} + ${normalizeEmail(username2)}`);
    }

    setUserStatus(username, status) { // 'active'->1, 'inactive'->2, 'separated'->3 (ENUM_User_Status).
        const statusId = userStatusId(status); // throws on unknown
        this.#logger?.info(`JANUS setUserStatus (stub): ${normalizeEmail(username)} -> ${status} (status_id=${statusId})`);
    }

    deleteUser(username) { // USE WITH CAUTION — external accounts only per Workflows.md:325
        this.#logger?.warn(`JANUS deleteUser (stub): ${normalizeEmail(username)}`);
    }
}
