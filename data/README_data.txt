DATA FILES
----------
The de-identified analysis dataset is provided in two formats. Both files
contain the same 118 questionnaire records and 36 columns. They were created
through a Stata de-identification process and checked to confirm that their
stored values agree.

    analysis_data_deidentified.dta
        File used by the main Stata analysis. The main Stata analysis script,
        code/WTA_education_analysis_repository.do, reads this file when the script
        is run from the data/ folder.

    analysis_data_deidentified.csv
        Open-format copy of the same dataset. It allows the deposited data to be
        viewed without Stata.

The two training locations are represented by the neutral labels small_town and
rural_area rather than by their actual names. See codebook.txt for variable
definitions, category codes, missing-value conventions, and explanations of the
constructed measures.
