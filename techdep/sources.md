# Sources

No API keys are required. Everything below works with WebSearch and WebFetch.
If a site blocks fetching, log it in the Search Log and try the next source.

## Procurement (evidence type 3)

| Scope | Portal | Tip |
|---|---|---|
| EU-wide | TED, https://ted.europa.eu | Award notices above EU thresholds. Search the provider name plus CPV codes 72300000 (data services), 72400000 (internet services), 72500000 (computer-related services), 48800000 (information systems and servers) |
| France | BOAMP, https://www.boamp.fr ; UGAP (central purchasing) | "avis d'attribution", "titulaire" |
| Germany | https://www.service.bund.de ; DTVP ; evergabe-online | "Zuschlag", "Auftragnehmer"; federal IT often via ITZBund or BWI |
| Italy | Consip, https://www.acquistinretepa.it ; ANAC, https://www.anticorruzione.it | "aggiudicazione", "aggiudicatario"; check PSN documents |
| Spain | PLACSP, https://contrataciondelestado.es | "adjudicación", "adjudicatario" |
| Netherlands | TenderNed, https://www.tenderned.nl | "gunning", "opdrachtnemer" |

## Certification registers (evidence type 2)

| Scheme | Where |
|---|---|
| SecNumCloud (FR) | ANSSI list of qualified products and services, https://cyber.gouv.fr |
| C5 (DE) | BSI, https://www.bsi.bund.de ; providers publish their own C5 attestations |
| ENS (ES) | CCN, https://ens.ccn.cni.es |
| Cloud qualification (IT) | ACN, https://www.acn.gov.it |
| EUCS (EU) | ENISA, https://www.enisa.europa.eu (check adoption status first) |

A certification proves the offer exists and meets a scheme. It never proves who uses it.

## Official statements (evidence type 4)

- Parliamentary questions and answers: Assemblée nationale and Sénat (FR), Bundestag DIP (DE), Camera and Senato (IT), Congreso (ES), Tweede Kamer (NL).
- Courts of auditors: Cour des comptes, Bundesrechnungshof, Corte dei conti, Tribunal de Cuentas, Algemene Rekenkamer, European Court of Auditors.
- Data protection authorities: CNIL, BfDI and Länder DPAs, Garante, AEPD, Autoriteit Persoonsgegevens, and the EDPS for EU institutions. Decisions often name the provider and data location.

## Corporate records (evidence type 5)

| Need | Source |
|---|---|
| Ultimate parent | GLEIF, https://search.gleif.org (LEI records include direct and ultimate parent when reported) |
| US parents | SEC EDGAR, https://www.sec.gov/edgar (10-K Exhibit 21 lists subsidiaries) |
| National registers | Infogreffe or Pappers (FR), Handelsregister and Unternehmensregister (DE), Registro Imprese (IT), BORME (ES), KvK (NL) |
| Cross-border | OpenCorporates, https://opencorporates.com |

## Technical traces (evidence type 6)

| Check | How |
|---|---|
| Who hosts a domain | Resolve the domain, then look up the IP's ASN owner on RIPEstat (https://stat.ripe.net) |
| Data center ownership | PeeringDB (https://www.peeringdb.com) facility records |
| Certificates | crt.sh (https://crt.sh) shows issuers and related hostnames |
| Sub-processors | The service's privacy notice or DPA annex (GDPR Art. 28 list) |

A CDN in front of a site (Cloudflare, Akamai) hides the origin host. Say so rather than attributing hosting to the CDN.

## Market data (for A4 rows)

Provider market shares come mostly from private analysts (Synergy Research, Gartner, IDC). Their press releases give headline shares. Cite the release, give the year, and note that the method is proprietary. Eurostat publishes enterprise cloud adoption rates by country but not by provider.
