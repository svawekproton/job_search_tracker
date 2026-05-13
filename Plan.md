# Implementation Plan - Job Search Tracker

Rails 8.1 job search tracker using Bootstrap, Stimulus, Turbo, Solid Queue, SQLite, RSpec, Active Storage, Action Text for notes, and Rails built-in authentication.

## 1. Project Initialization & Configuration

- [x] Initialize Rails 8 app with Bootstrap SCSS and SQLite.
- [x] Configure Turbo, Stimulus, Importmap, and Propshaft.
- [x] Configure Bootstrap and Bootstrap Icons.
- [x] Install and configure Solid Queue.
- [x] Install and configure Active Storage for CV and cover letter uploads.
- [x] Install and configure Action Text for rich note content.

## 2. Data Model Design

### JobApplication

Implemented fields and relationships:

- [x] `company_name`: string
- [x] `position`: string
- [x] `status`: integer enum (`applied`, `interviewing`, `offered`, `rejected`, `withdrawn`)
- [x] `applied_at`: date
- [x] `url`: string
- [x] `location`: string
- [x] `description`: plain text column rendered as formatted text
- [x] `user_id`: required owner
- [x] Attachments: `cv`, `cover_letter`
- [x] Associations to notes and events

Pending decision:

- [ ] Decide whether `description` should remain plain text or move to Action Text in a future migration.

### Note

- [x] `job_application_id`: references
- [x] `category`: string (`Question`, `Answer`, `General`)
- [x] `content`: Action Text rich text
- [x] Interview-prep scope for question and answer notes

### Event

- [x] `job_application_id`: references
- [x] `title`: string
- [x] `event_type`: integer enum (`call`, `technical_interview`, `hr_interview`, `follow_up`)
- [x] `scheduled_at`: datetime
- [x] `notes`: text

## 3. Core Implementation Phases

### Phase 1: Job Applications CRUD

- [x] Generate and customize job application CRUD.
- [x] Associate applications with the authenticated user.
- [x] Implement file uploads for CV and cover letter.
- [x] Build the application pipeline index.
- [x] Build the application detail page.
- [x] Add search by company, position, and location.
- [x] Add status filtering.

### Phase 2: Notes & Events

- [x] Create notes and events models.
- [x] Add modal forms from the job application show page.
- [x] Use Turbo Streams to append new notes and events without a full page reload.
- [x] Add an interview-prep notes view based on note category.

### Phase 3: Background Jobs

- [x] Configure Solid Queue and development jobs process.
- [ ] Add a domain-specific reminder job for upcoming interviews.
- [ ] Add reminder scheduling and delivery behavior.

### Phase 4: UI/UX Refinement

- [x] Dashboard metrics for total applications, active interviews, offers, and success rate.
- [x] Upcoming interviews and recent activity dashboard sections.
- [x] Search and filtering for applications by status or query.
- [x] Interactive status updates using Stimulus.
- [x] Clipboard copy behavior for job URLs.
- [x] File-selection preview behavior in forms.
- [ ] Document preview buttons for uploaded files.
- [ ] Read-more behavior for long descriptions.
- [ ] Settings destination for the mobile navigation.

## 4. Authentication

- [x] Implement Rails built-in authentication.
- [x] Add registration.
- [x] Associate `JobApplication` with `User`.
- [x] Scope job application controller queries to `Current.user`.
- [x] Scope dashboard stats and events to `Current.user`.
- [x] Add sign-in, sign-up, and logout navigation.
- [x] Add authentication helpers and request coverage.

## 5. Verification & Testing

- [x] Model specs for core models.
- [x] Request specs for authentication, dashboard, job applications, notes, events, passwords, and registrations.
- [x] System smoke flow for job application behavior.
- [ ] Expand system coverage for invalid modal submissions and live status UI feedback.
- [x] Align `config/ci.rb` test commands with the RSpec-first test strategy.

## 6. Known Follow-Up Work

- [ ] Improve Turbo failure handling for note and event modal validation errors.
- [x] Finish documentation and CI alignment from `implementation_details.md`.
- [ ] Add reminder job behavior for upcoming interviews.
- [ ] Decide whether job descriptions need Action Text.
