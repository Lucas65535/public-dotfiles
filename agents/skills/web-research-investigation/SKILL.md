---
name: web-research-investigation
description: >
  Web research and investigation reporting skill for live, source-backed market research, product
  comparison, technology investigation, and site-deep reading. Use this skill whenever the user
  asks for a 调查报告, 調査報告, research report, competitive analysis, 市場調査, 技術調査,
  vendor comparison, product comparison, current-state summary, or asks to search the web and
  synthesize findings into a structured report with citations. Use it even when the user only says
  "look this up", "compare these products", "帮我查一下", or "ネットで調べて", if the task
  requires multi-source web evidence rather than a quick factual answer.
---

# Web Research Investigation

Use this skill to turn web research into a disciplined workflow:

1. define the question and comparison frame
2. discover candidate sources broadly
3. read the right pages deeply
4. separate facts, inferences, and unknowns
5. write a report that is concrete, cited, and easy to scan

This skill should produce work that reads like a real research memo, not a vague internet summary.

## Execution Mode

Use a locally deployed Firecrawl instance as the only execution surface for this skill.

- Prefer `firecrawl` if it is already installed.
- If it is not installed, use `npx -y firecrawl-cli@latest` as the fallback command.
- Always point the CLI at the local instance with `FIRECRAWL_API_URL=http://localhost:3002` or `--api-url http://localhost:3002`, unless the user explicitly gives a different self-hosted Firecrawl URL.
- Do not fall back to the hosted Firecrawl API.
- Do not fall back to browser search, generic web search tools, or MCP tools when the local Firecrawl path fails.
- Do not require a separate SearXNG tool call. If the local Firecrawl instance is configured to use SearXNG internally, treat that as an implementation detail behind `firecrawl search`.

Before doing substantive research, run a quick preflight:

1. confirm the CLI exists and reports a version
2. confirm the local Firecrawl endpoint is configured
3. confirm the local Firecrawl service is reachable
4. confirm the first `firecrawl search` or `firecrawl scrape` request succeeds

Important sandbox note:

- In Codex, `localhost:3002` may be inaccessible from the sandbox even when the user's local Firecrawl service is healthy.
- Do not treat one sandbox-side connection failure as proof that the local service is down.
- If a localhost request fails in the sandbox, rerun the same check outside the sandbox with escalated permissions.
- If the escalated check succeeds, continue using the local Firecrawl path with escalated command execution for the research task.
- If the escalated check also fails, stop and tell the user exactly what is broken. Do not silently switch execution surfaces.

## Working Style

Write plainly.

- Prefer concrete wording over fashionable business language.
- Do not write phrases like "赋能", "抓手", "闭环", "生态位", "降本增效" unless you are quoting a source and the wording matters.
- Replace generic claims with specifics:
  - bad: "Product A empowers HR digital transformation"
  - good: "Product A covers onboarding, payroll, and evaluation in one system"
- Distinguish clearly between:
  - **fact**: directly supported by a source
  - **inference**: your reasoned conclusion from multiple facts
  - **unknown**: not confirmed from the available sources

## Tool Roles

### `firecrawl search`: discovery

Use `firecrawl search` first for broad discovery.

It is the default discovery step in this version of the skill because it keeps the workflow on one tool surface.

Use it for:

- official product pages
- pricing pages
- case studies
- security and API pages
- independent comparison articles
- recent news or reports when momentum matters

Do not trust one query or one result page. Run several narrow queries from different angles.

### `firecrawl scrape`: deep reading

Use `firecrawl scrape` when you know which pages matter.

Use it for:

- official pages
- pricing pages
- case studies
- blog posts
- docs pages that need full reading

Prefer `--only-main-content` for cleaner output. Add `--wait-for` when the page is JS-heavy.

### `firecrawl map`: site-deep discovery

Use `firecrawl map` when the relevant content is buried in a docs site or large product site.

Map first, then scrape the exact URLs you need.

### `firecrawl crawl`: constrained multi-page collection

Use `firecrawl crawl` only when map plus targeted scrape would be too slow.

Keep crawls tight:

- low page limits
- low depth
- include paths when possible
- no domain-wide crawling unless the user explicitly needs it

### `firecrawl agent`: last resort

Use `firecrawl agent` only when:

- the task spans many unknown sites
- the site is messy and normal search plus scrape still leaves gaps
- the user explicitly wants deeper autonomous research

Treat `firecrawl agent` output as a draft evidence set to review, not as unquestioned truth.

## Tool Selection Rules

Use this order unless there is a clear reason not to:

1. `firecrawl search` for discovery
2. `firecrawl scrape` for official pages and specific articles
3. `firecrawl map` when the relevant content is buried inside docs or a large site
4. `firecrawl crawl` only when map plus targeted scrape is too slow
5. `firecrawl agent` only if the normal workflow is not enough

Important constraints:

- Do not rely on a single broad `firecrawl search` query for serious market research.
- Do not scrape every search result. First rank URLs, then scrape the small set that matters.
- Do not jump to `firecrawl agent` because the first scrape was weak. First try:
  - `firecrawl scrape --wait-for 5000` to `10000`
  - direct subpages instead of the homepage
  - `firecrawl map` to locate the exact page
  - `firecrawl crawl` with tight limits if the relevant area spans several pages

## Research Workflow

### Phase 1: Define the Research Frame

Before searching, write down the frame in one short block:

- question to answer
- geography
- time window
- items being compared
- dimensions that matter
- what is out of scope

For example:

```text
Question: What are the main Japanese SaaS products in HR admin and talent management?
Geography: Japan
Time window: current market as of today
Compare: product scope, target customer, local workflow support, pricing style, adoption signals
Out of scope: global-only suites unless they matter in Japan
```

This prevents shallow "tool list" output.

### Phase 2: Source Plan

For serious market or product research, aim to cover at least these source types:

1. official product page
2. official pricing or plan page, if available
3. official case studies or customer stories
4. official security, compliance, or API/integration page when relevant
5. one or more independent comparison or market-overview pages
6. recent press release or report when adoption or momentum matters

Do not build a report from vendor pages alone unless the user explicitly wants only official positioning.

### Phase 3: Search Broadly with Firecrawl CLI

Search the same topic from several angles. One query is rarely enough.

Useful query families:

- official/vendor: `site:vendor.com product name`
- comparison: `A vs B`, `A 比較`, `A B 違い`
- buyer intent: `おすすめ`, `比較`, `review`, `導入事例`
- implementation: `API`, `integration`, `security`, `SSO`, `e-Gov`, `SOC2`
- pricing: `料金`, `pricing`, `plans`
- market view: `市場`, `シェア`, `カオスマップ`, `report`

For regional research, search in the market's language first. If the task is about Japan, run Japanese queries before English ones. Use English as a supplement, not a replacement.

After search, deduplicate and rank URLs. Prioritize:

- official product pages
- official customer case studies
- reputable local comparison media
- recent market reports or press releases
- pages with dates and clear attribution

### Phase 4: Read Deeply with Firecrawl CLI

Use `firecrawl scrape` for individual pages and `firecrawl map` to locate the right subpages.

For pricing, feature lists, and public product facts:

- prefer JSON output when the CLI flow supports a stable structured result for the task at hand
- otherwise scrape markdown and normalize the fields manually into your evidence table

For docs and large sites:

1. run `firecrawl map` with a focused search term
2. choose the exact URLs
3. scrape those pages directly

Do not send a large site to `firecrawl agent` just because the homepage was vague.

### Phase 5: Build an Evidence Table

As you read, normalize findings into a small table or note structure:

| Item | Dimension | Value | Source Type | URL | Date | Confidence |
|------|-----------|-------|-------------|-----|------|------------|
| Product A | Pricing | Quote-based | Official | ... | ... | High |
| Product A | SSO | Mentioned | Official | ... | ... | High |
| Product B | Adoption | "4,500 companies" | Official PR | ... | ... | Medium |

This makes synthesis cleaner and reduces accidental overstatement.

### Phase 6: Synthesize Carefully

Do three passes:

1. facts only
2. patterns and contrasts
3. unknowns, conflicts, and weak evidence

When a claim is derived rather than stated, say so:

- "Based on the pricing pages and case studies, this product appears more focused on mid-market customers."
- "This is an inference; the vendor does not state an explicit target segment."

## Reporting Rules

Read `references/report-template.md` before drafting the final report.

The report must answer the question directly and show enough evidence that another reader can verify it.

### What a good report must contain

- a direct executive summary
- clear scope and method
- comparison tables, not just prose
- evidence-backed findings with source links
- explicit unknowns and limitations
- references with access date

### Minimum comparison dimensions

When comparing products or vendors, cover as many of these as the evidence supports:

1. product scope
2. target customer segment
3. notable workflows or modules
4. region-specific support or regulation fit
5. pricing model and whether prices are public
6. implementation and support model
7. integration or API posture
8. security and compliance signals
9. public adoption signals
10. strengths
11. limitations
12. evidence quality

Do not stop at "features" and "pros/cons".

### For market research, add these dimensions

- market definition
- category split or taxonomy
- leading vendors by segment
- what buyers seem to optimize for
- major product trends
- where the evidence is still weak

### Plain-language requirements

Keep sentences short. Prefer nouns and verbs that describe what the product actually does.

Examples:

- instead of "build an all-in-one HR ecosystem", say "cover payroll, attendance, and evaluation in one suite"
- instead of "strong product capability", say "supports payroll, social insurance filings, and employee master data"
- instead of "deeply empower decision-making", say "provides dashboards and workforce analysis"

## Recommended Research Patterns

### Pattern 1: Market Survey

Use when the user asks for a market overview, category map, leading vendors, or buying criteria.

1. define geography, period, category, and exclusions
2. run 4-6 `firecrawl search` queries across official, comparison, and market-report angles
3. collect a long list of vendors
4. narrow to the main players with evidence
5. scrape official pages for product scope and positioning
6. scrape a small number of independent market-overview pages
7. write:
   - market structure
   - major players
   - buyer criteria
   - trends
   - comparison table

### Pattern 2: Product Comparison

Use when the user names specific tools or asks "which is better".

1. search official pages for each product
2. search pricing, case studies, API, and security pages
3. search independent reviews or comparison articles
4. extract fixed fields into a table
5. write a decision-oriented report with explicit tradeoffs

### Pattern 3: Site-Deep Reading

Use when the user gives a website or docs portal.

1. `firecrawl map` to find relevant pages
2. scrape only the relevant pages
3. organize findings by topic, not by URL
4. cite the pages you actually used

### Pattern 4: Fast Fact Collection Across Many Vendors

Use when you need the same fields from several product pages.

1. discover URLs with `firecrawl search`
2. scrape the candidate pages in a small batch
3. normalize the same fields into one table
4. review manually for obvious misses
5. fill gaps with direct `firecrawl scrape`

## Failure Handling

If a page returns weak or irrelevant content:

1. try `--wait-for 5000` to `10000`
2. try the direct subpage instead of the homepage
3. run `firecrawl map` with a specific search term
4. use a tighter scrape target instead of scraping the whole page blindly
5. try a small constrained crawl if the answer spans a docs section
6. only then consider `firecrawl agent`

If the failure is operational rather than content-related, stop and report it clearly instead of switching tools. Typical examples:

- `firecrawl` is not installed and `npx -y firecrawl-cli@latest` is unavailable
- `FIRECRAWL_API_URL` is missing or points at the wrong host
- the local Firecrawl service is down or not listening on the configured port
- the local deployment requires auth and the CLI is not configured for it
- a `firecrawl search` or `firecrawl scrape` request fails before any usable result is returned

When the failing request targets `localhost` from inside Codex, check whether the failure is sandbox-specific before concluding the service is broken:

1. run the preflight in the sandbox
2. if the localhost request fails, rerun the same command outside the sandbox with escalated permissions
3. if the escalated run works, continue the investigation with the same local Firecrawl command pattern outside the sandbox
4. if the escalated run also fails, report it as a real local Firecrawl problem

If a source is promotional or ambiguous:

- mark it as vendor positioning
- do not treat it as market fact unless corroborated

If you cannot verify a claim:

- leave it as unknown
- do not smooth over the gap with generic language

## Use of Firecrawl Agent

Use `firecrawl agent` only when one of these is true:

- the task is large and scattered across many unknown sites
- the site is heavily dynamic and normal search plus scrape still fails
- the user explicitly wants a deeper autonomous web investigation

When you use it:

- define a tight prompt
- request structured output when possible
- wait for completion instead of assuming a partial result is enough
- treat the result as input for review, not as unquestioned truth

## Operational Failure Message

When the local Firecrawl path is broken, tell the user directly and stop. Keep the message concrete. Example:

```text
Local Firecrawl is required for this skill, but the execution path is currently broken.
- CLI: installed
- API URL: http://localhost:3002
- Sandbox access to localhost: failed
- Escalated localhost check: failed
- Local service: not reachable
- Auth: not configured for this deployment

I stopped here instead of falling back to a hosted API or generic web search. If you want, I can help diagnose the local Firecrawl setup.
```

## Resources

- `references/report-template.md`: report structure for research memos and comparison reports
- `references/tool-quick-ref.md`: Firecrawl CLI command patterns for discovery, reading, mapping, crawling, and last-resort agent use
