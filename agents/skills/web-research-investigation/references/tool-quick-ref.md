# Tool Quick Reference

Use this file to avoid two common mistakes:

1. using too many moving parts for a simple investigation
2. using Firecrawl CLI in a loose way that produces noisy evidence

This version of the skill assumes one execution surface:

- `firecrawl` CLI

If `firecrawl` is not installed, use:

```bash
npx -y firecrawl-cli@latest ...
```

For local or self-hosted use, require:

```bash
FIRECRAWL_API_URL=http://localhost:3002 firecrawl ...
```

If you want the setting to persist in your shell session:

```bash
export FIRECRAWL_API_URL=http://localhost:3002
firecrawl --status
```

When `FIRECRAWL_API_URL` points to a local Firecrawl instance, treat that as the system of record for this skill. Do not switch to the hosted Firecrawl API. Do not split discovery into a separate SearXNG command unless the user explicitly asks for that.

## Preflight

Run these checks before a substantial investigation:

```bash
firecrawl --version
firecrawl --status
nc -z localhost 3002
FIRECRAWL_API_URL=http://localhost:3002 firecrawl search "test" --limit 1 --json
```

If any localhost check fails inside Codex, do one more verification outside the sandbox before diagnosing Firecrawl itself. In this environment, sandboxed `localhost` can fail even when the user's host service is healthy.

Recommended escalation pattern:

1. run the localhost preflight in the sandbox
2. if it fails, rerun the same command outside the sandbox with escalated permissions
3. if the escalated run succeeds, continue using local Firecrawl outside the sandbox
4. if the escalated run also fails, stop and report the exact failure to the user

Do not continue with generic web search as a fallback.

## `firecrawl search`

Use it for discovery. Run several focused queries rather than one broad query.

### Broad discovery

```bash
FIRECRAWL_API_URL=http://localhost:3002 \
firecrawl search "日本 タレントマネジメント SaaS 比較" --limit 10 --json
```

### Official pages

```bash
FIRECRAWL_API_URL=http://localhost:3002 \
firecrawl search "SmartHR 人事労務 公式" --limit 5 --json
```

### Recent news

```bash
FIRECRAWL_API_URL=http://localhost:3002 \
firecrawl search "AI startups funding" --sources news --tbs qdr:m --limit 10 --json
```

### Search and scrape a small result set

```bash
FIRECRAWL_API_URL=http://localhost:3002 \
firecrawl search "API documentation" --limit 5 --scrape --scrape-formats markdown --json
```

Use `--scrape` only for narrow result sets. Do not use it as a lazy replacement for source ranking.

## `firecrawl scrape`

Use it to read specific pages.

### One page in clean markdown

```bash
FIRECRAWL_API_URL=http://localhost:3002 \
firecrawl scrape https://example.com/pricing --only-main-content -o pricing.md
```

### JS-heavy page

```bash
FIRECRAWL_API_URL=http://localhost:3002 \
firecrawl scrape https://example.com/app-docs --only-main-content --wait-for 8000 -o docs.md
```

### Multiple pages

```bash
FIRECRAWL_API_URL=http://localhost:3002 \
firecrawl scrape https://vendor-a.example.com https://vendor-b.example.com --only-main-content --json
```

### Structured output when useful

```bash
FIRECRAWL_API_URL=http://localhost:3002 \
firecrawl scrape https://example.com --format markdown,links --json --pretty
```

Prefer markdown for reading. Prefer JSON when you need to post-process fields, links, or metadata in the shell.

## `firecrawl map`

Use it before crawl and before agent.

### Find the right subpages

```bash
FIRECRAWL_API_URL=http://localhost:3002 \
firecrawl map https://docs.example.com --search "SSO API SCIM" --json
```

### Limit and save results

```bash
FIRECRAWL_API_URL=http://localhost:3002 \
firecrawl map https://example.com --search "pricing" --limit 50 --json -o urls.json
```

Use map when the homepage is vague or the site is large.

## `firecrawl crawl`

Use it conservatively.

### Tight crawl

```bash
FIRECRAWL_API_URL=http://localhost:3002 \
firecrawl crawl https://docs.example.com --limit 20 --max-depth 2 --wait
```

### Constrained by paths

```bash
FIRECRAWL_API_URL=http://localhost:3002 \
firecrawl crawl https://docs.example.com \
  --include-paths /guides,/reference \
  --limit 20 \
  --max-depth 2 \
  --wait
```

Only crawl when map plus targeted scrape would be too slow.
Note: current CLI help shows `crawl` supports `--pretty` and `-o`, but not `--json`.

## `firecrawl agent`

Use only as a last resort for messy research.

```bash
FIRECRAWL_API_URL=http://localhost:3002 \
firecrawl agent "Find the leading Japanese SaaS products in payroll, labor admin, and talent management. For each product, identify product scope, target customer, public pricing model, security signals, and public adoption signals." --wait --json
```

Prefer bounded prompts. Review the output manually.

## Useful shell patterns

### Save search results and inspect URLs

```bash
FIRECRAWL_API_URL=http://localhost:3002 \
firecrawl search "SmartHR pricing" --limit 10 --json -o search-results.json

jq -r '.data.web[]?.url' search-results.json
```

### Build a URL list from map output

```bash
FIRECRAWL_API_URL=http://localhost:3002 \
firecrawl map https://docs.example.com --search "API" --json -o map.json

jq -r '.data.links[]?.url' map.json
```

### Keep evidence files

For serious investigations, save intermediate files rather than relying on terminal scrollback:

- `search-results.json`
- `pricing.md`
- `security.md`
- `cases.md`
- `map.json`

This makes the final report and source audit easier.

## Failure Reporting

When the local Firecrawl path is broken, prefer a short operational report over a workaround:

```text
Local Firecrawl is required for this skill, but the execution path is currently broken.
- CLI: installed or missing
- API URL: current configured value
- Sandbox localhost check: passed or failed
- Escalated localhost check: passed or failed
- Local service: reachable or not reachable
- Auth: configured or not configured for this deployment

I stopped here instead of falling back to a hosted API or generic web search.
```
