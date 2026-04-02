// T2componentsNMFRbyeduc.do
// Similar to t1 but stratified

putexcel set "$nmfratioresults/T2componentsNMFRbyeduc_altmarr.xlsx", replace

putexcel A1 = "Table 2. Components of nonmarital fertility ratio by educational attainment 2008-2023 alt marriage, American Community Survey"
putexcel (B2:D2), merge hcenter
putexcel (E2:G2), merge hcenter
putexcel (H2:J2), merge hcenter

putexcel B2 = "High school or less" E2 = "Some college" H2 = "Bachelor's or greater"
putexcel A3 = "Year" B3 = "Population of women ages 15-44" C3 = "Marital birth rate" D3 = "Nonmarital birth rate" ///
		 E3 = "Population of women ages 15-44" F3 = "Marital birth rate" G3 = "Nonmarital birth rate" ///
		 H3 = "Population of women ages 15-44" I3 = "Marital birth rate" J3 = "Nonmarital birth rate"

local i = 4
forvalues year = 2008/2023 {
	putexcel A`i' = "`year'"
	local i = `i' + 1
}


** Pull out estimates and place them in table

// Proportion of population married by educational status
use "$nmfratiokeep/acs_denominatorswide0023.dta", clear

keep if year >= 2008

local i = 1
foreach col in B E H {
	list propfemmarried1544educ`i'
	mkmat propfemmarried1544educ`i', matrix(propmar)
	putexcel `col'4 = matrix(propmar), nformat(0.00)
	
	local i = `i' + 1
}


// Marital and non-marital birth rate
import excel "$nmfratioresults/acsrates/birthrates_marstatALT_educ.xlsx", firstrow clear

destring Year, replace
destring Maritalstatus, replace
keep if Year >= 2008
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

// Graph of NMFR by educational status
import excel "$nmfratioresults/acsrates/birthrates_marstatALT_educ.xlsx", firstrow clear
destring Year, replace
destring Maritalstatus, replace
rename *, lower

foreach group in HSorless somecollege BA {
	gen `group'_mbr = rate  if maritalstatus == 1 & group == "`group'"
	bysort year: ereplace `group'_mbr = max(`group'_mbr)
	gen `group'_nmbr = rate if maritalstatus == 0 & group == "`group'" 
	bysort year: ereplace `group'_nmbr = max(`group'_nmbr)
}

egen tag = tag(year)
keep if tag == 1
drop tag


merge m:1 year using "$nmfratiokeep/acs_denominatorswide0023.dta"
drop if _merge != 3

// Gen NMFR by education
// NMFR = (nmfr * prop unmarried) / (nmfr * prop unmarried) + (mfr * prop married)

gen hs_nmfr = (HSorless_nmbr * (1- propfemmarried1544educ1)) / ((HSorless_nmbr * (1- propfemmarried1544educ1)) + (HSorless_mbr * (propfemmarried1544educ1))) * 100
gen sc_nmfr = (somecollege_nmbr * (1- propfemmarried1544educ2)) / ((somecollege_nmbr * (1- propfemmarried1544educ2)) + (somecollege_mbr * (propfemmarried1544educ2))) * 100
gen ba_nmfr = (BA_nmbr * (1- propfemmarried1544educ3)) / ((BA_nmbr * (1- propfemmarried1544educ3)) + (BA_mbr * (propfemmarried1544educ3))) * 100
