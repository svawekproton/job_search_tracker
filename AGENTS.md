# Repository Guidelines

## Project Structure & Module Organization
This is a Rails 8.1 app for job-search tracking. Main code lives in `app/` (`models/`, `controllers/`, `views/`, `helpers/`). Frontend behavior is in Stimulus controllers under `app/javascript/controllers/`, and styles are in `app/assets/stylesheets/application.bootstrap.scss` with compiled output in `app/assets/builds/`. Database schema and changes are in `db/schema.rb` and `db/migrate/`. Tests are in `spec/` (`models/`, `requests/`, `support/`, `fixtures/`).

## Build, Test, and Development Commands
- `bin/setup`: install gems/Yarn deps, prepare DB, clear logs/tmp.
- `bin/dev`: start Foreman stack (`web`, CSS watcher, Solid Queue jobs).
- `yarn build:css`: compile and autoprefix Bootstrap SCSS.
- `bundle exec rspec`: run the RSpec suite.
- `bin/rubocop`: run Ruby style checks.
- `bin/ci`: run setup, RuboCop, security audits, and CI test steps.

Run from repo root. For quick local work, use `bin/dev` in one terminal and `bundle exec rspec` as you iterate.

## Coding Style & Naming Conventions
Use default Rails/Ruby conventions and RuboCop Omakase rules (`.rubocop.yml`).
- Ruby: 2-space indentation, `snake_case` file/method names, `CamelCase` classes/modules.
- Specs: one behavior per example; keep test data minimal and explicit.
- Stimulus: controller files end with `_controller.js` (example: `status_updater_controller.js`).
- Prefer Turbo Streams + partials for incremental UI updates instead of full-page reload logic.

## Testing Guidelines
RSpec is the test framework (`.rspec`, `spec/rails_helper.rb`). Add or update specs for every feature and bug fix.
- Naming: files must end with `_spec.rb`.
- Placement: model specs in `spec/models/`, request specs in `spec/requests/`.
- Helpers/shared setup: `spec/support/`.

Before opening a PR, run at least `bundle exec rspec` and `bin/rubocop`.

## Commit & Pull Request Guidelines
Current history uses short, imperative commit subjects (for example, `Add ...`, `Refine ...`, `Implement ...`). Keep that style and keep commits focused.

PRs should include:
- concise problem/solution summary,
- linked issue (if any),
- migration notes (`db/migrate`) when schema changes,
- screenshots or short clips for UI changes,
- exact verification commands run.

## Security & Configuration Tips
Do not commit secrets. Keep credentials in Rails encrypted credentials (`config/credentials.yml.enc`) and environment variables. Run `bin/bundler-audit` and `bin/brakeman` for security-sensitive changes.
