---
name: backlog-git-pr
description: >
  Nulab Backlog Git repository and Pull Request management via MCP tools. Covers browsing
  repositories, creating pull requests with issue linking, code review workflows (viewing and
  adding PR comments), and PR status tracking. Use when the user wants to create a PR in Backlog,
  review pull requests, add review comments, check PR status, list open PRs, or link PRs to
  Backlog issues. Also triggers when the user mentions "pull request", "PR", "code review",
  "merge request", or "branch" in the context of Backlog Git operations.
  Requires the Backlog MCP server to be connected.
---

# Backlog Git & Pull Request Management

Procedural guide for Git repository browsing and Pull Request lifecycle management in Backlog.

## Workflow 1: Create a Pull Request

### Steps

1. **Detect current branch** (if user says "current branch"): run `git branch --show-current` via terminal to get the branch name automatically.
2. Identify the target project and repository:
   - Call `backlog_get_git_repositories` with `projectKey` to list repos.
   - If multiple repos exist, ask user which one (or match by name).
3. Gather PR parameters from user:
   - `branch`: source branch name (from step 1 or user-specified, e.g., `feature/user-auth`)
   - `base`: target branch name (e.g., `main`, `develop` — use project convention)
   - `summary`: PR title (see Title Convention below)
   - `description`: PR body (supports markdown)
4. Optional linking:
   - `issueId`: link to a Backlog issue (resolve issue key to numeric ID via `backlog_get_issue` if needed).
   - `assigneeId`: reviewer/assignee (resolve user name to ID via `backlog_get_users`).
   - `notifiedUserId`: users to notify.
5. If linking to an issue, call `backlog_get_issue` to fetch issue details for auto-generating the PR summary and description.
6. Call `backlog_add_pull_request` with all params.
7. **Post-creation issue updates**:
   - Call `backlog_update_issue` to change the linked issue's status (e.g., to "Processing" or "Resolved"). Ask user which status is appropriate.
   - Call `backlog_add_issue_comment` on the linked issue with a comment containing the PR reference (e.g., "PR #{number} created: {summary}").
8. Report the created PR number back to user.

### PR Title Convention

Default format: `[PROJECT-KEY-xxx] Change description`

Examples:
- `[PROJ-42] Implement user authentication`
- `[PROJ-108] Fix session timeout on Safari`

If no issue is linked, use a descriptive title without the prefix.

### PR Description Best Practices

Include in description:
- Summary of changes
- Related issue key (e.g., `PROJECT-123`)
- Testing notes
- Screenshots if UI changes

See `references/pr-templates.md` for templates.

## Workflow 2: Code Review

### View PRs Pending Review

1. Call `backlog_get_pull_requests` with `projectKey`, `repoName`, `statusId: [1]` (Open).
2. Present as table:

```
| # | Summary | Author | Branch | Created |
|---|---------|--------|--------|---------|
```

### Review a Specific PR

1. Call `backlog_get_pull_request` with `projectKey`, `repoName`, `number`.
2. Display: summary, description, branch info, issue link, status.
3. Call `backlog_get_pull_request_comments` with `number` to see existing review discussion.

### Add Review Comment

Call `backlog_add_pull_request_comment` with:
- `projectKey`, `repoName`, `number`
- `content`: the review comment (supports markdown)
- Optional `notifiedUserId`: ping the PR author

### Update Existing Comment

Call `backlog_update_pull_request_comment` with `number`, `commentId`, `content`.

## Workflow 3: PR Status Management

### PR Status IDs

| Status | ID | Description |
|--------|----|-------------|
| Open | 1 | Awaiting review |
| Closed | 2 | Closed without merge |
| Merged | 3 | Merged into base |

### Update PR Status

Call `backlog_update_pull_request` with `number` and `statusId`.

### PR Statistics

1. Call `backlog_get_pull_requests_count` with different `statusId` values:
   - `statusId: [1]` → Open count
   - `statusId: [2]` → Closed count
   - `statusId: [3]` → Merged count
2. Present summary.

## Workflow 4: Repository Browsing

- **List repositories**: `backlog_get_git_repositories` with `projectKey`.
- **Repository details**: `backlog_get_git_repository` with `projectKey` and `repoName` or `repoId`.

> Note: Backlog MCP does not support browsing file contents or viewing diffs. For code-level review, direct the user to the Backlog web UI.

## Resources

- `references/pr-templates.md` — PR description templates for features, bugfixes, and releases.
