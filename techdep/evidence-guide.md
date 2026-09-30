# Evidence Types and Confidence Caps

> Selling a cloud service and hosting a specific public body's workloads require different
> evidence. Owning a data center and controlling the service that runs in it also do.
> These caps override the general confidence levels.

## Evidence types

| # | Type | What it proves | Examples |
|---|---|---|---|
| 1 | Capability / offering | Provider sells service X | Product page, press release, marketplace listing |
| 2 | Certification | Offer meets a national or EU scheme | ANSSI SecNumCloud list, BSI C5 attestation, ENS certificate, ACN qualification, EUCS |
| 3 | Procurement record | Named buyer awarded a contract to the provider | TED award notice, BOAMP, service.bund.de, Consip/ANAC, PLACSP, TenderNed |
| 4 | Official statement | Buyer or regulator names the provider | Ministry answer to parliament, court of auditors report, data protection authority decision |
| 5 | Corporate record | Who owns the provider | Annual report, commercial register, SEC 10-K/20-F subsidiary list, merger notice |
| 6 | Technical trace | Where a service actually runs | DNS, IP ranges (ASN owner), TLS certificates, privacy notice listing sub-processors |

## Caps

| Evidence available | Maximum confidence |
|---|---|
| Offering only | SPECULATIVE |
| Offering + certification | SPECULATIVE (certification says the offer exists, not who uses it) |
| Technical trace only (DNS/ASN points to provider) | MODERATE INFERENCE |
| Technical trace + sub-processor list naming provider | STRONG INFERENCE |
| Press report naming buyer and provider, one source | MODERATE INFERENCE |
| Two independent press reports naming buyer and provider | STRONG INFERENCE |
| Procurement record or official statement, accessed this session | CONFIRMED |
| Corporate record accessed this session (for ownership claims) | CONFIRMED |

Rules:
- **Multiple weak signals do not jump a tier.** Three press articles repeating one ministry quote are one source.
- **A framework agreement is not usage.** A provider on a framework (UGAP, Consip, a Rahmenvertrag) can be used by many buyers or none. Framework membership caps at MODERATE INFERENCE for any specific buyer.
- **A sub-processor list is strong evidence** because it is a legal disclosure under GDPR Article 28. Look for it.
- **Ownership claims need a corporate record.** "European-owned" in a press release is capability-level evidence.
- **Freshness matters.** Contracts end, providers are acquired. Give the date of every source and flag anything older than 3 years.
- **Surface contradictions.** If a ministry says data is hosted in France and the sub-processor list names a US parent, that is a finding.

## Recording control (for the PA1 rows)

For every provider, record separately:
- **Provider HQ**: where the contracting entity is incorporated.
- **Control country (j)**: country of the ultimate owner, found in a corporate record. This is the column used for the matrix.
- **Technology supplier**: whose software stack runs the service, if different (for example a European operator running a US hyperscaler's platform).
- **Data location**: where data is stored, if stated.
