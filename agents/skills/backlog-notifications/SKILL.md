---
name: backlog-notifications
description: Triage Nulab Backlog notifications and watching items with the Bee CLI. Use this skill whenever the user asks what changed in Backlog, what needs attention today, which items mention or assign them, whether notifications can be marked read, or when they want to inspect, add, remove, or clean up watching items.
---

# Backlog Notifications

Process notification and watching workflows through `bee`.

## Working Rules

- Confirm authentication if needed with `bee auth status`.
- Prefer `--json` for reads.
- In non-interactive environments, pass all required flags explicitly and use `--yes` for write actions after user confirmation.
- Use dedicated commands before considering `bee api`.

## Scope

Use this skill when the task is primarily about attention management rather than issue editing.

- If the user wants to change issue status, assignee, priority, body, or comments after triage, hand off the mutation step to `backlog-issue-management`.
- If the user wants project-level standups, reporting, or sprint analytics, prefer `backlog-sprint-reporting`.

## Workflow 1: Notification Triage

1. Count unread notifications:

```sh
bee notification count \
  --already-read unread \
  --resource-already-read unread \
  --json
```

2. Fetch recent notifications:

```sh
bee notification list --count 100 --order desc --json
```

3. Classify them into:
   - Requires action: direct assignment, mention, review request
   - Status updates: watched issues or PRs moving state
   - FYI: comments and general activity
4. Pull issue or PR context only when necessary:
   - `bee issue view ISSUE --json`
   - `bee issue comment ISSUE --list --json`
   - `bee pr view ... --json` or `bee pr list ... --json`
5. Present a concise grouped summary with issue key, reason, actor, and newest relevant comment or status.

## Workflow 2: Mark Notifications as Read

Preview what will be marked as read before writing.

Single notification:

```sh
bee notification read NOTIFICATION_ID --yes
```

All notifications:

```sh
bee notification read-all --yes
```

Clarify whether the user wants a targeted cleanup or a global reset.

## Workflow 3: Watching Management

### View Watching Items

```sh
bee watching list --json
```

If the user needs more detail for a specific item:

```sh
bee watching view WATCHING_ID --json
```

Present issue key, summary, note, read state, and timestamps when available.

### Add a Watching Item

Preview the issue key and note, then run:

```sh
bee watching add --issue PROJ-123 --note "Track rollout" --json --yes
```

### Remove a Watching Item

Preview the watching ID and linked issue, then run:

```sh
bee watching delete WATCHING_ID --json --yes
```

### Mark a Watching Item as Read

```sh
bee watching read WATCHING_ID --yes
```

### Updating Notes

Bee currently exposes add, view, delete, and read for watching items, but not a dedicated edit command. If the user specifically wants to change a note:

1. Explain that there is no first-class `bee watching edit`.
2. Prefer delete-and-recreate only if the user agrees.
3. Use `bee api` only when the API endpoint is clearly known and the user has confirmed the write.

## Priority Classification

Use this order when summarizing:

1. Directly assigned to the user
2. Direct mention or review request
3. High-impact status change on watched work
4. General FYI activity

## Output Style

Keep triage output short and actionable. A good default is:

```text
Requires Action
- PROJ-101 Assigned to you by Tanaka
- PROJ-205 Mentioned you in a comment: "Need your approval on rollback"

Status Updates
- PROJ-088 Processing -> Closed

FYI
- PROJ-150 New comment from Suzuki
```

After the summary, ask whether the user wants any of these actions:

- open an item
- mark items as read
- add or remove a watching item
- switch to issue mutation
