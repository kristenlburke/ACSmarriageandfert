** NMFRatio **
// Started by KLB 1/2024


// Evaluating how marriage has surfaced as persistently relevant for fertility
// through the 2010s.


** Setup workspace **
clear all
do "setup_nmfratio.do"

************************************************
** Phase 1: Decomposition of vital statistics **
************************************************

// What I'm aiming to be able to do here is to generate
// birth rates by demographic sub-group.
// For this, I need the number of births and the number of
// people by subgroup (numerator & denominator).
// In order to execute the decomp, we also need the proportion
// of people in each demographic sub group.

** Population data from IPUMS USA
// These files take a while to run - they shouldn't change most of the time,
// so it's not necessary to re-run them unless there are changes to the
// raw data OR if the process for constructing population counts changes
// CHANGE RECONSTRUCT = 1 IF EITHER OF THESE FILES CHANGE
scalar reconstruct = 1

if reconstruct == 1 {
	// Reads in raw data from IPUMS and applies variable labels
	do "data/acs_dataprep.do"
	// Recode ACS vars
	do "data/acs_recodes.do"
	// Uses yearly ACS data to calculate population counts which will
	// serve as denominators in calculating annual rates
	do "data/acs_denominators_construct.do"
}

// Extract relevant denominators into separate files
// Year file
// Year x marital status x age file
do "data/acs_denominators_extract.do"


** Birth data from CDC Wonder database

// create files with yearly birth counts (overall, by marital status)
// and then with yearly birth counts by year x age x marital status
do "data/cdc_dataprep.do"


** Merge files
// Generate a year x marital status file
// Generate a year x marital status file x age 
do "data/merge.do"


** Generate rates by marital status, age, educ
// NOTE: this takes ~12 hours to run, so only set scalar = 1
// if you've got the time/intentions to rerun.
scalar runrates = 1

if runrates == 1 {
	do "data/acs_rates.do"
}



**************
** Analysis **
**************

** Analyses for manuscript **
// Figure 1 - NMF ratio over time
// this uses vital stats rates - so no editing denominator
do "analysis/F1nmfratio.do" 

// Table 1 - Components of NMFR for women ages 15-44
do "analysis/T1componentsNMFR.do"

// Figure 2 - counterfactual graphs
do "analysis/F2counterfactualgraph.do"

// Figure 3 - Marital birth rate ratios
do "analysis/F3maritalbirthrateratios.do"

// Table 2 - NMFR components by euduc
do "analysis/T2componentsNMFRbyeduc.do"

// Table 4 - Individual-level regressions with ACS data 
do "analysis/T4acsregressions.do"



** Supplemental analyses **
// Age-based sensitivity - same analysis excluding teenages (focus 19-44 instead of 15-44)

// Table 1 - Components of NMFR for women ages 15-44
do "analysis/T1componentsNMFR_1944.do"

// Figure 2 - counterfactual graphs
do "analysis/F2counterfactualgraph_1944.do"

// Figure 3 - Marital birth rate ratios
do "analysis/F3maritalbirthrateratios_1944.do"

// Table 2 - NMFR components by euduc
do "analysis/T2componentsNMFRbyeduc_1944.do"

// Table 4 - Individual-level regressions with ACS data 
do "analysis/T4acsregressions_1944.do"



// Marriage specification sensitivity - same analysis, but classifying those
// who married within the last year as 
// Table 1 - Components of NMFR for women ages 15-44
do "analysis/T1componentsNMFR_altmarriage.do"

// Figure 2 - counterfactual graphs
do "analysis/F2counterfactualgraph_altmarriage.do"

// Figure 3 - Marital birth rate ratios
do "analysis/F3maritalbirthrateratios_altmarriage.do"

// Table 2 - NMFR components by euduc
do "analysis/T2componentsNMFRbyeduc_altmarriage.do"

// Table 4 - Individual-level regressions with ACS data 
do "analysis/T4acsregressions_altmarriage.do"
