# -*- coding: utf-8 -*-
"""
Created on Wed Aug  3 09:34:14 2022

Content: Normality test for continuous variables 

@author: ewayagi
"""

#============================libraries========================================#

import numpy as np
import pandas as pd
import statsmodels.api as sm
import statsmodels.formula.api as smf
import matplotlib.pyplot as plt
from statsmodels.compat import lzip

#=============================loading data from R=============================#

mydata = sm.datasets.get_rdataset("wage2", "wooldridge").data

'''
or
mydata = sm.datasets.get_rdataset("wage2", "wooldridge")
mydata = mydata.data
.data converts it to a dataframe 
'''

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

#===========================central tendency==================================#

# mean
print(mydata.mean())

mean_wage = np.mean(mydata['wage'])
print(mean_wage)

# median 
median_wage = np.median(mydata['wage'])
print(median_wage)

# mode
from scipy import stats

mode_wage = stats.mode(mydata['wage'])
print(mode_wage)

# std dev
std_wage = np.std(mydata['wage'])
print(std_wage)

# variance
var_wage = np.var(mydata['wage'])
print(var_wage)

# percentile
fifty_wage = np.percentile(mydata['wage'], 25)
print(fifty_wage)

#==============================normality test=================================#
#==============================data visualization=============================#
# 1. plots 

# histogram 
# plot name: histwage.py

plt.hist(mydata['wage'])
plt.show()

'''
# OR
mydata.hist('wage')
'''
# qqplot
# plot name: qqwage.py

sm.qqplot(mydata['wage'], line = '45')
plt.show()

#========================probability distribution test========================#

# 2. skewness and kurtosis on wage

from scipy.stats import skew, kurtosis

skew_wage = skew(mydata['wage'], bias = False)
print(skew_wage)

kurto_wage = kurtosis(mydata['wage'], bias = False)
print(kurto_wage)

#===================statistical tests for normality===========================#

# 3. Shapiro-Wilks normality test

from scipy.stats import shapiro, anderson, kstest

shapiro_wage = shapiro(mydata['wage'])
print(shapiro_wage)

# 4. Anderson-Darling normality test 

anderson_wage = anderson(mydata['wage'])
print(anderson_wage)

# 5. Kolmogorov-Smirnov Test

kolmogrov_wage = kstest(mydata['wage'], 'norm')
print(kolmogrov_wage)

# What is your conclusion on normality test for wage variable?

#================================END==========================================#