// dataprep_cdc.do

** 1) Basic data
// First, just read in and clean up basic data I've coellated
// # of births total
// # of births unmarried
// ratio of nonmarital births (# unmarried/total)



import excel using "$cdcraw/Vital Stats NMFR Components - from reports.xlsx", clear firstrow
rename totalbirths birthstotal
rename nmbirths birthsunmarried
rename nmfr nmfratio

gen birthsmarried = birthstotal - birthsunmarried

// rename all variables so it's clear that they come from vital stats
rename * *VS
// except name year back!
rename yearVS year

gen group = "Total"

save "$nmfratiokeep/totalbirthsbyyear_fromNVSR.dta", replace


/* Commenting out age analysis

** 2) Data by demographic subgroup - marital status and age

// Data on the number of births by demographic subgroup come from the CDC 
// Wonder database: https://wonder.cdc.gov/natality.html

// Query: group results by YEAR, marital status, age

// I downloaded two sets of files -- one covering 2003-2006, the next covering 2007-2022

** 2003 -2006
import delimited using "$cdcraw/Natality, 2003-2006.txt", clear
// notes in the spreadsheet; delete
drop in 165/186

// drop totals
drop if notes == "Total"

// marital status
// there is a "unknown or not stated" group, which seems to have 0 births; 
// confirm and drop
count if births != 0 & maritalstatus == "Unknown or Not Stated"
drop if maritalstatus == "Unknown or Not Stated"
// there's also a "not reported" category, which is, doesn't contain any births
count if births != 0 & maritalstatus == "Not Reported"
drop if maritalstatus == "Not Reported"

gen marstat = .
replace marstat = 1 if maritalstatus == "Married"
replace marstat = 2 if maritalstatus == "Unmarried"
label define marstat 1 "Married" 2 "Unmarried"
label values marstat marstat

gen agecat9 = .
replace agecat9 = 1 if ageofmother9code == "15"
replace agecat9 = 2 if ageofmother9code == "15-19"
replace agecat9 = 3 if ageofmother9code == "20-24"
replace agecat9 = 4 if ageofmother9code == "25-29"
replace agecat9 = 5 if ageofmother9code == "30-34"
replace agecat9 = 6 if ageofmother9code == "35-39"
replace agecat9 = 7 if ageofmother9code == "40-44"
replace agecat9 = 8 if ageofmother9code == "45-49"
replace agecat9 = 9 if ageofmother9code == "50+"

label define agecat9 1 "<15" 2 "15-19" 3 "20-24" 4 "25-29" 5 "30-34" 6 "35-39" ///
					 7 "40-44" 8 "45-49" 9 "50+"
label values agecat9 agecat9

keep year births marstat agecat9
destring births, replace

save "$nmfratiotmp/births0306_agemarstat.dta", replace



** 2007 - 2022 data
import delimited using "$cdcraw/Natality, 2007-2022.txt", clear

// notes in the spreadsheet; delete
drop in 577/606 

// marital status
// there is a "unknown or not stated" group, which seems to have 0 births; 
// confirm and drop
count if births != "0" & maritalstatus == "Unknown or Not Stated"
drop if maritalstatus == "Unknown or Not Stated"
// there's also a "not reported" category, which is, I think coming from
// california starting in 2017.
tab year if maritalstatus == "Not Reported" & births != "0"
// FLAG FOR FOLLOW-UP: figure out what to do with these births!!!!
// I'll keep them in the file for now.

gen marstat = .
replace marstat = 1 if maritalstatus == "Married"
replace marstat = 2 if maritalstatus == "Unmarried"
label define marstat 1 "Married" 2 "Unmarried"
label values marstat marstat

gen agecat9 = .
replace agecat9 = 1 if ageofmother9code == "15"
replace agecat9 = 2 if ageofmother9code == "15-19"
replace agecat9 = 3 if ageofmother9code == "20-24"
replace agecat9 = 4 if ageofmother9code == "25-29"
replace agecat9 = 5 if ageofmother9code == "30-34"
replace agecat9 = 6 if ageofmother9code == "35-39"
replace agecat9 = 7 if ageofmother9code == "40-44"
replace agecat9 = 8 if ageofmother9code == "45-49"
replace agecat9 = 9 if ageofmother9code == "50+"

label define agecat9 1 "<15" 2 "15-19" 3 "20-24" 4 "25-29" 5 "30-34" 6 "35-39" ///
					 7 "40-44" 8 "45-49" 9 "50+"
label values agecat9 agecat9

keep year births marstat agecat9

// births for folks under 15 who are married are suppressed; make them missing 
// so that I can destring
replace births = "" if births == "Suppressed"
destring births, replace

save "$nmfratiotmp/births0722_agemarstat.dta", replace


** Append the files so that there is one, long file spanning 03-22
use "$nmfratiotmp/births0306_agemarstat.dta", clear
append using "$nmfratiotmp/births0722_agemarstat.dta"

save "$nmfratiokeep/births0322_agemarstat.dta", replace

*/
