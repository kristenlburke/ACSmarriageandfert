**********************************************************************
** Make separate denominator files for different phases of analysis ** 
**********************************************************************
use "$nmfratiokeep/acs_denominatorswide0023.dta", clear

** Year file
// a year-wise file that includes all population totals to calcualte annual
// birth rate and birth rate by marital status

keep year popfem popfem1?44 popfem1?44married popfem1?44unmarried propfemmarried1?44 propfemunmarried1?44 propfemmarALT1?44 propfemunmarALT1?44

save "$nmfratiokeep/denominators_total0023.dta", replace


** Year by marital status by education **
use "$nmfratiokeep/acs_denominatorswide0023.dta", clear
keep year propfemmarried1?44educ* propfemmarALT1?44educ*

save "$nmfratiokeep/denominators_byeduc0023.dta", replace

/* Commenting out age-specific files.

** Year x age x marital status file
// a file with one row per age x marital status x year, for age specific calculations 

use "$nmfratiokeep/acs_denominatorswide.dta", clear

** Reshape these data to make a data set that has population data by year x age group x marstat
// age groups include fem 15-44 (total denom) and then one for each age bracket


// reshape to long such that each row represents a population in a year
// i.e. there's a row for each 
reshape long popfemage , i(year) j(group) string
drop prop*

gen marstat = .
gen agecat9 = .
label define marstat 1 "Married" 2 "Unmarried"
label values marstat marstat
label values agecat9 agecat9

forvalues age = 1/9 {
	replace marstat = 1 if group == "`age'married"
	replace marstat = 2 if group == "`age'unmarried"
	
	replace agecat9 = `age' if group == "`age'married" | group == "`age'unmarried"
	
}


keep popfemage year marstat agecat9
keep if marstat != .

// rows: year, popfemage (population in agexmarstat group), 
//       marstat (1 = married, 2 = unmarried), 
//  	 agecat9 (missing age 1 bc we're not going to dabbel w/ rates < 15yo)

save "$nmfratiokeep/denominators_yearagemarstat.dta", replace

*/
