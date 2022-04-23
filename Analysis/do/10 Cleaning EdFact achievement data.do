******
clear all
global raw		"${ThesisAdditionalWorkRawData}/Data"				/* where raw data files are saved */
global data		"${ThesisAdditionalWorkRawData}/dta"			/* where dta outputs are saved */

global tables "${ThesisAdditionalWorkRawData}/Results/Table"
global fig "${ThesisAdditionalWorkRawData}/Results/Figure"
******

import delimited "$raw/EDF_SCH_AP_MTH_1819_PUBL.csv", clear
keep school_year stnam fipst leaid leanm ncessch schnam subject grade category numvalid pctprof
keep if fipst == 6
keep if category == "MBL" | category == "MWH" | category == "ECD" | category == "F" | category == "M"
keep if grade == "00"
la var school_year "School Year"
la var stnam "State Name"
la var fipst "Two-digit code for state"
la var leaid "District NCES ID"
//la var st_leaid "District State ID"
la var leanm "District Name"
la var ncessch "School NCES ID"
//la var st_schid "School State ID"
la var schnam "School Name"
la var subject "Subject"
la var grade "Grade (00 All grades)"
la var category "Category/Subgroup"
//la var date_cur "Date of data snapshot"
la var numvalid "Number of proficient students who were assigned a performance level"
la var pctprof "Percentage of students who scored at or above proficient"
