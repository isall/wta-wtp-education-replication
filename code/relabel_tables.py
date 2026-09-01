#!/usr/bin/env python3
"""
relabel_tables.py -- rewrite ONLY the row-label (first) column of the exported
regression tables to the submitted manuscript tokens, leaving every data cell
(coefficients, SEs, N, fit stats) untouched.

Why a post-processor: outreg2's own `label` option does not give clean token-only
row labels -- it adds a second column and renders factor rows as "DBegFarm = 1".
This script does the label mapping deterministically on the text, so numbers cannot
change and the result is a clean single-column table.

Usage:
    python3 relabel_tables.py <input_dir> [output_dir]
Default output_dir = "<input_dir>_tokens" (originals are NOT overwritten).
Handles both .txt (tab-separated) and .doc (RTF) outreg2 exports.
"""
import sys, os, re

# code-name (row label) -> submitted manuscript token
MAP = {
    "1.DBegFarm": "DBegFarm", "DBegFarm": "DBegFarm",
    "1.d_male": "Male", "d_male": "Male",
    "WTP_log": "Ln(WTP)",
    "total_travelcost": "TravC",
    "cost_day": "TotC",
    "cost_attendance": "OPCattend",
    "avgknowledge_be": "AvgKnowBef",
    "avgknowledge_af": "AvgKnowAft",
    "edu_yrs": "Education",
    "age_num": "Age",
    "no_ppl": "Npeople",
    "mileage": "Nmiles",
    "AdjWTAtcost": "WTA - TravC",
    "AdjWTPtcost": "WTP + TravC",
}

def relabel_txt(text):
    changed = []
    out = []
    for line in text.split("\n"):
        parts = line.split("\t")
        if parts and parts[0] in MAP and MAP[parts[0]] != parts[0]:
            changed.append((parts[0], MAP[parts[0]]))
            parts[0] = MAP[parts[0]]
        out.append("\t".join(parts))
    return "\n".join(out), changed

def relabel_doc(text):
    # RTF: the row label is the first cell, written as  \ql <label>\cell
    changed = []
    for code, tok in MAP.items():
        if code == tok:
            continue
        pat = "\\ql " + code + "\\cell"
        rep = "\\ql " + tok + "\\cell"
        if pat in text:
            n = text.count(pat)
            text = text.replace(pat, rep)
            changed.append((code, tok, n))
    return text, changed

def main():
    if len(sys.argv) < 2:
        sys.exit("usage: python3 relabel_tables.py <input_dir> [output_dir]")
    ind = sys.argv[1]
    outd = sys.argv[2] if len(sys.argv) > 2 else ind.rstrip("/\\") + "_tokens"
    os.makedirs(outd, exist_ok=True)
    mapped_files = 0
    for f in sorted(os.listdir(ind)):
        p = os.path.join(ind, f)
        if f.lower().endswith(".txt"):
            t = open(p, encoding="utf-8", errors="replace").read()
            nt, ch = relabel_txt(t)
            open(os.path.join(outd, f), "w", encoding="utf-8").write(nt)
            if ch:
                mapped_files += 1
                print(f"[txt] {f}: " + ", ".join(f"{a}->{b}" for a, b in dict(ch).items()))
        elif f.lower().endswith(".doc"):
            t = open(p, encoding="utf-8", errors="replace").read()
            nt, ch = relabel_doc(t)
            open(os.path.join(outd, f), "w", encoding="utf-8").write(nt)
            if ch:
                mapped_files += 1
                print(f"[doc] {f}: " + ", ".join(f"{a}->{b} (x{n})" for a, b, n in ch))
    if mapped_files == 0:
        sys.exit("ERROR: no table exports with mappable row labels were found in "
                 f"'{ind}'. Run the Stata analysis first (see README, execution "
                 "order), then rerun this helper.")
    print(f"\nDone. Token-labeled copies written to: {outd}")
    print("Only the first (row-label) column was changed; all data cells are byte-for-byte unchanged.")

if __name__ == "__main__":
    main()
