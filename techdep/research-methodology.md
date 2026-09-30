# Research Methodology (shared by all language agents)

All paths are relative to the skill folder given in your assignment.

## Phase 0: Calibrate
Read `evidence-guide.md` and `queries/counterfactual-check.md` before searching.
Remember the three distinctions: offering is not hosting, location is not control,
technology is not operation.

## Phase 1: Investigate
- Search first. Your memory only tells you where to look.
- Search only in your assigned language. If a lead needs another language, put it in `<gaps>`.
- Minimum: 2 searches in your language, 1 procurement portal or certification register search, 1 official-statement search (parliament, auditors, DPA).
- Add the current and previous year to queries for freshness.
- After each round of search, fetch the 2 or 3 most promising pages in full and extract verbatim quotes, dates, names and amounts.
- For every provider you find, try to fetch one corporate record showing its ultimate owner.
- Search by mechanism, not by known names: "award notice + hosting + [buyer]" finds unknown providers, "[known provider] clients" does not.
- Pivot rule: after 3 failed strategies on one lead, log it as a gap and move on.

## Phase 2: Check
Run the counterfactual check on each claim at STRONG INFERENCE or above, and apply the caps in `evidence-guide.md`.

## Output (return exactly this XML)
```xml
<findings language="xx">
  <found confidence="CONFIRMED|STRONG INFERENCE|MODERATE INFERENCE|SPECULATIVE" date="YYYY-MM">
    <claim>One sentence claim</claim>
    <url>https://...</url>
    <evidence>Verbatim quote in the original language</evidence>
    <evidence-type>procurement|official-statement|corporate-record|technical-trace|certification|press|offering</evidence-type>
  </found>
  <found-skilldb>Leads from lang/ files you could not verify</found-skilldb>
  <found-training>Anything from memory, flagged</found-training>
  <chain buyer="" country_i="" provider="" provider_hq="" control_country_j="" tech_supplier_country="" data_location="" certification=""/>
  <missed query="" source="" result="no results|paywalled|blocked"/>
  <counterfactual claim="" alternative="" plausibility="LOW|MEDIUM|HIGH" falsifier=""/>
  <gaps>What you could not verify and which language or source could</gaps>
</findings>
```
Never invent a URL, notice number or quote. An empty `<found>` list is a valid result.
