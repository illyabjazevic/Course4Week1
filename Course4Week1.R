#The following descriptions of the 9 variables in the dataset are taken from the UCI web site:
#Date: Date in format dd/mm/yyyy
#Time: time in format hh:mm:ss
#Global_active_power: household global minute-averaged active power (in kilowatt)
#Global_reactive_power: household global minute-averaged reactive power (in kilowatt)
#Voltage: minute-averaged voltage (in volt)
#Global_intensity: household global minute-averaged current intensity (in ampere)
#Sub_metering_1: energy sub-metering No. 1 (in watt-hour of active energy). It corresponds to the kitchen, containing mainly a dishwasher, an oven and a microwave (hot plates are not electric but gas powered).
#Sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy). It corresponds to the laundry room, containing a washing-machine, a tumble-drier, a refrigerator and a light.
#Sub_metering_3: energy sub-metering No. 3 (in watt-hour of active energy). It corresponds to an electric water-heater and an air-conditioner.

#When loading the dataset into R, please consider the following:

#The dataset has 2,075,259 rows and 9 columns. First calculate a rough estimate of how much memory the dataset will require in memory before reading into R. Make sure your computer has enough memory (most modern computers should be fine).
#We will only be using data from the dates 2007-02-01 and 2007-02-02. One alternative is to read the data from just those dates rather than reading in the entire dataset and subsetting to those dates.
#You may find it useful to convert the Date and Time variables to Date/Time classes in R using the strptime()\color{red}{\verb|strptime()|}strptime()  and as.Date()\color{red}{\verb|as.Date()|}as.Date() functions.
#Note that in this dataset missing values are coded as ?\color{red}{\verb|?|}?.




#STEP NUMBER 1
#YOU NEED TO DOWNLOAD AND SAVE THE FILE
#household_power_consumption.txt
#IN YOUR WORKING DIRECTORY

#ALSO YOU NEED TO INSTALL THE R PACKAGES
#DATA.TABLE, GGPLOT2, AND GRIDEXTRA
#install.packages("ggplot2")
#install.packages("gridExtra")
##install.packages("data.table")

library(ggplot2)
library(data.table)

powerDATAFRAME <- read.table("./household_power_consumption.txt", header=TRUE, sep=';', na.strings="?", nrows=2075259, stringsAsFactors = FALSE)


#WE subset the original DATAFRAME to deal with a smaller DATAFRAME
#This makes the process 100 times faster
smallDATAFRAME <- subset(powerDATAFRAME, powerDATAFRAME$Date=="1/2/2007" | powerDATAFRAME$Date =="2/2/2007")
#We convert the DATES that are in character format to DATE format.
smallDATAFRAME$Date <- as.Date(smallDATAFRAME$Date, format="%d/%m/%Y")

#PLOT NUMBER 1
#I use the GGPLOT2 package because it is the best package for plots

plot1 <-ggplot(data = smallDATAFRAME, mapping = aes(x = Global_active_power)) +
geom_histogram(bins = 10, color="black", fill="red", linetype="dashed") +
labs( title= "Plot Number One", x = "Global Active Power(kilowatts)", y="Frequency")
ggsave("plot1.png", width = 4, height = 4)

#PLOT NUMBER 2

#Using the GGPLOT2 package we need to convert the time 
#that is in character format to POSIXct format.
smallDATAFRAME$Time  <- as.POSIXct(paste(smallDATAFRAME$Date, smallDATAFRAME$Time), format = "%Y-%m-%d %H:%M:%S", tz = "UTC") 

plot2 <- ggplot(data = smallDATAFRAME, mapping = aes(Time, Global_active_power)) +
geom_line() + labs( title= "Plot Number Two", x = "Time", y="Global Active Power")
ggsave("plot2.png", width = 4, height = 4)

#PLOT NUMER 3

#ggplot() +
#geom_line(data = smallDATAFRAME, mapping = aes(Time, Sub_metering_1), color = "darkred") +
#geom_line(data = smallDATAFRAME, mapping = aes(Time, Sub_metering_2), color = "darkblue") +
#geom_line(data = smallDATAFRAME, mapping = aes(Time, Sub_metering_3), color = "darkgreen") +
#labs( title= "Plot Number Three", x = "Time", y="Energy Sub_metering") 

#With GGPLOT2 the legend that is necessary in this plot
#would be automatically generated if the data would be the same
#However, as we are using different data for each plot
#We need to use the following trick

plot3 <- ggplot(smallDATAFRAME, aes(Sub_metering_1,Sub_metering_2, Sub_metering_3))+
geom_line(aes(Time, Sub_metering_1, color = "Sub_metering_1"))+
geom_line(data=smallDATAFRAME,aes(Time, Sub_metering_2, color="Sub_metering_2"))+
geom_line(data=smallDATAFRAME,aes(Time, Sub_metering_3, color="Sub_metering_3"))+
labs(title= "Plot Number Three", colour="Datasets",x="Time",y="Energy Sub_metering")+
theme(legend.position = c(1, 1),legend.justification = c(1, 1))+
scale_color_manual(values = c("blue","red", "green"))

ggsave("plot3.png", width = 4, height = 4)

#PLOT NUMBER 4

#Plot 4 mixes the previous three plots
#With one additional
#It does not have sense to have separate files
#
plot4 <- ggplot(data = smallDATAFRAME, mapping = aes(Time, Global_reactive_power)) +
geom_line() + labs( title= "Plot Number Four", x = "Time", y="Global Reactive Power (kilowatts)")
ggsave("plot4FIRSTPART.png", width = 4, height = 4)

#For the plot 4 that mixes the previous ones
#We need to use a diffent package
#The gridExtra package
#install.packages("gridExtra")
library(gridExtra)
finalPLOT <- grid.arrange(plot1, plot2, plot3, plot4, ncol=2)
ggsave("plot4.png", finalPLOT, width = 8, height = 8)

