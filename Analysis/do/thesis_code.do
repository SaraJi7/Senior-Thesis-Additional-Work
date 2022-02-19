clear all       
set more off   
cd /Users/saraji/Downloads
import excel using thesis_data.xlsx, firstrow clear
gen year = year(Year)
drop Year
label define school_level 1 "elementary" 2 "middle" 3 "high"
gen SchoolType = 1
replace SchoolType = 2 if school_type == "middle"
replace SchoolType = 3 if school_type == "high"
label values SchoolType school_level
isid SchoolID year
duplicates list SchoolID year
replace SchoolID = 62805004246 in 33
replace SchoolID = 62805004239 in 36
tsset SchoolID year
replace blackmathpercentageofprofice = ".a" if blackmathpercentageofprofice == "PS"
destring blackmathpercentageofprofice, replace
replace whitemathpercentageofprofice = ".a" if whitemathpercentageofprofice == "PS"
destring whitemathpercentageofprofice, replace
replace ECDmathpercentageofproficenc = ".a" if ECDmathpercentageofproficenc == "PS"
destring ECDmathpercentageofproficenc, replace
replace LEPmathpercentageofproficenc = ".a" if LEPmathpercentageofproficenc == "PS"
destring LEPmathpercentageofproficenc, replace
replace BlackGrade912DropoutRate = "." if BlackGrade912DropoutRate == "N/A"
destring BlackGrade912DropoutRate, replace
replace WhiteGrade912DropoutRate = "." if WhiteGrade912DropoutRate == "N/A"
destring WhiteGrade912DropoutRate, replace
gen bwmathgap = whitemathpercentageofprofice - blackmathpercentageofprofice
gen bwdropoutgap = WhiteGrade912DropoutRate - BlackGrade912DropoutRate
gen bwsuspensiongap = WHIOSSratestudentsreceiving - BLAOutofSchoolSuspensionrat
by school_type, sort: reg bwmathgap enrolled bwsuspensiongap bwdropoutgap ECDmathpercentageofproficenc LEPmathpercentageofproficenc
by school_type, sort: reg blackmathpercentageofprofice enrolled
sort school_type
reg blackmathpercentageofprofice enrolled BLAOutofSchoolSuspensionrat ECDmathpercentageofproficenc LEPmathpercentageofproficenc if school_type=="elementary"
estimates store model1
reg blackmathpercentageofprofice enrolled BLAOutofSchoolSuspensionrat ECDmathpercentageofproficenc LEPmathpercentageofproficenc if school_type=="middle"
estimates store model2
reg blackmathpercentageofprofice enrolled BLAOutofSchoolSuspensionrat BlackGrade912DropoutRate ECDmathpercentageofproficenc LEPmathpercentageofproficenc if school_type=="high"
estimates store model3
esttab model1 model2 model3, se ar2
esttab model1 model2 model3 using example.tex, se ar2 ///
     title(Regression table\label{tab1})
	 
reg bwmathgap enrolled bwsuspensiongap ECDmathpercentageofproficenc LEPmathpercentageofproficenc if school_type=="elementary"
estimates store model4
reg bwmathgap enrolled bwsuspensiongap ECDmathpercentageofproficenc LEPmathpercentageofproficenc if school_type=="middle"
estimates store model5
reg bwmathgap enrolled bwsuspensiongap bwdropoutgap ECDmathpercentageofproficenc LEPmathpercentageofproficenc if school_type=="high"
estimates store model6
esttab model4 model5 model6, se ar2
esttab model4 model5 model6 using example2.tex, se ar2 ///
     title(Regression table\label{tab1})

	 
//fixed effects regression
xtset SchoolID year
xtreg blackmathpercentageofprofice enrolled BLAOutofSchoolSuspensionrat ECDmathpercentageofproficenc LEPmathpercentageofproficenc i.Year if school_type=="elementary",fe

//synthetic control method
ssc install synth, replace all
tsset SchoolID year
bysort SchoolID: gen a=_N
drop if a<4
save overall_data, replace
keep if SchoolType == 1
save elementary_data, replace
use overall_data, clear
keep if SchoolType == 2
save middle_data, replace
use overall_data, clear
keep if SchoolType == 3
save high_data, replace
use elementary_data, clear
replace id = lower(SchoolName)
//ecd missing for both 2011&2013
drop if SchoolID == 62805004253 
drop if SchoolID == 62805004302
drop if SchoolID == 62805004318
//62805004239
//62805004280
//62805004306
//62805004307
drop if blackmathpercentageofprofice==.a & year==2011
drop if blackmathpercentageofprofice==.a & year==2013
drop if blackmathpercentageofprofice==.a & year==2015
drop if blackmathpercentageofprofice==.a & year==2017
drop if ECDmathpercentageofproficenc==.a & year==2013

synth blackmathpercentageofprofice BLAOutofSchoolSuspensionrat ECDmathpercentageofproficenc blackmathpercentageofprofice(2011) blackmathpercentageofprofice(2013), trunit(62805004308) trperiod(2015) nested fig

use middle_data, clear
isid SchoolID year
duplicates list SchoolID year
tsset SchoolID year
bysort SchoolID: gen N=_N
drop if N<4
drop if LEPmathpercentageofproficenc==.a
drop if blackmathpercentageofprofice==.a & year==2013
synth blackmathpercentageofprofice BLAOutofSchoolSuspensionrat ECDmathpercentageofproficenc LEPmathpercentageofproficenc blackmathpercentageofprofice(2011) blackmathpercentageofprofice(2013), trunit(62805004303) trperiod(2015) nested fig

use elementary_data, clear
xi: reg bwmathgap enrolled bwsuspensiongap whitemathpercentageofprofice ECDmathpercentageofproficenc LEPmathpercentageofproficenc i.SchoolID, vce(robust) //robust LEPmathpercentageofproficenc i.SchoolID
estimates store m4

use middle_data, clear
xi: reg bwmathgap enrolled i.SchoolID, vce(robust)
xi: reg bwmathgap enrolled bwsuspensiongap whitemathpercentageofprofice ECDmathpercentageofproficenc LEPmathpercentageofproficenc i.SchoolID, vce(robust)
estimates store m5

use high_data, clear
xi: reg bwmathgap enrolled bwsuspensiongap bwdropoutgap  ECDmathpercentageofproficenc LEPmathpercentageofproficenc i.SchoolID, vce(robust)
estimates store m6

esttab m4 m5 m6, se ar2
esttab model1 model2 model3 using example.tex, se ar2 ///
     title(Regression table\label{tab1})
	 
	 

use elementary_data, clear
xi: reg blackmathpercentageofprofice enrolled i.SchoolID, vce(robust)
estimates store m1
xi: reg blackmathpercentageofprofice enrolled BLAOutofSchoolSuspensionrat ECDmathpercentageofproficenc LEPmathpercentageofproficenc i.SchoolID, vce(robust)
estimates store m4

use middle_data, clear
xi: reg blackmathpercentageofprofice enrolled i.SchoolID
estimates store m2
xi: reg blackmathpercentageofprofice enrolled BLAOutofSchoolSuspensionrat ECDmathpercentageofproficenc LEPmathpercentageofproficenc i.SchoolID
estimates store m5

use high_data, clear
xi: reg blackmathpercentageofprofice enrolled i.SchoolID, vce(robust)
estimates store m3
xi: reg blackmathpercentageofprofice enrolled BLAOutofSchoolSuspensionrat BlackGrade912DropoutRate ECDmathpercentageofproficenc LEPmathpercentageofproficenc i.SchoolID, vce(robust)
estimates store m6

esttab m1 m2 m3, se ar2
esttab model1 model2 model3 using example.tex, se ar2 ///
     title(Regression table\label{tab1})

isid SchoolID year
duplicates list SchoolID year
tsset SchoolID year
bysort SchoolID: gen N=_N
drop if N<4
drop if SchoolID == 62805004255
drop if SchoolID == 62805004304
drop if SchoolID == 62805004305
drop if SchoolID == 62805004315
drop if LEPmathpercentageofproficenc==.a & year==2011
drop if LEPmathpercentageofproficenc==.a & year==2013
drop if blackmathpercentageofprofice==.a & year==2013
drop if ECDmathpercentageofproficenc==.a & year==2011
synth BlackGrade912DropoutRate BLAOutofSchoolSuspensionrat ECDmathpercentageofproficenc BlackGrade912DropoutRate(2011) BlackGrade912DropoutRate(2013) blackmathpercentageofprofice, trunit(62805011555) trperiod(2015) nested fig


//district level analysis
ssc install synth, replace all
cd /Users/saraji/Downloads
import delimited using "seda_geodist_long_cs_4.0.csv", case(preserve) clear
keep if fips == 6
keep if subject == "mth"
save big_data, replace
keep if grade == 5
save elementary_data, replace
use big_data, clear
keep if grade == 8
save middle_data, replace
use elementary_data, clear
