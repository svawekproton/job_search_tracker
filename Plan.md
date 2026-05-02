# Implementation Plan - Job Search Tracker

Building a job search tracker using Rails 8, Bootstrap, Stimulus, Turbo, Solid Queue, and SQLite.

## 1. Project Initialization & Configuration
- [ ] Initialize Rails 8 app: `rails new . --css bootstrap --database sqlite3`.
- [ ] Install and configure **Solid Queue** for background jobs (default in Rails 8 production, needs setup for dev).
- [ ] Setup **ActionText** for rich text notes.
- [ ] Setup **ActiveStorage** for CV and Cover Letter uploads.
- [ ] Configure Bootstrap and ensure Turbo/Stimulus are working.

## 2. Data Model Design
### JobApplication
- `company_name`: string
- `position`: string
- `status`: integer (enum: applied, interviewing, offered, rejected, withdrawn)
- `applied_at`: date
- `url`: string
- `location`: string
- `description`: text
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
- Generate `JobApplication` scaffold.
- Implement file uploads for CV and Cover Letter using ActiveStorage.
- Design the index (list) and show (detail) pages with Bootstrap.

### Phase 2: Notes & Events (Nested/Related)
- Create `Notes` and `Events` models.
- Implement forms to add notes and events directly from the `JobApplication` show page.
- Use **Turbo Streams** to append new notes/events without page reloads.

### Phase 3: Background Jobs (Solid Queue)
- Example job: Send a reminder for an upcoming interview (simulated or logged).
- Ensure `solid_queue` is running alongside the server.

### Phase 4: UI/UX Refinement
- Dashboard view with application statistics (e.g., total applied, active interviews).
- Search and filtering for applications by status or company.
- Interactive status updates using Stimulus.

## 4. Verification & Testing
- Unit tests for models.
- System tests for the application flow (creating app, adding note, uploading CV).
- Verify Solid Queue processing.
