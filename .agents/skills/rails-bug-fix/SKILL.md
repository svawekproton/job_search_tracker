---
name: rails-bug-fix
description: Use when diagnosing and fixing a Rails bug, failing spec, runtime error, regression, broken Turbo behavior, incorrect query result, or unexpected app behavior. Trigger phrases include: failing spec, bug, error, broken, not working, regression, fix this, investigate failure.
---

# Rails Bug Fix

Use this skill to find the root cause and make the smallest safe fix. Do not use it for new features or broad refactors.

## Required workflow

1. Reproduce or inspect the failure first:
   - run the exact failing spec if provided
   - otherwise run the narrowest relevant spec
   - if command execution is unavailable, inspect the error and related files before editing

2. Identify the root cause before changing code.
   - Do not patch symptoms blindly.
   - Do not rewrite unrelated code.
   - Do not make broad style changes while fixing a bug.

3. Inspect only the relevant files first:
   - failing spec
   - implementation under test
   - route/controller/model/view involved
   - schema if data shape matters

4. Form one primary hypothesis, then test it with the smallest code change.

5. Add or update regression coverage unless the existing failing spec already captures the issue.

6. Verify in this order:
   - rerun the original failing spec or command
   - run nearby specs only if the fix touches shared behavior
   - avoid full suite unless explicitly requested

## Rails-specific checks

Check for these common causes:

- old strong params style where Rails 8 `params.expect` is expected
- missing `status: :unprocessable_entity` on failed Turbo form renders
- Turbo Stream response using the wrong target ID
- view IDs not using stable DOM IDs such as `dom_id(record)`
- controller queries not scoped through the current user/account pattern
- enum values mismatching schema or form params
- callback side effects running before commit instead of after commit
- specs missing Turbo `Accept` headers

## Output format

Return:

- Root cause
- Fix made
- Regression coverage
- Verification command and result
- Remaining risk, if any
