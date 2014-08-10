#Load relevant libraries--------------------------------------------------------
library(tcltk)
library(plyr)
library(Defaults)
library(lubridate)
library(sqldf)


fileURL<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileURL, "PowerConsumptTab.zip",method="curl")
data<-unzip("PowerConsumptTab.zip")
list(data)



#Instead of reading whole data set use sql to read the correct parts
#also possible using .txt file :) yay!!
consume <- read.csv.sql(file="household_power_consumption.txt",
                      sep = ";", sql = "select * from file where Date 
                     in ('1/2/2007', '2/2/2007') ")

#Set DATE TIME add Weekday------------------------------------------------------
consume$Date<-dmy(consume$Date)
consume$Time<-strptime(consume$Time,format="%H:%M:%S")  

head(consume)


#Adding a new column Date_Time that combines Date and Time
consume$Time<-format(consume$Time, format="%H:%M:%S")
consume$Date_Time<-paste(consume$Date,consume_sub$Time,sep=" ")
consume$Date_Time<-ymd_hms(consume$Date_Time)


#Plot1 histogramm---------------------------------------------------------------
png("plot1.png",width = 480, height = 480, units = "px")
hist(consume$Global_active_power,col="red",
     xlab=c("Global active power [kilowatts]"),main=c("Global active power"))
dev.off()
