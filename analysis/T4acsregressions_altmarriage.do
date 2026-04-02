// acs_regression.do

use "$nmfratiokeep/acs_0023recoded.dta", clear


// Set up weights
svyset CLUSTER [pweight=PERWT], strata(STRATA)

// women of repro age are our sample
tab YEAR baby if womanage1544 == 1
// Too few to rely on an LPM
// I was originally going to estimate AME, but I don't think the results call
// for it-- they stand on their own in showing a significant + assoc between
// marriage and fertility among those with low SES


keep if YEAR >= 2009
// overall
svy, subpop(if womanage1544 == 1): logit baby i.YEAR##i.married1yrago c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_overall_altmarr.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05) dec(2)  label replace
/// by educ
svy, subpop(if womanage1544 == 1 & educat == 1): logit baby i.YEAR##i.married1yrago c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_hsorless_altmarr.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05) dec(2)  label replace
svy, subpop(if womanage1544 == 1 & educat == 2): logit baby i.YEAR##i.married1yrago c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_somecollege_altmarr.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05) dec(2)  label replace
svy, subpop(if womanage1544 == 1 & educat == 3): logit baby i.YEAR##i.married1yrago c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_collegeormore_altmarr.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05) dec(2)  label replace


// Supplement - regressions w/o interaction
svy, subpop(if womanage1544 == 1): logit baby i.YEAR i.married1yrago c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_overall_nointeraction_altmarr.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05) dec(2)  label replace
/// by educ
svy, subpop(if womanage1544 == 1 & educat == 1): logit baby i.YEAR i.married1yrago c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_hsorless_nointeraction_altmarr.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05) dec(2)  label replace
svy, subpop(if womanage1544 == 1 & educat == 2): logit baby i.YEAR i.married1yrago c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_somecollege_nointeraction_altmarr.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05) dec(2)  label replace
svy, subpop(if womanage1544 == 1 & educat == 3): logit baby i.YEAR i.married1yrago c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_collegeormore_nointeraction_altmarr.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05) dec(2)  label replace


** EFORM - IN manuscript
svy, subpop(if womanage1544 == 1): logit baby i.YEAR##i.married1yrago c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_overalleform_altmarr.xls", sideway stats(coef se) alpha(0.001, 0.01, 0.05) dec(2)  label eform replace
/// by educ
svy, subpop(if womanage1544 == 1 & educat == 1): logit baby i.YEAR##i.married1yrago c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_hsorlesseform_altmarr.xls", sideway stats(coef se) alpha(0.001, 0.01, 0.05) dec(2)  label eform replace
svy, subpop(if womanage1544 == 1 & educat == 2): logit baby i.YEAR##i.married1yrago c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_somecollegeeform_altmarr.xls", sideway stats(coef se) alpha(0.001, 0.01, 0.05) dec(2)  label eform replace
svy, subpop(if womanage1544 == 1 & educat == 3): logit baby i.YEAR##i.married1yrago c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_collegeormoreeform_altmarr.xls", sideway stats(coef se) alpha(0.001, 0.01, 0.05) dec(2)  label eform replace


// Supplement - regressions w/o interaction
svy, subpop(if womanage1544 == 1): logit baby i.YEAR i.married1yrago c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_overall_nointeraction_altmarr.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05) dec(2)  label eform replace
/// by educ
svy, subpop(if womanage1544 == 1 & educat == 1): logit baby i.YEAR i.married1yrago c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_hsorless_nointeraction_altmarr.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05) dec(2)  label eform replace
svy, subpop(if womanage1544 == 1 & educat == 2): logit baby i.YEAR i.married1yrago c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_somecollege_nointeraction_altmarr.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05) dec(2)  label eform replace
svy, subpop(if womanage1544 == 1 & educat == 3): logit baby i.YEAR i.married1yrago c.AGE i.racethn i.bornus
outreg2 using "$nmfratioresults/logitbaby_collegeormore_nointeraction_altmarr.xls", sideway stats(coef ci) alpha(0.001, 0.01, 0.05) dec(2)  label eform replace
