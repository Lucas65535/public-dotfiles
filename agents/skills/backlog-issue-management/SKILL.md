---
name: backlog-issue-management
description: Nulab Backlog issue lifecycle management via MCP tools. Covers creating single/batch issues, updating status/assignee/priority, searching with filters (custom fields, dates, milestones), managing comments, and handling issue metadata (types, priorities, categories, custom fields, resolutions). Use when the user wants to create, update, search, filter, bulk-modify, or close issues in Backlog. Also triggers when the user provides a requirements list or spec to be decomposed into Backlog issues, or asks to change issue status/assignee in bulk. Requires the Backlog MCP server to be connected.
---

# Backlog Issue Management

Procedural guide for managing Backlog issues through MCP tools. Always query metadata IDs before operations — never hardcode or guess IDs.

## Content Rules (MUST FOLLOW)

These rules apply to **every** issue creation and update operation.

### Language Rules

| Field                  | Language | Style                      |
| ---------------------- | -------- | -------------------------- |
| **Summary (Title)**    | 日本語   | 簡潔で正確な書面語         |
| **Description (Body)** | 中文     | 清晰易懂的技术文档风格     |

Title examples (日本語):
```
✗ Bad:  做一个登录功能
✗ Bad:  make login feature
✓ Good: 【Backend】ユーザー認証バグの修正
✓ Good: 【DevOps】PostgreSQLの接続プール構成の最適化検討（PgBouncer導入）
```

### Footer Signature

Always append at the end of issue description:

```
<small>via Backlog MCP</small>
```

### Pre-creation Confirmation

Before calling `backlog_add_issue`, **always** present a preview and wait for user confirmation:

```
## Issue 作成確認

**Project**: SC_DEVOPS (One人事 DevOps)
**Type**: タスク (ID: 442104)
**Priority**: 中 (ID: 3)
**Summary**: ログイン機能の実装
**Description**: (preview)
**Milestone**: SP_2026/02
**Assignee**: yang.jiguang 楊 済光 

---
确认创建此 Issue 吗？(是/否)
```

- **Single Issue**: Show preview, wait for user confirmation to proceed
- **Batch Issues**: Show summary table, wait for user confirmation
- **User Rejects**: Ask for modifications or cancel operation

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

Read `../_backlog-common/references/project-config.md` first to skip known mappings.

## Workflow 1: Create a Single Issue

1. Identify the target project (ask user if ambiguous).
2. Call `backlog_get_project` with `projectKey` to confirm project info (ID, text formatting rule, etc.).
3. Query metadata: issue types, priorities, (optionally) categories, milestones, custom fields.
4. Map user intent to IDs:
   - Match issue type by name (e.g., "bug" -> Bug type ID).
   - Match priority by name (e.g., "high" -> High priority ID).
   - For custom fields: match field name -> field ID, option name -> option item ID.
5. Call `backlog_add_issue` with:
   - `projectId`, `summary`, `issueTypeId`, `priorityId` (required)
   - `description` (use Backlog markdown or plain text based on project's `textFormattingRule`). Apply Language Rules and Footer Signature.
   - Optional: `assigneeId`, `categoryId`, `milestoneId`, `versionId`, `startDate`, `dueDate`, `estimatedHours`, `parentIssueId`, `customFields`
6. Report created issue key back to user.

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
4. Create issues sequentially with `backlog_add_issue`:
   - If `parentIssueId` is specified for all items, set it on each call.
   - If the user wants a new parent issue + children: create the parent first, then use its returned ID as `parentIssueId` for children.
5. Collect all created issue keys and present a summary table to the user.

### Efficiency Rules

- Query metadata only once, reuse across all issues.
- If creation of one issue fails, continue with remaining issues and report failures at the end.
- Present a summary: created count, failed count, issue key list.

For input format examples, see `references/batch-creation-patterns.md`.

## Workflow 3: Update Issues

### Single Issue Update

1. Get current state: `backlog_get_issue` (by key or ID).
2. Call `backlog_update_issue` with only the fields that need changing.
3. Optionally add a `comment` in the same update call to explain the change.

### Bulk Status Update

1. Search target issues: `backlog_get_issues` with appropriate filters (statusId, milestoneId, assigneeId, etc.).
2. Confirm the list with the user before modifying.
3. Loop `backlog_update_issue` on each issue.
4. Report summary.

### Closing an Issue

When setting status to "Closed" (status ID 4):
- Must also set `resolutionId`. Query `backlog_get_resolutions` to find the appropriate reason.
- Common pattern: `statusId: 4, resolutionId: 0` (対応済み).

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
- **Add comment**: `backlog_add_issue_comment` with `issueKey` and `content`. Optionally set `notifiedUserId` to ping specific users.

## Safety Rules

1. **Delete operations**: Always confirm with the user before calling `backlog_delete_issue`. State the issue key and summary being deleted.
2. **Bulk updates**: Always show the list of issues to be modified and get user confirmation before executing.
3. **Status transitions**: Confirm when closing issues — the user may want a specific resolution reason.
4. **Never guess IDs**: Always query metadata tools to resolve names to IDs.

## Resources

- `../_backlog-common/references/project-config.md` — Shared project configuration (project keys, type mappings, team members, priorities, milestones, etc.). Read this first to skip runtime metadata queries.
- `references/issue-templates.md` — Reusable issue description templates for Bug, Task, Story, etc.
- `references/batch-creation-patterns.md` — Input format examples for batch issue creation.
