#!/usr/bin/env python3
"""Turn techdep PA1 rows into country-by-country dependency matrices.

Usage:
    python scripts/pa1_matrix.py rows.csv [--out matrices/]

Input: the CSV block at the end of a techdep report (see pa1-output.md).
Output: one CSV matrix per dimension (rows = dependent country i,
columns = control country j) and a printed summary.

Cell value = evidence score. Each row adds a weight by confidence
(CONFIRMED 1.0, STRONG INFERENCE 0.75, MODERATE INFERENCE 0.5).
For A8 and E6, j is tech_supplier_country when it is filled in.
When rows carry a numeric share in `value`, a second matrix averages those shares.
Standard library only.
"""
import argparse
import csv
import os
import re
import sys
from collections import defaultdict

COLUMNS = ["country_i", "buyer", "provider", "provider_hq", "control_country_j",
           "tech_supplier_country", "component", "dimension_id", "value", "confidence",
           "source_ids", "source_year", "note"]
WEIGHTS = {"CONFIRMED": 1.0, "STRONG INFERENCE": 0.75, "MODERATE INFERENCE": 0.5}
DIMENSIONS = {"A4": "Market share / installed base", "A7": "Public procurement",
              "A8": "Maintenance and updates", "D2": "Corporate ownership",
              "E1": "Infrastructure ownership", "E2": "Data location",
              "E6": "Remote control", "F1": "Jurisdictional reach"}
TECH_DIMENSIONS = {"A8", "E6"}
COMPONENTS = {"IaaS", "PaaS", "SaaS-hosting", "HPC", "data-center", "edge"}
CODE = re.compile(r"^([A-Z]{2}|EU)$")


def load(path):
    rows, errors = [], []
    with open(path, newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        missing = [c for c in COLUMNS if c not in (reader.fieldnames or [])]
        if missing:
            sys.exit(f"Missing columns: {', '.join(missing)}")
        for n, r in enumerate(reader, start=2):
            r = {k: (v or "").strip() for k, v in r.items()}
            problems = []
            for col in ("country_i", "control_country_j", "provider_hq"):
                if not CODE.match(r[col]):
                    problems.append(f"{col}='{r[col]}' is not an ISO2 code or EU")
            if r["tech_supplier_country"] and not CODE.match(r["tech_supplier_country"]):
                problems.append(f"tech_supplier_country='{r['tech_supplier_country']}' is not an ISO2 code")
            if r["dimension_id"] not in DIMENSIONS:
                problems.append(f"dimension_id='{r['dimension_id']}' not in {sorted(DIMENSIONS)}")
            if r["confidence"] not in WEIGHTS:
                problems.append(f"confidence='{r['confidence']}' must be one of {list(WEIGHTS)}")
            if r["component"] not in COMPONENTS:
                problems.append(f"component='{r['component']}' not in {sorted(COMPONENTS)}")
            if not r["source_ids"]:
                problems.append("source_ids is empty")
            if r["value"]:
                try:
                    v = float(r["value"])
                    if not 0 <= v <= 1:
                        problems.append("value must be between 0 and 1")
                except ValueError:
                    problems.append(f"value='{r['value']}' is not a number")
            if problems:
                errors.append(f"line {n}: " + "; ".join(problems))
            else:
                rows.append(r)
    return rows, errors


def build(rows):
    score = defaultdict(lambda: defaultdict(float))
    shares = defaultdict(lambda: defaultdict(list))
    for r in rows:
        d, i, j = r["dimension_id"], r["country_i"], r["control_country_j"]
        # For the update channel and remote control, the country that matters is
        # whoever supplies the technology, when it differs from the owner.
        if d in TECH_DIMENSIONS and r["tech_supplier_country"]:
            j = r["tech_supplier_country"]
        score[d][(i, j)] += WEIGHTS[r["confidence"]]
        if r["value"]:
            shares[d][(i, j)].append(float(r["value"]))
    return score, shares


def write_matrix(cells, path, fmt):
    iso_i = sorted({i for i, _ in cells})
    iso_j = sorted({j for _, j in cells})
    with open(path, "w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(["country_i \\ control_country_j"] + iso_j)
        for i in iso_i:
            w.writerow([i] + [fmt(cells[(i, j)]) if (i, j) in cells else "" for j in iso_j])
    return iso_i, iso_j


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("csv")
    ap.add_argument("--out", default="matrices")
    args = ap.parse_args()

    rows, errors = load(args.csv)
    if errors:
        print(f"{len(errors)} row(s) rejected:")
        for e in errors:
            print("  " + e)
    if not rows:
        sys.exit("No valid rows.")
    os.makedirs(args.out, exist_ok=True)
    score, shares = build(rows)

    print(f"\n{len(rows)} valid row(s). Matrices written to {args.out}/\n")
    for d in sorted(score):
        cells = score[d]
        path = os.path.join(args.out, f"L5_{d}_evidence.csv")
        iso_i, iso_j = write_matrix(cells, path, lambda v: f"{v:.2f}")
        print(f"{d}  {DIMENSIONS[d]}  ({len(iso_i)} x {len(iso_j)})")
        for (i, j), v in sorted(cells.items(), key=lambda x: -x[1]):
            flag = "  (domestic)" if i == j else ""
            print(f"    {i} -> {j}: {v:.2f}{flag}")
        if shares[d]:
            avg = {k: sum(v) / len(v) for k, v in shares[d].items()}
            write_matrix(avg, os.path.join(args.out, f"L5_{d}_share.csv"), lambda v: f"{v:.3f}")
            print(f"    share matrix written (L5_{d}_share.csv)")
    print()


if __name__ == "__main__":
    main()
