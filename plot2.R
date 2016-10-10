library(data.table)
library(dplyr)

##Download zip folder and unzip. This step reads the data into R

temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)

data <- unzip(temp, "household_power_consumption.txt")
hpc<-fread(data)
unlink(temp)

#convert Date column to date format and remove times

hpc$weekday<-weekdays(hpc$Date)
hpc$Date <- format(as.POSIXct(hpc$Date,format='%d/%m/%Y'),format='%d/%m/%Y')

#filter to required data

hpc<- hpc%>%
  filter(Date == "01/02/2007" |Date == "02/02/2007")

#Change format for plot1
hpc$Global_active_power <- as.numeric(hpc$Global_active_power)

head(hpc) 

hpc$weekday<-weekdays(hpc$Date)


#Set png parameters. Default is already 480x480 for pixels, but making it clear here.
png(filename = "plot1.png", width = 480, height = 480)
hist(hpc$Global_active_power, 
     col = "red", 
     xlab="Global Active Power (kilowatts)",
     ylab ="Frequency", 
     main="Global Active Power")
dev.off()
