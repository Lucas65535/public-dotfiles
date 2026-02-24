# Document Templates

Templates for common Wiki and Document content types. Adapt language and format to the user's needs.

## Meeting Notes

```
# {Meeting Title} — {YYYY/MM/DD}

## Attendees
- {name} ({role})
- {name} ({role})

## Agenda
1. {topic 1}
2. {topic 2}
3. {topic 3}

## Discussion

### {Topic 1}
- {key point}
- {decision made}

### {Topic 2}
- {key point}
- {action item}: {owner} by {date}

## Action Items
| # | Action | Owner | Due Date | Status |
|---|--------|-------|----------|--------|
| 1 | {task} | {name} | {date} | Open |
| 2 | {task} | {name} | {date} | Open |

## Next Meeting
- Date: {YYYY/MM/DD}
- Topics: {planned topics}
```

## Sprint Review

```
# Sprint {N} Review — {YYYY/MM/DD}

## Sprint Goal
{what this sprint aimed to achieve}

## Completed Items
| Issue Key | Summary | Type | Assignee |
|-----------|---------|------|----------|

## Incomplete Items
| Issue Key | Summary | Reason | Carry Over? |
|-----------|---------|--------|-------------|

## Demo Notes
{features demonstrated, feedback received}

## Metrics
- Planned: {n} issues
- Completed: {n} issues ({%})
- Story Points: {completed}/{planned}

## Retrospective Notes
### What went well
- {item}

### What could improve
- {item}

### Action items
- {item} (Owner: {name})
```

## Technical Documentation

```
# {Component/Feature Name}

## Overview
{1-2 paragraphs explaining what this is and why it exists}

## Architecture
{high-level design, data flow, component relationships}

## Setup / Prerequisites
- {requirement 1}
- {requirement 2}

## Usage
{how to use this component, with code examples}

## API Reference
| Endpoint / Method | Description | Parameters |
|-------------------|-------------|-----------|

## Configuration
| Setting | Default | Description |
|---------|---------|-------------|

## Troubleshooting
| Issue | Cause | Solution |
|-------|-------|----------|

## Related Documents
- {link to related wiki page}
```

## Runbook / Operations Guide

```
# {Service Name} Runbook

## Service Overview
- **Repository**: {repo URL}
- **Deployment**: {where and how}
- **Monitoring**: {dashboard URL}
- **On-call**: {rotation info}

## Common Operations

### {Operation 1: e.g., Restart Service}
1. {step 1}
2. {step 2}
3. {verification step}

### {Operation 2: e.g., Scale Up}
1. {step 1}
2. {step 2}

## Incident Response
1. Check {monitoring dashboard}
2. Review {log location}
3. {escalation procedure}

## Contacts
| Role | Name | Contact |
|------|------|---------|
```
