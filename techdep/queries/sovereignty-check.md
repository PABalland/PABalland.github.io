# Workflow: Sovereignty Check

Question shape: "Is [offer] really sovereign?"

Test the offer on four separate axes. Report each one, do not collapse them into a yes or no.

| Axis | Question | Evidence needed |
|---|---|---|
| Ownership | Who ultimately owns the operator? | Corporate record (GLEIF, national register, annual report) |
| Jurisdiction | Can a non-EU authority compel access to data or operations? | Ownership plus the legal analysis in the certification scheme or DPA/regulator opinions |
| Operations | Who runs it day to day and who holds admin credentials and encryption keys? | Certification scope, technical documentation, contract terms |
| Technology | Whose software runs it, who ships updates, and can the operator keep running without them? | Product documentation, JV agreements as reported, statements by the operator |

Steps:
1. Fetch the certification status (SecNumCloud, C5, ENS, ACN, EUCS). Note the scope and date.
2. Trace ownership to the ultimate parent.
3. For joint ventures, find the licensing or technology agreement as reported, and any statement about what happens if the technology partner stops supplying updates.
4. Search national-language press and parliamentary questions for criticism or doubts about the offer.
5. Run the counterfactual check on your overall assessment.

Output: the four-axis table, then PA1 rows (D2 for owner, A8 and E6 for technology and update channel, F1 if non-EU jurisdiction reaches it).
