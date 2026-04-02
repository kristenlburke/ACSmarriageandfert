// acs_rates.do

// Estimate rates of fertility overall, by marital status
// and then by marital status by subgroup in the ACS

// Read in ACS data
use "$nmfratiokeep/acs_0023recoded.dta", clear

// Set up weights
svyset CLUSTER [pweight=PERWT], strata(STRATA)

*********************
** Overall by year **
*********************

// Set up spreadsheet for placement - we'll put all rates in here
putexcel set "$nmfratioresults/acsrates/birthrates_1544.xlsx",  replace

putexcel A1 = "Year"
putexcel B1 = "Marital status" 
putexcel C1 = "Group"
putexcel D1 = "Rate"
putexcel E1 = "SE"

local row = 2
forvalues year = 2000/2023{
		svy, subpop(if womanage1544 == 1 & YEAR == `year'): mean baby
		matrix m = e(b)
		matrix V = e(V)
		matrix list V
		svmat V
		local se = sqrt(V1)
		putexcel D`row' = matrix(m)
		putexcel E`row' = `se' 
	
		putexcel A`row' = "`year'"
		putexcel B`row' = "overall"
		putexcel C`row' = "overall"
		
		local row = `row' + 1
		drop V*
}

** 19-44
putexcel set "$nmfratioresults/acsrates/birthrates_1944.xlsx",  replace

putexcel A1 = "Year"
putexcel B1 = "Marital status" 
putexcel C1 = "Group"
putexcel D1 = "Rate"
putexcel E1 = "SE"

local row = 2
forvalues year = 2000/2023{
		svy, subpop(if womanage1944 == 1 & YEAR == `year'): mean baby
		matrix m = e(b)
		matrix V = e(V)
		matrix list V
		svmat V
		local se = sqrt(V1)
		putexcel D`row' = matrix(m)
		putexcel E`row' = `se' 
	
		putexcel A`row' = "`year'"
		putexcel B`row' = "overall"
		putexcel C`row' = "overall"
		
		local row = `row' + 1
		drop V*
}

*****************************************
** Estimates by marital status by year **
*****************************************

putexcel set "$nmfratioresults/acsrates/birthrates_marstat_1544.xlsx",  replace

putexcel A1 = "Year"
putexcel B1 = "Marital status" 
putexcel C1 = "Group"
putexcel D1 = "Rate"
putexcel E1 = "SE"

local row = 2
forvalues year = 2000/2023{
	forvalues marstat = 0/1 {
		svy, subpop(if womanage1544 == 1 & married == `marstat' & YEAR == `year'): mean baby
		matrix m = e(b)
		matrix V = e(V)
		matrix list V
		svmat V
		local se = sqrt(V1)
		putexcel D`row' = matrix(m)
		putexcel E`row' = `se' 
	
		putexcel A`row' = "`year'"
		putexcel B`row' = "`marstat'"
		putexcel C`row' = "overall"
		
		local row = `row' + 1
		drop V*
	}
}

putexcel set "$nmfratioresults/acsrates/birthrates_marstat_1944.xlsx",  replace

putexcel A1 = "Year"
putexcel B1 = "Marital status" 
putexcel C1 = "Group"
putexcel D1 = "Rate"
putexcel E1 = "SE"

local row = 2
forvalues year = 2000/2023{
	forvalues marstat = 0/1 {
		svy, subpop(if womanage1944 == 1 & married == `marstat' & YEAR == `year'): mean baby
		matrix m = e(b)
		matrix V = e(V)
		matrix list V
		svmat V
		local se = sqrt(V1)
		putexcel D`row' = matrix(m)
		putexcel E`row' = `se' 
	
		putexcel A`row' = "`year'"
		putexcel B`row' = "`marstat'"
		putexcel C`row' = "overall"
		
		local row = `row' + 1
		drop V*
	}
}

// ALTERNATIVE MARITAL STATUS which excludes people who were married in last yr
// from married group.
// Only available 2008 forward.

putexcel set "$nmfratioresults/acsrates/birthrates_marstatALT_1544.xlsx",  replace

putexcel A1 = "Year"
putexcel B1 = "Marital status" 
putexcel C1 = "Group"
putexcel D1 = "Rate"
putexcel E1 = "SE"

local row = 2
forvalues year = 2008/2023{
	forvalues marstat = 0/1 {
		svy, subpop(if womanage1544 == 1 & married1yrago == `marstat' & YEAR == `year'): mean baby
		matrix m = e(b)
		matrix V = e(V)
		matrix list V
		svmat V
		local se = sqrt(V1)
		putexcel D`row' = matrix(m)
		putexcel E`row' = `se' 
	
		putexcel A`row' = "`year'"
		putexcel B`row' = "`marstat'"
		putexcel C`row' = "overall"
		
		local row = `row' + 1
		drop V*
	}
}




/* Commenting out analyses by age

**********************
** Estimates by age ** 
**********************

// Set up spreadsheet for placement - we'll put all rates in here
putexcel set "$nmfratioresults/acsrates/birthrates_marstat_age.xlsx",  replace

putexcel A1 = "Year"
putexcel B1 = "Marital status" 
putexcel C1 = "Group"
putexcel D1 = "Rate"
putexcel E1 = "SE"

local ages 1519 2024 2529 3034 3539 40+
local row = 2
forvalues year = 2001/2022{
	forvalues marstat = 0/1 {
		forvalues agecat = 1/6 {
			svy, subpop(if womanage1544 == 1 & agecat6 == `agecat' & married == `marstat' & YEAR == `year'): mean baby
			matrix m`agecat' = e(b)
			matrix V`agecat' = e(V)
			matrix list V`agecat'
			svmat V`agecat' 
			local se`agecat' = sqrt(V`agecat'1)
			putexcel D`row' = matrix(m`agecat')
			putexcel E`row' = `se`agecat'' 
		
			putexcel A`row' = "`year'"
			putexcel B`row' = "`marstat'"
			local age: word `agecat' of `ages'
			putexcel C`row' = "`age'"
			
			local row = `row' + 1
			drop V?1
		}
	}
}

*/

****************************
** Estimates by education ** 
****************************

// Ages 15-44
putexcel set "$nmfratioresults/acsrates/birthrates_marstat_educ.xlsx",  replace

putexcel A1 = "Year"
putexcel B1 = "Marital status" 
putexcel C1 = "Group"
putexcel D1 = "Rate"
putexcel E1 = "SE"

local educs HSorless somecollege BA
local row = 2
forvalues year = 2000/2023{
	forvalues marstat = 0/1 {
		forvalues educat = 1/3 {
			svy, subpop(if womanage1544 == 1 & educat == `educat' & married == `marstat' & YEAR == `year'): mean baby
			matrix m`educat' = e(b)
			matrix V`educat' = e(V)
			matrix list V`educat'
			svmat V`educat' 
			local se`educat' = sqrt(V`educat'1)
			putexcel D`row' = matrix(m`educat')
			putexcel E`row' = `se`educat'' 
		
			putexcel A`row' = "`year'"
			putexcel B`row' = "`marstat'"
			local educ: word `educat' of `educs'
			putexcel C`row' = "`educ'"
			
			local row = `row' + 1
			drop V?1
		}
	}
}


// ages 19-44
putexcel set "$nmfratioresults/acsrates/birthrates_marstat_educ_1944.xlsx",  replace

putexcel A1 = "Year"
putexcel B1 = "Marital status" 
putexcel C1 = "Group"
putexcel D1 = "Rate"
putexcel E1 = "SE"

local educs HSorless somecollege BA
local row = 2
forvalues year = 2000/2023{
	forvalues marstat = 0/1 {
		forvalues educat = 1/3 {
			svy, subpop(if womanage1944 == 1 & educat == `educat' & married == `marstat' & YEAR == `year'): mean baby
			matrix m`educat' = e(b)
			matrix V`educat' = e(V)
			matrix list V`educat'
			svmat V`educat' 
			local se`educat' = sqrt(V`educat'1)
			putexcel D`row' = matrix(m`educat')
			putexcel E`row' = `se`educat'' 
		
			putexcel A`row' = "`year'"
			putexcel B`row' = "`marstat'"
			local educ: word `educat' of `educs'
			putexcel C`row' = "`educ'"
			
			local row = `row' + 1
			drop V?1
		}
	}
}


// ALTERNATIVE MARITAL STATUS
// Only available 2008 forward.

// Ages 15-44
putexcel set "$nmfratioresults/acsrates/birthrates_marstatALT_educ.xlsx",  replace

putexcel A1 = "Year"
putexcel B1 = "Marital status" 
putexcel C1 = "Group"
putexcel D1 = "Rate"
putexcel E1 = "SE"

local educs HSorless somecollege BA
local row = 2
forvalues year = 2008/2023{
	forvalues marstat = 0/1 {
		forvalues educat = 1/3 {
			svy, subpop(if womanage1544 == 1 & educat == `educat' & married1yrago == `marstat' & YEAR == `year'): mean baby
			matrix m`educat' = e(b)
			matrix V`educat' = e(V)
			matrix list V`educat'
			svmat V`educat' 
			local se`educat' = sqrt(V`educat'1)
			putexcel D`row' = matrix(m`educat')
			putexcel E`row' = `se`educat'' 
		
			putexcel A`row' = "`year'"
			putexcel B`row' = "`marstat'"
			local educ: word `educat' of `educs'
			putexcel C`row' = "`educ'"
			
			local row = `row' + 1
			drop V?1
		}
	}
}
