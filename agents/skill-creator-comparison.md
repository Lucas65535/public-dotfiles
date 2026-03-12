# Skill Creator Deep Comparison

This document compares the two `skill-creator` skills in this repository:

- `agents/skills/skill-creator/`
- `agents/skills/.system/skill-creator/`

The goal is not just to say "they are different", but to explain:

1. How each one works in concrete terms
2. What workflow each one is optimized for
3. Where they overlap
4. Where they diverge or conflict
5. How they should be understood together

## Files Compared

- `agents/skills/skill-creator/SKILL.md`
- `agents/skills/.system/skill-creator/SKILL.md`

Supporting scripts and references were also reviewed from both directories.

## Executive Summary

These two `skill-creator` directories are not duplicates in the narrow sense. They represent two different layers of the skill lifecycle.

- `agents/skills/.system/skill-creator` is primarily a skill scaffolding and standards guide for Codex-style skills. It focuses on initializing a skill correctly, organizing resources, generating UI metadata, and validating the structure.
- `agents/skills/skill-creator` is primarily a skill development, evaluation, and optimization workbench. It focuses on drafting a skill, running structured evaluations, comparing against baselines, collecting human feedback, benchmarking, and iterating on both skill behavior and triggering quality.

In short:

- `.system/skill-creator` answers: "How do I create a proper skill?"
- `skill-creator` answers: "How do I prove and improve that this skill actually works well?"

## Part 1: How `agents/skills/skill-creator` Works

## Core Orientation

The root-level `skill-creator` is built around an iterative evaluation loop. It assumes that writing a skill is only the beginning. The real work is testing the skill against realistic prompts, comparing it to a baseline, getting human review, and refining it repeatedly.

Its center of gravity is not scaffolding. Its center of gravity is evidence-driven iteration.

## High-Level Workflow

The workflow described in `agents/skills/skill-creator/SKILL.md` is:

1. Decide what the skill should do
2. Draft the skill
3. Create realistic test prompts
4. Run the skill on those prompts
5. Run a baseline version on the same prompts
6. Help the user evaluate the difference qualitatively and quantitatively
7. Revise the skill
8. Repeat
9. Optionally optimize the description for better triggering
10. Package the final skill

This is much closer to an R&D or experiment loop than a simple authoring guide.

## Stage-by-Stage Breakdown

### 1. Capture Intent

The skill starts by clarifying:

- What the skill should enable
- When it should trigger
- What outputs are expected
- Whether it should have formal test cases

It also suggests extracting as much as possible from the current conversation before asking the user more questions. That makes it workflow-aware from the start.

### 2. Interview and Research

It then pushes for proactive clarification:

- Edge cases
- Input and output formats
- Dependencies
- Example files
- Success criteria

It also encourages research via MCPs or subagents if available.

### 3. Write the Skill

It instructs the author to produce:

- `name`
- `description`
- optional `compatibility`
- the actual Markdown body

It emphasizes that the `description` is the primary trigger mechanism, and explicitly recommends writing it in a somewhat "pushy" way to counter under-triggering.

### 4. Create Test Prompts

After the draft, it requires 2-3 realistic prompts and stores them in:

- `evals/evals.json`

At this stage it wants prompts first, without assertions yet.

### 5. Run With-Skill and Baseline Together

This is the most important part of the root-level version.

For each eval case, it wants two runs launched in the same turn:

- `with_skill`
- baseline

Baseline depends on context:

- new skill: `without_skill`
- improvement of existing skill: old version snapshot

This makes the workflow comparative by design.

### 6. Draft Assertions While Runs Are Active

Instead of waiting idly, it asks the author to define quantitative assertions while the test runs are still executing.

These assertions are written into:

- `eval_metadata.json`
- `evals/evals.json`

### 7. Capture Timing and Token Data

It explicitly instructs the author to capture:

- `total_tokens`
- `duration_ms`

and persist them into:

- `timing.json`

This matters because the root-level skill does not only measure correctness. It also measures cost and latency.

### 8. Grade and Aggregate Results

Once runs are complete, the workflow requires:

- grading each run
- aggregating benchmark statistics
- analyzing hidden patterns

This is supported by:

- `agents/grader.md`
- `agents/analyzer.md`
- `scripts/aggregate_benchmark.py`

### 9. Launch a Human Review Interface

The skill strongly emphasizes generating a review UI via:

- `eval-viewer/generate_review.py`

The user is expected to inspect outputs, review formal grades, and leave feedback.

The document is very explicit that the human should see the outputs before the author prematurely concludes what to change.

### 10. Read Feedback and Iterate

User feedback is stored in:

- `feedback.json`

The workflow then loops:

1. improve the skill
2. rerun the evals into a new iteration directory
3. show the new outputs
4. collect feedback again
5. repeat

### 11. Optimize the Description

This version treats trigger quality as a separate optimization problem.

It asks the author to:

1. create a should-trigger / should-not-trigger eval set
2. review the eval set with the user
3. run an automated optimization loop
4. apply the best resulting description

This is unusually advanced and makes the root-level version much more than a generic writing guide.

### 12. Package the Final Skill

Packaging is included, but it comes after the evaluation and iteration cycle. That means packaging is seen as a final delivery step, not the main value of the skill.

## Root-Level Supporting Toolchain

The root-level `skill-creator` includes a substantial toolchain:

- `scripts/run_eval.py`
- `scripts/improve_description.py`
- `scripts/run_loop.py`
- `scripts/aggregate_benchmark.py`
- `scripts/generate_report.py`
- `scripts/package_skill.py`
- `eval-viewer/generate_review.py`
- `agents/grader.md`
- `agents/comparator.md`
- `agents/analyzer.md`
- `references/schemas.md`

This is the clearest signal that this version is designed as a full evaluation and optimization system.

## Root-Level Design Philosophy

The root-level skill reflects the following beliefs:

- A skill draft is only a hypothesis
- Skill quality should be tested, not assumed
- Baselines matter
- Human review matters
- Description triggering can be optimized empirically
- Token and time costs matter alongside pass rate

This is best described as a skill R&D workflow.

## Part 2: How `agents/skills/.system/skill-creator` Works

## Core Orientation

The `.system` version is oriented around clean skill construction for Codex. It treats a skill as a structured, modular artifact with required metadata, optional resource directories, and product-facing UI metadata.

Its center of gravity is not benchmark iteration. Its center of gravity is correct initialization, structure, and packaging of knowledge into a reusable skill.

## High-Level Workflow

The workflow described in `agents/skills/.system/skill-creator/SKILL.md` is:

1. Understand the skill through concrete examples
2. Plan reusable skill contents
3. Initialize the skill with a script
4. Edit the skill and resources
5. Validate the skill
6. Iterate through real usage

This is a construction and standards workflow, not an evaluation lab.

## Stage-by-Stage Breakdown

### 1. Understand the Skill Through Concrete Examples

The `.system` version asks the author to ground the skill in specific, realistic use cases. It also recommends not overwhelming the user with too many questions at once.

Its purpose is to make the skill concrete enough to design well.

### 2. Plan Reusable Contents

This step is central in the `.system` version.

For each example, the author should decide whether the skill would benefit from:

- scripts
- references
- assets

Examples from the doc include:

- a PDF skill needing reusable scripts
- a frontend skill needing boilerplate assets
- a BigQuery skill needing schema references

This makes reusable artifact planning a first-class design step.

### 3. Initialize the Skill

The `.system` version explicitly says that new skills should be created with:

- `scripts/init_skill.py`

That script:

- normalizes the skill name
- creates the directory
- generates a template `SKILL.md`
- optionally creates resource folders
- generates `agents/openai.yaml`

This is a strong sign that `.system` is intended to standardize skill creation from the start.

### 4. Generate UI Metadata

This is one of the clearest distinctive features of the `.system` version.

It recommends creating:

- `display_name`
- `short_description`
- `default_prompt`

via:

- `scripts/generate_openai_yaml.py`

and writing them into:

- `agents/openai.yaml`

This moves part of skill definition into product-facing metadata instead of putting everything into `SKILL.md`.

### 5. Edit the Skill

When editing the skill, the `.system` document emphasizes:

- only include information Codex actually needs
- keep the skill concise
- avoid duplicate information
- move detailed material into `references/`
- choose an appropriate degree of freedom for the task

It spends much more time than the root-level version discussing token discipline and information architecture.

### 6. Validate the Skill

It explicitly requires:

- `scripts/quick_validate.py`

This checks basic structural rules like:

- YAML frontmatter exists
- required fields are present
- naming rules are valid
- descriptions are within bounds

### 7. Iterate by Real Usage

Unlike the root-level version, iteration here is lightweight:

1. use the skill on real tasks
2. notice friction
3. adjust the skill
4. test again

There is no formal benchmark, no viewer, and no baseline comparison system.

## `.system` Supporting Toolchain

The `.system` `skill-creator` includes a much smaller and more focused toolchain:

- `scripts/init_skill.py`
- `scripts/generate_openai_yaml.py`
- `scripts/quick_validate.py`
- `references/openai_yaml.md`
- `agents/openai.yaml`

That is consistent with a scaffolding and metadata-generation role.

## `.system` Design Philosophy

The `.system` version reflects the following beliefs:

- A skill is a structured Codex artifact
- Good defaults and scaffolding reduce mistakes
- Skill resources should be planned deliberately
- The context window is limited and should be protected
- UI-facing metadata matters
- A skill should be clean, concise, and modular

This is best described as a skill construction and standards workflow.

## Part 3: Direct Comparison

## Core Difference

These two versions solve different problems.

- `agents/skills/.system/skill-creator` solves skill construction
- `agents/skills/skill-creator` solves skill optimization and validation

That is the most precise high-level distinction.

## Workflow Comparison

### Root-Level `skill-creator`

Primary loop:

1. draft
2. evaluate
3. compare against baseline
4. collect human review
5. revise
6. rerun
7. optimize description

### `.system/skill-creator`

Primary loop:

1. understand examples
2. plan reusable resources
3. initialize structure
4. write skill contents
5. generate metadata
6. validate
7. iterate through use

## Side-by-Side Capability Matrix

| Capability | `agents/skills/skill-creator` | `agents/skills/.system/skill-creator` |
|---|---|---|
| Initialize new skill directory | Weak | Strong |
| Generate `SKILL.md` template | Weak | Strong |
| Generate `agents/openai.yaml` | No meaningful focus | Strong |
| Plan reusable resources | Medium | Strong |
| Basic structural validation | Yes | Yes |
| Formal eval set workflow | Strong | No |
| Baseline comparison | Strong | No |
| Grading and benchmark aggregation | Strong | No |
| Human review viewer | Strong | No |
| Blind comparison workflow | Yes | No |
| Trigger description optimization | Strong | No |
| Packaging after iteration | Yes | Not central |

## Chapter-by-Chapter Mapping

| Topic | Root-Level Version | `.system` Version | Relationship |
|---|---|---|---|
| What a skill is | Brief | Extensive | `.system` is more foundational |
| Requirement discovery | `Capture Intent`, `Interview and Research` | `Understanding the Skill with Concrete Examples` | Overlapping |
| Resource planning | Mentioned but secondary | Explicit phase | `.system` is stronger |
| Writing `SKILL.md` | Trigger-aware drafting | Structure and concision focused | Overlapping but different emphasis |
| Progressive disclosure | Yes | Yes | Overlapping |
| Initialization script | No | Yes | `.system` only |
| UI metadata | Minimal | Core concern | `.system` only |
| Validation | Present | Present | Overlapping |
| Test prompt workflow | Core | Not formalized | Root-level only |
| Baseline testing | Core | Absent | Root-level only |
| Benchmarking | Core | Absent | Root-level only |
| Human review UI | Core | Absent | Root-level only |
| Trigger eval optimization | Core | Absent | Root-level only |

## Philosophical Contrast

The difference is not just "one is longer" or "one has more scripts". They express different engineering philosophies.

### Root-Level Philosophy

- Do not assume the first draft is good
- Measure behavior
- Compare against a baseline
- Collect human review
- Treat triggering as an optimization target
- Iterate until performance stabilizes

### `.system` Philosophy

- Start from a correct structure
- Keep the skill concise
- Use scripts and references deliberately
- Separate UI metadata from trigger metadata
- Generate standard artifacts
- Validate early

## Part 4: Script-Level Comparison

## `.system` Scripts and What They Mean

### `scripts/init_skill.py`

This script represents factory-style initialization.

It:

- normalizes names
- creates folders
- writes a template `SKILL.md`
- optionally creates resource directories
- can generate `agents/openai.yaml`

This script encodes the belief that a skill should begin from a standardized scaffold rather than ad hoc manual assembly.

### `scripts/generate_openai_yaml.py`

This script represents the idea that a skill is also a UI and product object.

It generates:

- `display_name`
- `short_description`
- optional interface fields

and writes them into:

- `agents/openai.yaml`

This is specific to the Codex-oriented product model and is largely absent from the root-level version.

### `scripts/quick_validate.py`

This script represents lightweight structural correctness:

- valid frontmatter
- valid naming
- valid description

In the `.system` workflow, this is a key guardrail rather than a minor utility.

## Root-Level Scripts and What They Mean

### `scripts/run_eval.py`

This script represents the belief that trigger behavior can be measured empirically.

It tests whether a description actually causes the skill to trigger under realistic prompts. That turns skill invocation from a vague writing problem into a measurable behavior problem.

### `scripts/improve_description.py`

This script represents the idea that `description` is an optimization artifact, not just a one-time line of prose.

It uses failure cases and history to produce a better description while trying to avoid naive overfitting.

### `scripts/run_loop.py`

This script represents a train/test optimization loop for trigger descriptions.

It:

- splits evals into train and test
- reruns evaluations
- improves descriptions based on train failures
- selects a best result using held-out performance

This is much closer to an experiment loop than a traditional documentation workflow.

### `scripts/aggregate_benchmark.py`

This script represents performance aggregation across runs.

It combines:

- pass rate
- timing
- token usage

and calculates deltas between configurations.

That means skill quality is being treated as multi-dimensional, not just "looked good to the author".

### `scripts/package_skill.py`

This script packages a mature skill at the end of the process. In the root-level workflow, packaging is downstream of testing and refinement.

## Script-Level Summary

At the script layer, the contrast becomes even clearer:

- `.system` scripts create, normalize, and validate
- root-level scripts evaluate, compare, optimize, and package

## Part 5: Overlaps, Differences, and Potential Conflicts

## Areas of Overlap

These two versions do overlap in some meaningful ways:

- both care about `name` and `description`
- both care about resource directories
- both discuss progressive disclosure
- both include validation
- both assume the skill may need iteration

So they are not unrelated. They are just optimized for different phases.

## Areas Where `.system` Is Stronger

- skill initialization
- clean folder structure
- reusable resource planning
- Codex-specific UI metadata
- concise information architecture

## Areas Where Root-Level Is Stronger

- realistic eval setup
- baseline comparison
- benchmark analysis
- human review workflow
- blind comparison
- trigger description optimization

## Potential Tensions

### 1. Frontmatter Expectations Are Not Fully Identical

The `.system` document says frontmatter should only include `name` and `description`.

The root-level validator allows more fields such as:

- `license`
- `allowed-tools`
- `metadata`
- `compatibility`

This suggests a difference between idealized guidance and broader compatibility in practice.

### 2. Skill Length Tolerance Differs

The root-level version is willing to support quite involved workflows, as long as they are useful and progressively disclosed.

The `.system` version is much more forceful about brevity and context economy.

This can lead to different authoring styles:

- root-level: richer operational instructions
- `.system`: leaner and more modular instructions

### 3. Resource Extraction Happens at Different Times

The `.system` version pushes resource planning upfront.

The root-level version often discovers needed scripts after observing repeated work in eval runs.

This is a design-method difference:

- `.system`: anticipate reuse
- root-level: infer reuse from repeated behavior

### 4. Platform Orientation Differs

The root-level version is clearly written around a Claude-centered evaluation environment:

- `claude -p`
- Claude.ai
- Cowork
- subagents

The `.system` version is clearly written around a Codex-style product model:

- Codex
- `agents/openai.yaml`
- UI metadata

This is an inferred difference from the documents and scripts, but it is a strong and consistent inference.

## Part 6: Best Interpretation of Their Relationship

The best interpretation is that these two directories belong to different layers of the same lifecycle.

### `.system/skill-creator`

Acts like a canonical factory or standards layer:

- create the skill correctly
- organize the contents correctly
- generate metadata correctly
- validate the structure

### `agents/skills/skill-creator`

Acts like an advanced lab or optimization layer:

- test the skill on realistic cases
- compare against alternatives
- gather human review
- improve outcomes
- tune triggering

This means they are not best understood as mutually exclusive replacements. They are closer to complementary tools.

## Part 7: Recommended Combined Workflow

If these two skills were combined into a best-practice workflow, the cleanest sequence would be:

1. Use `.system/skill-creator` to create the skill skeleton
2. Use `.system/skill-creator` to generate `agents/openai.yaml`
3. Use `.system/skill-creator` to validate structure and naming
4. Use root-level `skill-creator` to create realistic eval prompts
5. Use root-level `skill-creator` to run baseline comparisons
6. Use root-level `skill-creator` to generate benchmark and review artifacts
7. Use root-level `skill-creator` to iterate on skill behavior
8. Use root-level `skill-creator` to optimize the description trigger behavior
9. Package the final skill

This captures the strengths of both.

## Final Conclusion

The two `skill-creator` implementations are deeply different in purpose.

`agents/skills/.system/skill-creator` is the better guide when the main problem is:

- creating a new skill cleanly
- structuring it well
- generating Codex-facing metadata
- enforcing foundational conventions

`agents/skills/skill-creator` is the better guide when the main problem is:

- validating whether the skill actually performs well
- comparing it to a baseline
- improving outputs through repeated review
- optimizing trigger quality empirically

The most accurate final summary is:

- `.system/skill-creator` focuses on skill construction
- root-level `skill-creator` focuses on skill optimization and validation

Together, they describe two different but complementary stages of a mature skill development workflow.
