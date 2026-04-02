// acs_recodes.do

use "$nmfratiokeep/acs_0023.dta", clear

** Age
// generate age groups to align with vital stats data
gen agecat9 = .
replace agecat9 = 1 if AGE < 15
replace agecat9 = 2 if AGE >= 15 & AGE < 20
replace agecat9 = 3 if AGE >= 20 & AGE < 25
replace agecat9 = 4 if AGE >= 25 & AGE < 30
replace agecat9 = 5 if AGE >= 30 & AGE < 35
replace agecat9 = 6 if AGE >= 35 & AGE < 40
replace agecat9 = 7 if AGE >= 40 & AGE < 45
replace agecat9 = 8 if AGE >= 45 & AGE < 50
replace agecat9 = 9 if AGE >= 50 & AGE < .

label define agecat9 1 "<15" 2 "15-19" 3 "20-24" 4 "25-29" 5 "30-34" 6 "35-39" ///
					 7 "40-44" 8 "45-49" 9 "50+"
label values agecat9 agecat9


gen agecat6 = .
replace agecat6 = 1 if AGE >= 15 & AGE < 20
replace agecat6 = 2 if AGE >= 20 & AGE < 25
replace agecat6 = 3 if AGE >= 25 & AGE < 30
replace agecat6 = 4 if AGE >= 30 & AGE < 35
replace agecat6 = 5 if AGE >= 35 & AGE < 40
replace agecat6 = 6 if AGE >= 40 & AGE < .

label define agecat6 1 "15-19" 2 "20-24" 3 "25-29" 4 "30-34" 5 "35-39" ///
					 6 "40+"
					 
label values agecat6 agecat6


gen agesq = AGE*AGE

** Fertilitly in the last year
// asked of women ages 15-50
// I'll focus my analysis on 15-44 for consistency with NCHS
gen womanage1544 = 0
replace womanage1544 = 1 if SEX == 2 & (AGE >= 15 & AGE <= 44)

gen womanage1944 = 0
replace womanage1944 = 1 if SEX == 2 & (AGE >= 19 & AGE <= 44)

/* a note from katie genadek, worth investigating:
It turns out that the ACS question used to say something like Have you birthed 
a child, in the last 12 months. And they changed it in 2017/2018 to in the last 
12 month, have you birthed a child? They did this without testing (which is 
unusual) but because empirically that it looked like many people were missing 
the second half the question. */

/* From IPUMS on comparability and suppressed code
Problems in the collection of data on women who gave birth in the past year in 
2012 led to suppressing this variable in 59 PUMAs within the states of Florida, 
Georgia, Kansas, Montana, North Carolina, Ohio and Texas. These suppressed cases 
were given a code of 8. This only affects data from the 2012 1-year ACS and 2012 
cases from the 3- and 5-year 2012 ACS samples. See the Estimation section of the
Accuracy of the Data for the 2012 1-year PUMS for more information on PUMS 
estimates using FERTYR (referred to as FER in document).
*/

gen baby = 0
replace baby = 1 if FERTYR == 2


** Marital status
gen married = 0
replace married = 1 if MARST == 1 | MARST == 2

// Generate an alternate marital status variable that considers people who were
// married in the last year to be UNMARRIED to try to tease out whether marriage
// in response to a pregnancy is affecting results. Substantively, if someone gets
// married bc they're preg, this suggests that the institution of marriage is 
// meaningful for fertility -- but this will be for an analytic test to see whether
// this is introducing any bias, as the rate of marriage in response to preg 
// might change over time.
// NOTE: this Q only appears in 2008 forward

gen married1yrago = .
replace married1yrago = 0 if YEAR >= 2008
// People who are currently married and don't say that they got married
// within the last year were married 1 year ago.
replace married1yrago = 1 if (married == 1 & MARRINYR == 1 & YEAR >= 2008)
tab married married1yrago if YEAR >= 2008, m row



** Race/ethnicity
gen racethn = .
replace racethn = 1 if RACE == 1 & HISPAN == 0 // nh white
replace racethn = 2 if RACE == 2 & HISPAN == 0 // nh black
replace racethn = 3 if HISPAN > 0 & HISPAN < .
replace racethn = 4 if (RACE == 4 | RACE == 5 | RACE == 6) & HISPAN == 0 
replace racethn = 5 if (RACE == 3 |(RACE >= 7 & RACE < .)) & HISPAN == 0

label define racethn 1 "NH White" 2 "NH Black" 3 "Hispanic/Latino" 4 "AAPI" 5 "Other (including multiracial)"
label values racethn racethn

** Nativity
gen bornus = 0
replace bornus = 1 if BPL <= 120

** Education
gen educat = .
replace educat = 1 if EDUC <= 6 // grade 12 or less
replace educat = 2 if EDUC == 7 | EDUC == 8
replace educat = 3 if EDUC >= 9 & EDUC < . 
label define educat 1 "HS or less" 2 "Some college" 3 "4+ years college"
label values educat educat

/* Decided that we shouldn't limit the main sample and instead should just
 * focus on years w/ group quarters, so commenting this out.
 
** Group Quarters
// ACS surveys before the year 2006 did not include people living in group
// quarters. Therefore, for comparability, we'll exclude everyone living in
// group quarters.
gen excludegq = 0
replace excludegq = 1 if GQ == 3 | GQ == 4
*/


save "$nmfratiokeep/acs_0023recoded.dta", replace
