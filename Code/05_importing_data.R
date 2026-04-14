#code to import data

library(terra)
library(viridis)
library(imageRy)

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
