library(data.table)
library(dplyr)
library(reshape2)

##Download zip folder and unzip. This step reads the data into R

temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)

data <- unzip(temp, "household_power_consumption.txt")
hpc<-fread(data)
unlink(temp)

#convert Date column to date format 
hpc$Date <- format(as.POSIXct(hpc$Date,format=c('%d/%m/%Y')),format=c('%d/%m/%Y'))

#filter to required days and add datetime column
hpc<- hpc%>%
		filter(Date == "01/02/2007" | Date == "02/02/2007")
hpc$Datetime <- paste(hpc$Date, hpc$Time)
hpc$Datetime <- as.POSIXct( strptime(hpc$Datetime, "%d/%m/%Y %H:%M:%S"))

#Change sub metering to numeric for plot4
hpc$Sub_metering_1 <- as.numeric(hpc$Sub_metering_1)
hpc$Sub_metering_2 <- as.numeric(hpc$Sub_metering_2)
hpc$Sub_metering_3 <- as.numeric(hpc$Sub_metering_3)
hpc$Global_reactive_power <- as.numeric(hpc$Global_reactive_power)
hpc$Voltage<- as.numeric(hpc$Voltage)
hpc$Global_active_power <- as.numeric(hpc$Global_active_power)


#Set png parameters. Default is already 480x480 for pixels, but making it clear here.
png(filename = "plot4.png", width = 480, height = 480)
par(mfrow =c(2,2))
#Build plots
plot(hpc$Global_active_power ~ hpc$Datetime 
		,ylab="Global Active Power (kilowatts)"
		,xlab =""
		,type = "l"
)
plot(hpc$Voltage ~ hpc$Datetime 
		,ylab="Voltage"
		,xlab ="datetime"
		,type = "l"
)
plot(hpc$Sub_metering_1~ hpc$Datetime ,type = "s", col ="black",xlab="",ylab="Energy sub meeting")
lines(hpc$Sub_metering_2~ hpc$Datetime ,col = "red", type = "s")
lines(hpc$Sub_metering_3~ hpc$Datetime ,col = "blue", type = "s")	
legend("topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), lty=c(1,1), col =c("black","red","blue"))
plot(hpc$Global_reactive_power ~ hpc$Datetime 
		,ylab="Global_Reactive_Power (kilowatts)"
		,xlab ="datetime"
		,type = "l"
)

dev.off()
