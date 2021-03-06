library(data.table)
library(dplyr)

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

#Change global active power to numeric for plot2
hpc$Global_active_power <- as.numeric(hpc$Global_active_power)


#Set png parameters. Default is already 480x480 for pixels, but making it clear here.
png(filename = "plot2.png", width = 480, height = 480)
plot(hpc$Global_active_power ~ hpc$Datetime 
	,ylab="Global Active Power (kilowatts)"
	,xlab =""
	,type = "l"
		)
dev.off()
