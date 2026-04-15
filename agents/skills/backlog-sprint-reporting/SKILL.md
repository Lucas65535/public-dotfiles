---
name: backlog-sprint-reporting
description: Plan milestones and generate Nulab Backlog reports with the Bee CLI. Use this skill whenever the user wants sprint or milestone setup, standup summaries, weekly or monthly reporting, sprint review notes, or project health analysis from Backlog data rather than issue-by-issue editing.
---

# Backlog Sprint Reporting

Use `bee` to gather Backlog data for milestone management, standups, sprint reviews, and project health reporting.

## Working Rules

- In Codex sandboxed runs, treat `bee auth status` as a network-dependent check, not a definitive auth verdict.
- If `bee auth status` reports `Authentication failed` inside the sandbox, treat that result as inconclusive because Bee validates credentials via the Backlog API and the sandbox may block outbound access.
- Retry the same read-only Bee command outside the sandbox before concluding auth is broken.
- Ask the user to run `bee auth login` only if the non-sandbox retry also fails or a non-sandbox read command shows the credentials are invalid.
- Prefer `--json` for all reads so counts and grouping are reproducible.
- Use first-class CLI commands such as `bee milestone list`, `bee issue list`, and `bee wiki create` before considering `bee api`.
- Any write step such as creating a milestone or publishing a wiki page needs a preview and explicit confirmation.

## Project Setup & Identification

### Use Full Project Keys

Backlog projects are identified by their **full project key**, not a partial prefix.

**Common Projects:**

| Project Key | Project Name | Project ID |
|-------------|--------------|------------|
| SC_DEVOPS   | One人事 DevOps | 124287 |
| SC_SAAS     | One人事 SaaS   | 87546 |
| SC_QA       | Q&A・要望       | 115671 |

**Wrong:**
```sh
bee milestone list -p SC --json  # ❌ Fails
bee issue list -p SC -a @me --json
```

**Right:**
```sh
bee milestone list -p SC_DEVOPS --json  # ✅
bee issue list -p SC_SAAS -a @me --json   # ✅
```

### How to Find Your Project Key

```sh
# List all accessible projects
bee project list --json | jq -r '.[] | "\(.projectKey): \(.name)"'

# Get project details
bee project view -p SC_DEVOPS --json | jq '{key: .projectKey, name: .name, id: .id}'
```

### Using Cached Project Config

The skill references `references/project-config.md` for quick lookups of:
- Project keys and IDs
- Priority ID mappings
- Common resolutions

Query this file first before making Backlog API calls.

## Scope

Use this skill when the main task is planning, aggregation, or reporting.

- If the user wants issue CRUD or issue state changes, prefer `backlog-issue-management`.
- If the user wants notification triage or watching cleanup, prefer `backlog-notifications`.

Read `references/policies.md` before interpreting status groups and date phrases. Use `references/report-templates.md` when the user wants a formatted standup, weekly, monthly, or health report.

If the first reporting read fails in the Codex sandbox, retry one read-only Bee command outside the sandbox before treating the workspace as unauthenticated.

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

### Data Pull Patterns

Always use `--json` for programmatic access and pipe through `jq` for formatting:

```sh
# counts by status
bee issue count -p PROJECT --status 1 --json  # open
bee issue count -p PROJECT --status 3 --json  # in progress
bee issue count -p PROJECT --status 4 --json  # resolved

# date-ranged queries (use YYYY-MM-DD format)
 bee issue count -p PROJECT --created-since 2026-04-01 --created-until 2026-04-07 --json
 bee issue count -p PROJECT --updated-since 2026-04-01 --json

# overdue work
 bee issue list -p PROJECT --due-until TODAY --status 1 --status 2 --status 3 --json | \
   jq -r '.[] | "\(.issueKey): \(.summary) (due: \(.dueDate // "none"))"'

# priority breakdown of open work
 bee issue count -p PROJECT --priority high --status 1 --status 2 --status 3 --json
 bee issue count -p PROJECT --priority normal --status 1 --status 2 --status 3 --json
```

### jq Formatting Examples

```sh
# Summarize by assignee
bee issue list -p PROJECT --status 1 --status 2 --status 3 --json | \
  jq -r 'group_by(.assignee.name) | .[] | "\(.[0].assignee.name // "unassigned"): \(length) open issues"'

# Get specific fields only (faster)
bee issue list -p PROJECT --json 'issueKey,summary,status.name,assignee.name,dueDate' | \
  jq -r '.[] | "\(.issueKey): \(.summary) | \(.status.name)"'
```

### PR Activity (if applicable)

```sh
# Merged PRs in date range
 bee pr list -p PROJECT -R REPO --status merged --count 100 --json | \
   jq -r '.[] | "\(.title) by \(.author.name) merged at \(.mergedAt)"'

# Open PRs needing review
 bee pr list -p PROJECT --status open --count 100 --json | \
   jq -r '.[] | "\(.title) - \(.reviewers[].name // "no reviewer")"'
```

### Publishing to Wiki

If the user wants the report saved to Backlog Wiki:

1. Show the final page name and body preview.
2. After confirmation, run:

```sh
bee wiki create -p PROJECT -n "Weekly Report - YYYY-MM-DD" -b "BODY" --json --yes
```

⚠️ **Note:** Wiki pages require project key (`-p`), not project ID.

## Workflow 4: Project Health Analysis

Use issue counts plus issue lists for a compact health report.

### Recommended Dimensions

- Priority distribution of open work
- Overdue volume and age
- Workload by assignee
- High-priority unassigned work
- Velocity trend (if requested)

### Query Patterns with jq

```sh
# High priority open work count
 bee issue count -p PROJECT --priority high --status 1 --status 2 --status 3 --json

# Overdue issues (sorted by due date)
 bee issue list -p PROJECT --due-until TODAY --status 1 --status 2 --status 3 \
   --sort dueDate --order asc --count 100 --json | \
   jq -r '.[] | "\(.issueKey): \(.summary) (due: \(.dueDate // "none"), assignee: \(.assignee.name // "unassigned")"'

# Workload distribution by assignee
 bee issue list -p PROJECT --status 1 --status 2 --status 3 --count 100 --json | \
   jq -r 'group_by(.assignee.name) | sort_by(length) | reverse[] | "\(.[0].assignee.name // "unassigned"): \(length) issues"'

# Unassigned high-priority work
 bee issue list -p PROJECT --priority high --status 1 --status 2 --status 3 --json | \
   jq -r '.[] | select(.assignee.name == null) | "\(.issueKey): \(.summary)"'
```

### Performance Tips

- **Batch queries**: Combine multiple status filters in one call instead of separate calls per status
- **Field filtering**: Use `--json 'field1,field2'` to reduce data transfer:
  ```sh
  bee issue list -p PROJECT --json 'issueKey,summary,status.name,assignee.name,dueDate'
  ```
- **Count first, list later**: Use `bee issue count` to get totals before deciding whether to fetch full lists
- **Reuse data**: Cache issue lists in memory and compute multiple metrics from the same dataset

### Sample Health Report Structure

```markdown
# Project Health - SC_DEVOPS (2026-04-08)

## Overview
- Total open issues: 47
- High priority: 12
- Overdue: 3

## By Assignee
- zhang.huazhou: 18 issues
- yang.jiguang: 15 issues
- Unassigned: 5 issues

## Critical Issues
- SC_DEVOPS-1234: Server monitoring down (High, overdue by 2 days)
- SC_DEVOPS-1238: Database connection leak (High, unassigned)

## Recommendations
1. Reassign SC_DEVOPS-1238 immediately
2. Address 3 overdue items by EOD
```

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

## Troubleshooting

### "Project not found" when using `-p`

**Symptom:** `ERROR Project not found: "SC"`

**Cause:** Using partial project key instead of full key.

**Fix:** Use complete project key:

```sh
# ❌ Wrong
bee milestone list -p SC --json

# ✅ Right
bee milestone list -p SC_DEVOPS --json
```

### No results from date filters

**Symptom:** `bee issue list --created-since 2026-04-01` returns empty.

**Fix:**
- Verify date format: `YYYY-MM-DD` (zero-padded)
- Check timezone: Backlog uses UTC or space timezone
- Try broader range first to confirm data exists:
  ```sh
  bee issue count -p PROJECT --json
  ```

### JSON parsing errors or null fields

**Symptom:** `jq: error (at <stdin>:0): Cannot index null value`

**Fix:**
- Use null-safe navigation: `(.field // "default")`
- Check full JSON structure first:
  ```sh
  bee issue list -p PROJECT --count 1 --json | jq '.[0]'
  ```

### Wiki page creation fails

**Symptom:** `bee wiki create` returns permission error.

**Fix:**
- Verify you have wiki write permission in the project
- Use correct project key: `-p SC_DEVOPS`
- Ensure page name doesn't contain illegal characters (`/`, `\`, `:`)

### PR list empty or command not found

**Symptom:** `bee pr list` returns empty or errors.

**Fix:**
- PR commands require Git integration enabled in the project
- Check if repository name is correct: `-R REPO_NAME`
- Use `bee pr list -p PROJECT --count 1` to test connectivity

### Slow queries with large datasets

**Symptom:** Commands take too long or time out.

**Fix:**
- Use `--count 100` or limit to reduce payload
- Filter by status or date first
- Fetch specific fields only:
  ```sh
  bee issue list -p PROJECT --json 'issueKey,summary,status.name' --count 50
  ```

## Performance Best Practices

1. **Count before listing**: Use `bee issue count` to gauge size before doing expensive `bee issue list`
2. **Field filtering**: `--json 'field1,field2'` reduces transfer time
3. **Batch status queries**: `--status 1 --status 2 --status 3` in single call
4. **Cache data**: Save issue lists to files and reuse for multiple metrics:
   ```sh
   bee issue list -p PROJECT --status 1 --status 2 --status 3 --json > open_issues.json
   jq -r '.[] | .assignee.name' open_issues.json | sort | uniq -c
   ```

## Resources

- `references/policies.md`
- `references/report-templates.md`
- `references/project-config.md` - Project keys and IDs
