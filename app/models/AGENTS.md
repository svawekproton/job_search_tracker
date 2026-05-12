# Models

The root `AGENTS.md` applies globally. This file adds rules for `app/models/`.

## Model Responsibilities

Use models for:

- Validations and record-level business rules
- Associations
- Reusable named scopes
- Derived state that belongs to a record
- Small, explicit domain methods

Do not turn models into dumping grounds. If a workflow coordinates multiple models, external APIs, emails, or jobs, use an explicit method/object rather than hiding it in callbacks.

## Queries and Scopes

- Put repeated queries into named scopes.
- Simple scope composition outside the model is acceptable.
- Avoid repeating `where`, `joins`, or complex `order` chains across controllers.
- Keep scopes chainable.
- Use explicit names that describe intent, not implementation.

Good:

```ruby
scope :active, -> { where(status: %i[applied interviewing]) }
scope :recent_first, -> { order(created_at: :desc) }
```

Avoid:

```ruby
# repeated in several controllers/views
JobApplication.where(status: [0, 1]).order("created_at DESC")
```

## Validations and Database Integrity

- Use model validations for user-facing/application-level rules.
- Use database constraints for integrity where appropriate: `null: false`, foreign keys, unique indexes.
- When adding a reference, ensure indexes and foreign keys match the existing project style.
- Do not rely only on validations for data that must be impossible to corrupt.

## Enums and Status Fields

- Follow the existing schema style for enums.
- Do not change enum storage type casually.
- Prefer explicit enum mappings.
- Add tests for status/state rules.
- Do not rely on implicit integer ordering unless the existing code already does.

Example:

```ruby
enum :status, {
  applied: 0,
  interviewing: 1,
  offered: 2,
  rejected: 3
}
```

If the project already uses string-backed enums for a model, keep using that style for that model.

## Callbacks

Use callbacks only when the side effect is tightly coupled to the record lifecycle.

Prefer:

- `after_commit` for broadcasts, jobs, or anything that depends on committed data
- explicit public methods for workflows
- jobs for slow or external work

Avoid:

- external API calls in model callbacks
- sending emails directly from callbacks
- complex multi-model orchestration in callbacks
- callbacks that make tests surprising or order-dependent

## Turbo Broadcasts

If the model already uses Turbo broadcasts, keep broadcast targets and partial names consistent with existing views.

Prefer Rails DOM helpers such as `dom_id(record)` in related views and stream targets.

## Avoid

- God models
- Query logic duplicated across controllers
- External services called directly from models
- `update_all` or `delete_all` without a clearly scoped relation
- Silent changes to callbacks, enum mappings, or validations without specs
