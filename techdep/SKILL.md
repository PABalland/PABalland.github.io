---
name: techdep
description: "European cloud dependency intelligence. Traces who hosts, owns and legally controls the cloud infrastructure used by European governments, public bodies and critical sectors, in six languages, with graded evidence and output rows ready for a country-by-country dependency matrix. Use whenever the user asks who hosts a public service or dataset, how dependent a country or sector is on US or other foreign cloud providers, whether a 'sovereign cloud' offer is really sovereign, what happens under a cutoff or CLOUD Act scenario, or which European providers could substitute. Trigger even if the user only says 'cloud dependency', 'hyperscalers', 'SecNumCloud', 'C5', 'EUCS' or 'sovereign cloud'."
argument-hint: "[question about cloud dependency]"
allowed-tools: Read Glob Grep WebSearch WebFetch Bash(python3 ${CLAUDE_SKILL_DIR}/scripts/pa1_matrix.py *) Bash(mkdir -p techdep-output*)
---

# European Cloud Dependency Intelligence

**Question:** $ARGUMENTS (if this is empty, use the user's latest message)

**Skill folder:** `${CLAUDE_SKILL_DIR}` (every file named below is inside it; pass this path to sub-agents)

Layer 5 of the digital stack (cloud infrastructure) as used in the PA1 Tech Dependency Index.
The question this skill answers is always a variant of: **country i relies on provider p,
and the law of country j ultimately controls p. How strong is that link, and how do we know?**

> **Everything in the lang/ files is a lead, not a fact.** Provider names, joint ventures and
> contract awards listed there were compiled from training knowledge and have NOT been verified.
> They tell you where to search. A finding that contradicts them is worth more than one that
> confirms them.

## Rule Zero: Search First, Know Later

Your training knowledge is a hypothesis generator, never a source. Your first action is to
search, not to answer. If a search comes back empty, report that as a result.

Minimum search requirements:
- Every investigation includes at least 2 searches in the national language of each country involved.
- Every provider-ID or country-exposure investigation queries at least one procurement portal or certification register (see sources.md).
- Every report contains at least one finding that an English-language search would not have produced.

## Three distinctions that matter more than anything else

1. **Offering is not hosting.** "Provider X sells a sovereign cloud" says nothing about whether ministry Y runs on it. Only a contract award, an official statement or an audit names the relationship.
2. **Location is not control.** A data center in Frankfurt run by a US-owned company is still reachable by US law. Always record both the provider's headquarters and the country of its ultimate owner.
3. **Technology is not operation.** Joint ventures that run a hyperscaler's software under a European operator (the "trusted cloud" model) have a split answer: ownership may be European while the software supply and update channel is not. Record both.

## Confidence levels

Grade every finding. See [evidence-guide.md](evidence-guide.md) for which evidence can support which level.

| Level | Meaning |
|---|---|
| CONFIRMED (YYYY source) | Named relationship in a source accessed this session |
| STRONG INFERENCE | 2+ independent signals found this session |
| MODERATE INFERENCE | 1 indirect signal found this session |
| SPECULATIVE | Deduction from market structure |
| FROM SKILL DATABASE | From lang/ files, not verified today |
| FROM TRAINING KNOWLEDGE | Model memory, lowest reliability, always flagged |

## Anti-hallucination rules

Never:
1. Say "according to TED" or "the BOAMP notice shows" unless you fetched it this session.
2. Invent a URL, notice number, contract value or certification ID. Say "search for X on Y" instead.
3. Present a lang/ file entry as current fact.
4. Fill a gap with a plausible guess. "I could not identify the hosting provider" is a valid finding.
5. Treat a provider's marketing claim of sovereignty as evidence of legal or operational control.

Always:
1. Build the Source Registry before writing prose. Every web-sourced claim carries a registry number.
2. Include "What I Could Not Verify" and a Search Log.
3. State the date of every source. Cloud contracts are renewed and providers are acquired.

## Step 1: Classify the question

| Type | Example | Workflow |
|---|---|---|
| Provider ID | "Who hosts France's Health Data Hub?" | [queries/provider-id.md](queries/provider-id.md) |
| Country exposure | "How dependent is the Italian public sector on US cloud?" | [queries/country-exposure.md](queries/country-exposure.md) |
| Sovereignty check | "Is Delos Cloud really sovereign?" | [queries/sovereignty-check.md](queries/sovereignty-check.md) |
| Scenario | "If US providers suspended service to EU governments, who breaks first?" | [queries/scenario.md](queries/scenario.md) |
| Discovery | "Which EU providers could replace Azure for the Dutch government?" | [queries/discovery.md](queries/discovery.md) |

Depth:
- QUICK: one entity, one country, 1 agent.
- STANDARD: one country or one provider across borders, 2 to 3 agents.
- DEEP: multi-country exposure or scenario, 3+ agents. Show first-round leads to the user before going deeper.

## Step 2: Dispatch language agents

The plugin ships six researchers. Their sub-agent types are:

| Language / scope | Sub-agent type |
|---|---|
| French (France, Belgium, Luxembourg) | `techdep:fr-researcher` |
| German (Germany, Austria) | `techdep:de-researcher` |
| Italian | `techdep:it-researcher` |
| Spanish | `techdep:es-researcher` |
| Dutch (Netherlands, Flanders) | `techdep:nl-researcher` |
| EU level and provider filings (English) | `techdep:eu-researcher` |

Always add `techdep:eu-researcher` when a US, UK or Chinese provider is involved: its job is
ownership chains, SEC filings and EU-level procurement (TED). Belgium usually needs both the
French and the Dutch researcher.

Prompt template for each agent:
```
Skill folder: ${CLAUDE_SKILL_DIR}
Investigate: [question restated]
Query workflow: queries/[workflow].md
Today's date: [YYYY-MM-DD]
Cross-pollination: [findings from other agents, or "First round, no prior findings."]
```

Launch first-round agents in parallel, in one message. When an agent finds a provider, parent
company or contract in another country, spawn that country's agent with the finding as
cross-pollination.

**Fallback.** If the `techdep:` agent types are not available (for example the skill was
copied without its plugin manifest), spawn `general-purpose` sub-agents instead and start each
prompt with: "Read ${CLAUDE_SKILL_DIR}/agents/xx-researcher.md and follow it as your
instructions." If sub-agents are not available at all, run the searches yourself, one language
at a time, following research-methodology.md.

## Step 3: Assemble the report (three phases)

**Phase 1, Source Registry.** Parse every `<found>` block from the agents, number them, and check
that each claim follows from its quoted evidence. Downgrade claims that stretch.

**Phase 1.5, Counterfactual check.** For every claim at STRONG INFERENCE or above, answer the
three questions in [queries/counterfactual-check.md](queries/counterfactual-check.md). Downgrade
where the alternative explanation is as plausible.

**Phase 2, Narrative.** Write the report in this order:

```markdown
# [Question restated]

## Findings
- [claim] [1]
- [claim] [2]

## Dependency chain
| Buyer (country i) | Provider | Provider HQ | Ultimate owner (country j) | Software/tech supplier | Data location | Certification | Confidence |

## Counterfactual Check
## What I Could Not Verify
## Recommended Next Steps
## Search Log
| # | Query | Language | Source | Result |
## Source Registry
[1] Source, date, URL
    Evidence: "verbatim quote in original language"

## PA1 Matrix Rows
(CSV block, see pa1-output.md)
```

Writing style: plain and direct. Say what you found, what you could not find, and what you
think it means. Gaps are content.

## Step 4: Save the report and build the matrices

End every report with a CSV block following [pa1-output.md](pa1-output.md): one row per
evidenced link between a country and a controlling country, MODERATE INFERENCE or above only.

Then, in the user's current project folder:
1. `mkdir -p techdep-output`
2. Write the full report to `techdep-output/<short-slug>.md`.
3. Write the CSV block (header plus rows, no code fences) to `techdep-output/<short-slug>-rows.csv`.
4. Run `python3 ${CLAUDE_SKILL_DIR}/scripts/pa1_matrix.py techdep-output/<short-slug>-rows.csv --out techdep-output/matrices`
5. If the script rejects rows, fix them (or drop them and say why) and run it again.
6. Tell the user where the report and matrices are, in one or two lines.

If the investigation produced no row at MODERATE INFERENCE or above, skip steps 3 to 5 and say so.

## After the report

Offer to execute the recommended next steps now, for example: "(a) search TED for award notices
naming [provider] since 2023, (b) check the ANSSI SecNumCloud list for [offer], (c) trace the
ownership of [operator] in the Handelsregister."
