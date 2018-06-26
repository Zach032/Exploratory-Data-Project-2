NEI[, Emissions := lapply(.SD, as.numeric), .SDcols = c("Emissions")]

totalNEI <- NEI[fips=="24510", lapply(.SD, sum, na.rm=TRUE), .SDcols=c("Emissions"), by=year]

png(filename = "plot2.png")
barplot(totalNEI[,Emissions], names=totalNEI[,year], xlab="Years", 
        ylab="Emissions", main="Emissions Over the Years in Balitmore" )

dev.off()
