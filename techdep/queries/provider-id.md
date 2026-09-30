# Workflow: Provider ID

Question shape: "Who hosts [service, dataset or public body]?"

1. **Pin down the buyer.** Exact legal name of the public body and the service (for example the agency that operates the platform, not the ministry that announced it).
2. **Procurement first.** Search the national portal and TED for award notices where the buyer appears. Use the national-language terms for "award" and "contractor" from your lang file, plus the local words for hosting and cloud.
3. **Official statements.** Search parliamentary questions, court of auditors reports and DPA decisions that name the buyer and the word for hosting.
4. **Technical trace.** Resolve the service's public domain, look up the ASN owner, and fetch the privacy notice for a sub-processor list. Note CDNs.
5. **Ownership.** For every provider found, fetch a corporate record showing the ultimate owner. Record provider HQ and control country separately.
6. **Split models.** If the provider is a joint venture or "trusted cloud" operator, find out whose software runs the service and who pushes updates.
7. **Freshness.** Search for migration or tender announcements in the last two years. A 2020 award may have been replaced.

Output: the dependency chain table, rows for A7 (if procurement record), D2, F1, A8 (split model) and E2 (if data location is stated).
