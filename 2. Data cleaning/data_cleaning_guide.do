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

 //Part A
// Consumer Intervention Sample Selection
// grouping data into consumers under the potato intervention or otherwise 
// this requires that you gen and replace string variables and values 
// note that for the string we use this "" for blank while for numeric type we use . for missing values
gen intervention = ""
replace intervention = "yes" if selected_variety != ""
replace intervention = "no" if selected_variety == ""

// ordering var
order intervention, before(selected_variety)
order cooking_end_time q4_aroma q12_flesh_color q21_mealiness_hand q22_stickiness_hand q23_mealiness_mouth /*
*/q24_softness q25_hardness q26_stickiness_mouth q27_crumbliness q28_fibrousness q31_sweetness q32_aftertaste  /*
*/q4_cookingtime q9_overalliking q6_normal_sp_prep_mthd q6_normal_sp_prep_mthd_or q7_preparedifferently /*
*/q8_pref_dif_prep_method q8_pref_dif_prep_method_or, before(enum)

// rename var and labels
lab var farmer_id "farmer id"
lab var cooking_start_time "potato cooking start time"

// destring the var by defining and labeling the values 
replace intervention = "0" if regexm(intervention,"no")
replace intervention = "1" if regexm(intervention,"yes")
destring intervention, replace
la define interventionla 0 "no" 1 "yes"
la val intervention interventionla
lab var intervention "group of potato cosumer intervention"

rename selected_variety variety
replace variety = "1" if regexm(variety,"Ejumula")
replace variety = "2" if regexm(variety,"Narospot 1")
replace variety = "3" if regexm(variety,"Naspot 13")
replace variety = "4" if regexm(variety,"Tanzania")
destring variety, replace
la define varietyla 1 "Ejumula" 2 "Narospot 1" 3 "Naspot 13" 4 "Tanzania"
la val variety varietyla
lab var variety "selected varieties for intervention"

rename q11_ext_appearance ext_appearance
replace ext_appearance = "1" if regexm(ext_appearance,"Just about Right")
replace ext_appearance = "2" if regexm(ext_appearance,"Much Too Little")
replace ext_appearance= "3" if regexm(ext_appearance,"Much Too Much")
replace ext_appearance = "4" if regexm(ext_appearance,"Too Little")
replace ext_appearance = "5" if regexm(ext_appearance,"Too Much")
destring ext_appearance, replace
la define ext_appearancela 1 "Just about Right" 2 "Much Too Little" 3 "Much Too Muc" 4 "Too Little" 5 "Too Much"
la val ext_appearance ext_appearancela
lab var variety "external appearance of selected variety"

// save the changes in the data
save "spdata.dta", replace
// clear memory and logs
clear all

// Part B 
capture log close 
log using manulog.log, replace 
set more off 
cd "C:\path_or_directory_location"
use spdata,clear
