// F1nmfratio.do

// Plot the nonmarital fertilty ratio - i.e., the prop of all births that were
// to the unmarried - over time


// change to location of CDCbirthrates.txt from github
import delimited "ACSmarriageandfert/CDCbirthrates.txt", clear 

// NOTE: as of 3/2021, CDC has not published final 2022 birth data.
// These data should be released on APRIL 4, which will allow this chart to go
// through 2022.
// https://www.cdc.gov/nchs/pressroom/calendar/2024_Schedule.htm

twoway (line nmfratioVS year, lwidth(medthick) lcolor(black)), ///
	   	xlabel(,labsize(3)) xlabel(1960(5)2020) xtitle("Year") plotregion(style(none)) ///
		title("Figure 2.1 Nonmarital fertility ratio in the US, 1960-2023", size(medium) margin(b=5)) ///
			ytitle("Percent of all births to unmarried women")
graph export "$nmfratioresults/prints/F1nmfratio.png", replace 	
		
// edited per JT for Demography
twoway (line nmfratioVS year, lwidth(medthick) lcolor(black)), ///
	   	xlabel(,labsize(3)) xlabel(1960(5)2020) xtitle("Year") plotregion(style(none)) ///
		ylabel(,angle(0)) ///
		ytitle("{bf:Non-marital Fertility Ratio (NMFR)}") ///
		xtitle("{bf:Year}")
graph export "$nmfratioresults/prints/F1nmfratio_fordemog.pdf", replace 



