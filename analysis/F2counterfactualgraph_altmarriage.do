// We'll use the ACS rates to estimate counterfactual scenarios
// Note: i was previously using vital stats rates but I don't think
// that's appropriate -- I'm dropping vital stats in analysis after
// proving that ACS is good enough to answer this question.

// What data do I need?
// Rates by marital status by year (and later by educ if I want to stratify)
// Proportion married by year

import excel "$nmfratioresults/acsrates/birthrates_marstatALT_1544.xlsx", firstrow clear
destring Year, replace
keep if Year >= 2003
rename Year year
sort Maritalstatus year

// consolidate data so that there's one row per year with both marital and nonmarital birth rate
gen rate = Rate * 1000 
gen maritalbr = rate if Maritalstatus == "1"
gen nonmaritalbr = rate if Maritalstatus == "0"
bysort year: ereplace maritalbr = max(maritalbr)
bysort year: ereplace nonmaritalbr = max(nonmaritalbr)
egen tag = tag(year)
keep if tag == 1
drop tag Maritalstatus Group Rate rate SE


// merge in data to pull out prop of poulation married - keep only the data
// we'll use
merge 1:1 year using "$nmfratiokeep/birthfile_total_acscdcmerged.dta"
keep year maritalbr nonmaritalbr propfemmarALT1544

gen constantpop = 1000000 // it doesn't matter what this is for calculating the ratios

// generate a nmfratio - this will match T1
gen nmfratio = (((1-propfemmarALT1544)*nonmaritalbr*constantpop)/(((1-propfemmarALT1544)*nonmaritalbr*constantpop)+((propfemmarALT1544)*maritalbr*constantpop))*100)

// Generate counterfactual rates compared to 2009
keep if year >= 2009 // & year < 2020
gen maritalfert09 = maritalbr if year == 2009
ereplace maritalfert09 = max(maritalfert09)

gen nmaritalfert09 = nonmaritalbr if year == 2009
ereplace nmaritalfert09 = max(nmaritalfert09)

gen propmarried09 = propfemmarALT1544 if year == 2009
ereplace propmarried09 = max(propmarried09)


// If everything stayed the same except....
// PROP MARRIED
gen propmarriedconstant_counter = (((1-propfemmarALT1544)*nmaritalfert09*constantpop)/(((1-propfemmarALT1544)*nmaritalfert09*constantpop)+((propfemmarALT1544)*maritalfert09*constantpop))*100)

/* this was a check to make sure my one-line code was working right -- it is.
gen propmarriedvaries_mbirths = (maritalfert09/1000)*(propfemmarried1544*constantpop)
gen propmarriedvaries_nmbirhts = (nmaritalfert09/1000)*((1-propfemmarried1544)*constantpop)
gen propmarriedvaries_nnmfr = ((propmarriedvaries_nmbirhts)/(propmarriedvaries_nmbirhts+propmarriedvaries_mbirths)*100)
*/

// MARITAL FERTILITY RATE
gen marfertrateconstant_counter = (((1-propmarried09)*nmaritalfert09*constantpop)/(((1-propmarried09)*nmaritalfert09*constantpop)+((propmarried09)*maritalbr*constantpop))*100) 

/* this was a check to make sure my one-line code was working right -- it is.
gen marriedvaries_mbirths = (maritalbr/1000)*(propmarried09*constantpop)
gen marriedvaries_nmbirhts = (nmaritalfert09/1000)*((1-propmarried09)*constantpop)
gen marriedvaries_nnmfr = ((marriedvaries_nmbirhts)/(marriedvaries_nmbirhts+marriedvaries_mbirths)*100)
*/

// NONMARITAL FERTILITY RATE
gen nonmarfertrateconstant_counter = (((1-propmarried09)*nonmaritalbr*constantpop)/(((1-propmarried09)*nonmaritalbr*constantpop)+((propmarried09)*maritalfert09*constantpop))*100) 

/* this was a check to make sure my one-line code was working right -- it is.
gen nmfvaries_mbirths  = (maritalfert09/1000)*(propmarried09*constantpop)
gen nmfvaries_nmbirhts = (nonmaritalbr/1000)*((1-propmarried09)*constantpop)
gen nmfvaries_nnmfr    = ((nmfvaries_nmbirhts)/(nmfvaries_nmbirhts+nmfvaries_mbirths)*100)
*/

twoway (scatter nmfratio year, msymbol(O) mcolor(black)) ///
	   (line 	nmfratio year, msymbol(O) lcolor(black)) ///
	   (scatter propmarriedconstant_counter year, msymbol(S) mcolor("166 206 227")) ///
	   (line 	propmarriedconstant_counter year, msymbol(S) lpattern(dash) lcolor("166 206 227")) ///
	   (scatter marfertrateconstant_counter year, msymbol(D) mcolor("31 120 180")) ///
	   (line 	marfertrateconstant_counter year, msymbol(D) lpattern(dash) lcolor("31 120 180")) ///
	   (scatter nonmarfertrateconstant_counter year, msymbol(T) mcolor("178 223 138")) ///
	   (line 	nonmarfertrateconstant_counter year, msymbol(T) lpattern(dash) lcolor("178 223 138")), ///
			title("Figure 2.2 Nonmarital fertility ratio, as observed and" "counterfactuals standardized to 2009 save for listed component of change", size(medium)) ///
			xlabel(,labsize(3)) xlabel(2009(2)2023) plotregion(style(none))	///
			legend( order(1 "As observed" 3 "Proportion married" 5 "Marital birth rate" 7 "Nonmarital birth rate"))
graph export "$nmfratioresults/prints/counterfactual_overall_altmar.png", replace 

// no title
twoway (scatter nmfratio year, msymbol(O) mcolor(black)) ///
	   (line 	nmfratio year, msymbol(O) lcolor(black)) ///
	   (scatter propmarriedconstant_counter year, msymbol(S) mcolor("166 206 227")) ///
	   (line 	propmarriedconstant_counter year, msymbol(S) lpattern(dash) lcolor("166 206 227")) ///
	   (scatter marfertrateconstant_counter year, msymbol(D) mcolor("31 120 180")) ///
	   (line 	marfertrateconstant_counter year, msymbol(D) lpattern(dash) lcolor("31 120 180")) ///
	   (scatter nonmarfertrateconstant_counter year, msymbol(T) mcolor("178 223 138")) ///
	   (line 	nonmarfertrateconstant_counter year, msymbol(T) lpattern(dash) lcolor("178 223 138")), ///
			xlabel(,labsize(3)) xlabel(2009(2)2023) plotregion(style(none))	///
			legend( order(1 "As observed" 3 "Proportion married" 5 "Marital birth rate" 7 "Nonmarital birth rate"))
graph export "$nmfratioresults/prints/counterfactual_overall_altmar_notitle.png", replace 
