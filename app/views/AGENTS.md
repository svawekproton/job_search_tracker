# Views

The root `AGENTS.md` applies globally. This file adds rules for `app/views/`.

## General Rules

- Use ERB templates: `.html.erb`.
- Use partials for repeated markup.
- Partial names start with `_`.
- Keep business logic out of views.
- Use helpers or model methods for presentation logic that is reused or non-trivial.
- Prefer Bootstrap utility/classes already used in the app before adding custom CSS.

## Partials

Pass locals explicitly when rendering partials unless rendering a collection with Rails conventions.

Good:

```erb
<%= render "job_applications/application", application: @job_application %>
```

Collection rendering:

```erb
<%= render @job_applications %>
```

## DOM IDs

Use Rails DOM helpers where possible:

```erb
<%= dom_id(job_application) %>
<%= dom_class(job_application) %>
```

Prefer these over hand-built IDs, especially for Turbo Frames and Turbo Streams.

## Turbo Frames

Use Turbo Frames for scoped, independently updateable regions.

Every frame needs a stable unique ID.

```erb
<%= turbo_frame_tag dom_id(@job_application) do %>
  <%= render "job_applications/application", application: @job_application %>
<% end %>
```

A controller response to a frame request must include a matching frame.

## Turbo Streams

Prefer Turbo Streams + partials for incremental updates.

Example:

```erb
<%= turbo_stream.prepend "job_applications", partial: "job_applications/application", locals: { application: @job_application } %>
<%= turbo_stream.replace "job_application_form", partial: "job_applications/form", locals: { job_application: JobApplication.new } %>
```

Use stable target IDs. Prefer IDs generated from Rails helpers or clearly named container IDs.

## Real-Time Updates

If using model broadcasts or Solid Cable, keep stream names, target IDs, and partial paths consistent.

```erb
<%= turbo_stream_from "job_applications" %>

<div id="job_applications">
  <%= render @job_applications %>
</div>
```

## Stimulus Integration

- Do not add inline `<script>` tags.
- Use Stimulus controllers for client-side behaviour.
- Use `data-controller`, `data-*-target`, and `data-*-value` attributes clearly.
- Do not duplicate server state in JavaScript unless necessary.

## Avoid

- Complex conditionals in ERB
- Queries in views
- Inline JavaScript
- `raw` / `html_safe` unless content is known safe
- Hardcoded DOM IDs that can collide inside collections
- Large templates that should be broken into partials
