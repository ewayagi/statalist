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
*binary var (0,1)
replace intervention = "0" if regexm(intervention,"no")
replace intervention = "1" if regexm(intervention,"yes")
destring intervention, replace
la define interventionla 0 "no" 1 "yes"
la val intervention interventionla
lab var intervention "group of potato cosumer intervention"

*categorical var (1,2,3...n)
rename selected_variety variety
replace variety = "1" if regexm(variety,"Ejumula")
replace variety = "2" if regexm(variety,"Narospot 1")
replace variety = "3" if regexm(variety,"Naspot 13")
replace variety = "4" if regexm(variety,"Tanzania")
destring variety, replace
la define varietyla 1 "Ejumula" 2 "Narospot 1" 3 "Naspot 13" 4 "Tanzania"
la val variety varietyla
lab var variety "selected varieties for intervention"

// STATA datetime var
/* truncating part of a string  time val eg 18:11:00.000+03:00 to 18:11:00.000
note that the UTC (+03:00) is a plain character*/
replace cooking_start_time = subinstr(cooking_start_time ,"+03:00", "", .)
replace cooking_end_time = subinstr(cooking_end_time ,"+03:00", "", .)
/*converting time stored a string to STATA time format 
type help datetime for more and suitable formats
also read more here https://www.stata.com/manuals13/u24.pdf*/
gen double cooking_time_begin = clock(cooking_start_time, "hms")
order cooking_time_begin, before(cooking_start_time)
gen double cooking_time_end = clock(cooking_end_time, "hms")
order cooking_time_end, before(cooking_end_time)
lab var cooking_time_begin "potato cooking start time"
lab var cooking_time_end "potato cooking stop time"
*gen time taken to cook the selected potato
gen cooking_time = cooking_time_end - cooking_time_begin
order cooking_time, before(ext_appearance)
*convert the generated STATA time to minutes
gen cooking_time_minutes = cooking_time/msofminutes(1)
order cooking_time_minutes, before(ext_appearance)
lab var cooking_time_minutes "potato cooking time in minutes"
// droping var
drop cooking_start_time cooking_end_time cooking_time
// rename var
rename (cooking_time_minutes q4_cookingtime ext_appearance q4_aroma q12_flesh_color q21_mealiness_hand ///
q22_stickiness_hand q23_mealiness_mouth q24_softness q25_hardness q26_stickiness_mouth q27_crumbliness ///
q28_fibrousness q31_sweetness q32_aftertaste q9_overalliking q6_normal_sp_prep_mthd q6_normal_sp_prep_mthd_or ///
q7_preparedifferently q8_pref_dif_prep_method q8_pref_dif_prep_method_or) (cooking_time cooking_time_rate ///
ext_appearance_rate aroma_rate flesh_color_rate mealiness_hand_rate stickiness_hand_rate mealiness_mouth_rate ///
softness_rate hardness_rate stickiness_mouth_rate crumbliness_rate fibrousness_rate sweetness_rate aftertaste_rate ///
liking_rate norm_prep_mtd other_norm_prep_mtd diff_prep_mtd pref_prep_mtd other_pref_prep_mtd)

// save the changes in the data
save "spdata.dta", replace
// clear memory and logs
clear all
