---
name: backlog-notifications
description: Nulab Backlog notification triage and watch management via MCP tools. Covers summarizing unread notifications, understanding mentions and assignments with issue or PR context, marking notifications as read, and managing watched issues. Use this skill whenever the user asks what needs their attention in Backlog, what changed recently, which watched issues moved, or wants to add, update, remove, or review watches. Requires the Backlog MCP server to be connected.
---

# Backlog Notification & Watch Management

Procedural guide for processing Backlog notifications and managing watched issues.

## Scope

Use this skill when the task is primarily about attention management rather than issue editing.

- If the user wants to change issue state, assignee, priority, or comments after triage, hand off the mutation step to `backlog-issue-management`.
- If the user wants a project-level report, standup summary, sprint review, or risk analysis, prefer `backlog-sprint-reporting`.

Do not rely on local metadata caches here unless the user explicitly asks for project-specific mapping help. Notification payloads, `backlog_get_myself`, and follow-up MCP lookups are usually sufficient.

## Workflow 1: Morning Notification Triage

Process all unread notifications and present a prioritized summary.

### Steps

1. Check unread count: `backlog_count_notifications` with `alreadyRead: false`, `resourceAlreadyRead: false`.
2. If count > 0, fetch notifications: `backlog_get_notifications` with `count: 100`, `order: "desc"`.
3. For each notification, classify by type and gather context:
   - **Issue status change**: note the old/new status from the notification data.
   - **Issue comment / @mention**: call `backlog_get_issue_comments` on the related issue to get recent comment content.
   - **Issue assignment**: note who assigned what.
   - **PR activity**: note PR number and action. Call `backlog_get_pull_request_comments` to get review discussion details.
4. Group and present:

```
## Notifications Summary — {date}

### Requires Your Action ({count})
- [PROJ-101] You were assigned: "Fix login timeout" (High priority)
- [PROJ-205] @mentioned in comment: "{comment preview}"

### Status Updates ({count})
- [PROJ-88] Status changed: Processing → Closed (by Tanaka)
- [PROJ-92] Status changed: Open → Processing (by Suzuki)

### FYI ({count})
- [PROJ-150] New comment: "{preview}"
- [PR #12] New comment on "Refactor auth module"
```

5. Ask user if they want to mark all as read or handle individually.

## Workflow 2: Mark Notifications as Read

Before any read-state mutation, show the target notification IDs or state change summary and ask for confirmation.

### Mark Individual

Call `backlog_mark_notification_as_read` with `id` (notification ID from the list).

### Mark All as Read

Call `backlog_reset_unread_notification_count`.

> Note: `reset_unread_notification_count` only resets the counter. Individual notifications retain their read/unread state until marked via `mark_notification_as_read`.

## Workflow 3: Watch Management

### View My Watches

1. Get current user ID: `backlog_get_myself`.
2. Call `backlog_get_watching_list_items` with `userId`.
3. Present as table:

```
| Issue Key | Summary | Watch Note | Last Updated |
|-----------|---------|------------|-------------|
```

### Watch Count

Call `backlog_get_watching_list_count` with `userId`.

### Add a Watch

Before adding a watch, show the target issue key and optional note and ask for confirmation.

Call `backlog_add_watching` with:
- `issueIdOrKey`: the issue ID or key to watch
- `note`: optional note for why you're watching

### Update Watch Note

Before updating a watch note, show the old note and new note and ask for confirmation.

Call `backlog_update_watching` with `watchId` and `note`.

### Remove a Watch

Before deleting a watch, show the watch ID, issue key, and note summary and ask for confirmation.

Call `backlog_delete_watching` with `watchId`.

### Mark Watch as Read

Call `backlog_mark_watching_as_read` with `watchId`.

## Priority Classification

When presenting notifications, classify urgency:

| Priority | Criteria |
|----------|----------|
| **Action Required** | Assigned to you, @mentioned, review requested |
| **Status Update** | Issues you watch changed status |
| **FYI** | Comments on watched issues, other activity |

## Resources

- No bundled references by default. Keep this skill lean and resolve metadata dynamically from Backlog when needed.
