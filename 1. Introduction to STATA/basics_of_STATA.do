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
*add more outputto the existing log 
log using manulog.log, append
*replacing the existing log 
log using manulog.log, replace

// help/ search in STATA
help logit
search logit
net search logit

// simple arithmetics
disp 12 +-*/ 2
disp sqrt(36)

// installing a package
ssc install oaxaca
findit tabmiss //oaxaca and tabmiss are the packages

/******************************************************************************************************
Best Regards 
Emmanuel Wayagi 
"ZERO COMPLACENCY"
******************************************************************************************************/
