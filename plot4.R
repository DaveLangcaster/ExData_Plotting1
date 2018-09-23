## This script will create 4 plots on a single canvas (GAP vs. time, Vol vs. time, submetering vs. time and GRP vs. time)

## Check if the required packages are loaded, and load them if not

package.check <- lapply(packages, FUN = function(x) {
        if (!require(x, character.only = TRUE)) {
                install.packages(x, dependencies = TRUE)
                library(x, character.only = TRUE)
        }
})

## Create a directory for the data file

if(!file.exists(file.path(getwd(), "data"))){
        dir.create(file.path(getwd(),"data"))
}

## Set variables for the url and download folder

path <- file.path(getwd(), "data")
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

## Download the data file

if (!file.exists("household_power_consumption.zip")) {
        download.file(url, file.path(path, "household_power_consumption.zip"))
}

## Unzip the data file

unzip(file.path(path, "household_power_consumption.zip"), exdir = path)

## Set the working directory

setwd(path)

## Read in the power data

powerData <- data.table::fread(input = "household_power_consumption.txt"
                               , na.strings="?"
)

## Create column in table with date and time merged together

DateTimeCombined <- strptime(paste(powerData$Date, powerData$Time, sep=" "), "%d/%m/%Y %H:%M:%S")
powerData <- cbind(powerData, DateTimeCombined)

## Change class of Date and Time columns to correct class

powerData$Date <- as.Date(powerData$Date, format="%d/%m/%Y")
powerData$Time <- format(powerData$Time, format="%H:%M:%S")

## Subset data from 2007-02-01 and 2007-02-02

powerSubset <- subset(powerData, Date == "2007-02-01" | Date =="2007-02-02")

## Plot the 4 graphs

png("plot4.png", width=480, height=480)
par(mfrow=c(2,2))
with(powerSubset, plot(DateTimeCombined, Global_active_power, type="l", xlab="", ylab="Global Active Power"))
with(powerSubset, plot(DateTimeCombined, Voltage, type = "l", xlab="datetime", ylab="Voltage"))
with(powerSubset, plot(DateTimeCombined, Sub_metering_1, type="l", xlab="", ylab="Energy sub metering"))
lines(powerSubset$DateTimeCombined, powerSubset$Sub_metering_2,type="l", col= "red")
lines(powerSubset$DateTimeCombined, powerSubset$Sub_metering_3,type="l", col= "blue")
legend(c("topright"), c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty= 1, lwd=2, col = c("black", "red", "blue"))
with(powerSubset, plot(DateTimeCombined, Global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power"))
dev.off()
