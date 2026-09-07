---
name: crosswalk-review
description: Review, repair and rebuild a crosswalk between two classifications or taxonomies — NACE/SIC/NAICS, ISCO/ESCO/O*NET, CPC/IPC, HS codes, NUTS, internal taxonomies, or any tag-to-category mapping. Diagnoses where a similarity-based or LLM-generated mapping went wrong, disambiguates using the explanatory notes one level below the assignment level, and emits the result as hard-coded R assignment lines with a per-item rationale. Use this whenever someone mentions a crosswalk, concordance, correspondence table, mapping table, or lookup between two coding systems, or asks to match/map/assign the categories of one classification onto another, or asks whether an existing mapping is any good — even if they only describe it as "matching X to Y" and never say the word crosswalk.
---

# Crosswalk review

Crosswalks get built by string similarity, embeddings, or a one-shot LLM pass. Those methods get the easy 80% right and fail in patterned ways: they overfill one category, leave a sibling empty, and split items that belong together because the surface words differ. The failures cluster, which is what makes them findable.

The job is to find those clusters, fix them with evidence rather than intuition, and hand back something the user can audit line by line and partially reject.

## What the user actually needs

Not a corrected file. A corrected file plus the reasoning, in a form where they can delete the fifteen lines they disagree with and keep the rest. Assume the user knows their domain better than you do — the output format exists so their judgment can override yours cheaply, one line at a time.

Never silently rewrite item or category names. They are join keys in someone's pipeline.

## Workflow

### 1. Pin down the versions

Classifications get revised, and revisions move exactly the things that are hard to classify. Before reasoning about any class, establish which revision each side is on — the user's category labels usually reveal it. If the answer matters to a call you're about to make, search for the current structure rather than trusting recall; the notes below on fabrication apply with full force here.

Get this wrong and every downstream argument is confidently wrong. See `references/version-traps.md` for the checks worth running.

### 2. Profile before touching anything

Load the file and compute, in this order:

- **Items per category, sorted.** The top and bottom of that list is where the errors live. A category holding 17% of all items next to a sibling holding six is not proof of error, but it is where to look first.
- **Empty categories.** List them explicitly. They are a finding, not a defect.
- **The low-score tail**, if the file carries match scores. The bottom decile is where the mechanical method gave up. Read every one.
- **Split siblings.** Items whose obvious counterparts sit in a different category — `Search Engine` in one place, `Semantic Search` in another. These are the highest-yield finds and no score column reveals them.

`references/diagnostics.md` has the exact queries in both R and pandas.

### 3. Disambiguate one level below the assignment level

This is the core move and the reason this skill exists.

When two candidate categories both plausibly fit an item, the parent labels will not decide it — they are too coarse, which is why the mechanical method failed. The decision lives in the explanatory notes of the classes one or two levels down, which frequently name the activity outright.

Worked cases from a NACE↔Crunchbase pass:

- `Collection Agency`, `Debt Collections`, `Credit Bureau` looked like finance and sat in division 66. NACE class 82.91 is titled "activities of collection agencies and credit bureaus". Not a judgment call — a lookup.
- `Interior Design` sat with the engineers in 71. Class 74.10, specialised design activities, covers it explicitly alongside graphic and industrial design.
- `Jewelry` sat in fabricated metal products (25). Class 32.12 is manufacture of jewellery.
- `Coffee` and `Tea` sat in beverage manufacture (11). Class 10.83 is processing of tea and coffee — a food class, not a beverage one.

Assign at the level the user asked for; reason at the level where the notes are written. Then cite the class in the output so they can check you.

### 4. Mine the file's own conventions

The existing mapping encodes decisions someone already made. Find them and extend them — internal consistency is a free source of rules and it is far more persuasive to the user than an outside principle.

In the NACE case, `FinTech`→64, `InsurTech`→66 and `PropTech`→68 were already there. That licensed `EdTech`→85, `Legal Tech`→69, `AgTech`→01 and `GovTech`→84 as consistency rather than as your invention.

Where the file's own convention conflicts with the classification's logic, say so and let the user pick.

### 5. Treat empty categories as results

Some categories genuinely attract nothing — household employers, extraterritorial bodies, repair trades in a startup database. Do not fill a category to flatten the distribution. State why each one is empty, and note where an empty category is an artefact of the source vocabulary rather than of the economy.

Filling one is justified only when a real item is misplaced elsewhere. `Automotive` sat in motor vehicle *manufacturing* while most firms carrying that tag are dealers and repairers; moving it filled the empty trade-and-repair division and left the manufacturing one with the tags that genuinely belong there.

Expect the count of empty categories to stay roughly flat. Fixing one often empties another, and that is fine — an honestly empty category beats a category propped up by one bad assignment.

### 6. Tier every proposal by confidence, before writing any code

Present proposed changes grouped by strength, in prose, and let the user react before you generate the file:

- **Verbatim** — the class notes name the item. Not negotiable.
- **Strong** — the class scope clearly covers it.
- **Arguable** — turns on an empirical fact about the population that the data cannot settle (does this firm intermediate or hold the asset?). Name the fact it turns on.
- **Weak** — you are extending a pattern with no support in the notes. Say so and recommend dropping it.

Volunteering your own weakest call is what makes the strong ones credible. In the NACE pass, `Ethereum`→64 had no basis beyond sitting next to `Bitcoin`; flagging it unprompted is what let the user trust the other fourteen lines in that block.

Keep total changes proportionate. Around 5–10% of items is a repair; 40% is a rebuild the user did not ask for.

### 7. Emit hard-coded R

See the output contract below. This is not negotiable formatting — the whole point is auditability.

### 8. Validate

Run `scripts/validate_assignments.py` before presenting. It parses the generated R and checks coverage, uniqueness, and that every name matches the source byte for byte.

```bash
python scripts/validate_assignments.py --source crosswalk.csv --script crosswalk_assign.R \
  --item-col key --category-col domain
```

## Output contract

One assignment line per item, one comment per line, no exceptions. Even for unchanged items — the user asked for a mapping they can read, and a file where only the changes are visible forces them to hold the rest in their head.

```r
# =====================================================================
# <source classification> <-> <target vocabulary>
# One assignment per item (<N> items, <M> categories, one-to-one).
# The comment on each line gives the class that justifies it, or the
# reason where no class applies. Lines marked [moved] differ from the
# original mapping.
#
#   crosswalk <- read.csv("crosswalk.csv", stringsAsFactors = FALSE)
#   source("crosswalk_assign.R")
# =====================================================================

# ----------------------------------------------------------------------
# 47  Retail trade (47)
# ----------------------------------------------------------------------
crosswalk$domain[crosswalk$key == "Beauty"] = "Retail trade (47)"  # 47.75 retail sale of cosmetic and toilet articles
crosswalk$domain[crosswalk$key == "Gift Card"] = "Retail trade (47)"  # [moved from 64] retail instrument, not a financial service
#   no item assigned: <reason this category is empty>
```

Rules that make the format work:

- **Full literal strings on both sides.** No lookup vectors, no indices, no `paste0`. The user pastes single lines into a console, reorders them, deletes them. Every line must stand alone.
- **Match on the item name**, so the script is idempotent and order-independent. Running it twice changes nothing; running it on a fresh read of the original reproduces the result exactly.
- **Assign only the mapped column.** Do not touch scores, counts, or flags in the same line.
- **`[moved from X]` prefix** on the comment of every changed line, so `grep "\[moved"` yields the change list on its own.
- **Category header comments** in category order, with empty categories present as a comment giving the reason. The user should be able to read the file as a document.
- **Every line gets a comment.** Give the class code where one justifies the assignment. Where none does — umbrella terms, business-model tags, audience segments — say that plainly instead of inventing a code.
- **`stopifnot` block at the end** checking item count, uniqueness, and category count.

Deliver the R script and the rebuilt data file together, plus a short changes table if the user wants one.

### Stale scores

If the source carries a similarity score, that score describes the *original* pairing and is meaningless for a moved item. Say so, and offer the two-line block that flags moved rows and nulls their score. Do not fold it into the assignment lines.

## Never fabricate a class code

A cited code that does not say what you claim is worse than no citation, because the user checks the first two, finds them right, and stops checking.

- Cite a code only when you are confident of its scope. Otherwise give the reason in plain language — "umbrella tag, no closer class" is a perfectly good comment.
- Where a call depends on a revision-specific change, verify it before citing it.
- Never invent a plausible-looking code to fill a comment slot. Comments are the deliverable's evidence; padding them destroys it.

## Anti-patterns

- Rebalancing for its own sake. Distribution is a diagnostic, not an objective.
- Rewriting names to "clean" them.
- Burying a weak call among strong ones.
- Emitting only the diff.
- Reasoning from the item's name instead of what the entities carrying it actually do. `Automotive` is not a manufacturing tag just because cars are manufactured.
- Asking the user to re-specify what the file already shows.

## Reference files

- `references/diagnostics.md` — profiling queries in R and pandas, including the split-sibling check
- `references/version-traps.md` — classification revision changes that routinely break crosswalks, and how to check
- `references/worked-example.md` — the NACE Rev. 2.1 ↔ Crunchbase pass this skill was distilled from
