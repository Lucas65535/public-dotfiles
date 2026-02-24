# Batch Issue Creation Patterns

Examples of input formats the user may provide, and how to parse them into Backlog issues.

## Pattern 1: Simple List

User input:
```
Create these tasks in PROJECT-KEY:
1. Implement user login
2. Add password recovery
3. Set up OAuth2 integration
4. Write authentication tests
```

Parse as:
- 4 issues, all type=Task (default), priority=Medium (default)
- Summary = each list item
- All in the same project

## Pattern 2: Structured List with Metadata

User input:
```
Create issues in PROJECT-KEY, Sprint 15:
- [Bug/High] Login fails on Safari - assign to Tanaka
- [Task/Medium] Refactor auth module
- [Story/High] User profile page - due 2026-03-01
```

Parse as:
- Extract type, priority, assignee, due date from inline annotations
- `[Type/Priority]` pattern at the start
- `assign to Name` or `due YYYY-MM-DD` at the end

## Pattern 3: Parent + Children

User input:
```
Parent: PROJECT-KEY-100
Children:
1. Frontend implementation - Task, High
2. Backend API - Task, High
3. Database migration - Task, Medium
4. Integration tests - Task, Low
```

Parse as:
- All children get `parentIssueId` = ID of PROJECT-KEY-100
- Resolve parent issue key to numeric ID via `backlog_get_issue`

## Pattern 4: Create Parent with Children

User input:
```
Create a Story "User Authentication Feature" with sub-tasks:
1. Design login UI
2. Implement login API
3. Add session management
4. Write E2E tests
```

Parse as:
- First create the parent Story
- Then create 4 sub-tasks with `parentIssueId` = newly created parent's ID

## Pattern 5: From Spec / Requirements Document

User input provides a longer document or spec. Parse approach:
1. Identify distinct work items (look for headings, bullet points, numbered items)
2. Infer issue type from context (UI work = Task, bug description = Bug, user-facing feature = Story)
3. Infer priority from language cues ("critical" = High, "nice to have" = Low)
4. Group related items under a parent issue if they form a logical feature

## Execution Checklist

When processing any batch creation:

1. Parse all items first — present the parsed list to user for confirmation
2. Query metadata once (types, priorities, milestones, users)
3. Resolve all names to IDs
4. Create issues sequentially
5. Track successes and failures
6. Present final summary table:

```
| # | Issue Key | Summary | Type | Priority | Status |
|---|-----------|---------|------|----------|--------|
| 1 | PROJ-101 | Login UI | Task | High | Created |
| 2 | PROJ-102 | Login API | Task | High | Created |
| 3 | — | Session mgmt | Task | Medium | FAILED: [reason] |
```
