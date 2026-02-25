---
name: _backlog-common
description: >
  Internal shared configuration for all Backlog skills. Contains project mappings,
  team member IDs, and metadata caches. This skill should NOT be used directly —
  it is referenced by other backlog-* skills as a shared data source.
---

# Backlog Common Configuration

This directory holds shared project configuration used by all `backlog-*` skills.

## Usage

Other Backlog skills reference `references/project-config.md` for cached metadata:
- Project keys/IDs
- Issue types, priorities, categories, custom fields
- Team member IDs and notification groups
- Milestones/sprints
- Resolutions
- Default values per project

Read `references/project-config.md` before making MCP API calls to skip unnecessary metadata queries.
