# Investigation Report Template

Use this template for market surveys, product comparisons, technology investigations, and site-deep research.

The point is not to sound polished. The point is to answer the question clearly, show the evidence, and make tradeoffs visible.

---

## Core Template

```markdown
# [Report Title]

> Research date: YYYY-MM-DD HH:MM JST
> Scope: [geography / time window / category]
> Method: Firecrawl CLI for discovery, page reading, and site mapping
> Source mix: [official pages / case studies / third-party comparisons / reports]
> Saved path: [absolute or workspace-relative report file path]

## Executive Summary

[4-8 sentences. Answer the question first. Name the main conclusion, the main tradeoff, and the main uncertainty.]

## Research Frame

- Question: [what was investigated]
- In scope: [products / regions / time window]
- Out of scope: [what was excluded]
- Comparison dimensions: [what matters in this report]

## Method and Source Quality

| Source type | Role in this report | Reliability notes |
|-------------|---------------------|-------------------|
| Official product pages | Product scope, pricing, positioning | Strong for product facts, weak for market claims |
| Official case studies | Implementation examples, customer type | Useful but selective |
| Independent comparison articles | Cross-vendor framing | Check freshness and bias |
| Press releases / market reports | Adoption signals, momentum | Verify dates and wording |

## Market Structure or Comparison Set

[Explain the category split or why these products were chosen.]

## Detailed Findings

### 1. [Finding title]

[State the finding in plain language.]

- Evidence:
  - [Source title](URL)
  - [Source title](URL)
- What this means:
  - [short interpretation]
- Unknowns:
  - [what remains unverified]

### 2. [Finding title]

[Repeat as needed.]

## Comparison Table

| Product / Vendor | Product scope | Target customer | Key modules / workflows | Pricing model | Integrations / API | Security / compliance signals | Adoption signals | Main strengths | Main limitations |
|------------------|---------------|-----------------|--------------------------|---------------|--------------------|-------------------------------|------------------|----------------|------------------|
| A | ... | ... | ... | ... | ... | ... | ... | ... | ... |
| B | ... | ... | ... | ... | ... | ... | ... | ... | ... |
| C | ... | ... | ... | ... | ... | ... | ... | ... | ... |

## Buyer or Decision View

### If the reader wants [priority A]

- [Which products fit]
- [Why]
- [What to watch out for]

### If the reader wants [priority B]

- [Which products fit]
- [Why]
- [What to watch out for]

## Trends and Implications

- Trend 1: [concrete description]
- Trend 2: [concrete description]
- Trend 3: [concrete description]

## Gaps, Contradictions, and Limits

- [claim that could not be verified]
- [where vendor language and independent sources differ]
- [data that is old, missing, or not public]

## Bottom Line

[Short closing paragraph. Say what is most likely true based on the evidence, and what the reader should verify next if making a real decision.]

## References

| # | Source title | URL | Accessed | Contribution |
|---|--------------|-----|----------|--------------|
| 1 | ... | https://... | YYYY-MM-DD | Product scope |
| 2 | ... | https://... | YYYY-MM-DD | Pricing / adoption signal |
| 3 | ... | https://... | YYYY-MM-DD | Third-party comparison |
```

---

## Section Guide

| Section | Include when |
|---------|--------------|
| Executive Summary | Always |
| Research Frame | Always |
| Method and Source Quality | Always |
| Market Structure or Comparison Set | Always for market/product research |
| Detailed Findings | Always |
| Comparison Table | Always when 2 or more products, vendors, or options are involved |
| Buyer or Decision View | When the user needs selection guidance |
| Trends and Implications | When looking at a market, category, or product direction |
| Gaps, Contradictions, and Limits | Always |
| References | Always |

## Writing Rules

- Prefer direct language over consultant language.
- Do not pad the report with abstract phrases.
- If a number is important, give the number, unit, and date.
- If a claim comes only from a vendor page, say that.
- If a conclusion is your inference, label it as an inference.
- If evidence is weak, say so instead of smoothing it over.

## Useful Extra Tables

### Pricing and packaging

| Product | Public pricing | Pricing style | Free trial | Notes |
|---------|----------------|---------------|------------|-------|
| A | Yes / No | per user / quote / tiered | Yes / No | ... |

### Implementation and support

| Product | Implementation model | Customer support | Typical fit | Notes |
|---------|----------------------|------------------|-------------|-------|
| A | self-serve / guided / partner-led | chat / email / CSM | SMB / mid-market / enterprise | ... |

### Source quality log

| Claim | Best supporting source | Source type | Confidence |
|-------|------------------------|-------------|------------|
| ... | ... | official / third-party / report | high / medium / low |
