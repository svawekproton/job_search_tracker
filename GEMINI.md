# Job Search Tracker - Project Instructions

This document provides foundational guidance for development within this workspace.

## Tech Stack
- **Framework:** Ruby on Rails 8.1
- **Database:** SQLite 3 (Production-ready configuration)
- **Frontend:** Bootstrap 5, Stimulus, and Turbo (Hotwire)
- **Background Jobs:** Solid Queue
- **Rich Text:** ActionText (Trix)
- **File Storage:** ActiveStorage

## Architecture & Conventions
- **Dynamic Updates:** Prioritize Turbo Streams for real-time UI updates (e.g., adding notes or events) to avoid full page reloads.
- **Styling:** Use Bootstrap 5 classes and utility-first patterns. Custom CSS should be minimal and added to `app/assets/stylesheets/application.bootstrap.scss`.
- **Database:** Leverage Rails 8 defaults for SQLite, including WAL mode and immediate transactions.
- **Background Jobs:** Use `Solid Queue`. Ensure `bin/jobs` is running during development.

## Testing Standards
- **Framework:** **RSpec** (Minitest has been removed).
- **Locations:**
  - Model specs: `spec/models/`
  - Request/Controller specs: `spec/requests/`
  - System specs: `spec/system/` (if added)
- **Mandate:** Always add RSpec tests for new features and bug fixes. Run tests with `bundle exec rspec`.

## Key Models
- `JobApplication`: Core tracking record for a job application.
- `Note`: Rich text entries (ActionText) for questions, answers, and general notes.
- `Event`: Tracks calls, interviews, and follow-ups with scheduled timestamps.

## Development Workflow
- **Initialization:** Use `bin/dev` to start the web server, CSS watcher, and Solid Queue worker simultaneously.
- **Git:** Maintain clean commit messages.
- **Documentation:** Keep `Plan.md` updated for major feature roadmaps.
