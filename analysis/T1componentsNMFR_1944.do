// T1componentsNMFR_1944.do

// This is a descriptive table that includes
// Year (2003-2022)
// population ages 19-44 (from acs denominators)
// proportion of those who are married
// vital stats data: mbr, nmbr, nmfr
// acs estimates: mbr, nmbr, nmfr


** Set up table shell ** 

putexcel set "$nmfratioresults/T1componentsNMFR_1944.xlsx", replace

putexcel A1 = "Table 1. Components of nonmarital fertility ratio for women ages 19-44 in the United States, 2003-2022"
putexcel (D2:F2), merge hcenter
putexcel (G2:I2), merge hcenter

putexcel D2 = "Vital Statistics rates" G2 = "American Commmuntiy Survey rates"
putexcel A3 = "Year" B3 = "Population of women ages 19-44" C3 = "Proportion of women ages 19-44 married" ///
		 D3 = "Marital birth rate" E3 = "Nonmarital birth rate" F3 = "Nonmarital fertility ratio" ///
		 G3 = "Marital birth rate" H3 = "Nonmarital birth rate" I3 = "Nonmarital fertility ratio"

local i = 4
forvalues year = 2003/2022 {
	putexcel A`i' = "`year'"
	local i = `i' + 1
}

putexcel A24 = "Note: Population and proportion married estimates for each year come from the American Community Survey"

** Pull out statistics and place in table **

// Population counts from ACS denominator file
use "$nmfratiokeep/acs_denominatorswide.dta", clear

// pop female in age range
list popfem1944
mkmat popfem1944, matrix(popfem)
putexcel B4 = matrix(popfem), nformat(##,###,###)

// proportion married in age range
list propfemmarried1944
mkmat propfemmarried1944, matrix(propmarried)
putexcel C4 = matrix(propmarried), nformat(0.00)

// Vital stats rates computed using birth counts from vital stats + ACS denominators
use "$nmfratiokeep/birthfile_total_acscdcmerged.dta", clear
keep if year >= 2003

list maritalfertrate1944
mkmat maritalfertrate1944, matrix(mfr)
putexcel D4 = matrix(mfr), nformat(00.0)

list nonmaritalfr1944
mkmat nonmaritalfr1944, matrix(nmfrate)
putexcel E4 = matrix(nmfrate), nformat(00.0)

list nmfratio
mkmat nmfratio, matrix(nmfratio)
putexcel F4 = matrix(nmfratio), nformat(00.0)

// ACS rates computed and saved in excel
import excel "$nmfratioresults/acsrates/birthrates_marstat_1944.xlsx", firstrow clear
destring Year, replace
keep if Year >= 2003
sort Maritalstatus Year 

// convert rate to standard terms
gen Rateper1000 = Rate * 1000

mkmat Rateper1000 if Maritalstatus == "1", matrix (mfr)
putexcel G4 = matrix(mfr), nformat(00.0)

mkmat Rateper1000 if Maritalstatus == "0", matrix(nmfrate)
putexcel H4 = matrix(nmfrate), nformat(00.0)

// Compute NMFR by merging ACS rates to ACS denominators
rename Year year
merge m:1 year using "$nmfratiokeep/acs_denominatorswide.dta"

gen nonmaritalbirths = Rate * popfem1944unmarried if Maritalstatus == "0"
gen maritalbirths = Rate * popfem1944married if Maritalstatus == "1"

bysort year: ereplace nonmaritalbirths = max(nonmaritalbirths)
bysort year: ereplace maritalbirths = max(maritalbirths)

egen tag = tag(year)
keep if tag == 1

gen nmfr = (nonmaritalbirths/(nonmaritalbirths+maritalbirths))*100
list year nmfr
mkmat nmfr, matrix(nmfratioacs)
putexcel I4 = matrix(nmfratioacs), nformat(00.0)

