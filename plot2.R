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

# Convert Date column to date type and Global_active_power to numeric
powerData$Date <- as.Date(powerData$Date, "%d/%m/%Y") 
powerData$Global_active_power <- as.numeric(powerData$Global_active_power)

# Select only data from dates 2007-02-01 and 2007-02-02
selectedPowerData <- with(powerData, 
                          powerData[(Date >= "2007-02-01" & Date <= "2007-02-02"), ])

# Prepare data for plot2 x = date and time, y = Global Active Power
x <- as.POSIXct(paste(selectedPowerData$Date, selectedPowerData$Time), 
                format="%Y-%m-%d %H:%M:%S")
y <- selectedPowerData$Global_active_power

# Draw plot 2
plot(x,y, type="l", col="black", lwd=1, xlab = "", 
     ylab="Global Active Power (kilowatts)")

# Save plot2 to PNG
dev.print(png, file = "plot2.png", width = 480, height = 480)