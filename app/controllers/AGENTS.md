# Controllers

The root `AGENTS.md` applies globally. This file adds rules for `app/controllers/`.

## Controller Responsibilities

Controllers should coordinate HTTP flow only:

- load records
- authorize/authenticate using the existing app pattern
- call model/domain methods
- respond with redirects, renders, Turbo Streams, or errors

Keep controllers thin, but do not move code into a model just to make the controller artificially tiny.

## RESTful Design

Prefer standard RESTful actions:

- `index`
- `show`
- `new`
- `create`
- `edit`
- `update`
- `destroy`

If behaviour does not fit cleanly, prefer a dedicated nested controller instead of custom member actions.

Good examples:

```ruby
JobApplications::StatusChangesController#create
JobApplications::NotesController#create
JobApplications::FollowUpsController#create
```

Avoid custom actions such as `mark_as_interviewing`, `archive`, or `restore` unless the existing route style already uses them.

## Queries

- Simple composition of model scopes in controllers is acceptable.
- Move repeated or complex query logic into model scopes or a dedicated query object.
- Do not build large SQL fragments in controllers.
- Scope user-owned records through the authenticated user/current account pattern used in the app.

Good:

```ruby
@applications = current_user.job_applications.active.recent_first
```

Avoid:

```ruby
@applications = JobApplication.where("status IN (?)", [0, 1]).order("created_at DESC")
```

## Strong Params

Always use strong params.

```ruby
private

def job_application_params
  params.expect(job_application: [
    :company,
    :position,
    :status,
    :notes
  ])
end
```

Never use `permit!`.

## Turbo and HTML Responses

For failed form submissions, render with `status: :unprocessable_entity` so Turbo handles the response correctly.

Example:

```ruby
def create
  @job_application = JobApplication.new(job_application_params)

  if @job_application.save
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @job_application, notice: "Application was created." }
    end
  else
    render :new, status: :unprocessable_entity
  end
end
```

Use explicit `respond_to` blocks when the action supports both HTML and Turbo Stream responses.

## Background Work

Do not call external APIs or slow work synchronously from controllers.

Use Active Job/Solid Queue for:

- email sending
- scraping/fetching
- notifications
- slow calculations
- external API calls

## Error Handling

- Do not use `rescue_from` for normal control flow.
- Use `rescue_from` only for genuinely exceptional cases or app-wide error handling.
- Prefer clear branches for expected validation or authorization failures.

## Avoid

- Fat controllers
- Deeply nested conditionals
- Duplicated authentication guards
- `permit!`
- New dependencies for simple request handling
- JSON endpoints mixed into HTML controllers unless the existing app already follows that pattern
