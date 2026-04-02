---
name: backlog-issue-management
description: Nulab Backlog issue lifecycle management via MCP tools. Covers creating single or batch issues, updating status/assignee/priority, adding comments, closing issues, and searching/filtering issues by milestone, date, keyword, assignee, or custom field. Use this skill whenever the user intends to create or modify Backlog issues, bulk-update issue state, or decompose a spec or requirements list into Backlog issues, even if the request starts from a sprint or notification context. Requires the Backlog MCP server to be connected.
---

# Backlog Issue Management

Procedural guide for managing Backlog issues through MCP tools. Always query metadata IDs before operations — never hardcode or guess IDs.

## Scope

Use this skill when the task is primarily about issue CRUD and issue state changes.

- If the user wants unread summaries, mentions, or watch management, prefer `backlog-notifications`.
- If the user wants a standup, weekly report, sprint review, or project health summary, prefer `backlog-sprint-reporting`.
- If a request starts from notifications or a sprint report but the real task is "change these issues", switch to this skill for the mutation step.

## Content Rules

Read `references/policies.md` before creating or updating issues. Apply its language rules and footer convention unless the user explicitly asks to override them.

### Pre-modification Confirmation (MANDATORY)

Before calling ANY tool that mutates data (e.g., `backlog_add_issue`, `backlog_update_issue`, `backlog_add_issue_comment`, `backlog_delete_issue`), **always** present a detailed preview of the specific changes and wait for user confirmation:

```
## 変更確認 (Change Confirmation)

**Action**: [Create Issue / Update Issue / Add Comment]
**Target**: [New Issue / PROJ-123]
**Changes**:
- **Status**: [e.g., In Progress -> 処理済み]
- **Assignee**: [e.g., unassigned -> user.name]
- **Comment**: [e.g., "The fix has been deployed."]
- ... [other changes]

---
确认执行此操作吗？(是/否) / Are you sure you want to apply these changes? (Y/N)
```

- **You MUST NOT make any modifying tool calls until the user has explicitly confirmed.**
- **Batch Issues**: Show summary table of all changes, wait for user confirmation.
- **User Rejects**: Ask for modifications or cancel operation.

## Metadata-First Principle

Before any create/update operation, resolve human-readable names to IDs:

| Need | Tool | Key param |
|------|------|-----------|
| Issue type ID (Bug/Task/Story...) | `backlog_get_issue_types` | `projectKey` |
| Priority ID (High/Medium/Low...) | `backlog_get_priorities` | — |
| Category ID | `backlog_get_categories` | `projectKey` |
| Custom field definitions & option IDs | `backlog_get_custom_fields` | `projectKey` |
| Milestone/version ID | `backlog_get_version_milestone_list` | `projectKey` |
| Resolution ID (for closing) | `backlog_get_resolutions` | — |
| User ID (assignee) | `backlog_get_users` | — |

Cache results within the conversation — do not re-query unchanged metadata.

Read `references/project-config.md` before calling lookup tools. If the target project or value is missing there, fall back to MCP metadata queries.

## Workflow 1: Create a Single Issue

1. Identify the target project (ask user if ambiguous).
2. Call `backlog_get_project` with `projectKey` to confirm project info (ID, text formatting rule, etc.).
3. Query metadata: issue types, priorities, (optionally) categories, milestones, custom fields.
4. Map user intent to IDs:
   - Match issue type by name (e.g., "bug" -> Bug type ID).
   - Match priority by name (e.g., "high" -> High priority ID).
   - For custom fields: match field name -> field ID, option name -> option item ID.
5. Present the confirmation preview to the user.
6. Once confirmed, call `backlog_add_issue` with:
   - `projectId`, `summary`, `issueTypeId`, `priorityId` (required)
   - `description` (use Backlog markdown or plain text based on project's `textFormattingRule`). Apply Language Rules and Footer Signature.
   - Optional: `assigneeId`, `categoryId`, `milestoneId`, `versionId`, `startDate`, `dueDate`, `estimatedHours`, `parentIssueId`, `customFields`
7. Report created issue key back to user.

### Custom Fields Format

```
customFields: [
  { "id": 12345, "value": [67890] }           // single-select list: value = [itemId]
  { "id": 12346, "value": [111, 222] }         // multi-select list: value = [itemId, itemId]
  // Note: text/numeric/date custom fields are not directly supported in add_issue
  // via the MCP tool's customFields parameter — only list-type fields with item IDs
]
```

### Parent-Child Relationship

Set `parentIssueId` to create a sub-issue. The parent must exist in the same project.

## Workflow 2: Batch Issue Creation

For creating multiple issues from a requirements list, spec, or user-provided items.

1. Parse the user's input into a structured list of issues (summary, type, priority, description, etc.).
2. Query ALL needed metadata **once** upfront (types, priorities, milestones, categories, custom fields).
3. Build the ID-resolved issue list.
4. Present the confirmation summary table to the user.
5. Once confirmed, create issues sequentially with `backlog_add_issue`.
6. Collect all created issue keys and present a summary to the user.

### Efficiency Rules

- Query metadata only once, reuse across all issues.
- If creation of one issue fails, continue with remaining issues and report failures at the end.

For input format examples, see `references/batch-creation-patterns.md`.

## Workflow 3: Update Issues

### Single Issue Update (Combined Operations)

Whenever possible, **combine multiple updates into a SINGLE `backlog_update_issue` call**. For example, if you need to add a comment, change the assignee, and update the status, do it all in one call.

1. Get current state: `backlog_get_issue` (by key or ID).
2. Prepare the fields to change (e.g., `statusId`, `assigneeId`, `comment`).
3. Present the confirmation preview to the user.
4. Once confirmed, call `backlog_update_issue` with the combined fields.

### Resolving/Changing Status

- **DEFAULT TO "処理済み" (Resolved)**: When asked to change an issue's status to done/completed, unless explicitly instructed otherwise by the user, you should update the status to "処理済み" (usually ID 3) rather than "完了" (Closed, usually ID 4).
- **Closing ("完了")**: Only set status to "Closed" (status ID 4) if explicitly instructed. When doing so, you must also set `resolutionId`. Query `backlog_get_resolutions` to find the appropriate reason. Common pattern: `statusId: 4, resolutionId: 0` (対応済み).

### Bulk Status Update

1. Search target issues: `backlog_get_issues` with appropriate filters (statusId, milestoneId, assigneeId, etc.).
2. Present the confirmation list to the user before modifying.
3. Once confirmed, loop `backlog_update_issue` on each issue.
4. Report summary.

## Workflow 4: Search and Filter Issues

Use `backlog_get_issues` with filter combinations:

### Common Filter Patterns

| Scenario | Key params |
|----------|-----------:|
| My open issues | `assigneeId: [myId]`, `statusId: [1,2,3]` |
| Overdue issues | `dueDateUntil: "YYYY-MM-DD"` (today), `statusId: [1,2,3]` |
| Sprint backlog | `milestoneId: [sprintId]` |
| Recently created | `createdSince: "YYYY-MM-DD"` |
| By keyword | `keyword: "search term"` |
| By custom field | `customFields: [{"type":"text","id":fieldId,"value":"keyword"}]` |

### Pagination

- Default `count` is 20, max is 100.
- Use `offset` for pagination: 0, 100, 200, ...
- Use `backlog_count_issues` first to know total count.

### Sorting

Use `sort` param: `created`, `updated`, `dueDate`, `priority`, `status`, `assignee`, etc.
Combine with `order`: `asc` or `desc`.

## Workflow 5: Comments

- **Read comments**: `backlog_get_issue_comments` with `issueKey`, use `order: "desc"` for latest first.
- **Add comment**: Only use `backlog_add_issue_comment` if you are ONLY adding a comment. If you are also modifying the issue (status, assignee, etc.), use `backlog_update_issue` and pass the `comment` parameter. Always confirm with the user first.

## Safety Rules

1. **Confirmation Rule**: ALWAYS explicitly ask for confirmation with a preview of changes BEFORE mutating any data (`add_issue`, `update_issue`, `add_issue_comment`, `delete_issue`).
2. **Delete operations**: Always confirm with the user before calling `backlog_delete_issue`. State the issue key and summary being deleted.
3. **Bulk updates**: Always show the list of issues to be modified and get user confirmation before executing.
4. **Status transitions**: Confirm when closing issues — the user may want a specific resolution reason.
5. **Never guess IDs**: Always query metadata tools to resolve names to IDs.

## Resources

- `references/project-config.md` — Stable project, priority, resolution, issue type, and team ID mappings for common Backlog work.
- `references/policies.md` — Language rules and footer conventions for issue titles and descriptions.
- `references/issue-templates.md` — Reusable issue description templates for Bug, Task, Story, etc.
- `references/batch-creation-patterns.md` — Input format examples for batch issue creation.
