// merge.do


** Generate a year x marital status file

use "$nmfratiokeep/denominators_total0023.dta", clear

merge 1:1 year using "$nmfratiokeep/totalbirthsbyyear_fromNVSR.dta"

// the years that didn't merge are the ones that I haven't pulled pop denom
// data for-- they're not the focus here.
tab year if _merge == 2

drop if _merge == 2
drop _merge


/* No longer generating rates using ACS denominators because 1) they're available from vital stats and 2) we're excluding group quarters from denom, which will affect denominator


gen fertrate1544 = (birthstotal/popfem1544) * 1000
gen maritalfertrate1544 = (birthsmarried/popfem1544married) * 1000
gen nonmaritalfr1544 = (birthsunmarried/popfem1544unmarried) * 1000

gen fertrate1944 = (birthstotal/popfem1944) * 1000
gen maritalfertrate1944 = (birthsmarried/popfem1944married) * 1000
gen nonmaritalfr1944 = (birthsunmarried/popfem1944unmarried) * 1000

*/

save "$nmfratiokeep/birthfile_total_acscdcmerged.dta", replace
export excel using "$nmfratioresults/birthfile_total_acscdcmerged.xls", replace firstrow(variables)


/* Commenting out age-specific anaysis

** Generate a year x marital status file x age 

use "$nmfratiokeep/denominators_yearagemarstat.dta", clear

merge 1:1 year marstat agecat9 using "$nmfratiokeep/births0322_agemarstat.dta"
tab agecat9 if _merge == 2

// the _merge == 2 (only in birth data, not in denominator data) are due to...
// not generating denom data for agecat9 == 1 (<15)
gen accounted = 0
replace accounted = 1 if _merge == 2 & agecat9 == 1

tab accounted if _merge == 2

// missing marstat - these "not reported" for marital status births
// FLAG FOR FOLLOW-UP
replace accounted = 1 if _merge == 2 & marstat == .

tab accounted if _merge == 2

// what's left? birth data from 2021 & 2022 that I didn't get pop data on
replace accounted = 1 if _merge == 2 & year > 2020

tab accounted if _merge == 2
// they're all accounted for

drop if _merge == 2

save "$nmfratiokeep/birthfile_agemarstat.dta", replace
*/
