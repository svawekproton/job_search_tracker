# Job Search Tracker

A Rails 8.1 application for tracking job applications, interview events, notes, documents, and application status.

## Prerequisites

- Ruby matching the version in `.ruby-version`
- Bundler
- SQLite 3
- Node.js and Yarn 1.x for Bootstrap SCSS builds

## Setup

Install dependencies and prepare the database:

```bash
bin/setup
```

If you need to rebuild CSS assets separately:

```bash
yarn build:css
```

## Run Locally

Start the Rails server, CSS watcher, and Solid Queue worker:

```bash
bin/dev
```

The development process list is defined in `Procfile.dev`:

- `web`: Rails server
- `css`: Bootstrap SCSS watcher
- `jobs`: Solid Queue worker via `bin/jobs`

## Authentication

The app uses Rails built-in session authentication, not Devise. Users can sign up, sign in, and sign out through the session and registration routes. Job applications are associated with the signed-in user, and dashboard/application queries are scoped through `Current.user`.

## Core Features

- Dashboard metrics for total applications, active interviews, offers, success rate, upcoming events, and recent activity
- Job application CRUD with status, application date, URL, location, plain-text description, CV upload, and cover letter upload
- Search by company, position, or location
- Status filtering
- Nested notes and events on each job application
- Turbo-powered modal creation for notes and events
- Stimulus controllers for status UI updates, clipboard copying, modal triggers, and file-selection previews
- Solid Queue-backed background job infrastructure

## Testing and Quality

Run the RSpec suite:

```bash
bundle exec rspec
```

Run a targeted spec while iterating:

```bash
bundle exec rspec spec/requests/job_applications_spec.rb
```

Run Ruby style checks:

```bash
bin/rubocop
```

Run the project CI script:

```bash
bin/ci
```

`bin/ci` also runs security checks such as Bundler Audit, Importmap audit, and Brakeman.

## Background Jobs

Solid Queue is configured as the Active Job backend. In development, keep the `jobs` process from `bin/dev` running so queued jobs can be processed. The project currently has the queue infrastructure in place, but no domain-specific reminder job has been implemented yet.
