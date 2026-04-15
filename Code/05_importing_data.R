#code to import data

install.packages("ggridges")
library(terra)
library(viridis)
library(imageRy)
library(ggridges)

setwd("C:\\Users\\Marta\\Desktop\\Uni 2\\Telerilevamento geo-ecologico\\drone")
getwd()

list.files()
#ci fa la lista dei file nella cartella

#importiamo banda verde
green=rast("DJI_20260409152942_0001_MS_G.tif")
#rast per raster spaziali

plot(green)
green=flip(green)
plot(green, col=mako(100))

red=rast("DJI_20260409152942_0001_MS_R.tif")
red=flip(red)
plot(red)

NIR=flip(rast("DJI_20260409152942_0001_MS_NIR.tif"))
plot(NIR)

stack=c(green, red, NIR)
plot(stack)

#creiamo una immagine a falsi colori con RGB
#le tre immagini verranno un po' sfasate perché l'angolo di acquisizione delle fotocamere è un po' diverso
#la coregistrazione può aggiustare questa cosa ma è molto pesante e lunga quindi non la facciamo

plotRGB(stack, r=3, g=2, b=1)
#manca lo stretch
#se ho un'immagine da 0 a 255 valori non è detto che 'immagine li copra tutti, magari va da 20 a 100
#quindi applichiamo un'operazione lineare che si chiama stretch lineare che li allunga
#stretch="lin" 
plotRGB(stack, r=3, g=2, b=1, stretch="lin")
#ciò che diventa rosso è la vegetazione
plotRGB(stack, r=3, g=2, b=1, stretch="hist")
#aumenta molto la discriminanza dei valori intermedi ma praticamente elimina quelli estremi

im.multiframe(1,2)
plotRGB(stack, r=3, g=2, b=1, stretch="lin")
plotRGB(stack, r=3, g=2, b=1, stretch="hist")

#NDVI
?im.ndvi
ndvi=im.ndvi(stack, 3, 2)
dev.off()

#esportazione dati
#funzione di terra
writeRaster(ndvi, "ndvi.tif")
#la esporta nella cartella selezionata come direttoria

#importare: rast, esportare: writeRaster
#selezionando direttoria
#salvando questo dato me lo salva in bianco e nero
#per salvarlo a colori salvo un'immagine e non il dato
im.multiframe(2,2)
plot(green)
plot(red)
plot(NIR)
plot(ndvi)

#file png
#file immagine con risoluzione predefinita non molto alta
png("figura1.png")
im.multiframe(2,2)
plot(green)
plot(red)
plot(NIR)
plot(ndvi)
dev.off()
#con png apro l'immagine, ci metto tutto quello che voglio dentro 
#poi dev.off() chiude l'immagine
#--> mi salva l'immagine nella cartella

#file pdf
#file vettoriale, risoluzione perfetta anche se si ingrandisce
pdf("figura1.pdf")
im.multiframe(2,2)
plot(green)
plot(red)
plot(NIR)
plot(ndvi)
dev.off()

#pacchetto patchwork prende pacchetti di ggplot e li unisce
plot1=im.ggplot(ndvi)
plot2=im.ridgeline(ndvi,scale=1)
plot1+plot2

#se li esporto con png e pdf non vengono in scala o non vengono proprio, quindi meglio fare lo screenshot
# https://github.com/ducciorocchini/Telerilevamento_2026/tree/main/Drone2
#diventa:
gregt= rast("https://raw.githubusercontent.com/ducciorocchini/Telerilevamento_2026/main/Drone2/DJI_20260409152942_0001_MS_G.TIF")
#cambiare da githuba raw...
#togliere tree perché tree serve solo per la visualizzazione
#aggiungere il nome del file
gregt=flip(gregt)
plot(gregt)

#importing earth data
setwd("C:\\Users\\Marta\\Desktop\\Uni 2\\Telerilevamento geo-ecologico")
list.files()

sat = rast( "ISS074-E-417243.jpg" )
plot(sat)
sat=flip(sat)

