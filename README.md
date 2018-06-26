# Exploratory-Data-Project-2
## [File Download](https://github.com/Zach032/Exploratory-Data-Project-2/blob/master/read_files.R)
```R
library("data.table")
path <- getwd()
url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(url, destfile = paste(path, "dataFiles.zip", sep = "/"))
unzip(zipfile = "dataFiles.zip")

SCC <- data.table::as.data.table(x = readRDS(file = "Source_Classification_Code.rds"))
NEI <- data.table::as.data.table(x = readRDS(file = "summarySCC_PM25.rds"))
```
## [Question One](https://github.com/Zach032/Exploratory-Data-Project-2/blob/master/plot1.R)
Have total emissions from PM2.5 decreased in the United States from 1999 to 2008?
</br>From the graph there is a clear decrease in emissions over time.
```R
NEI[, Emissions := lapply(.SD, as.numeric), .SDcols = c("Emissions")]

totalNEI <- NEI[, lapply(.SD, sum, na.rm=TRUE), .SDcols=c("Emissions"), by=year]

png(filename = "plot1.png")
barplot(totalNEI[,Emissions], names=totalNEI[,year], xlab="Years", 
        ylab="Emissions", main="Emissions Over the Years" )

dev.off()
```
![](https://github.com/Zach032/Exploratory-Data-Project-2/blob/master/plot1.png)
## [Question Two](https://github.com/Zach032/Exploratory-Data-Project-2/blob/master/plot2.R)
Have total emissions from PM2.5 decreased in the Baltimore City, Maryland from 1999 to 2008?
</br>Emissions has decreased over time, we can see a jump in emissions almost to 1999 levels followed by a drop down to the lowest it has been in 2008.
```R
NEI[, Emissions := lapply(.SD, as.numeric), .SDcols = c("Emissions")]

totalNEI <- NEI[fips=="24510", lapply(.SD, sum, na.rm=TRUE), .SDcols=c("Emissions"), by=year]

png(filename = "plot2.png")
barplot(totalNEI[,Emissions], names=totalNEI[,year], xlab="Years", 
        ylab="Emissions", main="Emissions Over the Years in Balitmore" )

dev.off()
```
![](https://github.com/Zach032/Exploratory-Data-Project-2/blob/master/plot2.png)
## [Question Three](https://github.com/Zach032/Exploratory-Data-Project-2/blob/master/plot3.R)
Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City?
</br>There has been a decrease in all types of emissions except for point.
```R
library(ggplot2)
baltimoreNEI <- NEI[fips=="24510",]

g <- ggplot(baltimoreNEI,aes(factor(year),Emissions,fill=type))+ geom_bar(stat="identity") + 
    facet_grid(.~type,scales = "free",space="free") +
    labs(x="Year", y=expression("Total PM"[2.5]*" Emission (Tons)")) +
    labs(title=expression("PM"[2.5]*" Emissions, Baltimore City 1999-2008 by Source Type"))
ggsave(file="plot3.png")

dev.off()
```
![](https://github.com/Zach032/Exploratory-Data-Project-2/blob/master/plot3.png)
## [Question Four](https://github.com/Zach032/Exploratory-Data-Project-2/blob/master/plot4.R)
Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?
</br>There has been a decrease in coal combustion-related emmissions.
```R
library(ggplot2)

combustionRelated <- grepl("comb", SCC[, SCC.Level.One], ignore.case = TRUE)
coalRealted <- grepl("coal", SCC[, SCC.Level.Four], ignore.case = TRUE)
combustionSCC <- SCC[combustionRelated & coalRealted, SCC]
combustionNEI <- NEI[NEI[, SCC] %in% combustionSCC]

ggplot(combustionNEI,aes(x = factor(year),y = Emissions/10^5)) +
    geom_bar(stat="identity", fill ="red", width=0.75) +
    labs(x="Year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
    labs(title=expression("PM"[2.5]*" Coal Combustion Source Emissions Across US from 1999-2008"))

ggsave(file="plot4.png")

dev.off()
```
![](https://github.com/Zach032/Exploratory-Data-Project-2/blob/master/plot4.png)
## [Question Five](https://github.com/Zach032/Exploratory-Data-Project-2/blob/master/plot5.R)
How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
</br>There has been a decrease in vehicle emissions in Baltimore City.
```R
condition <- grepl("vehicle", SCC[, SCC.Level.Two], ignore.case = TRUE)
vehiclesSCC <- SCC[condition, SCC]
vehiclesNEI <- NEI[NEI[, SCC] %in% vehiclesSCC, ]

baltimoreVehiclesNEI <- vehiclesNEI[fips=="24510", ]

ggplot(baltimoreVehiclesNEI,aes(factor(year),Emissions)) +
    geom_bar(stat="identity", fill ="gblue" ,width=0.75) +
    labs(x="Year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
    labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore from 1999-2008"))
ggsave(file="plot5.png")

dev.off()
```
![](https://github.com/Zach032/Exploratory-Data-Project-2/blob/master/plot5.png)
## [Question Six](https://github.com/Zach032/Exploratory-Data-Project-2/blob/master/plot6.R)
Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California. Which city has seen greater changes over time in motor vehicle emissions?
</br>Compared to Los Angeles, Baltimore has far less vehicle emissions.
```R
condition <- grepl("vehicle", SCC[, SCC.Level.Two], ignore.case = TRUE)
vehiclesSCC <- SCC[condition, SCC]
vehiclesNEI <- NEI[NEI[, SCC] %in% vehiclesSCC, ]

baltimoreVehiclesNEI <- vehiclesNEI[fips=="24510", ]
baltimoreVehiclesNEI[, city := c("Baltimore City")]
laVehiclesNEI <- vehiclesNEI[fips=="06037"]
laVehiclesNEI[, city := c("Los Angeles")]
bothNEI <- rbind(baltimoreVehiclesNEI, laVehiclesNEI)

ggplot(bothNEI, aes(x=factor(year), y=Emissions, fill=city)) +
    geom_bar(aes(fill=year),stat="identity") +
    facet_grid(.~city, scales="free", space="free") +
    labs(x="Year", y=expression("Total PM"[2.5]*" Emission (Kilo-Tons)")) + 
    labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore & LA, 1999-2008"))
ggsave("plot6.png")

dev.off()
```
![](https://github.com/Zach032/Exploratory-Data-Project-2/blob/master/plot6.png)
