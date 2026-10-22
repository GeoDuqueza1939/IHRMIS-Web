# IHRMIS — To-Do

> Consolidated work items for the IHRMIS project. Single source of truth for
> what is outstanding, what was just finished, and what is being proposed for
> removal. Supersedes inline `TODO` comments in the source and the `TODO:`
> blocks that used to ride along in commit messages.
>
> **Maintained at the end of each development session**, by a single developer
> or by a group of human and/or agentic developers. Whoever closes out a
> session updates this file.

## How this list is maintained

- Checkboxes are the state: `[ ]` open, `[x]` done, `~~struck~~` removed.
- New items go under the priority they belong to, with enough context that
  someone picking this up cold knows where to start.
- Items that turn out to be done, obsolete, or duplicated are moved to
  **Completed** or **Proposed for removal** rather than silently deleted.
- Source-code `TODO` comments and commit-message `TODO:` blocks are written
  here instead. New inline `TODO` comments are not to be added.
- Short comments that explain the code beside them may stay in the source.
  Longer notes belong in `DevNotes.md`.

---

## P0 — Foundations (block every other item)

### Provision the live database and app user
- [ ] Load `db/schema.sql`; verify **134 tables / 203 FKs / 103 seed rows**
- [ ] Create the least-privilege app user and export `IHRMIS_MYSQL_*`
- [ ] Wire the app's connection check green
- Blocked on: `sudo` needs a password — a human must run the admin step

### Enter the RBAC seed rows
- [ ] `Right` rows — **0 present**. Minimum per the table's own COMMENT:
      `rights.assign`, `roles.assign`, `users.manage`, `users.link.approve`
- [ ] `Role_Right` grant rows — **0 present** (possible once `Right` has fixed ids)
- [ ] Add the rights each feature suite below will need

### Fill in the ENUM descriptions
- [ ] **65 of 68** ENUM seed rows still have a NULL `description`:
      `ENUM_Res_Doc_Type` 54/54, `ENUM_User_Status` 4/4,
      `ENUM_User_Type` 3/3, `ENUM_OAuth_Provider` 4/4

---

## P0 — Authentication

### Wire the security middleware (installed, never imported)
- [ ] `helmet`, `express-session` + store, `express-rate-limit` on the auth routes
- [ ] CSRF protection on state-changing requests
- Live responses today carry **no** HSTS, `X-Frame-Options`, CSP, `nosniff`,
  and no session cookie at all

### Implement the 17 JANUS auth bodies
- [ ] **OIDC** — Authorization Code + PKCE via `openid-client`/`jose`; enforce
      `hd`/`tenant` = `deped.gov.ph`; JWKS-validate `id_token` (iss/aud/exp)
- [ ] **Email sign-in** — `argon2.verify` against `User_Login`; check status and
      lockout; rotate session; update `failed_attempts`
- [ ] **Signup / addUser / verifyUser** — `User` + `User_Login` +
      `Verification_Token`; send the SMTP link
- [ ] **OAuth linking** — `linkOAuthAccount`, `requestUnlink`, `approveUnlink`
- [ ] **Credentials** — `changePassword`, `addLogin` (max 3 alts), `removeLogin`
- [ ] **RBAC** — `addRole`, `removeRole`, `assignRight`
- [ ] **Account lifecycle** — `mergeUsers`, `setUserStatus`, `deleteUser`
- [ ] Add the missing `addDepEdUser`
- [ ] Replace the silent stubs with real errors

### Fix the 3 known code nits
1. `approveUnlink` guard is vacuous — `UNLINK_STATUS.includes(approve ? 'approved' : 'rejected')` is always true
2. `verifyOAuthUser` double-gate rejects the `microsoft365` alias that `oAuthProviderId` accepts
3. `loadEnumMaps` derives a junk `not` → 0 key from `"Not specified"`

---

## P1 — Engineering hygiene

- [ ] A real test runner — the `test` script (`node ihrmis-server.mjs && exit 0`) can never fail
- [ ] Linter and formatter
- [ ] CI workflow
- [ ] `dotenv` + `.env.example` — configuration is export-only today
- [ ] Root `README.md` with setup instructions
- [ ] Correct the stale counts in `db/README.md` (says 126 tables / 195 FKs / "130 tables"; actual **134 / 203 / 103**)
- [ ] Sitemap for the `emre3` card deck: the card body scrolls internally, which is awkward for printing
- [ ] `emre3` spine labels are abbreviated ("Job", "Eligibility") to keep the vertical strips short

---

## Feature suites (not started — all three depend on the P0 items above)

- [ ] **Time and Attendance** — shifts, schedules, holiday calendar, attendance logs/day, leaves + ledger, teaching load
- [ ] **Employee Discipline** — offense catalog, case, proceedings, decision, appeal, preventive suspension
- [ ] **Proceedings** — `Case_Proceeding` generic deliberation layer + junction template

---

## Backlog

- [ ] Convert the `ENUM_*` tables to native MySQL `ENUM` types (at minimum the
      three auth ones, possibly all)

---

## Completed (retained for reference)

- [x] Consolidate the color themes into a shared theme layer — `themes.css`
- [x] Add the dossier and card-deck employee record layouts
- [x] Wire the EmRE module to serve the layouts it owns
- [x] Unify the Role codes in code (`SEED_ROLES` + `TOP_MGMT`) with the model rows
- [x] Finish the EmRE tabbed view; browser-check `login31` and `emre1` at desktop and narrow widths
