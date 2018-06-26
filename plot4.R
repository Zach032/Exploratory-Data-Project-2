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
