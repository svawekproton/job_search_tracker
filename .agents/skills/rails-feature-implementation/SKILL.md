---
name: rails-feature-implementation
description: Use when adding or changing a feature in this Rails 8 app, especially changes involving models, controllers, routes, migrations, views, Turbo, background jobs, or RSpec specs. Trigger phrases include: add feature, implement, change behavior, add field, add workflow, add CRUD, update form, add filtering, add sorting.
---

# Rails Feature Implementation

Use this skill to implement a coherent Rails feature or behavior change. Do not use it for tiny edits, simple explanations, or pure code review.

## Required workflow

1. Inspect the existing app shape before editing:
   - `config/routes.rb`
   - `db/schema.rb`
   - relevant models
   - relevant controllers
   - relevant views/partials
   - relevant specs
   - `Gemfile` only if dependencies seem relevant

2. State a short implementation plan before coding when the change touches more than two files or requires a migration.

3. Make the smallest coherent change that fits existing project patterns.

4. Follow project conventions:
   - Rails 8 style
   - Rails 8 strong params with `params.expect`
   - RSpec for tests
   - Hotwire/Turbo and server-rendered partials before custom JavaScript
   - Solid Queue / Active Job for background work
   - no new gems unless explicitly approved
   - no Devise, React, Vue, Svelte, Redis, Sidekiq, or frontend build-system changes unless explicitly requested

5. Add or update tests:
   - model specs for validations, scopes, enum behavior, and record-level methods
   - request specs for controller behavior, redirects, auth, and Turbo Stream responses
   - job specs for Active Job behavior

6. Verify narrowly first:
   - run the most relevant spec file or example
   - run lint only for touched Ruby files when useful
   - do not run full CI unless the user asks

## Rails 8 parameter rule

Use `params.expect` for required permitted params.

```ruby
def job_application_params
  params.expect(job_application: [
    :company,
    :position,
    :status,
    :notes
  ])
end
```

Never use `permit!`. Avoid `params.expect(model: {})` unless the user explicitly wants to allow all current and future attributes.

## Migration rule

When adding or changing database columns:

- inspect `db/schema.rb` first
- match existing column types and naming style
- add indexes for foreign keys and frequently filtered columns
- do not run `rails db:migrate` without approval if project instructions require asking first

## Output format

Return:

- Summary
- Files changed
- Tests added or updated
- Commands run
- Risks, assumptions, or follow-up needed
