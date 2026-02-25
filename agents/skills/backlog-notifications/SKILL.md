---
name: backlog-notifications
description: Nulab Backlog notification processing and watch management via MCP tools. Covers triaging unread notifications, understanding notification context, marking notifications as read, and managing watched issues. Use when the user asks to check notifications, process unread items, manage their watch list, or wants a summary of recent Backlog activity directed at them. Also triggers when the user says "check my notifications", "what's new", "unread messages", "watch this issue", or asks about items requiring their attention in Backlog. Requires the Backlog MCP server to be connected.
---

# Backlog Notification & Watch Management

Procedural guide for processing Backlog notifications and managing watched issues.

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

Call `backlog_add_watching` with:
- `issueIdOrKey`: the issue ID or key to watch
- `note`: optional note for why you're watching

### Update Watch Note

Call `backlog_update_watching` with `watchId` and `note`.

### Remove a Watch

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

- `../_backlog-common/references/project-config.md` — Shared project configuration (project keys, team members, etc.). Read this first to skip runtime metadata queries.
