#!/usr/bin/env python
# coding: utf-8

# # Normality test

# # 1. Continuous variable

# In[17]:


#============================Background Notes==================================#
'''
Normality assumption ensures that the dataset (samples) are withdrawn from 
normally distributed populations.You can check this on a specifc variable 
or more significantly on the distributions of parameters or the 
estimators(βs) of the regression, such as OLS. In this notebook, I illustrate 
how to test Normality at a variable level. I also write the codes for 
Central Limit Theorem (CLT). 
'''


# In[19]:


#============================libraries========================================#
import numpy as np
import pandas as pd
import statsmodels.api as sm
# import statsmodels.formula.api as smf
import matplotlib.pyplot as plt
# from statsmodels.compat import lzip


# In[20]:


#=============================loading data from R=============================#
mydata = sm.datasets.get_rdataset("wage2", "wooldridge").data

# '.data' converts our data into a dataframe 
# wage2 is the name of the data
# wooldridge is the R library containing the data


# In[21]:


#=========================exploring the data==================================#
# check missing values 
print(mydata.isnull())

#dropping the missing values 
mydata = mydata.dropna()

#displaying data columns 
pd.set_option('display.max_columns', None)
print(mydata.columns.values)
print(type(mydata))
print(mydata.dtypes)
print(mydata.describe())


# In[22]:


#================================CLT=========================================#
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


# In[23]:


#==============================normality test=================================#
#==============================data visualization=============================#
# 1. plots 
# histogram 
plt.hist(mydata['wage'])
plt.show()

'''
OR
mydata.hist('wage')
'''
# qqplot
sm.qqplot(mydata['wage'], line = '45')
plt.show()


# In[24]:


#========================probability distribution test========================#
# 2. skewness and kurtosis on wage
from scipy.stats import skew, kurtosis

# skewness
skew_wage = skew(mydata['wage'], bias = False)
print(skew_wage)

# kurtosis
kurto_wage = kurtosis(mydata['wage'], bias = False)
print(kurto_wage)


# In[25]:


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


# # 2. Dummy variable

# In[26]:


#====================================CLT======================================# 
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


# In[27]:


#=============selecting the central tendency for wage-urban variable==========#
print(urban_means['wage'])
print(urban_stds['wage'])
print(urban_vars['wage'])


# In[28]:


#=============================cbinding the 3==================================#
wage_combination = pd.concat([urban_means['wage'], urban_stds['wage'],                         urban_vars['wage']], axis=1)
print(wage_combination)


# In[29]:


# urban workers; urban = 1
wage_urban_select = mydata[['urban','wage']].dropna()
wage_urban = wage_urban_select[wage_urban_select.urban == 1]
print(wage_urban)

# means of wages for urban workers
print(wage_urban.mean())

# rural workers; urban = 0
wage_rural_select = mydata[['urban','wage']].dropna()
wage_rural = wage_rural_select[wage_rural_select.urban == 0]
print(wage_rural)

# means of wages for rural workers
print(wage_rural.mean())


# In[30]:


#==============================normality test=================================#
#==============================data visualization=============================#
# 1. plots 
# a. wage_urban 
#histogram
plt.hist(wage_urban)
plt.show()

# qqplot
sm.qqplot(wage_urban, line = '45')
plt.show()

# b. wage_rural 
#histogram
plt.hist(wage_rural)
plt.show()

# qqplot
sm.qqplot(wage_rural, line = '45')
plt.show()


# In[31]:


#========================probability distribution test========================#
# 2. skewness and kurtosis on wage for dummy variable
# a. wage_urban
# skewness
skew_wage_urban = skew(wage_urban, bias = False)
print(skew_wage_urban[1])

# kurtosis
kurto_wage_urban = kurtosis(wage_urban, bias = False)
print(kurto_wage_urban[1])

# b. wage_rural
# skewness
skew_wage_rural = skew(wage_rural, bias = False)
print(skew_wage_rural[1])

# kurtosis
kurto_wage_rural = kurtosis(wage_rural, bias = False)
print(kurto_wage_rural[1])


# In[32]:


#===================statistical tests for normality===========================#
# 3. Shapiro-Wilks normality test
# a. wage_urban
shapiro_wage_urban = shapiro(wage_urban)
print(shapiro_wage_urban)

# b. wage_rural
shapiro_wage_rural = shapiro(wage_rural)
print(shapiro_wage_rural)

# What is your conclusion for the normality test above? 

#===================================END=======================================#

