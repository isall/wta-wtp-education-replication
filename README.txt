===========================================================================
VALUING EDUCATION USING A WILLINGNESS-TO-ACCEPT EXPERIMENT
Replication data and code
===========================================================================

ABOUT THIS PACKAGE
------------------
This package contains the de-identified data and analysis code needed to
reproduce Tables 1-4, S1 Table, S2 Table, and Figures 4-5 of the article:

"Valuing education for limited-resource audiences using a willingness to
accept experiment"

The Supporting Information files supplied to PLOS ONE are included in docs/ as
reference copies. Figures 1-3 are supplied as final images rather than generated
by the public code. Figures 4-5 can be regenerated from the de-identified
speed-and-distance data in data/.

To protect participants and the two training locations, the package does not
include raw surveys, direct identifiers, exact locations or coordinates, or
location-revealing routing materials. These withheld materials are not needed
to reproduce the reported statistical results. See
docs/Data_Availability_Statement.txt for the Data Availability Statement.


QUICK START
-----------
Run the four steps below in order. Commands shown for Stata and R are entered
inside those programs. The Python command is entered in a terminal.

Step 1 -- Main analysis and tables
    Working folder: data/
    Stata command:  do "../code/WTA_education_analysis_repository.do"

Step 2 -- Apply article row labels to exported tables
    Working folder: repository root (the folder containing README.txt,
                    code/, and data/)
    Terminal command:
        python3 code/relabel_tables.py data

Step 3 -- S2 Table and travel-companion shares
    Working folder: data/
    Stata command:  do "../code/reproduce_S2_and_shares.do"

Step 4 -- Figures 4-5
    Working folder: data/
    R command:      source("../code/figs4_5_spillman_R_only.R")

Detailed requirements, inputs, outputs, and checks are provided below.


1. PACKAGE CONTENTS
-------------------

Location  File or group                       Purpose
--------  ----------------------------------  ---------------------------------
root      README.txt                          Main public instructions.

root      CITATION.cff                        Citation information for the
                                              replication package.

root      LICENSE-CC-BY-4.0.txt               License for data, documentation,
                                              and figures.

root      LICENSE-MIT.txt                     License for Stata, R, and Python
                                              code.

root      .gitignore                          Keeps locally generated outputs and
                                              system/editor files out of version
                                              control.

data/     analysis_data_deidentified.dta      File used by the main Stata analysis.
                                              It has 118 questionnaire records.

data/     analysis_data_deidentified.csv      Open-format copy of the same
                                              de-identified analysis data.

data/     speed_distance_deidentified.csv     De-identified one-way distance and
                                              speed data used for Figures 4-5.
                                              It contains neutral site labels
                                              and no coordinates.

data/     codebook.txt                        Documents the data columns and
                                              constructed analysis variables.

data/     README_data.txt                     Explains the relationship between
                                              the Stata and CSV data files.

code/     WTA_education_analysis_repository.do
                                              Main Stata analysis for Tables 1-4
                                              and robustness results.

code/     relabel_tables.py                   Creates copies of exported tables
                                              with article row labels without
                                              changing their numeric cells.


code/     reproduce_S2_and_shares.do          Reproduces S2 Table and the
                                              travel-companion shares.

code/     figs4_5_spillman_R_only.R            Recreates Figures 4-5.

docs/     S1_Appendix.pdf                     Blank survey instrument supplied
                                              to PLOS ONE as S1 Appendix.

docs/     S1_Table.pdf                        S1 Table reference copy.

docs/     S2_Table.pdf                        S2 Table reference copy.

docs/     Data_Availability_Statement.txt     Data Availability Statement.

docs/     README_docs.txt                     Guide to the files in docs/.

figures/  Fig1.tif ... Fig5.tif              Final figure files supplied to
                                              PLOS ONE.

figures/  README_figures.txt                  Guide to the figure files.


2. SOFTWARE REQUIREMENTS AND VALIDATED ENVIRONMENT
--------------------------------------------------
The workflow was validated with the exact versions below. Other versions and
platforms have not been tested.

Software  Purpose                       Validated environment
--------  ----------------------------  ---------------------------------------
Stata     Main analysis, S1 Table,       Stata/SE 15.1, Windows 64-bit,
          S2 Table, and table exports    Revision 03 Feb 2020

R         Figures 4-5                   R 4.6.1, macOS arm64

Python    Table-label helper            Python 3.14.5, macOS arm64

Required Stata community packages:

    Package or command set   Validated version
    -----------------------  -----------------
    outreg2                  2.3.2
    esttab                   2.1.1
    eststo                   1.1.0
    estadd                   2.3.5

The esttab, eststo, and estadd commands are supplied by the estout package.
Install the Stata packages once, if needed:

    ssc install outreg2
    ssc install estout

No other community-contributed Stata commands are required.

Required R packages:

    readr 2.2.0
    dplyr 1.2.1
    ggplot2 4.0.3

The documented workflow specifies R 4.1 or later, but only R 4.6.1 was
validated. The curve is fitted with the base-R nls function. The optional ragg
package (validated version 1.5.2) produces LZW-compressed TIFF files. If ragg is
not installed, the script still completes and writes uncompressed TIFF files.

The Python helper uses only the Python standard library; no third-party Python
packages are required.


3. DETAILED REPRODUCTION INSTRUCTIONS
-------------------------------------

STEP 1 -- RUN THE MAIN STATA ANALYSIS

Purpose:
    Reproduce the main descriptive statistics, regression models, marginal
    effects, and robustness results.

Working folder:
    data/

Command:
    do "../code/WTA_education_analysis_repository.do"

Main input:
    analysis_data_deidentified.dta

Sample rule:
    The dataset contains 118 records. The script removes the four
    records with missing one-way mileage, leaving 114 records before other
    variable-specific missing values affect individual models.

Main outputs:
    logs/full_stata_output.txt
    R1_3_robustness_perceived_benefit.rtf

    Eleven table-export pairs, each consisting of one .doc and one .txt file:

    First_table_Linear_WTA_3rd_Wage
    Sample_table_Linear_WTA_3rd_Wage
    Linear_Full_WTA_3rd_Wage_combined
    Oprobit_FullModel_WTA_3rd_Wage
    Sample_Oprobit_FullModel_WTA
    Ologit_FullModel_WTA_3rd_Wage
    MarginalEffects_WTP_log
    MarginalEffects_d_begin_growers
    MarginalEffects_avgknowledge_be
    MarginalEffects_avgknowledge_af
    MarginalEffects_total_travelcost

The script writes these files into data/ because data/ is the working folder.


STEP 2 -- APPLY ARTICLE ROW LABELS TO EXPORTED TABLES

Purpose:
    Replace internal code names in the first table column with the short labels
    used in the article's tables, such as Ln(WTP), TravC, and DBegFarm. Numeric
    data cells are not changed.

Working folder:
    Repository root (the folder containing README.txt, code/, and data/).

Command:
    python3 code/relabel_tables.py data

Input:
    The .doc and .txt files created by Step 1 in data/.

Output:
    data_tokens/

The helper does not overwrite the originals. It copies all 11 .txt and all 11
.doc table exports to data_tokens/. Where applicable, the copies use article
row labels. Other .txt files found directly in data/ are copied unchanged.

Six table pairs contain labels that need substitution. The five
marginal-effects pairs contain no mappable first-column labels and are copied
unchanged. Messages are printed only for files in which substitutions occur;
the expected successful run prints six [txt] messages and six [doc] messages,
followed by "Done."

If the helper finds no table export with a mappable row label, it exits with an
error instead of reporting success. Confirm that Step 1 completed and that the
Python command was run from the repository root.


STEP 3 -- REPRODUCE S2 TABLE AND TRAVEL-COMPANION SHARES

Purpose:
    Reproduce both descriptive panels of S2 Table and the travel-companion
    percentages reported in the Results section.

Working folder:
    data/

Command: do "../code/reproduce_S2_and_shares.do"

Input:
    analysis_data_deidentified.dta

Output:
    logs/S2_and_shares_output.txt

This auxiliary script is descriptive only. It does not create new analysis
variables, recode responses, or estimate models. It applies the same mileage
rule as the main script, reducing 118 records to 114. Among the 113 records
with a valid travel-party response, 56.64% traveled with at least one other
person.


STEP 4 -- REPRODUCE FIGURES 4-5

Purpose:
    Fit the Spillman speed-distance curves and generate Figures 4 and 5 with
    scatterplots, fitted curves, equations, standard errors, and notes.

Working folder:
    data/

Command:
    source("../code/figs4_5_spillman_R_only.R")

Input:
    speed_distance_deidentified.csv

Input checks:
    Required columns: site, distance_miles, and speed_mph.
    small_town_site records: 1,681.
    rural_area_site records: 1,387.

Quality checks:
    The script stops unless the fitted coefficients agree with the reported
    rounded coefficients within 0.01.

Outputs:
    Fig4.tif -- small_town_site, 600 dpi
    Fig5.tif -- rural_area_site, 600 dpi

If ragg is installed, the TIFF files use LZW compression. Otherwise, the
script writes uncompressed TIFF files. Compression does not change the fitted
model or plotted values.


4. WHERE TO FIND EACH REPORTED RESULT
-------------------------------------

Reported result      Reproduction source
-------------------  ---------------------------------------------------------
Table 1              Descriptive statistics in logs/full_stata_output.txt.

Table 2              Linear_Full_WTA_3rd_Wage_combined.doc/.txt contains the
                     full five-model OLS export. The First_table_Linear and
                     Sample_table_Linear files provide additional OLS results
                     and common-sample checks, which use the same records
                     across models.

Table 3              Oprobit_FullModel_WTA_3rd_Wage.doc/.txt contains the full
                     five-model ordered-probit export. Sample_Oprobit_FullModel
                     contains the corresponding check using the same records
                     across models.

Table 4              The five MarginalEffects_*.doc/.txt export pairs.

S1 Table             R1_3_robustness_perceived_benefit.rtf and the associated
                     results in the main Stata log. Ologit_FullModel contains
                     the ordered-logit robustness models discussed in the
                     article.

S2 Table             Both panels in logs/S2_and_shares_output.txt. The
                     S2_Table.pdf reference copy is included for direct
                     comparison.

Companion shares     logs/S2_and_shares_output.txt, including the reported
                     56.64% value.

Figures 4-5          Fig4.tif and Fig5.tif generated by the R script from
                     speed_distance_deidentified.csv.

The Supporting Information PDFs supplied to PLOS ONE are reference copies. The
scripts and data in this repository are the reproduction mechanism.


5. IMPORTANT INTERPRETATION NOTES
---------------------------------

Additional N = 58 diagnostic
    The main Stata log contains one additional N = 58 estimation that omits
    the two perceived-benefit indicator variables. It is an auxiliary
    diagnostic and is not reported in the article.

Per-hour travel-cost values
    The reported values $17.27 and $10.56 per hour are derived from the Table 1
    total-travel-cost mean ($69.08) and median ($42.25), divided by the four-hour
    session length. They are derived values rather than separate script outputs.

Figure 1
    figures/Fig1.tif is the WTA/WTP survey-box illustration from the
    questionnaire. It is not a map and is not an analysis input.

Figures 2-3
    figures/Fig2.tif and figures/Fig3.tif are author-generated figures showing
    drive-time boundaries (isochrones) on a blank background. They do not reproduce
    proprietary basemaps, satellite imagery, street maps, topographic maps, or map
    tiles. The article describes the use of the Open Source Routing Machine (OSRM)
    to generate these boundaries. Exact contours and coordinates are withheld
    because they would reveal the training locations. The maps are illustrative
    and are not analysis inputs.


Figures 4-5
    The R script maps small_town_site to Figure 4 and rural_area_site to
    Figure 5. The reported fitted equations are:

        Figure 4: 53.356 - 24.509 * 0.978^Distance
        Figure 5: 54.104 - 40.822 * 0.982^Distance

    The script also displays coefficient standard errors and the significance
    note and verifies the fitted coefficients before writing the figures.


6. GENERATED FILES AND VERSION CONTROL
--------------------------------------
Running the scripts creates logs, Stata table exports, data_tokens/, and
regenerated Figure 4-5 files in data/. The repository's .gitignore keeps these
files, along with R-session and Python-cache files, out of version control. The
final figure files in figures/ remain part of the public package.


Ignore rules prevent generated files from being added to version control; they
do not delete local outputs.


7. PRIVACY AND MATERIALS NOT INCLUDED
--------------------------------------
The following materials are not public because they could identify
participants or reveal the two training locations:

- raw survey records, including direct identifiers, free-text responses, and
  administrative fields;
- exact training-location names, identities, and coordinates;
- raw routing, API, isochrones, and coordinate-generation inputs or outputs that
  would reveal the locations;
- private IRB and consent records, private correspondence, and internal project
  files.

The public dataset removes sensitive and unused fields and replaces the two
training locations with the neutral labels small_town and rural_area. The
de-identification procedure and numeric-equivalence validation are not public
because they require the withheld raw materials. None of the withheld
materials is required to reproduce the statistical results reported in the
article.


8. VERSION, CITATION, AND LICENSES
---------------------------------
Repository release:
    v1.0.0 -- the repository release associated with the article.

Article:
    "Valuing education for limited-resource audiences using a willingness to
    accept experiment," PLOS ONE. Final article citation details are not
    included in this release; CITATION.cff contains citation information for
    the replication package.

Archived package:
    Zenodo DOI: 10.5281/zenodo.22134188

Version-controlled repository:
    https://github.com/isall/wta-wtp-education-replication

Citation file:
    CITATION.cff

Licenses:
    Data, documentation, and figures: CC BY 4.0
        See LICENSE-CC-BY-4.0.txt.

    Stata, R, and Python code: MIT License
        See LICENSE-MIT.txt.