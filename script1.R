library(dplyr)
library(lubridate)
ener<-read.table("household_power_consumption.txt", sep=";", header = T,colClasses = "character")
ener$Date<-dmy(ener$Date)
ener2<-filter(ener,Date==dmy("01-02-2007")|Date==dmy("02-02-2007"))
DateTime<-as_datetime(paste(as.character(ener2$Date),ener2$Time))
ener3<-cbind(DateTime,ener2[,3:9])
for (x in names(ener3)) {
  if(x!="Datetime") { ener3[[x]]<-as.numeric(ener3[[x]])}
}
png("plot1.png")
hist(ener3$Global_active_power,xlab="Global Active Power (kilowatts)",col="red",main="Global Active Power")
dev.off()