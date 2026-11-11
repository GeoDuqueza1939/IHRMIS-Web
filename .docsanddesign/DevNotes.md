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

Date/Time: 2026-11-12 06:42 AM
Developer: Geo

[This is a late update]

Yesterday, I resumed with revisiting the tables in the database model. However, I hit some snag in the Plantilla item and Position management tables. It became clear quickly that the current model for Plantilla and positions management is somehow weak in the history recording and auditing departments, as it can't possibly record the evolution of positions and Plantilla items, not to mention track the lifetime of Plantilla items. So I started some painstaking revamp of this part of the model. I came up with the following tables (excluding ENUM tables):

- Position
- Plantilla_Item
- Plantilla_Item_History
- Plantilla_Item_Lineage

I will continue working on this today, so the above tables might still change.

---

Date/Time: 2026-11-10 03:54 AM
Developer: Geo

Today, I set out to update the ToDo list. I updated a few items that need updating due to changes in the design and added a few more. Employee Discipline is now just the Case Registry, as I realized that implementing a complete feature set for discipline and grievance need more planning than anticipated, so I decided to push its full design and implementation to the subsequent development cycles. Then, I realized that proceedings are still not implemented and teams are still underdeveloped. I decided to convert case proceedings to a more general proceedings entity so it can be used not just in case proceedings, but even in RSP evaluations or regular meetings of HRM committees.

The following tables were added into a Proceedings Data diagram in the database model:

- Proceeding - use to setup various proceedings such as meetings, seminars, deliberations, etc. A team is assigned to handle each proceeding
- Proceeding_Participant - an employee that attends or participates in the proceedings via the system
- Participant_Log - records participant check-ins and messages. May be used for online chat messages
- Proceeding_Minutes - records minutes of the proceedings; May record multiple minutes
- Proceeding_Document - attached generated or uploaded documents
- ENUM_Proceeding_Type

I also began revisiting the diagrams in the model, inserting/updating seed rows and adding relationships to the Tags table along the way. I also discovered that some ENUM tables had been inadvertently renamed, likely due to the duplication of tables. I'll be checking for all that had been affected.

I encountered the incomplete seed list in ENUM_Eligibility_Type, which I decided to defer the completion of for now.

I also hit a snag in the Plantilla_Item table, something related to the evolution, replacement, or abolition of either or both an item and a position. I will need to quickly redesign this very soon with minimal changes to the design of the other modelled tables. Just to clarify, a position can be created, filled, vacated, upgraded, retitled, replaced, frozen, or abolished, and a Plantilla item can be created, filled, vacated, reclassified, retitled, renumbered, converted, frozen, marked as coterminous to the incumbent, or abolished. I should find a middle ground between the two status sets and redesign the two tables to have a historical or succession record. There are also suggestions to store events rather than statuses.

Another thing: we should add a function to update ages when birthdays are available, as age cannot be flagged as generated, since birthday data is not always available for reference.

I still have a long road ahead...

---

Date/Time: 2026-11-09 03:44 PM
Developer: Geo

I renamed Allowance to Compensation_Entitlement, so it can cover more types of benefits and compensation. I also renamed Loan_Deduction to Deduction_Code, as deduction codes is its only significant content. From here on, I will need the input of the Payroll Officer to proceed with the payroll tables design.

I also proceeded to design tables related to employee discipline, grievance, and the like. I went to create the following tables:

- Case
- Case_Party
- Case_History
- Case_Document
- Case_Tag
- ENUM_Case_Type
- ENUM_Case_Category
- ENUM_Case_Status
- ENUM_Confidentiality_Level
- ENUM_Case_Role

Finally, I have added the single Log table to record all user operations. I have also added a Tag table to the model and combined both Tag and Case_Tag under the Tag Data diagrams. Then, I hit a snag: how do I connect multiple types of data to one or more tags? Case_Tag was easy, as it directly connects tags with cases. Nevertheless, I came up with a not-so-elegant solution: a data tag that any type of data can refer to which connects the data to the actual tags. I cycled through many other solutions, eventually settling on the tables Tag, Tag_Item, and Tags. Tags will be the junction table that will connect all tag data to all other tables.

The database model is now 98%-99% complete. What's left is to add tags references to concerned tables, consult the Payroll Officer regarding payroll data design, enter all seed entries, and finalize the database model before deploying it for testing. I don't have enough time to add these to the ToDo and I don't have any other helper, so I guess I would just refer to the DevNotes, instead, for now.

---

Date/Time: 2026-11-09 10:01 AM
Developer: Geo

I added the following payroll-related tables to the model:

- Billing - will contain the data of employees' loan payment schedule from billers/public lending institutions (PLIs)
- Loan_Deduction - will group billing data according to PLIs and deduction codes
- Allowance - specifically assigned allowances/compensations that are regularly credited
- Payee - added to ensure that each payroll has a specific list of employee-payees; may be used to facilitate the indirect grouping of compensation and deduction entries according to payee

The definition of the Allowance almost duplicates the core structure of the ENUM_Compensation_Type table, but it is retained as such to allow for specific (non-generalized) assignments of these allowances.

Payroll tables are mostly done. However, I need direct inputs from the Payroll Officer before finalizing things.

---

Date/Time: 2026-11-06 02:56 PM
Developer: Geo

I mainly just modified the layout of some ERD in the model. No big changes, just tried to make some of the recent diagrams more readable, specifically Employee data and Payroll data diagrams. However, the most significant change is renaming the Agency_Contribution table to Employer_Contribution. What remains to be done for the payroll data diagrams is to add the tables related to billing and allowances. Billing is assigned by PLIs/biller organizations to the employee. I am thinking of something similar for the allowances, but implicitly understood as assigned by the employer and has effective and end dates. These tables will facilitate the computation of compensation and deduction entries in the payroll.

---

Date/Time: 2026-11-05 07:16 AM
Developer: Geo

Here are the things that the system (and the Payroll Officer) will do whenever a regular payroll is prepared for a period (default is for a whole month):

1. Employees and employee information updates for payroll integration
2. Uploading of billing data according to date of receipt and workflow procedure.
3. Trigger creation of payroll for specified period.
4. Create compensation items for basic salary/wage
5. Create compensation items for overtime pay (if applicable)
6. Create deduction items for mandatory government contributions (GSIS, PhilHealth, Pag-IBIG/HDMF)
7. Create compensation items for taxable incentives and allowances
8. Create deduction items for withholding tax (if applicable)
9. Create compensation items for PERA and other allowances and incentives (non-taxable and with annual tax threshold)
10. Create deduction items for voluntary contributions
11. Create deduction items for all loan payments.
12. Add prepared salary adjustment compensation/deduction items, if required.
13. Add tax adjustment compensation/deduction items, if required.
14. Generate PDF version of the payroll (for printing, e-signing, or wet signature).
15. Print payroll.
16. Print payslips (no PDF versions of payslips will be generated).

Here are the things that the system will ask whenever a supplemental payroll is prepared, although some of these may be prepared even before a payroll is prepared.

1. Specific employees to be included as payee
2. Compensation and deduction item types to include per employee-payee
3. Whether to recompute tax based on compensation entries (except for salary adjustment and tax adjustment items)

The net pay for each payee in the payroll will not be recorded but will be aggregated from the recorded compensation and deductions.

I have also compiled a salary table from all the salary schedules that I could find covering the years 1989 to 2027. It is currently for OCR and visual re-auditing to ensure accuracy. Please see the file Philippine_Civilian_Government_Salary_Schedules_1989_2027.xlsx.

---

Date/Time: 2026-11-04 04:58 PM
Developer: Geo

Me pondering on the way home: maybe we should now also add the tables that will serve as queues for recipients of monetary incentives and step increments. I am thinking of covering not just loyalty incentive but of other monetary incentives as well. These may be put in the R&R data diagram, but payroll processing will refer to these, whenever necessary.

Speaking of queues, we might also need to plan queues for different categories, such as soon-to-retire employees (captured/filtered according to age). Business logic or manual filtering may be used for these queues/categories. This shall have a very low priority, for now, although it might prove to be useful in the long run, as it could potentially make the system more flexible in profiling/categorizing people for various purposes within the bounds of law and policy.

---

Date/Time: 2026-11-04 04:03 PM
Developer: Geo

While pondering about the design of the payroll-related tables, I've gotten into thinking about the usual payrolls processed. I've determined them to be the following:

- Regular Payroll - This is the monthly payroll where compensation is computed for each employee-payee integrated into the payroll. Standard payroll items will be automatically included in the computation of this payroll.
- Supplementary Payroll - This is the payroll prepared in cases where employee-payees cannot be directly integrated into the regular payroll, particularly in the case of new hires. This may also be prepared if waiting for the regular payroll processing cycle will cause considerable delays in crediting the compensation of employee-payees. Payroll items may be specified and prepared beforehand (e.g., selected from a queue). Taxation and other deductions may or may not be included, depending on the payroll items included.

Other payroll-related tables may be created later after consultation with the Payroll Officer. After payroll, will be employee discipline and proceedings (all types).

---

Date/Time: 2026-11-03 12:22 AM
Developer: Geo

Inserted several payroll related tables in the model in the Payroll Data diagram. Payroll table will define the payroll type and period. Payroll_History table will record actions done on the Payroll as it is processed. Compensation will hold the compensation data of each employee for the payroll period. 3 ENUM tables were also added.

Deductions, such as for mandatory and voluntary government contributions, taxation, insurance premiums, and loan payments are still not yet modelled.

---

Date/Time: 2026-10-30 4:45 PM
Developer: Geo

Workload management tables have been inserted in the model in the Workload Management Data diagram. Corresponding item in ToDo has been added and updated. To describe the changes, __Workload__ is transacted either from an employee's set of duties or from a set of tasks assigned by a supervisor (dutyId is optional in this case), whereas Workload_Transaction carries relevant time and status data. ENUM_Workload_Status has been seeded with pre-defined statuses. If the dutyId is not defined, the task will be considered as 'Other Tasks'.

---

Date/Time: 2026-10-29 6:00 PM
Developer: Geo

The database model, DB-ERD.mwb, has been updated with new tables for tracking attendance and leaves. Tables for holding data on documentary requests and RSP applicant checklists have been likewise created. The biggest part that remains to be modelled for the database are the following:

- Payroll (Compensation, Benefits, Taxation) - This group might now become a priority feature ever since PRIME-HRM has been replaced by PRIME-ESG.
- Workload management - already started with Workload table related to Duty table. This will record data similar to what business process/workload tracking software handle. In such software, the employee transacts a process/task when beginning work on that process/task and, upon completion, records quantified results of the task (e.g., number of documents processed, number of subject classes handled). Low priority feature, but great for task and performance monitoring, tracking, and auditing. Since I consider this low priority anyway, I wont be incorporating a feature to upload snapshots/screenshots and other MOVs for now, as, if necessary, these things have to be verified face-to-face and manually, anyway.
- Policies and employee discipline
- Loyalty incentive and step increment recipients tracking - These might be better created after the Payroll-related tables had been created.
- Tag table - Connect different pieces of data; very useful for searching, filtering, and relating data to each other.
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
