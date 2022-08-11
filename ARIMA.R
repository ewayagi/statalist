#author:ewayagi
#Date: Sun 7, AUg 2022
#Content:ARIMA model
#Data source: data("GoldSilver"); from AER package

#============================loading libraries=================================#

library(AER)
library("xts")
library(tseries)
library(forecast)

#=====================clearing the memory======================================#
rm(list=ls()) 
gc() 
cat("\f") 
ls() 
dev.off()

#==============================loading the data================================#

data("GoldSilver")

arima = GoldSilver
class(arima)

#=======================converting to a time series============================#

arimats = xts(arima)

#======================================plots===================================#

plot(arimats$gold)

#the series is non-stationary

#=============================Stationarity test================================#

acf(arimats$gold)

pacf(arimats$gold)

adf.test(arimats$gold)

#again the series is non-stationary

#==============================Auto ARIMA model================================#

arima_model = auto.arima(arimats$gold, ic = "aic", trace = TRUE)

arima_model

acf(ts(arima_model$residuals))

pacf(ts(arima_model$residuals))

adf.test(arima_model$residuals)

#==============================forecasting=====================================#

arima_modelfs = forecast(arima_model, level = c(95), h = 10*12)
arima_modelfs

plot(arima_modelfs)

#===================================THE END====================================#

rm(list=ls()) 
gc() 
cat("\f") 
ls() 
dev.off()
