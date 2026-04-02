// acs_birthrateratios.do

// use data export form acs_rates.do
// 0) estimate birht rates over time in ACS
// to compare marital and nonmarital fertility rates over time 
// 1) overall
// 2) by age
// 3) by education
// 4) by race/ethnicity


import excel "$nmfratioresults/acsrates/birthrates.xlsx", firstrow clear
rename *, lower
destring year, replace

replace rate = rate * 1000
twoway (line rate year, lwidth(medthick) lcolor(black)) 

****************
** 1) Overall **
****************

import excel "$nmfratioresults/acsrates/birthrates_marstatALT_1544.xlsx", firstrow clear
rename *, lower
destring year, replace
destring maritalstatus, replace

replace rate = rate * 1000
replace se = se * 1000


reshape wide rate se, i(year) j(maritalstatus)

twoway (line rate0 year, lwidth(medthick) lcolor(black)) ///
	   (line rate1 year, lwidth(medthick) lcolor(gray)) 
	   
gen mbrr = rate1/rate0
twoway (line mbrr year, lwidth(medthick) lcolor(black))


	   

****************
** 3) By educ **
****************

import excel "$nmfratioresults/acsrates/birthrates_marstatALT_educ.xlsx", firstrow clear
rename *, lower
destring year, replace
destring maritalstatus, replace
keep if year >= 2008 // & year < 2020

gen educ = 1 if group == "HSorless"
replace educ = 2 if group == "somecollege" 
replace educ = 3 if group == "BA"
label define educ 1 "HS or less" 2 "Some college" 3 "BA+"
label values educ educ

replace rate = rate * 1000
replace se = se * 1000
	   
// Group-specific trajectory
local educs HS somecollege BA
forvalues e = 1/3 {
	local educ: word `e' of `educs'
	twoway (line rate year if educ == `e' & maritalstatus == 0,  lcolor(black)) ///
		   (line rate year if educ == `e' & maritalstatus == 1,  lcolor(purple)), ///
		   legend(order(1 "Unmarried" 2 "Married")) ///
		   title("Marital and nonmarital fertility rate 2001-2022, educ `educ'")
	   graph export "$nmfratioresults/prints/marital_nonmarital_rates_altmarst_educ`e'.png", replace 
}

// all on one graph
twoway (line rate year if educ == 1 & maritalstatus == 0,  lcolor(black)) /// 
	   (line rate year if educ == 1 & maritalstatus == 1,  lcolor(purple))  ///
	   (line rate year if educ == 2 & maritalstatus == 0,  lcolor(black) lpattern(dash)) ///
	   (line rate year if educ == 2 & maritalstatus == 1,  lcolor(purple) lpattern(dash)) ///
	   (line rate year if educ == 3 & maritalstatus == 0,  lcolor(black) lpattern(dash_dot)) ///
	   (line rate year if educ == 3 & maritalstatus == 1,  lcolor(purple) lpattern(dash_dot)), ///
	   legend(order(1 "Unmarried" 2 "Married")) ///
	   title("Marital and nonmarital fertility rate 2003-2022, by educ") ///
	   legend(order(1 "Unmarried, HS" 2 "Married, HS" 3 "Unmarried, some college" 4 "Married, some college" 5 "Unmarried, BA+" 6 "Married, BA+")) plotregion(style(none))
	   
   graph export "$nmfratioresults/prints/marital_nonmarital_rates_altmarst_alleducs.png", replace 


// MBRR for all groups
bysort year maritalstatus group: gen maritalbr = rate    if maritalstatus == 1
bysort year group: ereplace maritalbr = max(maritalbr)
bysort year maritalstatus group: gen nonmaritalbr = rate if maritalstatus == 0
bysort year group: ereplace nonmaritalbr = max(nonmaritalbr)
egen tag = tag(year group)
keep if tag == 1
drop maritalstatus rate

gen mbrr = maritalbr/nonmaritalbr

keep if year >= 2008

twoway (line mbrr year if educ == 1, lwidth(medthick) lcolor("102 194 165") lpattern(solid)) ///
	   (line mbrr year if educ == 2, lwidth(medthick) lcolor("252 141 98") lpattern(shortdash)) ///
	   (line mbrr year if educ == 3, lwidth(medthick) lcolor("141 160 203") lpattern(longdash)), ///
	   legend(order(1 "HS or less" 2 "Some college" 3 "BA+")) ///
	   ytitle("Marital birth rate ratio") legend(cols(3))  ///
	   xlabel(,labsize(3)) xlabel(2008(2)2023) plotregion(style(none))
graph export "$nmfratioresults/prints/MBRR by educ alt marriage.png", replace 

