// T2componentsNMFRbyeduc_1944.do
// Similar to t1 but stratified

putexcel set "$nmfratioresults/T2componentsNMFRbyeduc_1944.xlsx", replace

putexcel A1 = "Table 2. Components of nonmarital fertility ratio by educational attainment 2003-2022, American Community Survey"
putexcel (B2:D2), merge hcenter
putexcel (E2:G2), merge hcenter
putexcel (H2:J2), merge hcenter

putexcel B2 = "High school or less" E2 = "Some college" H2 = "Bachelor's or greater"
putexcel A3 = "Year" B3 = "Population of women ages 19-44" C3 = "Marital birth rate" D3 = "Nonmarital birth rate" ///
		 E3 = "Population of women ages 19-44" F3 = "Marital birth rate" G3 = "Nonmarital birth rate" ///
		 H3 = "Population of women ages 19-44" I3 = "Marital birth rate" J3 = "Nonmarital birth rate"

local i = 4
forvalues year = 2003/2023 {
	putexcel A`i' = "`year'"
	local i = `i' + 1
}


** Pull out estimates and place them in table

// Proportion of population married by educational status
use "$nmfratiokeep/acs_denominatorswide.dta", clear

local i = 1
foreach col in B E H {
	list propfemmarried1944educ`i'
	mkmat propfemmarried1944educ`i', matrix(propmar)
	putexcel `col'4 = matrix(propmar), nformat(0.00)
	
	local i = `i' + 1
}


// Marital and non-marital birth rate
import excel "$nmfratioresults/acsrates/birthrates_marstat_educ_1944.xlsx", firstrow clear

destring Year, replace
destring Maritalstatus, replace
keep if Year >= 2003
sort Group Maritalstatus Year 

// convert rate to standard terms
gen Rateper1000 = Rate * 1000


local cols1 C F I
local cols2 D G J
local groups HSorless somecollege BA
forvalues i = 1/3 {
	local col1:  word `i' of `cols1'
	local col2:  word `i' of `cols2'
	local group: word `i' of `groups'
	
	mkmat Rateper1000 if Maritalstatus == 1 & Group == "`group'", matrix (fr)
	putexcel `col1'4 = matrix(fr), nformat(00.0)
	
	mkmat Rateper1000 if Maritalstatus == 0 & Group == "`group'", matrix (fr)
	putexcel `col2'4 = matrix(fr), nformat(00.0)
	
}
