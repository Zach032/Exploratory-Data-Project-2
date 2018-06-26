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