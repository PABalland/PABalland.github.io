# PA1 Output Rows

Every report ends with a CSV block. Each row is one evidenced link between a buyer
in country i and a provider controlled from country j. The rows feed the layer 5
bilateral matrices of the PA1 Tech Dependency Index.

## Columns (in this order)

| Column | Content |
|---|---|
| country_i | ISO 3166 alpha-2 code of the dependent country (FR, DE, IT...), or EU for EU institutions |
| buyer | The public body, sector or company that uses the service |
| provider | Provider or operator name |
| provider_hq | ISO2 code where the contracting entity is incorporated |
| control_country_j | ISO2 code of the ultimate owner. The matrix uses this column, except for A8 and E6 (see below) |
| tech_supplier_country | ISO2 code of the software/platform supplier if different, otherwise blank |
| component | One of: IaaS, PaaS, SaaS-hosting, HPC, data-center, edge |
| dimension_id | PA1 dimension code (table below) |
| value | Number between 0 and 1 if the source gives a share, otherwise blank |
| confidence | CONFIRMED, STRONG INFERENCE or MODERATE INFERENCE |
| source_ids | Registry numbers, separated by ";" (for example "1;4") |
| source_year | Year of the most recent source |
| note | One short sentence, no commas inside quotes |

## Dimension codes used for layer 5

| Code | Dimension | Use when the evidence shows |
|---|---|---|
| A4 | Market share / installed base | Share of a country's or sector's cloud use served by providers from j |
| A7 | Public procurement | A contract award from a buyer in i to a provider controlled from j |
| A8 | Maintenance and updates | The software or update channel comes from j (split-model JVs) |
| D2 | Corporate ownership | A provider operating in i is owned from j |
| E1 | Infrastructure ownership | Data centers in i owned by operators from j |
| E2 | Data location | Data of buyers in i stored or processed in j |
| E6 | Remote control | j's operator can suspend, degrade or update the service |
| F1 | Jurisdictional reach | j's law (CLOUD Act, FISA 702 and similar) reaches the service |

## Example block

This is a format illustration only. It is not a research finding.

```csv
country_i,buyer,provider,provider_hq,control_country_j,tech_supplier_country,component,dimension_id,value,confidence,source_ids,source_year,note
XX,Example Ministry,Example Cloud SAS,XX,YY,ZZ,IaaS,A7,,CONFIRMED,1,2026,Award notice names provider
```

Rules:
- For A8 (updates) and E6 (remote control), the script uses tech_supplier_country as j when it is filled in, because the country that ships the software is the one that can stop it.
- Only MODERATE INFERENCE or higher. SPECULATIVE, skill database and training knowledge findings stay in the narrative.
- One row per dimension. A single contract award may produce A7, F1 and A8 rows.
- If control_country_j equals country_i, still write the row. Domestic reliance is the matrix diagonal.
