/******************************************************************************************************
Author: Emmanuel Wayagi
Content: Data cleaning 
Note: the goal of data cleaning convert all var into numeric types, deal with missing val, correct for outliers, 
******************************************************************************************************/

// preparing the environment
clear //clearing the memory
capture log close //closing the previous logs 
log using manulog.log, replace //recording the session in a replaced log
set more off //sets all outputs to be visible in the results window 

// import excel data and saving it in STATA
cd "C:\path_or_directory_location" //changes the working directory 
global Data C:\path_or_directory_location //sets the global file directory 
import excel "$Data/spotato.xlsx", sheet("Sheet1") firstrow clear //imports the sweet potato data from the global path
save "$Data/spdata.dta" // saves the STATA data

/* check for unique hh id; note that the id should uniquely identify the observations otherwise you can replace the identical 
IDs with unique val */
isid farmer_id
duplicates report farmer_id // checks for duplicates 

// Consumer Intervention Sample Selection
// rename var and labels
rename (selected_variety q11_ext_appearance) (variety ext_appearance)
lab var farmer_id "farmer id"
lab var variety "selected potato variety for cooking test"
lab var ext_appearance "external appearance of selected potato"
lab var cooking_start_time "potato cooking start time"
// grouping data into consumers under the potato intervention or otherwise 
// this requires that you gen and replace string variables and values 
// note that for the string we use this "" for blank while for numeric type we use . for missing values
gen intervention = ""
order intervention, before(variety )
replace intervention = "yes" if variety != ""
replace intervention = "no" if variety == ""
// destrin the intervention var by defining and labeling the values 
replace intervention = "0" if regexm(intervention,"no")
replace intervention = "1" if regexm(intervention,"yes")
destring intervention, replace
la define interventionla 0 "no" 1 "yes"
la val intervention interventionla
lab var intervention "group of potato cosumer intervention"
// save the changes in the data
save "C:\path_or_directory_location/spdata.dta", replace
// clear memory and logs
clear all

// Part A 
capture log close 
log using manulog.log, replace 
set more off 
cd "C:\path_or_directory_location"
use spdata,clear