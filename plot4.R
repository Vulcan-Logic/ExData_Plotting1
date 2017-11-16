#written by Vineet W. Singh - 15-11-2017
#plot4.R
#submission for assignment of Week 1 - Part 4 of the Exploratory Data Analysis module of the data science course of coursera

#this script checks to see if the following file is present in the current directory, "household_power_consumption.txt". 
#If the file is present it will open it and load the data into a data frame. 
#If the file is not present it will try to download it and then load it. 
#The data will be processed into appropriate types and subset.The script will then produce the required 4 plots of 
#and save it as PNG file called plot4.png. 

#check if package curl is installed
if(is.element("curl", installed.packages()[,1])){ #check if curl is installed
  require("curl") #load curl if it is installed
} else{              #curl is not installed - stop
  stop("missing package: curl, please install it first")
}

#check if package dplyr is installed
if(is.element("dplyr", installed.packages()[,1])){ #check if dplyr is installed
  require("dplyr") #load dplyr if it is installed
} else{              #dplyr is not installed - stop
  stop("missing package: dplyr, please install it first")
}

#check if package lubridate is installed
if(is.element("lubridate", installed.packages()[,1])){ #check if lubridate is installed
  require("dplyr") #load lubridate if it is installed
} else{              #lubridate is not installed - stop
  stop("missing package: lubridate, please install it first")
}

#check to see if input data exists or download it and then read it
if (file.exists("household_power_consumption.txt")){
  ener<-read.table("household_power_consumption.txt", sep=";", header = T,colClasses = "character") 
} else {
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(url,destfile="./datazip.zip",method="curl")
  unzip('./datazip.zip',exdir='./')
  ener<-read.table("household_power_consumption.txt", sep=";", header = T,colClasses = "character")
}

ener$Date<-dmy(ener$Date)                                            #convert date field from character to date
ener2<-filter(ener,Date==dmy("01-02-2007")|Date==dmy("02-02-2007"))  #subset the data to extract required rows
DateTime<-as_datetime(paste(as.character(ener2$Date),ener2$Time))    #add time to date and make it a datetime field
ener3<-cbind(DateTime,ener2[,3:9])                                   #make a new dataframe with just the datetime field instead of two fields of date and time
for (x in names(ener3)) {                                            #convert the rest of the fields in the data frame to numeric to enable plotting
  if(x!="Datetime") { ener3[[x]]<-as.numeric(ener3[[x]])}            #don't convert the datetime field
}

par(mfrow=2)                                 #divide the device into four screens.
ax1<-c(1170288000,1170374400,1170460740)     #make the right vector for the x axis values
al1<-c("Thu","Fri","Sat")                    #make the labels vector for the x axis

#make the first plot
plot(ener3$DateTime,ener3$Global_active_power,type="l",lty=1,lwd=1,xaxt='n',ylab="Global Active Power",xlab="")
axis(1,at=ax1,labels = al1)                  #set the axis for plot 1

#make the second plot 
plot(ener3$DateTime,ener3$Voltage,type="l",lty=1,lwd=1,xaxt='n',ylab="Voltage",xlab="datetime")
axis(1,at=ax1,labels = al1)                  #set the axis for the second plot

#make the third plot
plot(ener3$DateTime,ener3$Sub_metering_1,col="black",type="l",lty=1,lwd=1,xaxt='n',ylab="Energy Sub Metering",xlab="")
lines(ener3$DateTime,ener3$Sub_metering_2,col="red",lty=1,lwd=1)
lines(ener3$DateTime,ener3$Sub_metering_3,col="blue",lty=1,lwd=1)
axis(1,at=ax1,labels = al1)                 #set the axis for the third plot
#set the legend for the third plot
legend("top", c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty=c(1,1,1),lwd=c(1,1,1),col=c("black","red","blue"),bty="n",cex=0.8,xjust=1,x.intersp = 0.8)

#make the last plot
plot(ener3$DateTime,ener3$Global_reactive_power,type="l",lty=1,lwd=1,xaxt='n',ylab="Global Reactive Power",xlab="datetime")
axis(1,at=ax1,labels = al1)                 #set the axis for the last plot

dev.copy(png, file="plot4.png")             #copy the current device i.e. screen contents to a png file 
dev.off()                                   #close the device and save the file. 
