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

# Convert Date column to date type and submeterings to numeric
powerData$Date <- as.Date(powerData$Date, "%d/%m/%Y") 
powerData$Sub_metering_1 <- as.numeric(powerData$Sub_metering_1)
powerData$Sub_metering_2 <- as.numeric(powerData$Sub_metering_2)
powerData$Sub_metering_3 <- as.numeric(powerData$Sub_metering_3)

# Select only data from dates 2007-02-01 and 2007-02-02
selectedPowerData <- with(powerData, 
                          powerData[(Date >= "2007-02-01" & Date <= "2007-02-02"), ])

# Prepare data for plot3 x = date and time, y = Sub_meterings
x <- as.POSIXct(paste(selectedPowerData$Date, selectedPowerData$Time), 
                format="%Y-%m-%d %H:%M:%S")
y1 <- selectedPowerData$Sub_metering_1
y2 <- selectedPowerData$Sub_metering_2
y3 <- selectedPowerData$Sub_metering_3

# Set window size to make sure the legend shows well in the image
windows(height = 6, width = 6)

# Draw the plot
plot(x,y1, type="l", col="black", lwd=1, xlab = "", ylab="Energy submetering")
lines(x, y2, col="red", lwd=1)
lines(x, y3, col="blue", lwd=1)

# Add legend to plot3
legend("topright",
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col=c("black", "red", "blue"),
       lwd = 1)

# Save plot3 to PNG
dev.print(png, file = "plot3.png", width = 480, height = 480)