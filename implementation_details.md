# Implementation Details: Step-by-Step Fix Plan

This plan converts the review findings into an execution sequence with file-level scope, verification, and review checkpoints.

## 0. Baseline and Safety Check
1. Create a working branch for the fixes.
2. Capture baseline state:
   - `bundle exec rspec`
   - `bin/rubocop`
3. Keep the existing controller `params.expect(...)` changes intact unless a failing test proves regression.

## 1. Fix Runtime UI/UX Issues (Highest Priority)

### 1.1 Clipboard controller reliability
1. Update [app/javascript/controllers/clipboard_controller.js](/Users/slava/Learn/test_projects/job_search_tracker/app/javascript/controllers/clipboard_controller.js):
   - Change `copy()` to `copy(event)`.
   - Replace implicit global `event` usage.
   - Prefer `navigator.clipboard.writeText(...)` with fallback to `execCommand`.
2. Ensure button feedback still works (`Copied` state and restore timer).
3. Add/adjust JS-level behavior test if JS test setup exists; otherwise validate via system test in step 3.

Acceptance criteria:
- Clicking copy button copies URL and does not raise console errors.
- Feedback text/icon transitions correctly.

### 1.2 Status updater target scope fix
1. Update [app/views/job_applications/show.html.erb](/Users/slava/Learn/test_projects/job_search_tracker/app/views/job_applications/show.html.erb):
   - Move `data-controller="status-updater"` so both `select`, `badge`, and `card` targets are inside controller scope.
   - Keep current visual design and status submit behavior.
2. Keep [app/javascript/controllers/status_updater_controller.js](/Users/slava/Learn/test_projects/job_search_tracker/app/javascript/controllers/status_updater_controller.js) logic, but simplify if target wiring permits.

Acceptance criteria:
- Changing status updates badge text/classes.
- Card border color updates immediately before server response.

### 1.3 Turbo failure handling for note/event modals
1. Update [app/controllers/notes_controller.rb](/Users/slava/Learn/test_projects/job_search_tracker/app/controllers/notes_controller.rb):
   - Add `format.turbo_stream` branch for validation failures.
   - Render form frame replacement with `status: :unprocessable_entity`.
2. Update [app/controllers/events_controller.rb](/Users/slava/Learn/test_projects/job_search_tracker/app/controllers/events_controller.rb) similarly.
3. Add failure turbo templates if needed (or reuse frame replace directly).
4. Update forms if needed to show validation errors clearly:
   - [app/views/notes/_form.html.erb](/Users/slava/Learn/test_projects/job_search_tracker/app/views/notes/_form.html.erb)
   - [app/views/events/_form.html.erb](/Users/slava/Learn/test_projects/job_search_tracker/app/views/events/_form.html.erb)

Acceptance criteria:
- Invalid submit from modal does not redirect full page.
- Modal remains open with inline errors.

## 2. Remove Guesswork and Improve Domain Consistency

### 2.1 Normalize note categories
1. Update [app/models/note.rb](/Users/slava/Learn/test_projects/job_search_tracker/app/models/note.rb):
   - Introduce single source of truth (constant or enum-like mapping).
   - Add inclusion validation for category values.
2. Replace hardcoded category arrays in:
   - [app/views/notes/_form.html.erb](/Users/slava/Learn/test_projects/job_search_tracker/app/views/notes/_form.html.erb)
   - [app/views/job_applications/show.html.erb](/Users/slava/Learn/test_projects/job_search_tracker/app/views/job_applications/show.html.erb)
   - [app/views/notes/create.turbo_stream.erb](/Users/slava/Learn/test_projects/job_search_tracker/app/views/notes/create.turbo_stream.erb)

Acceptance criteria:
- UI dropdown and query logic use the same category source.
- Invalid category values are rejected at model level.

### 2.2 Optional cleanup: timeline composition extraction
1. Move combined activity sort/merge from view into helper/model method.
2. Keep output identical.

Acceptance criteria:
- `show` template gets simpler.
- Behavior remains unchanged.

## 3. Fill Testing Gaps

### 3.1 Request specs for missing controller branches
1. Expand [spec/requests/job_applications_spec.rb](/Users/slava/Learn/test_projects/job_search_tracker/spec/requests/job_applications_spec.rb):
   - Add `POST /job_applications` success/failure.
   - Add invalid `PATCH` branch assertions.
   - Add status filter assertions.
2. Add explicit `params.expect` contract tests where high-risk:
   - [spec/requests/sessions_spec.rb](/Users/slava/Learn/test_projects/job_search_tracker/spec/requests/sessions_spec.rb)
   - [spec/requests/passwords_spec.rb](/Users/slava/Learn/test_projects/job_search_tracker/spec/requests/passwords_spec.rb)
   - [spec/requests/registrations_spec.rb](/Users/slava/Learn/test_projects/job_search_tracker/spec/requests/registrations_spec.rb)
   - [spec/requests/notes_spec.rb](/Users/slava/Learn/test_projects/job_search_tracker/spec/requests/notes_spec.rb)
   - [spec/requests/events_spec.rb](/Users/slava/Learn/test_projects/job_search_tracker/spec/requests/events_spec.rb)
3. Add shared examples for authentication-required endpoints and apply broadly.

Acceptance criteria:
- Branches for success/failure/auth/invalid input are covered for main request paths.

### 3.2 Add system-level smoke flow (minimum)
1. Add `spec/system` flow for:
   - login
   - status update visual change
   - modal invalid note/event submit stays in modal with errors
2. Keep it lean (1-2 high-value system specs).

Acceptance criteria:
- At least one end-to-end test validates the UI interactions that request specs cannot fully verify.

### 3.3 Reduce brittle assertions
1. Replace full raw HTML fragment checks with stable semantic assertions.
2. Clean confusing comments in tests (for example dashboard spec notes).

Acceptance criteria:
- Tests fail only on meaningful behavior regressions, not harmless markup shifts.

## 4. Documentation Corrections

### 4.1 Replace placeholder README
1. Rewrite [README.md](/Users/slava/Learn/test_projects/job_search_tracker/README.md):
   - prerequisites
   - setup (`bin/setup`)
   - local run (`bin/dev`, `jobs` process)
   - auth flow overview
   - testing commands (`bundle exec rspec`, `bin/rubocop`, `bin/ci`)
   - queue/background notes

Acceptance criteria:
- New contributor can run app and tests from README only.

### 4.2 Reconcile Plan.md with implemented reality
1. Update [Plan.md](/Users/slava/Learn/test_projects/job_search_tracker/Plan.md):
   - mark already-complete auth items as done.
   - keep only truly pending tasks unchecked.
2. Resolve `description` mismatch explicitly:
   - Either mark as plain text currently, or schedule ActionText migration task.

Acceptance criteria:
- `Plan.md` accurately reflects implementation status and next work.

### 4.3 Clarify design spec status
1. Update [Design_Specification.md](/Users/slava/Learn/test_projects/job_search_tracker/Design_Specification.md):
   - mark aspirational vs implemented features (filters, preview buttons, read-more).
   - avoid presenting future features as shipped.

Acceptance criteria:
- No ambiguity about what exists now vs future UX goals.

## 5. CI/Test Command Alignment
1. Decide one of:
   - switch [config/ci.rb](/Users/slava/Learn/test_projects/job_search_tracker/config/ci.rb) test steps to RSpec, or
   - document why Rails test commands remain and ensure both suites exist.
2. If staying RSpec-first, update CI steps accordingly.

Acceptance criteria:
- CI test commands match the actual maintained test suite strategy.

## 6. Final Verification and Review Gate
1. Run:
   - `bundle exec rspec`
   - `bin/rubocop`
   - targeted system spec(s), if added
2. Manually verify:
   - clipboard copy behavior
   - status border live change
   - invalid modal submissions stay in modal
3. Produce PR summary with:
   - issue -> fix mapping
   - tests added/updated
   - docs changed
   - known follow-ups (if any)

## Reviewer-Flag Checklist (Pre-PR)
- Functionality regressions in modal/Turbo flows.
- Hidden assumptions in category/status mappings.
- Missing test coverage for new strong parameter contracts.
- Docs claiming features not implemented.
- CI strategy mismatch with test suite.
