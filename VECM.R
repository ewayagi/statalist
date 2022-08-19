#author:ewayagi and kkavengi
#Date: Mon 15, AUG 2022
#Content:VECM
#Data source: data("Investment")

#=====================clearing the memory======================================#
rm(list=ls()) 
gc() 
cat("\f") 
ls() 
dev.off()

#========================loading the data======================================#

#package for the data

install.packages("sandwich")
library(sandwich)

#data
data("Investment")

#help with the data
??Investment
help("Investment")

#calling the names of the data 
variable.names(Investment)

#check for missing data 
is.null(Investment)

#check the class of the data
class(Investment)

#assign investment to a data
data = Investment

View(data)

#convert to a data frame 
data1 = data.frame(data)

#=======================defining the time series variables=====================#

#loading library
library(tseries)

#due to the low number of observation (20), we specify frequency as 1 

gnp = print(ts(data1$GNP, start = c(1963,1), frequency = 1))
investment = print(ts(data1$Investment, start = c(1963,1), frequency = 1))
interest = print(ts(data1$Interest, start = c(1963,1), frequency = 1))

#store the selected variables into mydata

mydata <- cbind(gnp, investment, interest)

#============================data visualization================================#

plot(mydata)

# OR we can plot a fancy time series on the seleceted variables as follows

ts.plot(mydata[,"gnp"], mydata[,"investment"], mydata[,"interest"], type="l", 
        lty=c(1,2,3), col=c(1,2,3))
legend("topleft", border=NULL, legend=c("gnp","invetment", "interest"), 
       lty=c(1,2,3), col=c(1,2,3))

#==================================conclusion==================================#
#the series are non-stationary 

#===============statistical tests for unit root or stationarity================#

#load library
library(tseries)

#use either 
#Phillips-Perron Unit Root Test
#or
#Phillips-Perron Unit Root Test
#respectively

adf.test(mydata[,"gnp"])
pp.test(mydata[,"gnp"])

adf.test(mydata[,"investment"])
pp.test(mydata[,"investment"])

adf.test(mydata[,"interest"])
pp.test(mydata[,"interest"])

#==========================referencing the variables==========================#

dgnp = diff(gnp)
dinvestment = diff(investment)
dinterest = diff(interest)

#store the referenced variables into diff_data
diff_data = cbind(dgnp, dinterest, dinvestment)

#===================repeat the above tests after referencing==================#

pp.test(diff_data[,"dgnp"])
pp.test(diff_data[,"dinvestment"])
pp.test(diff_data[,"dinterest"])

#================================select optimal lags===========================#

#selecting the lags
lags = VARselect(diff_data, lag.max = 10, type = "const")

#view the selection
lags$selection

#pick lag = 3

#======================Johanson-cointegration test=============================#

#load library
library(urca)

cointest = ca.jo(diff_data,type="trace",ecdet='const',K=3)
summary(cointest)        

cointest1 = ca.jo(diff_data,type="eigen",ecdet='const',K=3)
summary(cointest1)

#we conclude the presence of cointegration of rank 1

#============================VECM model========================================#

#loading library
install.packages("tsDyn")
library(tsDyn)

vecm_model = VECM(diff_data, 3, r = 1,estim =c ("2OLS"))
summary(vecm_model)

#or

vecm_model1 = VECM(diff_data, 3, r = 1,estim =c ("ML"))
summary(vecm_model1)

#==================================Model diagnostic============================#

#load library
library(vars)

# converts VECM to VAR model to help with the tests

vecm_var = vec2var(cointest, r = 1)

# 1. Serial correlation

sctest = serial.test(vecm_var,lags.pt = 10, type = c("PT.asymptotic"))
sctest             

# 2.Heteroskedasticity

hstest = arch.test(vecm_var, lags.single = 10, multivariate.only = TRUE)
hstest            

# 3.Normality test

normtest = normality.test(vecm_var, multivariate.only = TRUE)
normtest 

#====================================forecasting===============================#

# load library
library(forecast)

forecast = predict(vecm_var, n.ahead = 5, ci = 0.95)
forecast

#===========================forecast plots=====================================#

plot(forecast)

# or 

fanchart(forecast, names = "dgnp", main = "Fanchart for GNP", 
         xlab = "Horizon", ylab = "GDP")

fanchart(forecast, names = "dinvestment", main = "Fanchart for INVESTMENT", 
         xlab = "Horizon", ylab = "INVESTMENT")

fanchart(forecast, names = "interest", main = "Fanchart for INTEREST", 
         xlab = "Horizon", ylab = "CONSUMPTION")

#==========================ending R session====================================#
rm(list=ls()) 
gc() 
cat("\f") 
ls() 
dev.off()

