## This script will create a plot of global active power against time

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

## subset data from 2007-02-01 and 2007-02-02

powerSubset <- subset(powerData, Date == "2007-02-01" | Date =="2007-02-02")

## plot global active power vs date & time

png("plot2.png", width=480, height=480)
with(powerSubset, plot(DateTimeCombined, Global_active_power, type="l", xlab="Day", ylab="Global Active Power (kilowatts)"))
dev.off()
