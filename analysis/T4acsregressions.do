// acs_regression.do

use "$nmfratiokeep/acs_0023recoded.dta", clear


// Set up weights
svyset CLUSTER [pweight=PERWT], strata(STRATA)

// women of repro age are our sample
tab YEAR baby if womanage1544 == 1, row
// Too few to rely on an LPM


keep if YEAR >= 2009
/*
// overall
svy, subpop(if womanage1544 == 1): logit baby i.YEAR##i.married c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_overall.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05) dec(2)  label replace
/// by educ
svy, subpop(if womanage1544 == 1 & educat == 1): logit baby i.YEAR##i.married c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_hsorless.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05) dec(2)  label replace
svy, subpop(if womanage1544 == 1 & educat == 2): logit baby i.YEAR##i.married c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_somecollege.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05) dec(2)  label replace
svy, subpop(if womanage1544 == 1 & educat == 3): logit baby i.YEAR##i.married c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_collegeormore.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05) dec(2)  label replace
*/

/*
// Supplement - regressions w/o interaction
svy, subpop(if womanage1544 == 1): logit baby i.YEAR i.married c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_overall_nointeraction.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05) dec(2)  label replace
/// by educ
svy, subpop(if womanage1544 == 1 & educat == 1): logit baby i.YEAR i.married c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_hsorless_nointeraction.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05) dec(2)  label replace
svy, subpop(if womanage1544 == 1 & educat == 2): logit baby i.YEAR i.married c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_somecollege_nointeraction.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05) dec(2)  label replace
svy, subpop(if womanage1544 == 1 & educat == 3): logit baby i.YEAR i.married c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_collegeormore_nointeraction.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05) dec(2)  label replace
*/

** EFORM - IN manuscript
svy, subpop(if womanage1544 == 1): logit baby i.YEAR##i.married c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_overalleform.xls", sideway stats(coef se) alpha(0.001, 0.01, 0.05) dec(2)  label eform replace
/// by educ
svy, subpop(if womanage1544 == 1 & educat == 1): logit baby i.YEAR##i.married c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_hsorlesseform.xls", sideway stats(coef se) alpha(0.001, 0.01, 0.05) dec(2)  label eform replace
svy, subpop(if womanage1544 == 1 & educat == 2): logit baby i.YEAR##i.married c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_somecollegeeform.xls", sideway stats(coef se) alpha(0.001, 0.01, 0.05) dec(2)  label eform replace
svy, subpop(if womanage1544 == 1 & educat == 3): logit baby i.YEAR##i.married c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_collegeormoreeform.xls", sideway stats(coef se) alpha(0.001, 0.01, 0.05) dec(2)  label eform replace

count if womanage1544 == 1
tab educat if womanage1544 == 1


/*
// Supplement - regressions w/o interaction
svy, subpop(if womanage1544 == 1): logit baby i.YEAR i.married c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_overall_nointeraction.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05) dec(2)  label eform replace
/// by educ
svy, subpop(if womanage1544 == 1 & educat == 1): logit baby i.YEAR i.married c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_hsorless_nointeraction.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05) dec(2)  label eform replace
svy, subpop(if womanage1544 == 1 & educat == 2): logit baby i.YEAR i.married c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_somecollege_nointeraction.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05) dec(2)  label eform replace
svy, subpop(if womanage1544 == 1 & educat == 3): logit baby i.YEAR i.married c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_collegeormore_nointeraction.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05) dec(2)  label eform replace
*/

