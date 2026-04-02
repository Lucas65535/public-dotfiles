---
name: backlog-sprint-reporting
description: Plan milestones and generate Nulab Backlog reports with the Bee CLI. Use this skill whenever the user wants sprint or milestone setup, standup summaries, weekly or monthly reporting, sprint review notes, or project health analysis from Backlog data rather than issue-by-issue editing.
---

# Backlog Sprint Reporting

Use `bee` to gather Backlog data for milestone management, standups, sprint reviews, and project health reporting.

## Working Rules

- Confirm Bee authentication if needed with `bee auth status`.
- Prefer `--json` for all reads so counts and grouping are reproducible.
- Use first-class CLI commands such as `bee milestone list`, `bee issue list`, and `bee wiki create` before considering `bee api`.
- Any write step such as creating a milestone or publishing a wiki page needs a preview and explicit confirmation.

## Scope

Use this skill when the main task is planning, aggregation, or reporting.

- If the user wants issue CRUD or issue state changes, prefer `backlog-issue-management`.
- If the user wants notification triage or watching cleanup, prefer `backlog-notifications`.

Read `references/policies.md` before interpreting status groups and date phrases. Use `references/report-templates.md` when the user wants a formatted standup, weekly, monthly, or health report.

## Workflow 1: Milestone Management

### Create a Milestone

1. Resolve the project key or ID.
2. Show a preview with name, date range, and description.
3. After confirmation, run:

```sh
bee milestone create \
  -p PROJECT \
  -n "Sprint 15" \
  --start-date YYYY-MM-DD \
  --release-due-date YYYY-MM-DD \
  -d "DESCRIPTION" \
  --json \
  --yes
```

### List Milestones

```sh
bee milestone list -p PROJECT --json
```

### Update or Archive a Milestone

1. Read current milestones with `bee milestone list -p PROJECT --json`.
2. Show old and new values.
3. After confirmation, run `bee milestone edit`:

```sh
bee milestone edit MILESTONE_ID \
  -p PROJECT \
  -n "NEW NAME" \
  --start-date YYYY-MM-DD \
  --release-due-date YYYY-MM-DD \
  --archived \
  --json \
  --yes
```

Use `--archived` when the user wants to close or archive a completed sprint.

## Workflow 2: Daily Standup Summary

Build a short team update from live issue data.

Typical sequence:

1. Resolve date boundaries from `references/policies.md`.
2. Load team and project context:
   - `bee user me --json`
   - `bee user list --json` when the user wants a team-wide view
   - `bee project view -p PROJECT --json`
3. Pull issue sets:

```sh
bee issue list -p PROJECT --status 2 --count 100 --json
bee issue list -p PROJECT --status 3 --status 4 --updated-since YYYY-MM-DD --count 100 --json
bee issue list -p PROJECT --created-since YYYY-MM-DD --count 100 --json
```

4. Group by assignee and flag:
   - in progress
   - completed since yesterday
   - new today
   - overdue or unassigned work
5. Format with the standup template.

## Workflow 3: Weekly or Monthly Report

Use multiple Bee queries and synthesize them in one report.

Suggested data pulls:

```sh
bee issue count -p PROJECT --created-since START --created-until END --json
bee issue count -p PROJECT --status 3 --status 4 --updated-since START --updated-until END --json
bee issue count -p PROJECT --status 4 --updated-since START --updated-until END --json
bee issue count -p PROJECT --status 1 --status 2 --status 3 --json
bee issue list -p PROJECT --status 1 --status 2 --status 3 --due-until TODAY --sort dueDate --order asc --count 100 --json
bee issue count -p PROJECT --priority high --status 1 --status 2 --status 3 --json
```

If PR activity matters, collect it per repository:

```sh
bee pr list -p PROJECT -R REPO --status merged --count 100 --json
```

Then format the result with the relevant template.

### Publishing to Wiki

If the user wants the report saved to Backlog Wiki:

1. Show the final page name and body preview.
2. After confirmation, run:

```sh
bee wiki create -p PROJECT -n "Weekly Report - YYYY-MM-DD" -b "BODY" --json --yes
```

## Workflow 4: Project Health Analysis

Use issue counts plus issue lists for a compact health report.

Recommended dimensions:

- Priority distribution of open work
- Overdue volume and age
- Workload by assignee
- High-priority unassigned work
- Velocity trend if the user asks for it

Suggested query patterns:

```sh
bee issue count -p PROJECT --priority high --status 1 --status 2 --status 3 --json
bee issue list -p PROJECT --due-until TODAY --status 1 --status 2 --status 3 --count 100 --sort dueDate --order asc --json
bee issue list -p PROJECT --status 1 --status 2 --status 3 --count 100 --json
```

Compute ratios and overload flags locally after retrieval rather than making many tiny follow-up requests.

## Workflow 5: Sprint Review

1. List milestones and resolve the target sprint ID:

```sh
bee milestone list -p PROJECT --json
```

2. Pull sprint-scoped issue sets:

```sh
bee issue list -p PROJECT --milestone SPRINT_ID --status 3 --status 4 --count 100 --json
bee issue list -p PROJECT --milestone SPRINT_ID --status 1 --status 2 --status 3 --count 100 --json
```

3. Aggregate:
   - planned vs completed
   - carried-over work
   - estimated vs actual hours
   - per-assignee workload and accuracy
4. Format with the sprint review template style.
5. If requested, publish the review to wiki with `bee wiki create`.

## When to Use `bee api`

Use `bee api` only if:

- the CLI lacks the needed endpoint or filter
- the user needs a niche field the subcommand output does not expose
- the reporting task depends on a Backlog object that Bee has not wrapped yet

Explain why `bee api` is necessary and keep the request read-only unless the user explicitly confirms a write.

## Resources

- `references/policies.md`
- `references/report-templates.md`
