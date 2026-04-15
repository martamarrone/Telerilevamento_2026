library(terra)
library(imageRy)

setwd("C:\\Users\\Marta\\Desktop\\Uni 2\\Telerilevamento geo-ecologico")
getwd()
list.files()

sat=rast("ISS074-E-417243.jpg")
im.multiframe(1,2)
plot(sat[[1]])
plot(sat[[2]])

png("prime_due_bande.png")
plot(sat[[1]])
plot(sat[[2]])
dev.off()

#istogrammi 
png("ist.png")
im.multiframe(3,1)
hist(values(sat[[1]]), main="Istogramma Red", col="red")
hist(values(sat[[2]]), main="Istogramma Green", col="green")
hist(values(sat[[3]]), main="Istogramma Blue", col="blue")
dev.off()
