# Implementation Plan - Job Search Tracker

Building a job search tracker using Rails 8, Bootstrap, Stimulus, Turbo, Solid Queue, and SQLite.

## 1. Project Initialization & Configuration
- [x] Initialize Rails 8 app: `rails new . --css bootstrap --database sqlite3`.
- [x] Install and configure **Solid Queue** for background jobs.
- [x] Setup **ActionText** for rich text notes.
- [x] Setup **ActiveStorage** for CV and Cover Letter uploads.
- [x] Configure Bootstrap and ensure Turbo/Stimulus are working.

## 2. Data Model Design
### JobApplication
- `company_name`: string
- `position`: string
- `status`: integer (enum: applied, interviewing, offered, rejected, withdrawn)
- `applied_at`: date
- `url`: string
- `location`: string
- `description`: ActionText (rich text)
- Attachments: `cv`, `cover_letter` (ActiveStorage)

### Note
- `job_application_id`: references
- `category`: string (e.g., "Question", "Answer", "General")
- `content`: ActionText (rich text)

### Event
- `job_application_id`: references
- `title`: string
- `event_type`: integer (enum: call, technical_interview, HR_interview, follow_up)
- `scheduled_at`: datetime
- `notes`: text

## 3. Core Implementation Phases

### Phase 1: Job Applications CRUD
- [x] Generate `JobApplication` scaffold.
- [x] Implement file uploads for CV and Cover Letter using ActiveStorage.
- [x] Design the index (list) and show (detail) pages with Bootstrap.

### Phase 2: Notes & Events (Nested/Related)
- [x] Create `Notes` and `Events` models.
- [x] Implement forms to add notes and events directly from the `JobApplication` show page (Modals).
- [x] Use **Turbo Streams** to append new notes/events without page reloads.

### Phase 3: Background Jobs (Solid Queue)
- [x] Ensure `solid_queue` is running alongside the server.
- [ ] Example job: Send a reminder for an upcoming interview.

### Phase 4: UI/UX Refinement
- [x] Dashboard view with application statistics (e.g., total applied, active interviews).
- [x] Search and filtering for applications by status or company.
- [x] Interactive status updates using Stimulus.

## 4. Verification & Testing
- [x] Unit tests for models (RSpec).
- [x] Request tests for controllers (RSpec).
- [ ] System tests for the application flow.

## 5. Authentication (Planned)
- [ ] Implement Rails 8 built-in authentication: `bin/rails generate authentication`.
- [ ] Associate `JobApplication` with `User`.
- [ ] Scope all controller queries to `Current.user` to ensure data isolation.
- [ ] Update `DashboardController` to only show stats and events for the authenticated user.
- [ ] Add Login/Logout functionality to the Bootstrap navbar.
- [ ] Update RSpec tests with authentication helpers and scope verification.
