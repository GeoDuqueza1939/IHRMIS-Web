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
