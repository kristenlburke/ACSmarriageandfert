use "$nmfratiokeep/birthfile_total_acscdcmerged.dta", clear

drop group
gen constantpop = 1000000 // it doesn't matter what this is for calculating the ratios

// using rdecompose
preserve

rdecompose propfemmarried1544 maritalfertrate nonmaritalfr, ///
		   group(year) multi ///
		   func(((1-propfemmarried1544)*nonmaritalfr*constantpop)/(((1-propfemmarried1544)*nonmaritalfr*constantpop)+((propfemmarried1544)*maritalfertrate*constantpop))*100) 
restore

preserve
keep if year == 2003 | year == 2009 | year == 2017

rdecompose propfemmarried1544 maritalfertrate nonmaritalfr, ///
		   group(year) multi ///
		   func(((1-propfemmarried1544)*nonmaritalfr*constantpop)/(((1-propfemmarried1544)*nonmaritalfr*constantpop)+((propfemmarried1544)*maritalfertrate*constantpop))*100) 	
		   
drop if year == 2003		
rdecompose propfemmarried1544 maritalfertrate nonmaritalfr, ///
		   group(year)  ///
		   func(((1-propfemmarried1544)*nonmaritalfr*constantpop)/(((1-propfemmarried1544)*nonmaritalfr*constantpop)+((propfemmarried1544)*maritalfertrate*constantpop))*100) 
   
restore

preserve 
keep if year == 2008 | year == 2017

rdecompose propfemmarried1544 maritalfertrate nonmaritalfr, ///
		   group(year) ///
		   func(((1-propfemmarried1544)*nonmaritalfr*constantpop)/(((1-propfemmarried1544)*nonmaritalfr*constantpop)+((propfemmarried1544)*maritalfertrate*constantpop))*100) 

restore		   
		   
