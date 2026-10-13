"use strict";

import config from './config.mjs';

/* ============================================================================
 * KAORI-DB-NOTE — auth model as implemented in `.docsanddesign/DB-ERD.mwb`
 * (schema IHRMIS, `User Data` diagram). Applied 2026-10-02 via
 * `tools/mwb-edit.mjs apply --spec /tmp/opencode/auth-spec.json`
 * (new `alterColumns` op); `wbcheck` structural + type checks passed and
 * MySQL Workbench 8.0.47 opens the model cleanly (126 tables, 13 diagrams).
 * ----------------------------------------------------------------------------
 * DELTAS vs the original handoff (per owner decisions):
 * - `User.username` widened VARCHAR(100) -> VARCHAR(250): signup/login take
 *   emails (`User_Login.email` is 250), so 100 would truncate long addresses.
 * - `User.status` / `User_Login.provider` / `OAuth_Account.provider` are
 *   TINYINT UNSIGNED FKs to retained ENUM tables (NOT native MySQL ENUMs),
 *   so future statuses/providers need data rows, not DDL:
 *     ENUM_User_Status(status): 0: Not specified, 1: Active, 2: Inactive,
 *       3: Separated. `User.status` DEFAULT 1, RESTRICT on delete.
 *     ENUM_OAuth_Provider(provider): 0: Not specified, 1: Local, 2: Google,
 *       3: Microsoft 365. `User_Login.provider` DEFAULT 1, RESTRICT.
 *     ENUM_User_Type(user_type): 0: Not specified, 1: External, 2: Employee.
 *       `User.user_type` DEFAULT 1, RESTRICT. (Tabled for future user types.)
 *   `User.user_type` native ENUM dropped; `Verification_Token.purpose` stays
 *   native ENUM('signup','verify_alt','reset','link') (a purpose, not a ref).
 * - `User.password_hash` VARCHAR(255) NN (argon2); + `failed_attempts`,
 *   `locked_until`, `created_at` (DEFAULT CURRENT_TIMESTAMP), `updated_at`
 *   (DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP — folded into the
 *   default expression: GRT has no column-level ON UPDATE key, Workbench
 *   forward-engineers `DEFAULT <value>` verbatim so the SQL stays valid).
 * - `Verification_Token` gains lookup index `idx_Verification_Token_hash`
 *   (verifyUser looks tokens up by hash); `loginId`/`granted_by`/`decided_by`
 *   intentionally carry NO FK (insert-ordering); table/column names match this
 *   file's queries exactly. All user-owned rows CASCADE from User; shared
 *   refs (Role, Right, ENUMs) are RESTRICT. Junctions use composite PKs.
 * ----------------------------------------------------------------------------
 * ACTION ITEMS — status 2026-10-12 (Kaori):
 * 1. DONE (Duke 67b45ab): id-maps + runtime loadEnumMaps; string guards now
 *    resolve to ids. Public signatures unchanged.
 * 2. SUPERSEDED 2026-10-13 (owner): model rows are canonical AND the only
 *    writer. `src/tools/seed-janus.mjs` retired 2026-10-13 (backup:
 *    `tools/backups/seed-janus.mjs`) and removed; `seed:janus` npm script
 *    removed with it. `Role_Right` grants stay a manual deploy step until
 *    they can live in the model against fixed Role/Right ids.
 * 3. OPEN (owner, Workbench Inserts tab): Role/Right descriptions + any
 *    remaining rows; then schema.sql carries everything automatically.
 * 4. OPEN (Duke): approveUnlink guard is vacuous (always true); verifyOAuthUser
 *    double-gate rejects the microsoft365 aliases the mapper accepts;
 *    loadEnumMaps derives a junk 'not'->0 key. Non-blocking nits.
 * 5. OPEN (DBA): live schema + app user still not created (see db/README.md).
 * BACKLOG (not this pass): one-go conversion of ENUM tables — at minimum the
 * three new ones, possibly all `ENUM_*` — to native MySQL ENUM types.
 * ----------------------------------------------------------------------------
 * NOTES: keep `Email_Address` (Person contact) separate from `User_Login`
 * (auth identity). DepEd users MAY keep non-DepEd alt local emails; they just
 * may never use a @deped.gov.ph address in the email-login path. PM_Role and
 * ENUM_PM_Role are performance-cycle roles — DO NOT reuse for system RBAC.
 * ============================================================================
 */

const DEPED_SUFFIX = `@${(config.janus?.depedDomain || 'deped.gov.ph').toLowerCase()}`;
const MAX_ALT_LOGINS = config.janus?.maxAltLogins ?? 3;
const SEED_ROLES = ['JOB_APPLICANT', 'EXTERNAL_USER', 'REGULAR_EMPLOYEE', 'HRMO', 'SYSTEM_ADMIN'];

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
            // TODO: start OIDC Authorization Code + PKCE flow via openid-client/jose.
            // Enforce hd/tenant = deped.gov.ph; callback must call verifyOAuthUser().
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
        // TODO(Kaori tables landed): lookup User_Login+User, check status/lockout,
        // argon2-verify password_hash, rotate session, update failed_attempts.
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
        // TODO: create User + User_Login(is_verified=0) + Verification_Token, send SMTP link.
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
        // TODO: argon2.verify(storedHash, password) via NABU User_Login join.
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

    // --- User management; username should be an email address ---

    signup(username) { // for email sign-ups only; sends email to specified email address with verification link
        const email = normalizeEmail(username);
        const warning = emailLoginWarning(email);
        if (warning) throw new Error(warning);
        // TODO: INSERT User(user_type=<USER_TYPE.external=1>, status=<USER_STATUS.active=1>) + User_Login(provider=1) + Verification_Token(purpose='signup'); nodemailer send.
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
        // TODO: JWKS-validate id_token (iss/aud/exp, hd=deped.gov.ph), then:
        // SELECT/INSERT OAuth_Account SET provider=<providerId>, deped_email=<email>;
        // link to existing User on verified alt-email match, else INSERT User(user_type=<USER_TYPE.employee>).
        this.#logger?.info(`JANUS verifyOAuthUser (stub): ${email} via ${provider} (provider_id=${providerId})`);
        return false;
    }

    linkOAuthAccount(userId, provider, subject, depedEmail) {
        // Both Google and MS365 DepEd accounts may link to the SAME user.
        const providerId = oAuthProviderId(provider);
        if (![OAUTH_PROVIDER.google, OAUTH_PROVIDER.ms365].includes(providerId)) throw new Error(`Unknown provider: ${provider}`);
        if (!isDepEdEmail(depedEmail)) throw new Error(`Only ${DEPED_SUFFIX} addresses can be linked via ${provider}.`);
        this.#logger?.info(`JANUS linkOAuthAccount (stub): user=${userId} ${provider}:${normalizeEmail(depedEmail)} (provider_id=${providerId})`);
        // TODO: INSERT INTO OAuth_Account(userId, provider=<providerId>, subject, deped_email).
    }

    requestUnlink(userId, oauthId) {
        // Account unlinking: user requests, sysadmin approves (users.link.approve right).
        this.#logger?.info(`JANUS unlink requested (stub): user=${userId} oauth=${oauthId}`);
        // TODO: INSERT INTO Unlink_Request(userId, oauthId, status='pending').
    }

    approveUnlink(requestId, approverId, approve = true) {
        // Unlink_Request.status is a native ENUM('pending','approved','rejected') — no id-map needed.
        if (!UNLINK_STATUS.includes(approve ? 'approved' : 'rejected')) throw new Error('Invalid unlink decision.');
        this.#logger?.info(`JANUS unlink ${approve ? 'approved' : 'rejected'} (stub): req=${requestId} by=${approverId}`);
        // TODO: check approver has users.link.approve / roles.assign; UPDATE Unlink_Request SET status, decided_by, decided_at;
        // on approve DELETE OAuth_Account row (never auto-unlink active employee without audit).
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
        // TODO: SELECT COUNT(*) FROM User_Login WHERE userId=? AND provider=<OAUTH_PROVIDER.local=1> AND is_primary=0;
        // throw if >= MAX_ALT_LOGINS; INSERT (provider=1) + Verification_Token(purpose='verify_alt').
        this.#logger?.info(`JANUS addLogin (stub): user=${userId} alt=${alt} (limit ${MAX_ALT_LOGINS}, provider_id=${OAUTH_PROVIDER.local})`);
    }

    removeLogin(userId, email) {
        this.#logger?.info(`JANUS removeLogin (stub): user=${userId} email=${normalizeEmail(email)}`);
        // TODO: DELETE FROM User_Login WHERE userId AND email (never delete last verified login).
    }

    addRole(username, role) {
        if (!SEED_ROLES.includes(role) && !/^[A-Z0-9_]+$/.test(String(role || ''))) {
            throw new Error(`Unknown role: ${role}`);
        }
        this.#logger?.info(`JANUS addRole (stub): ${normalizeEmail(username)} <- ${role}`);
        // TODO: require caller right roles.assign; INSERT INTO User_Role.
    }

    removeRole(username, role) {
        this.#logger?.info(`JANUS removeRole (stub): ${normalizeEmail(username)} -/-> ${role}`);
        // TODO: require caller right roles.assign; DELETE FROM User_Role (guard last-admin).
    }

    assignRight(username, right, granted = true) {
        // A user with rights.assign may modify others' rights (limited scope);
        // roles.assign may assign/remove both rights and roles.
        this.#logger?.info(`JANUS assignRight (stub): ${normalizeEmail(username)} ${granted ? '+=' : '-='} ${right}`);
        // TODO: upsert User_Right(granted); enforce scope limits for rights.assign callers.
    }

    mergeUsers(username1, username2, mergedData = {}) { // USE WITH CAUTION
        this.#logger?.warn(`JANUS mergeUsers (stub): ${normalizeEmail(username1)} + ${normalizeEmail(username2)}`);
        // TODO: sysadmin-only; re-point User_Login/OAuth_Account/User_Role/User_Right, keep audit trail.
    }

    setUserStatus(username, status) { // 'active'->1, 'inactive'->2, 'separated'->3 (ENUM_User_Status).
        const statusId = userStatusId(status); // throws on unknown
        this.#logger?.info(`JANUS setUserStatus (stub): ${normalizeEmail(username)} -> ${status} (status_id=${statusId})`);
        // TODO: UPDATE User SET status=<statusId> WHERE username=?; separated employees keep record, lose access.
    }

    deleteUser(username) { // USE WITH CAUTION — external accounts only per Workflows.md:325
        this.#logger?.warn(`JANUS deleteUser (stub): ${normalizeEmail(username)}`);
        // TODO: SELECT user_type FROM User; allow only user_type=<USER_TYPE.external=1>
        // (or separated+unlinked); else throw; cascade via FKs + audit.
    }
}
