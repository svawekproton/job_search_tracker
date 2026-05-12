# Repository Guidelines

## Project

This is a Rails 8.1 job-search tracking application.

Stack:

- Rails 8.1
- Ruby on Rails conventions with RuboCop Omakase
- RSpec for tests
- Hotwire: Turbo Drive, Turbo Frames, Turbo Streams
- Stimulus for small client-side behaviours
- Bootstrap 5 SCSS via `app/assets/stylesheets/application.bootstrap.scss`
- Solid Queue for background jobs
- Solid Cable / Turbo Streams where real-time updates are already used
- Rails built-in authentication/session auth

Do not introduce Devise, React, Vue, Redis, Sidekiq, GoodJob, Vite, Webpacker, or a new frontend framework unless explicitly asked.

## Files to Check First

Before changing behaviour, inspect the relevant existing code. Usually start with:

- `config/routes.rb`
- `db/schema.rb`
- `Gemfile`
- `app/controllers/application_controller.rb`
- relevant model/controller/view/spec files

Match the existing architecture before adding a new pattern.

## Agent Workflow

Before changing code:

1. Understand the current route, model, schema, and test coverage.
2. Prefer the smallest coherent change that solves the issue.
3. Reuse existing patterns before introducing new abstractions.
4. Add or update specs for behaviour changes.
5. Run the most targeted verification command possible.

Do not rewrite unrelated code, rename core objects, change routes, or add dependencies unless the task requires it.

When stuck, ask one focused question or propose a short plan. Do not make wide speculative changes.

## Commands

Run commands from the repository root.

### Fast, scoped commands to use during iteration

```bash
bundle exec rspec spec/path/to/file_spec.rb
bundle exec rspec spec/path/to/file_spec.rb:42
bin/rubocop app/path/to/file.rb
```

### Expensive commands — ask before running unless explicitly requested

```bash
bin/setup
bin/dev
yarn build:css
bundle exec rspec
bin/rubocop
bin/ci
rails db:migrate
```

## Permissions

Allowed without asking:

- Read files and directories
- Run targeted specs or lint commands
- Edit files relevant to the requested task
- Refactor locally when it directly supports the change

Ask before:

- Adding, removing, or upgrading gems/packages
- Running migrations
- Running the full test suite or full CI
- Deleting files or directories
- Changing credentials or secrets
- Changing authentication architecture
- Committing or pushing git changes

## Rails Conventions for This Project

- Prefer server-rendered Rails + Hotwire over client-heavy JavaScript.
- Prefer Turbo Frames/Streams and partials for incremental UI updates.
- Use Stimulus only for client-side behaviour that Turbo cannot handle cleanly.
- Use Active Job with Solid Queue for background work.
- Do not assume Redis is available.
- Keep jobs idempotent where practical.
- Follow the existing Rails built-in authentication/session pattern. Do not introduce Devise.
- Follow the existing asset setup. Do not add a new bundler or frontend build system unless explicitly asked.

## Ruby and Rails Style

- Use 2-space indentation.
- Use `snake_case` for files, methods, variables.
- Use `CamelCase` for classes and modules.
- Keep one primary class/module per file.
- Filename should match the class/module name.
- Prefer clear Rails conventions over clever metaprogramming.
- Avoid premature service objects. Extract only when the model/controller would otherwise become unclear.

## Security

Always follow these rules:

- Never commit secrets.
- Use Rails credentials or environment variables for secret configuration.
- Use strong params: `params.require(...).permit(...)`.
- Never use `permit!`.
- Never interpolate user input into SQL. Use parameterised queries or Active Record APIs.
- ERB escapes output by default. Use `html_safe` or `raw` only when the content is known safe.
- For security-sensitive changes, run or recommend `bin/brakeman` and `bin/bundler-audit`.

## Testing

RSpec is the test framework.

Add or update tests for every feature, bug fix, model rule, request behaviour, Turbo response, or background job behaviour.

Prefer targeted tests while iterating. Do not run the full suite unless asked or unless the change is broad enough to justify it.

## Pull Request Checklist

A good PR should include:

- Concise problem/solution summary
- Linked issue, if any
- Migration notes when schema changes
- Screenshots or short clips for UI changes
- Exact verification commands run

## Context7

Use Context7 for library/API documentation, code generation, setup, or configuration steps without waiting to be asked.
