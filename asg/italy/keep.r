FOLDER <- "~/Library/CloudStorage/Dropbox/GitHub/PABalland.github.io/asg/italy"   # <- set your folder

files    <- list.files(FOLDER, recursive = TRUE, full.names = TRUE)
keep     <- grepl("-it", basename(files), fixed = TRUE)
to_del   <- files[!keep]

# 1. Check first
cat("Keeping:", sum(keep), "files | Deleting:", length(to_del), "files\n")
print(head(to_del, 20))        # preview of what will be deleted

# 2. Delete (asks for confirmation)
if (readline("Delete these files? (yes/no): ") == "yes") {
  ok <- file.remove(to_del)
  cat("Deleted:", sum(ok), "files\n")
}

# claude session 
#cd ~/"Library/CloudStorage/Dropbox/GitHub/PABalland.github.io/asg/italy"
#claude

This folder holds data on Italian regions (files named like "abruzzo-itf1") in three subfolders: patents, scientific publications and investment.

1. Explore first. List the three subfolders and their files. Open a few files to understand the structure: columns, units, years, which technologies or sectors are covered. Tell me briefly what you found before analysing.

2. Analyse the data across all regions and all three dimensions. Look for:
  - which regions lead and which lag, in absolute terms and per capita if population data is available
- how concentrated activity is (e.g. the share of the top 3 regions)
- North–South differences
- the technologies or sectors where Italy or specific regions are strong or specialised
- whether strength in research (publications) turns into patents and investment, or where the gaps are
- trends over time, if the data covers several years

Do the calculations in code (R or Python). Never estimate numbers by eye.

3. Write 6 key talking points for politicians and policymakers:
  - one bold headline sentence each, then 2–3 sentences of explanation
- every point backed by at least one concrete number from the data, naming the regions
- plain language, no jargon, policy-relevant (what it means for regional or industrial policy)
- mix observations across patents, publications and investment, and at least one point that connects all three

4. Save the result as talking_points_italy.md in this folder. After the 6 points, add a short "Data notes" section: which files were used, the years covered, and any caveats (missing regions, small numbers, definitions).

Do not modify or delete any existing files.