NEI[, Emissions := lapply(.SD, as.numeric), .SDcols = c("Emissions")]

totalNEI <- NEI[, lapply(.SD, sum, na.rm=TRUE), .SDcols=c("Emissions"), by=year]

png(filename = "plot1.png")
barplot(totalNEI[,Emissions], names=totalNEI[,year], xlab="Years", 
        ylab="Emissions", main="Emissions Over the Years" )

dev.off()



