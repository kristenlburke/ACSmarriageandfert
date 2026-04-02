// acs_regression.do

use "$nmfratiokeep/acs_0122recoded.dta", clear


// Set up weights
svyset CLUSTER [pweight=PERWT], strata(STRATA)

// women of repro age are our sample
tab YEAR baby if womanage1944 == 1
// Too few to rely on an LPM
// I was originally going to estimate AME, but I don't think the results call
// for it-- they stand on their own in showing a significant + assoc between
// marriage and fertility among those with low SES


keep if YEAR >= 2009 
// overall - main analyses presented in paper
svy, subpop(if womanage1944 == 1): logit baby i.YEAR##i.married c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_overall_1944.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05) dec(2)  label replace
/// by educ
svy, subpop(if womanage1944 == 1 & educat == 1): logit baby i.YEAR##i.married c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_hsorless_1944.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05) dec(2)  label replace
svy, subpop(if womanage1944 == 1 & educat == 2): logit baby i.YEAR##i.married c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_somecollege_1944.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05) dec(2)  label replace
svy, subpop(if womanage1944 == 1 & educat == 3): logit baby i.YEAR##i.married c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_collegeormore_1944.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05) dec(2)  label replace


// Supplement - regressions w/o interaction
svy, subpop(if womanage1944 == 1): logit baby i.YEAR i.married c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_overall_nointeraction_1944.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05) dec(2)  label replace
/// by educ
svy, subpop(if womanage1944 == 1 & educat == 1): logit baby i.YEAR i.married c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_hsorless_nointeraction_1944.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05) dec(2)  label replace
svy, subpop(if womanage1944 == 1 & educat == 2): logit baby i.YEAR i.married c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_somecollege_nointeraction_1944.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05) dec(2)  label replace
svy, subpop(if womanage1944 == 1 & educat == 3): logit baby i.YEAR i.married c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_collegeormore_nointeraction_1944.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05) dec(2)  label replace
