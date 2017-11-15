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

png("plot2.png")
ax1<-c(1170288000,1170374400,1170460740)
al1<-c("Thu","Fri","Sat")
plot(ener3$DateTime,ener3$Global_active_power,type="l",lty=1,lwd=1,xaxt='n',ylab="Global Active Power (kilowatts)",xlab="")
axis(1,at=ax1,labels = al1)
dev.off()
