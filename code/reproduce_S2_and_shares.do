*==============================================================================
* reproduce_S2_and_shares.do
* Auxiliary reproduction script: reproduces S2 Table (Panels A and B) and the in-text travel-companion shares of the accepted manuscript from the deposited de-identified dataset. Strictly descriptive: no new analysis, no new variables, no recoding, no models. The two sample-rule lines below replicate the main analysis script (WTA_education_analysis_repository.do) verbatim.
* Run from data/:   do "../code/reproduce_S2_and_shares.do"
*
* Note: the per-hour travel-cost figures reported in the accepted text are the Table 1 TravC mean and median (outputs of the main analysis script) divided by the 4-hour session length; see the README. They are not recomputed here.
*==============================================================================
capture mkdir logs
capture log close
log using "logs/S2_and_shares_output.txt", text replace
local datadir "."
use "`datadir'/analysis_data_deidentified.dta", clear
destring travel_miles_class, replace   // main-script step (numeric stored as string)
drop if travel_miles_class == .        // main-script analysis-sample rule (118 -> 114)
* Missing responses in the string items below are stored as the literal "." (see codebook).

*--- S2 Table, Panel A: perceived benefit -------------------------------------
tab class_improve_reality                                   // counts; "." = item not answered
tab class_improve_reality if class_improve_reality != "."   // percentages of valid responses

*--- S2 Table, Panel B: influence on future direction -------------------------
tab class_influence_future
tab class_influence_future if class_influence_future != "."

*--- In-text travel-companion shares (Results section) ------------------------
tab travel_alone if travel_alone != "."                     // valid N = 113; "self" = traveled alone
quietly count if travel_alone != "."
local nvalid = r(N)
quietly count if travel_alone != "." & travel_alone != "self"
display as text "Share traveling with at least one other person: " %5.2f 100*r(N)/`nvalid' "%  (accepted value: 56.64%)"

log close
