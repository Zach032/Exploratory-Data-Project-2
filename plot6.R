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