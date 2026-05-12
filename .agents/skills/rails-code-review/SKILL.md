---
name: rails-code-review
description: Use when reviewing a Rails diff, PR, branch, or Codex-generated change before merging. Focus on correctness, Rails 8 conventions, architecture, security, Hotwire/Turbo behavior, tests, and unnecessary complexity. Trigger phrases include: review diff, code review, PR review, check my changes, is this good, before merge.
---

# Rails Code Review

Use this skill to review changes. Default to read-only review. Do not edit files unless the user explicitly asks for fixes.

## Required workflow

1. Inspect the diff first:
   - `git diff` or provided patch
   - changed files
   - related tests

2. Review against the actual project patterns, not generic Rails preferences.

3. Prioritize issues by merge risk:
   - blocker: correctness, data loss, security, broken tests, broken user flow
   - important: maintainability, missing tests, bad architecture, brittle Hotwire behavior
   - minor: naming, style, small cleanup

4. Be skeptical of generated code:
   - does it solve the requested problem?
   - is it smaller than necessary?
   - did it change unrelated behavior?
   - did it introduce a dependency or new architectural pattern?
   - did it silently skip tests?

## Review checklist

Rails 8:

- uses `params.expect` for strong params
- no `permit!`
- routes remain RESTful where practical
- controllers stay thin without hiding complex workflows in callbacks
- models avoid God-model growth
- migrations match existing schema style

Security:

- no raw SQL interpolation with user input
- user-owned records are scoped correctly
- no unsafe `html_safe` or `raw`
- no secrets in code, logs, fixtures, or specs
- no open redirects

Hotwire/Turbo:

- failed form renders use `status: :unprocessable_entity`
- Turbo Stream targets match stable DOM IDs
- partial locals are explicit
- Stimulus is used only for client-side behavior Turbo cannot handle cleanly

Tests:

- behavior changes have model/request/job specs as appropriate
- Turbo Stream requests include correct `Accept` headers
- tests verify behavior, not implementation details
- no fragile over-mocking of Rails internals

## Output format

Return:

1. Verdict: approve / approve with changes / reject
2. Blockers
3. Important improvements
4. Missing tests
5. Overengineering or unnecessary changes
6. Suggested verification commands

If there are no blockers, say so directly.
