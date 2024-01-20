/******************************************************************************************************
Author: Emmanuel Wayagi
Content: Basics of STATA 
******************************************************************************************************/
// NOTE the Command, Review/ History, Results, Variable and Properties WINDOWS displayed 

// clear memories
clear

// working directory
*check and change (if necessary) your working directory
pwd
cd "C:\path_or_directory_location"

// checking the content of current directory
dir

// logs
*create a log to record your sessions
log using logname.log

*closing a log 
close log
capture log close
*add more outputto the existing log 
log using manulog.log, append
*replacing the existing log 
log using manulog.log, replace

// help/ search in STATA
help logit
search logit
net search logit

// simple arithmetics
disp 12 +-*/^ 2
disp sqrt(36)

// installing a package
ssc install oaxaca
findit tabmiss //oaxaca and tabmiss are the packages

// commad STATA not to pause while running longer results
set more off

// long line commands
*use ///
order cooking_end_time q4_aroma q12_flesh_color q21_mealiness_hand q22_stickiness_hand q23_mealiness_mouth ///
q24_softness q25_hardness q26_stickiness_mouth q27_crumbliness q28_fibrousness q31_sweetness q32_aftertaste  ///
q4_cookingtime q9_overalliking q6_normal_sp_prep_mthd q6_normal_sp_prep_mthd_or q7_preparedifferently ///
q8_pref_dif_prep_method q8_pref_dif_prep_method_or, before(enum) 

*use */
order cooking_end_time q4_aroma q12_flesh_color q21_mealiness_hand q22_stickiness_hand q23_mealiness_mouth /*
*/q24_softness q25_hardness q26_stickiness_mouth q27_crumbliness q28_fibrousness q31_sweetness q32_aftertaste  /*
*/q4_cookingtime q9_overalliking q6_normal_sp_prep_mthd q6_normal_sp_prep_mthd_or q7_preparedifferently /*
*/q8_pref_dif_prep_method q8_pref_dif_prep_method_or, before(enum)

*delimit
#delimit ;
order cooking_end_time q4_aroma q12_flesh_color q21_mealiness_hand q22_stickiness_hand q23_mealiness_mouth
	q24_softness q25_hardness q26_stickiness_mouth q27_crumbliness q28_fibrousness q31_sweetness q32_aftertaste q4_cookingtime 
	q9_overalliking q6_normal_sp_prep_mthd q6_normal_sp_prep_mthd_or q7_preparedifferently q8_pref_dif_prep_method 
	q8_pref_dif_prep_method_or, before(enum) ;

/******************************************************************************************************
Best Regards 
Emmanuel Wayagi 
"ZERO COMPLACENCY"
******************************************************************************************************/
