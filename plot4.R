# Get zip file from the web
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if(!file.exists("./data")){dir.create("./data")}
download.file(fileUrl,destfile="./data/power_consumption.zip", method="curl")

# Unzip file and extract data. Only the first 70,000 rows because we only need
# data from dates 2007-02-01 and 2007-02-02
powerData <- read.table(unz("./data/power_consumption.zip", 
                            "household_power_consumption.txt"), 
                        nrows=70000, 
                        header=T, 
                        quote="\"", 
                        sep=";")

# Convert Date column to date type, Global_active_power, Voltage, submeterings and 
# Global reactive power to numeric
powerData$Date <- as.Date(powerData$Date, "%d/%m/%Y") 
powerData$Global_active_power <- as.numeric(powerData$Global_active_power)
powerData$Voltage <- as.numeric(powerData$Voltage)
powerData$Sub_metering_1 <- as.numeric(powerData$Sub_metering_1)
powerData$Sub_metering_2 <- as.numeric(powerData$Sub_metering_2)
powerData$Sub_metering_3 <- as.numeric(powerData$Sub_metering_3)
powerData$Global_reactive_power <- as.numeric(powerData$Global_reactive_power)

# Select only data from dates 2007-02-01 and 2007-02-02
selectedPowerData <- with(powerData, 
                          powerData[(Date >= "2007-02-01" & Date <= "2007-02-02"), ])

# Prepare data for x axis
x <- as.POSIXct(paste(selectedPowerData$Date, selectedPowerData$Time), 
                format="%Y-%m-%d %H:%M:%S")

# Prepare y axis for Global Active Power plot
y_gap <- selectedPowerData$Global_active_power

# Prepare y axis for Voltage plot
y_voltage <- selectedPowerData$Voltage

# Prepare y axis for submeterings plot
y1 <- selectedPowerData$Sub_metering_1
y2 <- selectedPowerData$Sub_metering_2
y3 <- selectedPowerData$Sub_metering_3

# Prepare y axis for Global Reactive Power plot
y_grp <- selectedPowerData$Global_reactive_power

# Set window size to make sure the legend shows well in the image
windows(height = 6.3, width = 6.3)

# Set plot area for 4 plots
par(mfrow = c(2,2))

# Draw Global active power plot
plot(x,y_gap, type="l", col="black", lwd=1, xlab = "", 
     ylab="Global Active Power")

# Draw Voltage plot
plot(x,y_voltage, type="l", col="black", lwd=1, xlab = "datetime", 
     ylab="Voltage")

# Draw Energy submetering plot
plot(x,y1, type="l", col="black", lwd=1, xlab = "", ylab="Energy submetering")
lines(x, y2, col="red", lwd=1)
lines(x, y3, col="blue", lwd=1)

# Add legend to submetering plot
legend("topright",
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col=c("black", "red", "blue"),
       lwd = 1,
       bty = "n")

# Draw Global reactive power plot
plot(x,y_grp, type="l", col="black", lwd=1, xlab = "datetime", 
     ylab="Global_reactive_power")

# Save to PNG
dev.print(png, file = "plot4.png", width = 480, height = 480)