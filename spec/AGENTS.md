# Specs

The root `AGENTS.md` applies globally. This file adds rules for `spec/`.

## Test Framework

RSpec is the test framework.

Add or update specs for behaviour changes. Prefer focused tests that describe observable behaviour rather than implementation details.

## File Placement

| What to test | Where |
| --- | --- |
| Model validations, scopes, model methods | `spec/models/*_spec.rb` |
| HTTP responses, redirects, auth, Turbo Streams | `spec/requests/*_spec.rb` |
| Background jobs | `spec/jobs/*_spec.rb` |
| Mailers | `spec/mailers/*_spec.rb` |
| Shared helpers/macros | `spec/support/` |
| Fixtures/test data | `spec/fixtures/` |

## Writing Specs

- Use one behaviour per example.
- Use `describe` for methods/endpoints.
- Use `context` for branches or states.
- Keep setup minimal and explicit.
- Prefer clear expectations over testing private methods.
- Avoid large factory chains unless the project already relies on them.

Example:

```ruby
RSpec.describe JobApplication, type: :model do
  describe "validations" do
    it "is invalid without a company" do
      application = described_class.new(position: "Developer")

      expect(application).not_to be_valid
      expect(application.errors[:company]).to be_present
    end
  end
end
```

## Request Specs

Use request specs for controller behaviour:

- successful responses
- redirects
- authentication/authorization
- validation failures
- Turbo Stream responses
- database state changes caused by requests

For failed form submissions, assert `:unprocessable_entity` when appropriate.

## Turbo Stream Request Specs

Use Turbo Stream headers:

```ruby
headers = { "Accept" => "text/vnd.turbo-stream.html" }
```

Example:

```ruby
post job_applications_path,
     params: { job_application: { company: "Acme", position: "Developer", status: "applied" } },
     headers: { "Accept" => "text/vnd.turbo-stream.html" }

expect(response).to have_http_status(:ok)
expect(response.media_type).to eq("text/vnd.turbo-stream.html")
expect(response.body).to include("turbo-stream")
```

Also assert the important state change, not only the markup.

## Job Specs

Use Active Job matchers for job enqueueing.

```ruby
expect {
  SendFollowUpEmailJob.perform_later(job_application.id)
}.to have_enqueued_job(SendFollowUpEmailJob).with(job_application.id)
```

If the job sends an email, either test the mailer separately or perform the job and assert delivery behaviour explicitly.

## Verification

During iteration, prefer targeted commands:

```bash
bundle exec rspec spec/models/job_application_spec.rb
bundle exec rspec spec/requests/job_applications_spec.rb
bundle exec rspec spec/jobs/send_follow_up_email_job_spec.rb
```

Run broader commands only when the change is broad or when explicitly requested.

## Avoid

- Brittle expectations against full rendered HTML pages
- Testing private methods directly
- Overusing `let!`
- Hidden setup in large shared contexts
- Specs that pass only because of execution order
- Adding tests that encode the current implementation instead of required behaviour
