---
name: backlog-wiki-docs
description: Nulab Backlog Wiki and Document management via MCP tools. Covers creating, searching, reading, and updating Wiki pages, as well as browsing and creating project documents. Use when the user wants to create meeting notes, technical documentation, Sprint review records, or any Wiki/document content in Backlog. Also triggers when the user asks to search, read, or update existing Wiki pages, or manage the document tree in a Backlog project. Requires the Backlog MCP server to be connected.
---

# Backlog Wiki & Document Management

Procedural guide for managing Wiki pages and Documents in Backlog projects.

## Workflow 1: Create a Wiki Page

### From User-Provided Notes

1. Identify the target project (ask if ambiguous).
2. Gather content from user: title, key points / bullet points / raw notes.
3. Expand user notes into a structured document using appropriate template from `references/doc-templates.md`.
4. Call `backlog_add_wiki` with:
   - `projectId` (resolve from project key via `backlog_get_project`)
   - `name`: page title
   - `content`: formatted content
   - `mailNotify`: set to `true` if user wants team notification

### Content Format

Check the project's `textFormattingRule` (via `backlog_get_project`):
- `"markdown"` → use standard Markdown
- `"backlog"` → use Backlog wiki syntax

When unsure, use Markdown — it's more commonly configured.

## Workflow 2: Search and Read Wiki Pages

### Search

1. Call `backlog_get_wiki_pages` with `projectKey` and optionally `keyword`.
2. Present results as a list with page names and IDs.

### Read Content

1. Call `backlog_get_wiki` with `wikiId` (from search results).
2. Display the page content to the user.

### Page Count

Call `backlog_get_wikis_count` with `projectKey` to get total Wiki pages in a project.

## Workflow 3: Update a Wiki Page

1. Search for the target page: `backlog_get_wiki_pages` with `keyword`.
2. Read current content: `backlog_get_wiki` with `wikiId`.
3. Apply user's requested changes (append, replace section, rewrite, etc.).
4. Call `backlog_update_wiki` with:
   - `wikiId`
   - `name` (if renaming)
   - `content` (updated full content)
   - `mailNotify` (if notification needed)

**Important**: `backlog_update_wiki` replaces the full content. Always read the current content first, merge changes, then write back.

## Workflow 4: Document Management

Documents are a separate system from Wiki in Backlog.

### Browse Documents

1. Call `backlog_get_document_tree` with `projectIdOrKey` to see the hierarchy.
2. Call `backlog_get_document` with `documentId` to read specific content.

### Create a Document

Call `backlog_addDocument` with:
- `projectId` (required)
- `title`: document title
- `content`: document body
- `parentId`: parent document ID (for nesting)
- `addLast`: `true` to add at end of list

### List Documents

Call `backlog_get_documents` with `projectIds: [id]` and optional `offset` for pagination.

## Resources

- `../_backlog-common/references/project-config.md` — Shared project configuration (project keys, team members, etc.). Read this first to skip runtime metadata queries.
- `references/doc-templates.md` — Templates for meeting notes, technical docs, Sprint reviews, and other common document types.
