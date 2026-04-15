---
name: backlog-notifications
description: Triage Nulab Backlog notifications and watching items with the Bee CLI. Use this skill whenever the user asks what changed in Backlog, what needs attention today, which items mention or assign them, whether notifications can be marked read, or when they want to inspect, add, remove, or clean up watching items.
---

# Backlog Notifications

Process notification and watching workflows through `bee`.

## Working Rules

- In Codex sandboxed runs, treat `bee auth status` as a network-dependent check, not a definitive auth verdict.
- If `bee auth status` reports `Authentication failed` inside the sandbox, treat that result as inconclusive because Bee validates credentials via the Backlog API and the sandbox may block outbound access.
- Retry the same read-only Bee command outside the sandbox before concluding auth is broken.
- Ask the user to run `bee auth login` only if the non-sandbox retry also fails or a non-sandbox read command shows the credentials are invalid.
- Prefer `--json` for reads.
- In non-interactive environments, pass all required flags explicitly and use `--yes` for write actions after user confirmation.
- Use dedicated commands before considering `bee api`.

## Project Setup & Identification

### Use Full Project Keys

Backlog projects are identified by their **full project key**, not a partial prefix.

**Wrong:**
```sh
bee milestone list -p SC --json  # ❌ Fails
```

**Right:**
```sh
bee milestone list -p SC_DEVOPS --json  # ✅ Works
bee milestone list -p SC_SAAS --json      # ✅ Works
```

### Preferred Project Mapping

| Project Key | Project Name | Project ID |
|-------------|--------------|------------|
| SC_DEVOPS   | One人事 DevOps | 124287 |
| SC_SAAS     | One人事 SaaS   | 87546 |
| SC_QA       | Q&A・要望       | 115671 |

⚠️ **Important:** The project **key** (e.g., `SC_DEVOPS`) is used with `-p` flag, NOT the project ID number.

### Retrieving Project Information

If unsure about the project key:

```sh
bee project list --json | jq '.[] | {key: .projectKey, name: .name}'
```

## Scope

Use this skill when the task is primarily about attention management rather than issue editing.

- If the user wants to change issue status, assignee, priority, body, or comments after triage, hand off the mutation step to `backlog-issue-management`.
- If the user wants project-level standups, reporting, or sprint analytics, prefer `backlog-sprint-reporting`.

## Workflow 1: Notification Triage

### Step 1: Count unread notifications

```sh
bee notification count \
  --already-read unread \
  --resource-already-read unread \
  --json
```

### Step 2: Fetch recent notifications with jq formatting

```sh
# Get last 50 notifications with summary
bee notification list --count 50 --order desc --json | \
  jq -r '.[] | "\(.id): \(.reason) - \(.resource.summary // "no summary") [\(.createdUser.name)]"'

# Get only unread notifications
bee notification list --count 100 --json | \
  jq -r '.[] | select(.lastRead == null) | "\(.id): \(.issue.key // .pullRequest.title) - \(.reason)"'
```

### Step 3: Pull context when needed

```sh
# View notification details (includes related issue)
bee notification view NOTIFICATION_ID --json | jq '.resource'

# Get issue details
bee issue view PROJ-123 --json | jq '{key: .issueKey, summary: .summary, status: .status.name}'

# Get recent comments on issue
bee issue comment PROJ-123 --list --json | jq -r '.[] | "\(.createdUser.name): \(.content)"'
```

### Step 4: Categorize and summarize

Use the Priority Classification order:
1. Directly assigned
2. Mention or review request
3. High-impact status change on watched work
4. General FYI activity

### Sandbox Retry Pattern

If notification reads fail in the Codex sandbox:

```sh
# First attempt (may fail due to network)
bee notification list --count 10 --json

# Retry outside sandbox (should succeed)
# Ask user: "Please run this command in your terminal to verify connectivity"
```

## Workflow 2: Mark Notifications as Read

Preview what will be marked as read before writing.

### Single notification

```sh
# Mark specific notification as read
bee notification read NOTIFICATION_ID --yes

# Or with preview
bee notification read NOTIFICATION_ID
# Confirm: "Mark notification NOTIFICATION_ID as read?"
```

### Bulk operations

```sh
# Mark all notifications as read (use with caution)
bee notification read-all --yes

# Selective cleanup: list then mark specific ones
bee notification list --json | jq -r '.[].id' > notification_ids.txt
# Review file, then:
xargs bee notification read < notification_ids.txt
```

### Filtered marking

```sh
# Mark all from a specific project as read
bee notification list --json | jq -r '.[] | select(.resource.project.key == "SC_DEVOPS") | .id' | \
  xargs bee notification read
```

Clarify whether the user wants a **targeted cleanup** or a **global reset** before executing.

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

## Troubleshooting

### "Notification count command fails"

**Symptom:** `bee notification count` returns an error.

**Fix:**
- Ensure you're using correct bee CLI version: `bee --version`
- Check authentication: `bee auth status`
- Use full project key if filtering by project (some subcommands support `-p`)

### "Watching list empty or unexpected"

**Symptom:** `bee watching list --json` returns empty or wrong items.

**Fix:**
- Check if you're in the correct Backlog space: `bee auth:whoami`
- Verify permissions: you can only see your own watching items
- Add explicit `--space` flag if using multiple spaces: `bee watching list --space nisshin30 --json`

### JSON parsing yields null fields

**Symptom:** Fields like `issue.summary` or `lastRead` return null.

**Fix:** Ensure you're using `--json` flag and proper jq syntax:

```sh
# Get all fields
bee notification list --count 10 --json | jq '.[0]'

# Access nested fields safely
bee notification list --count 10 --json | jq -r '.[] | "\(.resource.summary // "no summary")"'
```

### "Command not found: notification"

**Symptom:** `bee notification` subcommand not recognized.

**Cause:** Outdated bee CLI version.

**Fix:** Update bee: `npm update -g @nulab/bee`

## Resources

- `references/policies.md`
