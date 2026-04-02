# Reporting Policies

Use these shared reporting semantics so this skill stays aligned with issue-management behavior.

## Status Semantics

- Open: status ID `1`
- In progress: status ID `2`
- Resolved but not formally closed: status ID `3`
- Closed: status ID `4`
- Active work: status IDs `[1,2,3]`
- Business-done work: status IDs `[3,4]`
- Formally closed work: status IDs `[4]`

## Date Resolution

- `today` -> current date
- `this week` -> Monday of current week through today
- `last week` -> previous Monday through previous Sunday
- `this month` -> first day of current month through today
- `this sprint` -> resolve from `bee milestone list -p PROJECT --json`

Use `YYYY-MM-DD` for Backlog date parameters.
