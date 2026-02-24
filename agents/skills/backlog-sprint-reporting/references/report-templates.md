# Report Templates

Customizable output formats for Backlog progress reports. Adapt these templates based on the user's language preference and reporting needs.

## Daily Standup Template

```
## Standup Summary — {date}

### {member_name}
**In Progress:**
- {issue_key}: {summary} ({priority}, due {due_date})

**Completed (since yesterday):**
- {issue_key}: {summary}

**Blocked:**
- {issue_key}: {summary} — {reason}

### Unassigned
- {issue_key}: {summary} ({priority}, due {due_date})

---
**Alerts:**
- {count} overdue issues
- {count} high-priority unassigned issues
```

## Weekly Report Template

```
## Weekly Report — {start_date} ~ {end_date}

### Key Metrics
| Metric | This Week | Last Week | Trend |
|--------|-----------|-----------|-------|
| New issues | {n} | {n} | {arrow} |
| Closed issues | {n} | {n} | {arrow} |
| Open issues (total) | {n} | {n} | {arrow} |
| Overdue | {n} | {n} | {arrow} |

### Highlights
- {notable achievement or milestone}
- {risk or blocker}

### Overdue Issues
| Key | Summary | Assignee | Due | Days Over |
|-----|---------|----------|-----|-----------|

### Next Week Focus
- {planned items}
```

## Monthly Report Template

```
## Monthly Report — {year}/{month}

### Executive Summary
{1-2 sentence overview}

### Metrics
| Metric | This Month | Last Month | Change |
|--------|------------|------------|--------|
| Issues created | {n} | {n} | {+/-n} |
| Issues closed | {n} | {n} | {+/-n} |
| Closure rate | {%} | {%} | {+/-%} |
| Avg time to close | {days} | {days} | {+/-d} |

### Sprint Progress
| Sprint | Planned | Completed | Completion Rate |
|--------|---------|-----------|-----------------|

### Team Workload
| Member | Created | Closed | Open | Overdue |
|--------|---------|--------|------|---------|

### Risks & Actions
| Risk | Impact | Mitigation |
|------|--------|-----------|
```

## Health Report Template

```
## Project Health — {project_key} — {date}

### Overall Status: {GREEN/YELLOW/RED}

Criteria:
- GREEN: <5% overdue, no critical unassigned issues
- YELLOW: 5-15% overdue or some high-priority unassigned
- RED: >15% overdue or critical blockers

### Priority Distribution
| Priority | Open | % of Total |
|----------|------|-----------|

### Overdue Analysis
- Total overdue: {n} ({%} of open)
- Avg days overdue: {n}
- Max days overdue: {n} ({issue_key})

### Workload Balance
| Member | Open | Capacity Alert |
|--------|------|---------------|

### Action Items
1. {recommended action}
2. {recommended action}
```
