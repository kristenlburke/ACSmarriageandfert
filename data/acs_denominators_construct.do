*// acs_denominators

// use ACS population data to generate denominators which will be used to calculate
// birth rates
// These are the population counts for each population sub-group that I might
// like to estimate a marital/nomarital birth rate or NMBR MBRR for.

// We'll exclude everyone who was living in group quarters (excludegq != 0) because
// group quarters are not -- NOT - changed mind on this. want to maximize sample
// during primary anaysis years (2009 and later) not at the expense of early years.

// What do i want this data set to look like?
// one row per year, which contains:
// total female population
// total female population age 15-44
// total female population x age group
// total female popualtion married/unmarried
// total female population married x age group



// This section runs tabs and extracts the subpopulation count i.e. the
// real population size that each subpop is meant to represent
forvalues year = 2000/2023 {
	use "$nmfratiokeep/acs_0023recoded.dta", clear
	keep if YEAR == `year'
	svyset CLUSTER [pweight=PERWT], strata(STRATA)
	
	// total population
	svy: tab SEX
	gen poptotal = e(total)

	// total female population
	svy, subpop(if SEX == 2): tab SEX
	gen popfem = e(total) 
	
	// total female pop between 15-44
	svy, subpop(if SEX == 2 & (AGE >= 15 & AGE <= 44)): tab SEX
	gen popfem1544 = e(total) 
	
	svy, subpop(if SEX == 2 & (AGE >= 19 & AGE <= 44)): tab SEX
	gen popfem1944 = e(total) 

	
	// total fem pop over 15
	svy, subpop(if SEX == 2 & AGE >= 15): tab SEX
	gen popfem15over = e(total) 
	
	/* Commenting out age groups
	// total female population by age group
	forvalues i = 1/9 {
		svy, subpop(if SEX == 2 & agecat9 == `i'): tab SEX
		gen popfemage`i' = e(total) 
	}
	*/

	// total female population married (spouse absent or present)
	svy, subpop(if SEX == 2 & (MARST == 1 | MARST == 2)): tab SEX
	gen popfemmarried = e(total) 
	
	// total fem pop over 15 who is married
	svy, subpop(if SEX == 2 & (MARST == 1 | MARST == 2)): tab SEX
	gen popfem15overmar = e(total) 

	// total female population married (spouse absent or present) age 15-44
	svy, subpop(if SEX == 2 & (MARST == 1 | MARST == 2) & (AGE >= 15 & AGE <= 44)): tab SEX
	gen popfem1544married = e(total) 
	
	// total female population married (spouse absent or present) age 19-44
	svy, subpop(if SEX == 2 & (MARST == 1 | MARST == 2) & (AGE >= 15 & AGE <= 44)): tab SEX
	gen popfem1944married = e(total) 


	// total female population unmarried (separated, divorced, widowed, single)
	svy, subpop(if SEX == 2 & (MARST >= 3 & MARST <= 6)): tab SEX
	gen popfemunmarried = e(total) 

	// total female population unmarried 15-44 (separated, divorced, widowed, single)
	svy, subpop(if SEX == 2 & (MARST >= 3 & MARST <= 6) & (AGE >= 15 & AGE <= 44)): tab SEX
	gen popfem1544unmarried = e(total) 
	
	// total female population unmarried 19-44 (separated, divorced, widowed, single)
	svy, subpop(if SEX == 2 & (MARST >= 3 & MARST <= 6) & (AGE >= 19 & AGE <= 44)): tab SEX
	gen popfem1944unmarried = e(total) 
	

	// By EDUC - overall & marital status
	forvalues educ = 1/3 {
		// pop fem 1544
		svy, subpop(if SEX == 2 & (AGE >= 15 & AGE <= 44) & educat == `educ'): tab SEX
		gen popfem1544educ`educ' = e(total) 
		
		// pop fem 1544 married
		svy, subpop(if SEX == 2 & (MARST == 1 | MARST == 2) & (AGE >= 15 & AGE <= 44) & educat == `educ'): tab SEX
		gen popfem1544marriededuc`educ' = e(total) 
		
		// pop fem 1944
		svy, subpop(if SEX == 2 & (AGE >= 19 & AGE <= 44) & educat == `educ'): tab SEX
		gen popfem1944educ`educ' = e(total) 
		
		// pop fem 1944 married
		svy, subpop(if SEX == 2 & (MARST == 1 | MARST == 2) & (AGE >= 19 & AGE <= 44) & educat == `educ'): tab SEX
		gen popfem1944marriededuc`educ' = e(total) 
	} 
	
	
	
	// ALT MARRIAGE SPEC
	// For years 2008 forward, calculate alternative denominator for those who were married
	// one year ago (i.e. ruling out marriages in response to pregnancy)
	
	if YEAR >= 2008 {
		
		** Overall
		
		// total female population married 1yr ago ages 15-44
		svy, subpop(if SEX == 2  & (married1yrago == 1) & (AGE >= 15 & AGE <= 44)): tab SEX
		gen popfem1544marALT = e(total) 
	
		// total female population married 1yr ago ages 19-44
		svy, subpop(if SEX == 2 & (married1yrago == 1) & (AGE >= 19 & AGE <= 44)): tab SEX
		gen popfem1944marALT = e(total) 
	
	
		// total female population unmarried 1yr ago ages 15-44
		svy, subpop(if SEX == 2 & (married1yrago == 0) & (AGE >= 15 & AGE <= 44)): tab SEX
		gen popfem1544unmarALT = e(total) 
	
		// total female population unmarried 1yr ago ages 19-44
		svy, subpop(if SEX == 2 & (married1yrago == 0) & (AGE >= 19 & AGE <= 44)): tab SEX
		gen popfem1944unmarALT = e(total) 
		
		
		** BY EDUC
		forvalues educ = 1/3 {
		
			// total female population married 1yr ago ages 15-44
			svy, subpop(if SEX == 2 & (married1yrago == 1) & (AGE >= 15 & AGE <= 44) & educat == `educ'): tab SEX
			gen popfem1544marALTeduc`educ' = e(total) 
		
			// total female population married 1yr ago ages 19-44
			svy, subpop(if SEX == 2 & (married1yrago == 1) & (AGE >= 19 & AGE <= 44) & educat == `educ'): tab SEX
			gen popfem1944marALTeduc`educ' = e(total) 
		
		
			// total female population unmarried 1yr ago ages 15-44
			svy, subpop(if SEX == 2 & (married1yrago == 0) & (AGE >= 15 & AGE <= 44) & educat == `educ'): tab SEX
			gen popfem1544unmarALTeduc`educ' = e(total) 
		
			// total female population unmarried 1yr ago ages 19-44
			svy, subpop(if SEX == 2 & (married1yrago == 0) & (AGE >= 19 & AGE <= 44)): tab SEX
			gen popfem1944unmarALTeduc`educ' = e(total) 
		}
	
	
		
	}
 
 
	// Currently there is one observation per person contributing to the ACS
	// We've used their data to generate summary stats about the population in 
	// each year. We'll keep those summary stats and one copy of them per year
	// and discard the rest
	keep YEAR pop*
	keep in 1
	
	// Initiate and save as a tempfile
	tempfile pop`year'
	save `pop`year''
	
}

// Append each of the years' tempfiles
use `pop2000', clear
forvalues year = 2001/2023 {
	append using `pop`year''
}

// Generate proportion statistics from estimates.
gen propfem = popfem/poptotal

gen propfemmarried = popfemmarried/popfem
gen propfemunmarried = popfemunmarried/popfem

gen propfemmarried1544 = popfem1544married/popfem1544
gen propfemunmarried1544 = popfem1544unmarried/popfem1544

gen propfemmarried1944 = popfem1944married/popfem1944
gen propfemunmarried1944 = popfem1944unmarried/popfem1944

gen propfemmarALT1544 = popfem1544marALT/popfem1544
gen propfemunmarALT1544 = popfem1544unmarALT/popfem1544

gen propfemmarALT1944 = popfem1944marALT/popfem1944
gen propfemunmarALT1944 = popfem1944unmarALT/popfem1944

// Educational attainment
forvalues educ = 1/3  {
	gen propfemmarried1544educ`educ'= popfem1544marriededuc`educ'/popfem1544educ`educ' 
	gen propfemmarried1944educ`educ'= popfem1944marriededuc`educ'/popfem1944educ`educ' 
	
	gen propfemmarALT1544educ`educ' = popfem1544marALTeduc`educ'/popfem1544educ`educ'
	gen propfemmarALT1944educ`educ' = popfem1944marALTeduc`educ'/popfem1944educ`educ'
}

/* Commenting out age groups
// age group 
forvalues i = 2/9 {
	gen propfemage`i' = popfemage`i'/popfem
	
	gen propfemage`i'_1544 = popfemage`i'/popfem1544
	
	gen propfemage`i'_married = popfemmarriedage`i'/popfemage`i'
	
	gen propfemage`i'_unmarried = popfemunmarriedage`i'/popfemage`i'
}
*/

rename YEAR year
// save data in a wide format -- this file has all of the possible denominators
save "$nmfratiokeep/acs_denominatorswide0023.dta", replace
