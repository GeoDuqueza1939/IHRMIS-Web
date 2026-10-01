"use strict";

import config from './config.mjs';

/* ============================================================================
 * KAORI-DB-HANDOFF — instructions for OpenCode agent `Kaori` (DB model owner)
 * ----------------------------------------------------------------------------
 * CONTEXT
 * JANUS (Joint Authentication and Navigation for Unified Services) manages
 * user accounts + authentication. The `User` table already exists in
 * `.docsanddesign/DB-ERD.mwb` (schema IHRMIS, `User Data` diagram) and may be
 * ALTERed when necessary. Current shape (see `tools/mwb-edit.mjs digest`):
 *   User(userId BIGINT UNSIGNED PK AI, username VARCHAR(100) UNIQUE NN,
 *        password_hash VARCHAR(100) NN, initial_login BOOL DEFAULT 1,
 *        personId FK->Person CASCADE)
 * There are NO Role / Right / login / OAuth / token tables yet. PM_Role and
 * ENUM_PM_Role are performance-cycle roles — DO NOT reuse for system RBAC.
 *
 * WHAT KAORI SHOULD DO
 * 1. `node tools/mwb-edit.mjs digest --mwb .docsanddesign/DB-ERD.mwb`
 *    to confirm the `User` table and `User Data` diagram (2 figs, 1 conn).
 * 2. Apply changes ONLY via `tools/mwb-edit.mjs apply --mwb <in> --spec <json>
 *    --out <out>` (never hand-edit document.mwb.xml). Place new tables on the
 *    `User Data` diagram. Keep conventions: InnoDB, `BIGINT UNSIGNED AI` PKs,
 *    `fk_<Child>_<Parent><n>` FK names, `NO ACTION/RESTRICT` on ref tables,
 *    `CASCADE` from User -> child rows.
 * 3. Run `wbcheck` / roundtrip and ensure Workbench opens the model cleanly.
 * 4. Report back table/column deltas + the edits.json spec used.
 *
 * REQUIRED MODEL (illustrative DDL — translate to addTables/addColumns/
 * addForeignKeys spec; keep names exactly as below so janus.mjs queries match)
 *
 * -- 1) ALTER User: wider hash for argon2 + lifecycle + audit timestamps.
 * ALTER TABLE `User`
 *   MODIFY `password_hash` VARCHAR(255) NOT NULL,
 *   ADD COLUMN `status` ENUM('active','inactive','separated') NOT NULL DEFAULT 'active',
 *   ADD COLUMN `user_type` ENUM('external','employee') NOT NULL DEFAULT 'external',
 *   ADD COLUMN `failed_attempts` INT UNSIGNED NOT NULL DEFAULT 0,
 *   ADD COLUMN `locked_until` DATETIME NULL,
 *   ADD COLUMN `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 *   ADD COLUMN `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
 *     ON UPDATE CURRENT_TIMESTAMP;
 *
 * -- 2) Role = named collection of rights. Seed: JOB_APPLICANT,
 * --    EXTERNAL_USER, REGULAR_EMPLOYEE, HRMO, SYSTEM_ADMIN.
 * CREATE TABLE `Role` (`roleId` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 *   `code` VARCHAR(50) NOT NULL UNIQUE, `name` VARCHAR(100) NOT NULL,
 *   `description` LONGTEXT) ENGINE=InnoDB;
 * CREATE TABLE `Right` (`rightId` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 *   `code` VARCHAR(80) NOT NULL UNIQUE, `name` VARCHAR(120) NOT NULL,
 *   `description` LONGTEXT) ENGINE=InnoDB;
 * --    Seed rights (minimum): `rights.assign` (edit others' rights, limited),
 * --    `roles.assign` (assign/remove roles AND rights), `users.manage`,
 * --    `users.link.approve` (approve unlink requests).
 * CREATE TABLE `Role_Right` (`roleId` BIGINT UNSIGNED NOT NULL,
 *   `rightId` BIGINT UNSIGNED NOT NULL, PRIMARY KEY(`roleId`,`rightId`),
 *   FOREIGN KEY (`roleId`) REFERENCES `Role`(`roleId`) ON DELETE CASCADE,
 *   FOREIGN KEY (`rightId`) REFERENCES `Right`(`rightId`) ON DELETE CASCADE
 * ) ENGINE=InnoDB;
 * CREATE TABLE `User_Role` (`userId` BIGINT UNSIGNED NOT NULL,
 *   `roleId` BIGINT UNSIGNED NOT NULL, `granted_by` BIGINT UNSIGNED NULL,
 *   `granted_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 *   PRIMARY KEY(`userId`,`roleId`),
 *   FOREIGN KEY (`userId`) REFERENCES `User`(`userId`) ON DELETE CASCADE,
 *   FOREIGN KEY (`roleId`) REFERENCES `Role`(`roleId`) ON DELETE RESTRICT
 * ) ENGINE=InnoDB;
 * CREATE TABLE `User_Right` (`userId` BIGINT UNSIGNED NOT NULL,
 *   `rightId` BIGINT UNSIGNED NOT NULL, `granted` BOOLEAN NOT NULL DEFAULT 1,
 *   PRIMARY KEY(`userId`,`rightId`),
 *   FOREIGN KEY (`userId`) REFERENCES `User`(`userId`) ON DELETE CASCADE,
 *   FOREIGN KEY (`rightId`) REFERENCES `Right`(`rightId`) ON DELETE CASCADE
 * ) ENGINE=InnoDB;
 *
 * -- 3) Local logins: 1 primary + up to 3 alt NON-DepEd emails per user.
 * --    App-enforced (janus.mjs): reject `%@deped.gov.ph` for provider='local'.
 * CREATE TABLE `User_Login` (`loginId` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 *   `userId` BIGINT UNSIGNED NOT NULL, `email` VARCHAR(250) NOT NULL UNIQUE,
 *   `is_primary` BOOLEAN NOT NULL DEFAULT 0, `is_verified` BOOLEAN NOT NULL DEFAULT 0,
 *   `provider` ENUM('local','google','ms365') NOT NULL DEFAULT 'local',
 *   FOREIGN KEY (`userId`) REFERENCES `User`(`userId`) ON DELETE CASCADE
 * ) ENGINE=InnoDB;
 *
 * -- 4) DepEd SSO links: one row per (provider, subject); both Google and
 * --    MS365 DepEd accounts may link to the SAME User. Unlink = user requests,
 * --    sysadmin approves (see `Unlink_Request`).
 * CREATE TABLE `OAuth_Account` (`oauthId` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 *   `userId` BIGINT UNSIGNED NOT NULL, `provider` ENUM('google','ms365') NOT NULL,
 *   `subject` VARCHAR(255) NOT NULL, `deped_email` VARCHAR(250) NOT NULL,
 *   UNIQUE(`provider`,`subject`), UNIQUE(`provider`,`deped_email`),
 *   FOREIGN KEY (`userId`) REFERENCES `User`(`userId`) ON DELETE CASCADE
 * ) ENGINE=InnoDB;
 * CREATE TABLE `Unlink_Request` (`requestId` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 *   `userId` BIGINT UNSIGNED NOT NULL, `oauthId` BIGINT UNSIGNED NOT NULL,
 *   `status` ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending',
 *   `requested_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 *   `decided_by` BIGINT UNSIGNED NULL, `decided_at` DATETIME NULL,
 *   FOREIGN KEY (`userId`) REFERENCES `User`(`userId`) ON DELETE CASCADE,
 *   FOREIGN KEY (`oauthId`) REFERENCES `OAuth_Account`(`oauthId`) ON DELETE CASCADE
 * ) ENGINE=InnoDB;
 * CREATE TABLE `Verification_Token` (`tokenId` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 *   `userId` BIGINT UNSIGNED NOT NULL, `loginId` BIGINT UNSIGNED NULL,
 *   `token_hash` CHAR(64) NOT NULL, `purpose` ENUM('signup','verify_alt','reset','link') NOT NULL,
 *   `expires_at` DATETIME NOT NULL, `used_at` DATETIME NULL,
 *   FOREIGN KEY (`userId`) REFERENCES `User`(`userId`) ON DELETE CASCADE
 * ) ENGINE=InnoDB;
 *
 * NOTES: keep `Email_Address` (Person contact) separate from `User_Login`
 * (auth identity). DepEd users MAY keep non-DepEd alt local emails; they just
 * may never use a @deped.gov.ph address in the email-login path.
 * ============================================================================
 */

const DEPED_SUFFIX = `@${(config.janus?.depedDomain || 'deped.gov.ph').toLowerCase()}`;
const MAX_ALT_LOGINS = config.janus?.maxAltLogins ?? 3;
const SEED_ROLES = ['JOB_APPLICANT', 'EXTERNAL_USER', 'REGULAR_EMPLOYEE', 'HRMO', 'SYSTEM_ADMIN'];

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
            res.render('login3', {
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
            this.#controller.addCustomRoute('get', `${b}/signup`, (req, res) => res.render('login3', {
                baseDir: config.baseDir, username: '', password: '', error: '', warning: 'Signup uses email verification (pending SMTP config).',
            }));
            this.#controller.addCustomRoute('post', `${b}/signup`, this.#handleSignup.bind(this));
            this.#controller.addCustomRoute('get', `${b}/auth/google`, passport('google'));
            this.#controller.addCustomRoute('get', `${b}/auth/ms365`, passport('ms365'));
            this.#controller.addCustomRoute('get', `${b}/forgot`, (req, res) => res.render('login3', {
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
            return res.status(400).render('login3', {
                baseDir: config.baseDir, username, password: '', error: '', warning,
            });
        }
        // TODO(Kaori tables landed): lookup User_Login+User, check status/lockout,
        // argon2-verify password_hash, rotate session, update failed_attempts.
        this.#logger?.info(`JANUS email-login attempt: ${username}`);
        return res.status(501).render('login3', {
            baseDir: config.baseDir, username, password: '',
            error: 'Email sign-in is not fully wired yet (pending User_Login tables + argon2).',
            warning: '',
        });
    }

    async #handleSignup(req, res) {
        const username = normalizeEmail(req.body?.username);
        const warning = emailLoginWarning(username);
        if (warning) {
            return res.status(400).render('login3', {
                baseDir: config.baseDir, username, password: '', error: '', warning,
            });
        }
        // TODO: create User + User_Login(is_verified=0) + Verification_Token, send SMTP link.
        this.#logger?.info(`JANUS signup attempt: ${username}`);
        return res.status(501).render('login3', {
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
        // TODO: insert User(user_type=external) + User_Login + Verification_Token(purpose=signup); nodemailer send.
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
        if (!['google', 'ms365'].includes(provider)) throw new Error(`Unknown provider: ${provider}`);
        if (!isDepEdEmail(email)) throw new Error(`Only ${DEPED_SUFFIX} accounts may use ${provider} sign-in.`);
        if (!token) throw new Error('IdP token is required.');
        // TODO: JWKS-validate id_token (iss/aud/exp, hd=deped.gov.ph), upsert OAuth_Account,
        // link to existing User on verified alt-email match, else create User(user_type=employee).
        this.#logger?.info(`JANUS verifyOAuthUser (stub): ${email} via ${provider}`);
        return false;
    }

    linkOAuthAccount(userId, provider, subject, depedEmail) {
        // Both Google and MS365 DepEd accounts may link to the SAME user.
        if (!['google', 'ms365'].includes(provider)) throw new Error(`Unknown provider: ${provider}`);
        if (!isDepEdEmail(depedEmail)) throw new Error(`Only ${DEPED_SUFFIX} addresses can be linked via ${provider}.`);
        this.#logger?.info(`JANUS linkOAuthAccount (stub): user=${userId} ${provider}:${normalizeEmail(depedEmail)}`);
        // TODO: INSERT INTO OAuth_Account(userId, provider, subject, deped_email).
    }

    requestUnlink(userId, oauthId) {
        // Account unlinking: user requests, sysadmin approves (users.link.approve right).
        this.#logger?.info(`JANUS unlink requested (stub): user=${userId} oauth=${oauthId}`);
        // TODO: INSERT INTO Unlink_Request(userId, oauthId, status='pending').
    }

    approveUnlink(requestId, approverId, approve = true) {
        this.#logger?.info(`JANUS unlink ${approve ? 'approved' : 'rejected'} (stub): req=${requestId} by=${approverId}`);
        // TODO: check approver has users.link.approve / roles.assign; UPDATE Unlink_Request;
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
        // TODO: SELECT COUNT(*) FROM User_Login WHERE userId AND provider='local' AND is_primary=0;
        // throw if >= MAX_ALT_LOGINS; INSERT + Verification_Token(purpose=verify_alt).
        this.#logger?.info(`JANUS addLogin (stub): user=${userId} alt=${alt} (limit ${MAX_ALT_LOGINS})`);
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

    setUserStatus(username, status) { // set to active, inactive, or separated.
        if (!['active', 'inactive', 'separated'].includes(status)) throw new Error(`Unknown status: ${status}`);
        this.#logger?.info(`JANUS setUserStatus (stub): ${normalizeEmail(username)} -> ${status}`);
        // TODO: UPDATE User SET status; separated employees keep record, lose access.
    }

    deleteUser(username) { // USE WITH CAUTION — external accounts only per Workflows.md:325
        this.#logger?.warn(`JANUS deleteUser (stub): ${normalizeEmail(username)}`);
        // TODO: allow only user_type=external (or separated+unlinked); else throw; cascade via FKs + audit.
    }
}
