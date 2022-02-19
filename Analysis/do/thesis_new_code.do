use "/Users/saraji/Downloads/seda_school_pool_gcs_4.0.dta", clear
keep if fips == 6
gen temp_var1 = tostring(sedasch)
tostring sedasch, gen(temp_var1) format(%12.0f)
keep if substr(temp_var1,1,6)=="628050"
drop temp_var1
gen enrolled = 0
replace enrolled = 1 if sedaschname == "Montera Middle" | sedaschname == "Piedmont Avenue Elementary" | sedaschname == "Claremont Middle"
label variable enrolled "whether the school is enrolled in the MDP program"
save seda_data, replace
use "/Users/saraji/Downloads/seda_cov_school_pool_4.0.dta", clear
keep if fips == 6 & sedalea == 0628050
save cov_data, replace
use seda_data, clear
joinby sedasch using "cov_data"
save seda_data, replace
keep if type == 1
drop if charter == 1 | charter == 1 | sch_sped == 1
//dropping some of the variables that doesn't really matter
drop gap fips stateabb subcat subgroup sedalea schnam schcity type mingrd maxgrd charter magnet urbanicity locale sch_sped

//dependent var: cohort slope (the “trend” in the test scores across cohorts)
//And I don't really want the bayesian method
drop gcs_mn_avg_eb gcs_mn_coh_eb gcs_mn_grd_eb gcs_mn_mth_eb gcs_mn_avg_eb_se gcs_mn_coh_eb_se gcs_mn_grd_eb_se gcs_mn_mth_eb_se

//I don't really need SE from the OLS method either
drop gcs_mn_avg_ol_se gcs_mn_coh_ol_se gcs_mn_grd_ol_se gcs_mn_mth_ol_se

by level, sort: reg gcs_mn_avg_ol enrolled perblk perwht
reg gcs_mn_coh_ol gcs_mn_avg_ol enrolled lep_flag perblk perwht
save seda_data, replace
tsset sedalea year
