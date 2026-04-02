* Setup base environment for NLSY analysis

** Set seed for random variable
set seed 203847

** Set graph scheme
set scheme s1mono

** set maxvar
set maxvar 120000, perm

** Set varabbrev off
set varabbrev off

** set type - this is bc we're working w/ large numbers we don't want rounded
set type double

* Find my home directory, depending on OS.
if ("`c(os)'" == "Windows") {
    local temp_drive : env HOMEDRIVE
    local temp_dir : env HOMEPATH
    global homedir "`temp_drive'`temp_dir'"
    macro drop _temp_drive _temp_dir`
}
else {
    if ("`c(os)'" == "MacOSX") | ("`c(os)'" == "Unix") {
        global homedir : env HOME
    }
    else {
        display "Unknown operating system:  `c(os)'"
        exit
    }
}

**********************************
* Check for package dependencies *
**********************************
* This checks for packages that the user should install prior to running the project do files.

capture : which ereplace
if (_rc) {
    display as error in smcl `"Please install package {it:ereplace} from SSC in order to run these do-files;"' _newline ///
        `"you can do so by clicking this link: {stata "ssc install ereplace":auto-install ereplace}"'
    log close
    exit 199
}

capture : which unique
if (_rc) {
    display as error in smcl `"Please install package {it:unique} from SSC in order to run these do-files;"' _newline ///
        `"you can do so by clicking this link: {stata "ssc install unique":auto-install unique}"'
    log close
    exit 199
}


/*
capture : which egenmore
if (_rc) {
    display as error in smcl `"Please install package {it:egenmore} from SSC in order to run these do-files;"' _newline ///
        `"you can do so by clicking this link: {stata "ssc install egenmore":auto-install egenmore}"'
    log close
    exit 199
}
*/


// Run personal setup file
do setup_`c(username)'
