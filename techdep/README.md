# techdep

**Who really runs Europe's cloud? Traced in six languages, graded by evidence, ready for a dependency matrix.**

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Claude Code Skill](https://img.shields.io/badge/Claude%20Code-skill-blueviolet.svg)

`techdep` is a Claude Code skill that investigates dependency in the cloud layer of Europe's digital stack. For any public body, sector or country, it finds out who hosts the service, who owns the provider, whose law reaches it, and whose software it runs on. Every claim is sourced and graded, and every report ends with rows you can drop straight into a country-by-country dependency matrix.

It is the layer 5 (cloud infrastructure) module of the **PA1 Tech Dependency Index**, and a sibling of [chipchain](https://github.com/lboquillon/chipchain), whose research method it adapts.

## Why

The answer to "is this ministry dependent on a US provider?" rarely sits in English-language press. It sits in a French *avis d'attribution*, a German *Kleine Anfrage*, an Italian ACN register, a Spanish *adjudicación* or a Dutch *Kamerbrief*. And the usual answers confuse three different things:

- **Offering is not hosting.** A provider selling a sovereign cloud tells you nothing about who uses it.
- **Location is not control.** A data center in Frankfurt owned by a US company is still within reach of US law.
- **Technology is not operation.** A European joint venture running a hyperscaler's software is European-owned, but its update channel is not.

`techdep` keeps these apart and records each one separately.

## Try it

- `Who hosts France's Health Data Hub, and who controls that provider?`
- `How dependent is the Italian public administration on US cloud providers?`
- `Is Delos Cloud really sovereign? Check ownership, jurisdiction, operations and technology.`
- `Which EU-controlled providers could replace Azure for the Dutch central government?`
- `If US providers suspended services to a European government, what breaks first in Germany?`

## Query types

| Type | What it does |
|---|---|
| Provider ID | Finds who hosts a named service, from procurement records, parliamentary answers, sub-processor lists and DNS traces |
| Country exposure | Maps a country's or sector's reliance on providers by control country |
| Sovereignty check | Scores an offer on four separate axes: ownership, jurisdiction, operations, technology |
| Scenario | Traces what breaks, and how fast, under a cutoff, update stop or legal order |
| Discovery | Finds certified, EU-controlled substitutes with a public track record |

## How it stays honest

- **Search first.** Model memory is a hypothesis, never a source.
- **Six confidence levels,** from CONFIRMED (named in a procurement record or official statement accessed this session) down to FROM TRAINING KNOWLEDGE.
- **Evidence caps.** A certification or a marketing page can never support more than SPECULATIVE for a specific buyer. See [evidence-guide.md](evidence-guide.md).
- **Source Registry before prose,** with verbatim quotes in the original language.
- **Counterfactual check** on every strong claim.
- **Search Log and "What I Could Not Verify"** in every report.

## From report to matrix

Every report ends with a CSV block (format in [pa1-output.md](pa1-output.md)): one row per evidenced link between a dependent country *i* and a control country *j*, tagged with a PA1 dimension code (A7 procurement, D2 ownership, F1 jurisdictional reach, A8 update channel and others). Save the block as a file and run:

```bash
python3 scripts/pa1_matrix.py rows.csv
```

The script validates the rows and writes one country-by-country matrix per dimension, weighted by confidence. No dependencies beyond Python 3.

Test it on the synthetic file:

```bash
python3 scripts/pa1_matrix.py examples/format_test.csv
```

## Installation

Requires [Claude Code](https://claude.ai/code). No API keys. The repository is a Claude Code plugin, so there are three ways to use it.

**Option 1: install as a plugin (recommended).** Inside Claude Code:

```
/plugin marketplace add PABalland/techdep
/plugin install techdep@techdep
```

You get updates with `/plugin marketplace update techdep`.

**Option 2: clone into your skills folder.** Claude Code loads it in every session, no install step:

```bash
git clone https://github.com/PABalland/techdep.git ~/.claude/skills/techdep
```

**Option 3: try it for one session** without installing anything:

```bash
git clone https://github.com/PABalland/techdep.git
claude --plugin-dir ./techdep
```

Then ask a question in plain language, for example `Who hosts France's Health Data Hub?`, and the skill triggers on its own. To call it explicitly, type `/techdep` (options 2 and 3 show it in the `/` menu under that name, option 1 as `/techdep:techdep`).

The six language researchers load as sub-agents named `techdep:fr-researcher`, `techdep:de-researcher` and so on. Reports and matrices are written to a `techdep-output/` folder in whatever directory you started Claude Code from.

Check the plugin before publishing a change:

```bash
claude plugin validate ./techdep --strict
```

## Structure

```
.claude-plugin/          plugin.json (the plugin) and marketplace.json (so the repo installs with /plugin)
SKILL.md                 orchestrator instructions
agents/                  six language researchers (sub-agents)
research-methodology.md  method shared by the researchers
evidence-guide.md        evidence types and confidence caps
sources.md               procurement portals, certification registers, corporate and technical sources
pa1-output.md            CSV row format and dimension codes
queries/                 one workflow per query type, plus the counterfactual check
lang/                    one briefing per language: terms, disclosure sources, policy frame, leads
scripts/pa1_matrix.py    rows to matrices
examples/                synthetic file to test the script
```

## Contributing

- **Fix a term or add a source:** edit the relevant `lang/*.md` file. Check terms against real procurement notices, not dictionaries.
- **Add a country:** copy a `lang/` file and an agent file in `agents/`, then add the agent to the table in `SKILL.md`.
- **Add a layer:** the same structure works for other layers of the stack (networks, software, data and AI). Change the dimension codes in `pa1-output.md` and the script.

The leads in `lang/` were compiled from model knowledge and are not verified. Corrections backed by a source are the most useful contribution.

## Credits

Research method adapted from [chipchain](https://github.com/lboquillon/chipchain) by Leonardo Boquillon (MIT).

## License

MIT
