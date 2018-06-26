library(ggplot2)
baltimoreNEI <- NEI[fips=="24510",]

g <- ggplot(baltimoreNEI,aes(factor(year),Emissions,fill=type))+ geom_bar(stat="identity") + 
    facet_grid(.~type,scales = "free",space="free") +
    labs(x="year", y=expression("Total PM"[2.5]*" Emission (Tons)")) +
    labs(title=expression("PM"[2.5]*" Emissions, Baltimore City 1999-2008 by Source Type"))
ggsave(file="plot3.png")

dev.off()