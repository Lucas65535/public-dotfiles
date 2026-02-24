# Pull Request Description Templates

## Feature PR

```
## Summary
Implement {feature name} for {purpose}.

## Related Issue
{PROJECT-KEY}-{number}

## Changes
- {change 1}
- {change 2}
- {change 3}

## Testing
- [ ] Unit tests added/updated
- [ ] Manual testing completed
- [ ] Edge cases verified

## Screenshots
{if UI changes, add before/after screenshots}

## Notes for Reviewer
{any specific areas to focus review on}
```

## Bugfix PR

```
## Summary
Fix {bug description}.

## Related Issue
{PROJECT-KEY}-{number}

## Root Cause
{brief explanation of what caused the bug}

## Fix
{what was changed and why}

## Testing
- [ ] Bug no longer reproducible
- [ ] Regression tests added
- [ ] Related functionality verified

## Impact
{scope of the fix, any side effects}
```

## Release PR

```
## Release {version}

## Included Changes
- {PROJECT-KEY}-{n}: {summary}
- {PROJECT-KEY}-{n}: {summary}
- {PROJECT-KEY}-{n}: {summary}

## Breaking Changes
{list any breaking changes, or "None"}

## Migration Steps
{if applicable}

## Rollback Plan
{how to revert if issues arise}

## Checklist
- [ ] All tests passing
- [ ] Documentation updated
- [ ] Changelog updated
- [ ] Stakeholders notified
```

## Refactoring PR

```
## Summary
Refactor {component/module} to {goal: improve readability, reduce complexity, etc.}

## Related Issue
{PROJECT-KEY}-{number} (if applicable)

## Changes
- {structural change 1}
- {structural change 2}

## No Behavioral Change
This PR does not change any external behavior. All existing tests pass unchanged.

## Motivation
{why this refactoring is needed now}
```
