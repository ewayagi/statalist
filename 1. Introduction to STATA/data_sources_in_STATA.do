/******************************************************************************************************
Author: Emmanuel Wayagi
Content: Data sources in STATA
******************************************************************************************************/

// set your working directory
cd "C:\path_or_directory_location"

// 1. creating a simple dataset = monthly_expenditure
*open the data editor window
*type 1st column = Months from January to December
*follow the above steps to add more columns

*rename variables
rename (var1 var2 var3 var4 var5 var6 var7 var8) (months monthly_income domestic_travel rent dates foreign_travel investment upkeep)

*repacing values in a cell or in the entire column
replace investment = 150000
replace investment = 1 in 3

*generate other variables such as total savings as
egen tot_exp = rowtotal(domestic_travel rent dates foreign_travel investment upkeep)
gen savings = monthly_income - tot_exp

*label the variable
la var monthly_income "total monthly income"

*gen a binary var = saving_type
gen savings_type = .
*feed the values
replace savings_type = 0 if savings < 0
replace savings_type = 1 if savings > 0
destring savings_type, replace
la define savings_type 0 "dissavings" 1 "savings" 
la val savings_type savings_type 
label variable savings_type "type of monthly savings"

// save your data - CTRL + S
save "C:\path_or_directory_location\monthly_expenditure.dta"

// clear the data
clear

// 2. open existing stata data
*remember to set the directory to match the data source
use "C:\path_or_directory_location\monthly_expenditure.dta",clear

// use existing data from your directory
use monthly_expenditure, clear

// 3. importing data
*xls/xlsx
import excel "C:\path_or_directory_location\xlsx_data.xlsx", sheet("employment_rates") firstrow

// 4. using web data
webuse query
webuse set https://www.stata-press.com/data/r17/
webuse auto.dta 
webuse cancer.dta //auto and cancer =  name of the data

// 5 STATA inbuilt data
*checking all the available datasets
sysuse dir 
*call a specific dataset from the list
sysuse voter.dta

// Exploring your data
*view data
browse
*manupulate
edit
*checking for missing values
tabmiss
misstable sum
*view data structure
describe
*describe numerical statistics
summarize
*list variable names
ds

/******************************************************************************************************
Best Regards 
Emmanuel Wayagi 
"ZERO COMPLACENCY"
******************************************************************************************************/
