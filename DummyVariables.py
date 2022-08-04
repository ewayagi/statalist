# -*- coding: utf-8 -*-
"""
Created on Thu Aug  4 13:31:59 2022

Content: Normality tesst for dummy variables 

@author: ewayagi
"""

#=============================libraries=======================================#

import numpy as np
import pandas as pd
import statsmodels.api as sm
import statsmodels.formula.api as smf
import matplotlib.pyplot as plt
from statsmodels.compat import lzip

#=============================loading data from R=============================#

mydata = sm.datasets.get_rdataset("wage2", "wooldridge").data

# check missing values 
print(mydata.isnull())

#dropping the missing values 
mydata = mydata.dropna()

#displaying data columns 
pd.set_option('display.max_columns', None)
print(mydata)

#=========================exploring the data==================================#

print(mydata.columns.values)
print(type(mydata))
print(mydata.dtypes)
print(mydata.describe())

#=============================central tendency fo=============================# 

#checking for dychotomous/ dummy/ binary variables 
dummy_var = mydata.T[mydata.isin([0,1]).all()].T
print(dummy_var)

# checking counts of a dummy/ binary variable
count_urban = mydata['urban'].value_counts()
print(count_urban)

 # mean for urban 
urban_means = mydata.groupby(['urban']).mean()
print(urban_means)

# std dev for urban 
urban_stds = mydata.groupby(['urban']).std()
print(urban_stds)

# variance for urban 
urban_vars = mydata.groupby(['urban']).var()
print(urban_vars)

#=============selecting the central tendency for wage-urban variable==========#

print(urban_means['wage'])
print(urban_stds['wage'])
print(urban_vars['wage'])

#=============================cbinding the 3==================================#

wage_combination = pd.concat([urban_means['wage'], urban_stds['wage'],\
                         urban_vars['wage']], axis=1)
print(wage_combination)

#===============selecting wage values represented by the urban dummy==========#

# urban workers; urban = 1

wage_urban_select = mydata[['urban','wage']].dropna()
wage_urban = wage_urban_select[wage_urban_select.urban == 1]
print(wage_urban)

# means of wages for urban workers
 
print(wage_urban.mean())

# urban workers; urban = 0

wage_rural_select = mydata[['urban','wage']].dropna()
wage_rural = wage_rural_select[wage_rural_select.urban == 0]
print(wage_rural)

# means of wages for rural workers
 
print(wage_rural.mean())

#==============================normality test=================================#
#==============================data visualization=============================#
# 1. plots 

# a. wage_urban 

#histogram
# plot name: histwageurban.py 

plt.hist(wage_urban)
plt.show()

# qqplot
# plot name: qqwageurban.py

sm.qqplot(wage_urban, line = '45')
plt.show()


# b. wage_rural 

#histogram
# plot name: histwagerural.py  

plt.hist(wage_rural)
plt.show()

# qqplot
# plot name: qqwagerural.py

sm.qqplot(wage_rural, line = '45')
plt.show()

#========================probability distribution test========================#

# 2. skewness and kurtosis on wage for dummy variable

from scipy.stats import skew, kurtosis

# a. wage_urban

skew_wage_urban = skew(wage_urban, bias = False)
print(skew_wage_urban[1])

kurto_wage_urban = kurtosis(wage_urban, bias = False)
print(kurto_wage_urban[1])

# b. wage_rural

skew_wage_rural = skew(wage_rural, bias = False)
print(skew_wage_rural[1])

kurto_wage_rural = kurtosis(wage_rural, bias = False)
print(kurto_wage_rural[1])

#===================statistical tests for normality===========================#

# 3. Shapiro-Wilks normality test

from scipy.stats import shapiro

# a. wage_urban

shapiro_wage_urban = shapiro(wage_urban)
print(shapiro_wage_urban)

# b. wage_rural

shapiro_wage_rural = shapiro(wage_rural)
print(shapiro_wage_rural)

# What is your conclusion for the normality test above? 

#===================================END=======================================#