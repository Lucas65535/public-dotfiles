---
name: backlog-sprint-reporting
description: Sprint/milestone management and progress reporting for Nulab Backlog via MCP tools. Covers creating and managing sprints/milestones/versions, generating daily standup summaries, weekly/monthly reports, and project health analysis. Use when the user asks for a progress report, standup summary, sprint planning, milestone management, issue statistics, workload distribution, overdue analysis, or any form of Backlog data aggregation and reporting. Also triggers when the user mentions "report", "standup", "sprint", "milestone", "statistics", "overdue", or "health check" in the context of Backlog project management. Requires the Backlog MCP server to be connected.
---

# Backlog Sprint & Reporting

Procedural guide for sprint/milestone management and generating progress reports from Backlog data.

## Workflow 1: Sprint / Milestone Management

### Create a Sprint or Milestone

1. Identify the target project.
2. Call `backlog_add_version_milestone` with:
   - `projectKey` or `projectId`
   - `name` (e.g., "Sprint 15", "v2.1.0")
   - `startDate`, `releaseDueDate` (YYYY-MM-DD format)
   - Optional: `description`
3. Report created milestone name and ID.

### List Sprints / Milestones

Call `backlog_get_version_milestone_list` with `projectKey`. Present as table:

```
| Name | ID | Start | Release Due | Archived |
|------|----|-------|-------------|----------|
```

### Update Sprint / Milestone

Call `backlog_update_version_milestone` with `id`, `name` (required), and fields to change (`startDate`, `releaseDueDate`, `description`, `archived`).

### Close a Sprint

Set `archived: true` via `backlog_update_version_milestone` to archive a completed sprint.

## Workflow 2: Daily Standup Summary

Generate a quick status overview for a team standup meeting.

### Steps

1. Call `backlog_get_myself` to confirm current user identity.
2. Determine today's date and the target project.
3. Get team members: `backlog_get_users`.
3. Query in-progress issues: `backlog_get_issues` with `statusId: [2]` (Processing), `projectId: [id]`, `count: 100`.
4. Query recently completed (today/yesterday): `backlog_get_issues` with `statusId: [4]` (Closed), `updatedSince: "YYYY-MM-DD"` (yesterday).
5. Query newly created (today): `backlog_get_issues` with `createdSince: "YYYY-MM-DD"` (today).
6. Group results by assignee.
7. Format output:

```
## Standup Summary — YYYY-MM-DD

### [Member Name]
**In Progress:**
- PROJ-101: Login page implementation (High, due 02/20)
- PROJ-103: API refactoring (Medium)

**Completed (since yesterday):**
- PROJ-99: Fix header layout

### [Member Name]
...

### Unassigned Issues in Progress
- PROJ-110: Database migration (High, due 02/18 — OVERDUE)
```

Flag overdue items (dueDate < today).

## Workflow 3: Weekly / Monthly Report

Generate a structured report for a given date range.

### Steps

1. Call `backlog_get_myself` to confirm current user identity.
2. Define the date range (ask user or infer: "this week" = Monday to today, "this month" = 1st to today, "last week" = previous Mon-Sun).
3. Collect data with multiple queries:

| Metric | Tool | Params |
|--------|------|--------|
| New issues count | `backlog_count_issues` | `createdSince`, `createdUntil`, `projectId` |
| Closed issues count | `backlog_count_issues` | `statusId: [4]`, `updatedSince`, `updatedUntil`, `projectId` |
| Currently open | `backlog_count_issues` | `statusId: [1,2,3]`, `projectId` |
| Overdue list | `backlog_get_issues` | `dueDateUntil: today`, `statusId: [1,2,3]`, `projectId`, `sort: dueDate`, `order: asc` |
| High priority open | `backlog_count_issues` | `priorityId: [2]`, `statusId: [1,2,3]`, `projectId` |
| PR activity | `backlog_get_pull_requests` | `projectKey`, `repoName`, filter by date in results |

4. Optionally collect PR merge data: call `backlog_get_git_repositories` to list repos, then `backlog_get_pull_requests` with `statusId: [3]` (Merged) for each repo. Filter by date range in results.
5. Format using the report template from `references/report-templates.md`.
6. Optionally save to Wiki: call `backlog_get_project` to get `projectId`, then `backlog_add_wiki` with the report content.

### Output Format

```
## Weekly Report — YYYY/MM/DD ~ YYYY/MM/DD

### Summary
| Metric | Count |
|--------|-------|
| New issues | XX |
| Closed issues | XX |
| Net change | +/-XX |
| Currently open | XX |
| Overdue | XX |
| High priority open | XX |

### Overdue Issues
| Key | Summary | Assignee | Due Date | Days Overdue |
|-----|---------|----------|----------|-------------|

### Activity by Member
| Member | Created | Closed | In Progress |
|--------|---------|--------|-------------|
```

## Workflow 4: Project Health Analysis

Comprehensive multi-dimensional analysis of project status.

### Steps

1. Collect all dimensions:

**Priority Distribution** (open issues):
- Query `backlog_count_issues` for each priority level with `statusId: [1,2,3]`.

**Overdue Analysis**:
- `backlog_get_issues` with `dueDateUntil: today`, `statusId: [1,2,3]`, `sort: dueDate`, `order: asc`.
- Calculate days overdue for each.

**Workload per Member**:
- `backlog_get_issues` with `statusId: [1,2,3]`, `count: 100`, group by assignee.
- Or loop `backlog_count_issues` per `assigneeId`.

**Velocity Trend** (if requested):
- Compare closed counts across recent weeks/sprints.

2. Format output:

```
## Project Health — PROJECT_KEY — YYYY-MM-DD

### Priority Distribution (Open Issues)
| Priority | Count | % |
|----------|-------|---|
| Urgent | X | X% |
| High | X | X% |
| Medium | X | X% |
| Low | X | X% |

### Overdue Issues (X total)
| Key | Summary | Assignee | Due | Days Over |
|-----|---------|----------|-----|-----------|

### Workload Distribution
| Member | Open Issues | High Priority | Overdue |
|--------|-------------|---------------|---------|

### Risk Assessment
- [Highlight any member with >X open issues]
- [Highlight issues overdue by >7 days]
- [Note if high-priority issues lack assignees]
```

## Date Calculation Reference

When user says relative dates, resolve them:
- "today" → current date
- "this week" → Monday of current week to today
- "last week" → previous Monday to previous Sunday
- "this month" → 1st of current month to today
- "this sprint" → look up current milestone dates via `backlog_get_version_milestone_list`

All date params use `YYYY-MM-DD` format.

## Workflow 5: Sprint Review Report

Generate a Sprint retrospective report and optionally save to Wiki.

### Steps

1. Call `backlog_get_version_milestone_list` with `projectKey` to find the target Sprint's `milestoneId`.
2. Query completed issues: `backlog_get_issues` with `milestoneId: [sprintId]`, `statusId: [4]` (Closed), `count: 100`.
3. Query incomplete issues: `backlog_get_issues` with `milestoneId: [sprintId]`, `statusId: [1,2,3]`, `count: 100`.
4. Count by status: `backlog_count_issues` with `milestoneId: [sprintId]` for each status.
5. **Work hours analysis**: From the issues retrieved in steps 2-3, aggregate `estimatedHours` and `actualHours` fields. Calculate:
   - Total estimated vs actual hours
   - Per-assignee breakdown
   - Estimation accuracy (actual / estimated ratio)
6. Generate report content:

```
## Sprint {N} Review — YYYY/MM/DD

### Sprint Goal
{goal description}

### Metrics
| Metric | Value |
|--------|-------|
| Planned issues | {total} |
| Completed | {n} ({%}) |
| Incomplete / Carried over | {n} |
| Estimated hours | {n}h |
| Actual hours | {n}h |
| Estimation accuracy | {%} |

### Completed Issues
| Key | Summary | Type | Assignee | Est. | Actual |
|-----|---------|------|----------|------|--------|

### Carried Over Issues
| Key | Summary | Reason | Next Sprint? |
|-----|---------|--------|-------------|

### Work Hours by Member
| Member | Estimated | Actual | Accuracy |
|--------|-----------|--------|----------|

### Retrospective Notes
- What went well: {items}
- What could improve: {items}
- Action items: {items}
```

7. Save to Wiki: call `backlog_add_wiki` with `projectId`, `name` (e.g., "Sprint {N} Review — {date}"), and the formatted content.
8. Optionally, for key completed issues, call `backlog_add_issue_comment` to leave a summary comment (e.g., "Completed in Sprint {N}. Actual hours: {n}h vs estimated: {n}h.").

## Resources

- `references/report-templates.md` — Customizable output format templates for standup, weekly, monthly, and health reports.
