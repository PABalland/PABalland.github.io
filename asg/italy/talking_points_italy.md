# Italy's regions in green and digital technologies: six talking points

*Based on patents (2020–2024), scientific publications (2021–2025) and startup investment (2021–2025) for 21 Italian regions across 36–40 technologies. "Specialised" means a region's share of activity in a technology is above the reference average (specialisation index ≥ 1).*

---

### 1. Italy invents green: wind, hydrogen, recycling and heat pumps are national strengths, not regional exceptions.
Wind energy patents are a specialisation in 18 of 21 regions (including all 9 northern regions), hydrogen fuel cells and recycling in 16, and heat pumps in 15. For recycling, the typical region produces more than twice the expected share of patents (median index 2.28). This is a broad industrial base that national green-industry policy can scale up, rather than something to build from scratch.

### 2. Italy is largely absent from digital invention, including in its richest regions.
Across 13 digital technologies (AI, chips, cloud, cybersecurity, 5G, quantum and others), only 12% of region–technology combinations are patent specialisations, against 50% for the other technologies. No region is specialised in generative AI patents. Only Liguria and Valle d'Aosta are, narrowly, specialised in AI patents. Lombardia, Emilia-Romagna, Veneto and Piemonte have no patent specialisation in any of the 13. These are the most complex technologies in the dataset (average complexity score 74 vs 57), so the gap is about future competitiveness, not only today's output.

### 3. Excellent research does not turn into patents: quantum is the clearest case.
17 of 21 regions are specialised in quantum research publications, but only 5 are specialised in quantum patents and none in quantum investment. Across all technologies, a region that is strong in a field's research is no more likely to be strong in its patents (32% vs 38% for regions that are not). Calabria shows the problem most sharply: it is specialised in the research of 24 technologies, the most of any region, but in the patents of only 10, and it attracts no investment at all in 35 of 40 categories. Technology-transfer and university–industry links are the missing piece, not research capacity.

### 4. Startup investment is thin and concentrated in four hubs.
Lombardia records investment in 25 of 40 technology categories, Lazio in 20, and Piemonte and Emilia-Romagna in 16 each. Lombardia, Lazio and Piemonte alone account for 41% of all region–category combinations with any investment. Basilicata, Marche, Umbria and the two autonomous provinces of Trento and Bolzano attract investment in just one category each, and Valle d'Aosta in none. On average, southern regions attract investment in 4.6 categories against 8.4 in the North. Outside a few cities, Italy's inventions and research have very little private risk capital behind them.

### 5. Only 5 of 756 region–technology combinations are strong in research, patents and investment at once.
They are Piemonte in electric vehicles & charging and in wind energy, Lombardia in energy efficiency, and Toscana and Calabria in robotics. More broadly, when a region is specialised in patenting a technology, it is also specialised in attracting investment in it only 5.5% of the time. These five are natural candidates for regional "flagship" programmes. For everything else, policy needs to bridge the step from invention to finance, for example through public co-investment funds and proof-of-concept grants tied to existing patent strengths.

### 6. The South is not weaker in research, but it has fewer industrial stepping stones.
Southern regions are specialised in as many research fields as northern ones (12.9 on average vs 11.1). However, their base of related industrial capabilities is thinner: average relatedness density is 27.7 in the South against 35.8 in the North. It ranges from 46.8 in Lombardia, 42.4 in Veneto and 42.2 in Piemonte down to 17.2 in Basilicata and 15.7 in Molise. Low relatedness makes it harder and costlier for a region to move into new technologies. Cohesion and smart-specialisation funds in the South should therefore target fields close to existing strengths, and pair research money with support for the firms that would use it.

---

## Data notes

**Files used.** All 21 Italian NUTS2 files in each of the three folders:
- `regpat/`: patents (OECD REGPAT), pooled 2020–2024.
- `openalex/`: scientific publications (OpenAlex), pooled 2021–2025.
- `crunchbase/`: startup investment (Crunchbase funding amounts), pooled 2021–2025.

Trento and Bolzano are counted as separate regions, so there are 21 in total. The values were extracted from the data arrays embedded in each HTML chart. The periods and the funding-amount definition come from the R script history in `crunchbase/.Rapp.history`, not from the HTML files themselves.

**What each file contains.** For each technology, a file gives three numbers:
- **Specialisation index (RCA):** the region's share of activity in that technology relative to the reference average.
- **Relatedness density (0–100):** how many related technologies the region is already specialised in.
- **Complexity index:** a score for how sophisticated the technology is.

Patent files cover 36 technologies. Publication and investment files add four more: Environmental Consulting, Pollution Control, Water Management and Other. Cross-dimension comparisons use the 36 technologies that all three share.

**Caveats.**
- **No absolute counts, population or yearly figures.** The files contain only relative indices for one pooled period. So it is not possible to rank regions by total output, compute per-capita figures, measure the share of the top 3 regions in total activity, or show trends over time. Point 4's "concentration" figure counts region–category combinations with any non-zero investment. It is not a share of money invested.
- **Shared relatedness and complexity scores.** Relatedness density and complexity are identical across the three folders. They come from patent data and are re-used in the publication and investment charts.
- **Unclear reference group.** The specialisation index is computed against a wider set of NUTS2 regions (probably European), not against Italy alone. The exact reference group is not stated in the files.
- **Small numbers.** Investment is zero in most categories for most regions, so a single deal can produce extreme values (for example, robotics investment index 57.6 in Toscana and 52.8 in Calabria). Small regions show similar volatility in patents (Valle d'Aosta, Molise). Treat single-region, single-technology results as indicative.
- **Missing data.**
  - Valle d'Aosta has investment rows for only 36 categories, all zero.
  - Four of the 40 categories have no relatedness or complexity score.
  - One unrelated Finnish region (`pohjois--ja-ita-suomi-fi1d`) is in each folder and was excluded.
- **Region groups.** North = ITC + ITH (9 regions), Centre = ITI (4), South and Islands = ITF + ITG (8).
- **Digital group (point 2).** AI, generative AI, computer vision/language processing, cloud & edge, cybersecurity, HPC, IoT, 5G/6G, quantum, semiconductors, software engineering, blockchain and satellite connectivity.
