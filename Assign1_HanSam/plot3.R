#Load relevant libraries--------------------------------------------------------
library(tcltk)
library(plyr)
library(Defaults)
library(lubridate)
library(sqldf)

#Downloading the household power consumption data-------------------------------
fileURL<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileURL, "PowerConsumptTab.zip",method="curl")
data<-unzip("PowerConsumptTab.zip")
list(data)

#Instead of reading whole data set, use sql to read the correct parts-----------
consume <- read.csv.sql(file="household_power_consumption.txt",
                        sep = ";", sql = "select * from file where Date 
                     in ('1/2/2007', '2/2/2007') ")

#Set DATE TIME add Weekday------------------------------------------------------
consume$Date<-dmy(consume$Date)
consume$Time<-strptime(consume$Time,format="%H:%M:%S")  

head(consume)


#Adding a new column Date_Time that combines Date and Time
consume$Time<-format(consume$Time, format="%H:%M:%S")
consume$Date_Time<-paste(consume$Date,consume$Time,sep=" ")
consume$Date_Time<-ymd_hms(consume$Date_Time)


#Plot3--------------------------------------------------------------------------
png("plot3.png",width = 480, height = 480, units = "px")
plot(consume$Sub_metering_1~consume$Date_Time,type="n", 
     xlab="",ylab=c("Energy sub metering"))
lines(consume$Sub_metering_1~consume$Date_Time,col="black")
lines(consume$Sub_metering_2~consume$Date_Time,col="red")
lines(consume$Sub_metering_3~consume$Date_Time, col="blue")
legend("topright", legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       col=c("black","red","blue"), lty=1, cex=0.7)
dev.off()
