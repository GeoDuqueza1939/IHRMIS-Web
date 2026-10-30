# IHRMIS — Developer Notes

---

## How to use this file

- One note per entry, newest at the **top** — add yours above the existing ones.
- Every note starts with:
  - `Date/Time:` — when the note was written
  - `Developer:` — human name, or the designated name of the agentic developer
  - `ATTN:` — optional; the developer the note is specifically for
- Leave one empty line after the `ATTN:` line, then the note body.
- Notes are separated by a horizontal rule (three dashes on their own line,
  with a blank line either side so it does not read as a heading underline).

### What stays in the source, and what comes here

- **Short, informative comments stay in the source code**, particularly where
  they explain the code they sit beside.
- **Longer notes live here.**
- Where the source genuinely needs to point at a note, a short reference may
  be left in the code carrying the date/time and developer of the referenced
  note — **only when necessary**. Any developer may remove such a reference
  later, once it is no longer needed.
- Comments inside CSS files stay in their stylesheets; they carry styling
  instructions and the rationale for it.

---

Date/Time: 2026-10-29 6:00 PM
Developer: Geo

The database model, DB-ERD.mwb, has been updated with new tables for tracking attendance and leaves. Tables for holding data on documentary requests and RSP applicant checklists have been likewise created. The biggest part that remains to be modelled for the database are the following:

- Payroll (Compensation, Benefits, Taxation) - This group might now become a priority feature ever since PRIME-HRM has been replaced by PRIME-ESG.
- Workload management - already started with Workload table related to Duty table. This will record data similar to what business process/workload tracking software handle. In such software, the employee transacts a process/task when beginning work on that process/task and, upon completion, records quantified results of the task (e.g., number of documents processed, number of subject classes handled). Low priority feature, but great for task and performance monitoring, tracking, and auditing. Since I consider this low priority anyway, I wont be incorporating a feature to upload snapshots/screenshots and other MOVs for now, as, if necessary, these things have to be verified face-to-face and manually, anyway.
- Policies and employee discipline
- Loyalty incentive and step increment recipients tracking - These might be better created after the Payroll-related tables had been created.
- Tag and ENUM_table - Connect different pieces of data; very useful for searching, filtering, and relating data to each other.
- Log table - Very important system feature, especially for digital governance.

All these tables and table groups are very important so they have to be modelled before the database can finally be deployed. But then again, I may have to revisit each table again to ensure that entity relationships are properly setup...

Regarding initial setup of the system, particularly during initial deployment, there is a need to ensure that configuration are properly captured into config.mjs and the databases with inserts are properly deployed so that the system is in a usable state right after setup. We need to verify that these are implemented:

- Initialization of the database(s); in cases of reinitialization/refreshing of the system, database backup flows should be incorporated.
- Setting up of initial database and system users.
- Capturing and recording of system and database settings.

Do note that some of these are not yet in the ToDo.md file. These will have to be added as well and included in the prioritization of tasks.

---

Date/Time: 2026-10-22 03:50 PM
Developer: Geo

_This note is last edited: _2026-10-28 08:15 PM.__

Let us fine tune the design first according to actual requirements in operations. However, call me out if you see gaps in the design.

Now, let's talk about attendance. In current/manual workflows, the attendance is currently tracked per working day either via biometrics or via time cards marked manually or using bundy clocks. This is due to the lack of attendance-capturing equipment in some units/schools. Upon deployment of the system, attendance status will therefore be considered either tracked or untracked. Some employees may have their attendance specified as tracked beforehand, specifically those in the Schools Division Office which has a biometric attendance scanner installed. Likewise, if their attendance data is automatically recorded via biometrics or manually uploaded to the system using a specific file format, their attendance shall also be considered as tracked. The attendance status may also be updated if they are covered by specific approved documents, such as leave forms, travel orders, travel authority, official issuances, or legal decrees. Once an employee clocks in via biometrics or their attendance data is uploaded to the system, their attendance status is then recomputed to fit into the following statuses:

- Present - employee clocks in on time or within the applicable grace period (if any); will change to either Half Day or Undertime if employee clocks out too early; the Present status will override any preset statuses but will not override the effects of the coverage of approved documents.
- Absent - no time ins or time outs were recorded; no coverage of approved documents; no attendance record during an employee's official time; may become AWOL if no leaves are filed within thresholds.
- Late - employee clocks in after the start of their official time or after the applicable grace period (if any); also called as 'Tardy'.
- Half Day - clocks in and clocks out within specified thresholds for half day.
- Excused - any absence, tardiness, undertime, or half day not covered by approved documents may be excused through the discretion of authorized parties, such as both the HRMO and top management.

The following statuses may be preset, depending on employee requests and other considerations. As such, these statuses may only be set once the required documents are either approved electronically or a scan of the required approved document is uploaded. Once set, they may only be manually reset to another value by a user with sufficient privilege. As such, changes to the attendance status shall be recorded. Setting of these statuses may be done individually or en masse, when an HRMO or an authorized HRM staff either uploads the approved document or reviews an electronically approved document. (Note: This has a consequence of requiring the review of approved documents by the HRMO or by authorized HRM staff. Likewise, when a document type is defined, its scope shall also be identified as either Individual, Group, or All, where a Group scope will allow the selection of more than one applicable employee or unit/school).

- On Leave - requires an approved leave form
- On Travel - requires the issuance of either a travel order or a travel authority
- On Remote Work - requires an official issuance
- Half Day - requires an approved leave form or an issuance if to be set in advance; Present status

Thresholds for grace periods will be added to the data of shifts/schedules and the system settings. Thresholds for early clock ins and for determining half days and undertimes will also be added to the system settings.

An attendance record could be automatic through biometrics capture or manually uploaded or encoded into the system. The following modifies an existing attendance record or creates a new one:

- clock in (start of shift)
- clock out (lunch; optional)
- clock in (lunch; optional)
- clock out (end of shift)
- the approval of leaves
- the issuance of a memorandum, authority, or order
- the excuse of an absence by appropriate authorities

Being both late and undertime will not necessarily be considered as half day. This means that both anomalies should also be tracked in the attendance record. Likewise, what will be considered as half day will largely be defined by policy which could consider any or any combination of the following factors:

- number of hours worked
- clock in time
- clock out time
- approval of authorized parties (similar to excused)

---

Date/Time: 2026-10-22
Developer: OC
ATTN: Geo

**Source notes and TODOs consolidated.** The 17 inline `TODO` comments in
`src/modules/janus.mjs` and the `TODO:` blocks carried in the commit messages
have been consolidated into `.docsanddesign/ToDo.md`. The long auth-model note
and the commented-out tab implementation have been moved into this file;
short comments that explain the code beside them were left in the source, as
were all CSS comments. No source file now carries a `TODO` marker.

Migrated entries are listed below, each with a blank `Date/Time` line to mark
it as an original rather than a new note. They are ordered as they were found
in the source, with the first found at the bottom.

Items that were already done, or that duplicated other entries, were dropped
from the list rather than carried forward.

---

Date/Time:
Developer: Geo

Commented-out tab implementation, superseded by the external
`src/public/js/tab.js` (`TabControl`). Kept here for reference; the
`tabbed-display` / `tabbed-data` markup it targets no longer exists in
`emre1.ejs`.

```javascript
(function () {
  var root = document.querySelector('.tabbed-display');
  if (!root) return;
  var bar = root.querySelector('.tabs');
  var panels = Array.prototype.slice.call(
    root.querySelectorAll(':scope > section[role="tabpanel"]'));
  if (!bar || !panels.length) return;
  root.classList.add('js-tabs');

  function labelOf(panel) {
    var h = panel.querySelector('h2.tab');
    return h ? { text: h.textContent.trim(), title: h.getAttribute('title') || '' }
             : { text: panel.id || 'Section', title: '' };
  }

  var buttons = panels.map(function (panel, i) {
    var lab = labelOf(panel);
    var btn = document.createElement('button');
    btn.type = 'button';
    btn.id = 'tabbtn-' + panel.id.replace(/^tab-/, '');
    btn.setAttribute('role', 'tab');
    btn.setAttribute('aria-controls', panel.id);
    btn.textContent = lab.text;
    if (lab.title) btn.title = lab.title;
    btn.addEventListener('click', function () { activate(i, true); });
    bar.appendChild(btn);
    panel.setAttribute('aria-labelledby', btn.id);
    return btn;
  });

  function activate(i, pushHash) {
    buttons.forEach(function (b, j) {
      var on = i === j;
      b.classList.toggle('active', on);
      b.setAttribute('aria-selected', on ? 'true' : 'false');
      b.tabIndex = on ? 0 : -1;
      panels[j].classList.toggle('active', on);
    });
    if (pushHash && panels[i].id) {
      try { history.replaceState(null, '', '#' + panels[i].id); } catch (e) {}
    }
  }

  bar.addEventListener('keydown', function (e) {
    var cur = buttons.indexOf(document.activeElement);
    if (cur < 0) return;
    var next = null;
    if (e.key === 'ArrowRight') next = (cur + 1) % buttons.length;
    else if (e.key === 'ArrowLeft') next = (cur - 1 + buttons.length) % buttons.length;
    else if (e.key === 'Home') next = 0;
    else if (e.key === 'End') next = buttons.length - 1;
    if (next !== null) {
      e.preventDefault();
      buttons[next].focus();
      activate(next, true);
    }
  });

  var start = 0;
  if (location.hash) {
    var at = panels.findIndex(function (p) { return '#' + p.id === location.hash; });
    if (at >= 0) start = at;
  }
  activate(start, false);
})();
```

*(moved from `src/views/emre1.ejs`, lines 228–296)*

---

Date/Time:
Developer: Geo

KAORI-DB-NOTE — auth model as implemented in `.docsanddesign/DB-ERD.mwb`
(schema IHRMIS, `User Data` diagram). Applied 2026-10-02 via
`tools/mwb-edit.mjs apply --spec /tmp/opencode/auth-spec.json`
(new `alterColumns` op); `wbcheck` structural + type checks passed and
MySQL Workbench 8.0.47 opens the model cleanly (126 tables, 13 diagrams).
----------------------------------------------------------------------------
DELTAS vs the original handoff (per owner decisions):
- `User.username` widened VARCHAR(100) -> VARCHAR(250): signup/login take
  emails (`User_Login.email` is 250), so 100 would truncate long addresses.
- `User.status` / `User_Login.provider` / `OAuth_Account.provider` are
  TINYINT UNSIGNED FKs to retained ENUM tables (NOT native MySQL ENUMs),
  so future statuses/providers need data rows, not DDL:
    ENUM_User_Status(status): 0: Not specified, 1: Active, 2: Inactive,
      3: Separated. `User.status` DEFAULT 1, RESTRICT on delete.
    ENUM_OAuth_Provider(provider): 0: Not specified, 1: Local, 2: Google,
      3: Microsoft 365. `User_Login.provider` DEFAULT 1, RESTRICT.
    ENUM_User_Type(user_type): 0: Not specified, 1: External, 2: Employee.
      `User.user_type` DEFAULT 1, RESTRICT. (Tabled for future user types.)
  `User.user_type` native ENUM dropped; `Verification_Token.purpose` stays
  native ENUM('signup','verify_alt','reset','link') (a purpose, not a ref).
- `User.password_hash` VARCHAR(255) NN (argon2); + `failed_attempts`,
  `locked_until`, `created_at` (DEFAULT CURRENT_TIMESTAMP), `updated_at`
  (DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP — folded into the
  default expression: GRT has no column-level ON UPDATE key, Workbench
  forward-engineers `DEFAULT <value>` verbatim so the SQL stays valid).
- `Verification_Token` gains lookup index `idx_Verification_Token_hash`
  (verifyUser looks tokens up by hash); `loginId`/`granted_by`/`decided_by`
  intentionally carry NO FK (insert-ordering); table/column names match this
  file's queries exactly. All user-owned rows CASCADE from User; shared
  refs (Role, Right, ENUMs) are RESTRICT. Junctions use composite PKs.
----------------------------------------------------------------------------
NOTES: keep `Email_Address` (Person contact) separate from `User_Login`
(auth identity). DepEd users MAY keep non-DepEd alt local emails; they just
may never use a @deped.gov.ph address in the email-login path. PM_Role and
ENUM_PM_Role are performance-cycle roles — DO NOT reuse for system RBAC.

*(moved from `src/modules/janus.mjs` — the ACTION ITEMS and BACKLOG sections
of the original have been split out into `ToDo.md`)*
