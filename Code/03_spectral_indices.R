library(terra)
library(imageRy)
library(viridis)

im.list()
#usiamo l'immagine "matogrosso_l5_1992219_lrg.jpg" 
#si può cercare su internet 
#in questo caso non hanno messo tutte le bande ma solo 
mato1992=im.import("matogrosso_l5_1992219_lrg.jpg")
mato1992=flip(mato1992)
#ruotato secondo il nord
#l1=NIR l2=red l3=green
im.plotRGB(mato1992, 1,2,3)
#abbiamo messo l'infrarosso come componenete rossa, quindi tutto il rosso è la foresta pluviale

#banda del NIR sulla componente verde
im.plotRGB(mato1992, 2,1,3)

#banda del NIR sulla componente blu
im.plotRGB(mato1992, 3,2,1)

mato1992
#riflettanza fino a 250 invece che tra 0 e 1, perché?
#se la mantenessimo tra 0 e 1 avremmo tutti i pixel con un valore diverso tra 0 e 1 (valori continui)
#--> eliminiamo numeri continui, usiamo quelli discreti (digital numbers)
#perché 250?

#importiamo anche l'immagine di mato del 2006, un altro satellite (ast)
mato2006=im.import("matogrosso_ast_2006209_lrg.jpg")  
mato2006=flip(mato2006)
#flip perché è un jpeg quindi non le informazioni legate a un sistema di riferimento

im.plotRGB(mato2006,1,2,3)
#questa volta l'acqua si distingue dal suolo
par(mfrow=c(1,2))
im.plotRGB(mato1992, 1,2,3)
plotRGB(mato2006,1,2,3)

im.plotRGB(mato1992, 1,2,3, stretch="hist")
#per cambiare il tipo di stretch che di default è lineare
#mette in risalto gli errori dell'immagine, per vedere se alcune irregolarità sono solo errori grafici o meno

#NIR nel verde e poi nel rosso
im.plotRGB(mato1992, 2,1,3)
im.plotRGB(mato2006, 2,1,3)
im.plotRGB(mato1992, 3,2,1)
im.plotRGB(mato2006,3,2,1)
#con l'infrarosso sul blu vediamo molto bene il giallo
#il giallo è molto evidente alla retina e in questo caso rappresenta il suolo
#in questa versione il suolo nudo è molto evidente

#DVI
dvi1992=mato1992[[1]] - mato1992[[2]]
#quindi NDVI non normalizzato (senza denominatore)
#quindi riflettanza nella banda dell'infrarosso - riflettanza nella banda del rosso
plot(dvi1992)

#8 bit
#NIR - red = 255 - 0 = 255 massimo dvi
#NIR - red = 0 - 255 = -255 minimo dvi
#--> dvi a 8 bit varia tra -255 e 255

# 4 bit
#NIR - red = 16 - 0 = 16 massimo dvi
#NIR - red = 0 - 16 = -16 minimo dvi 

dvi2006=mato2006[[1]] - mato2006[[2]]
plot(dvi2006)

#NDVI
#8 bit
#NIR - red = (255 - 0)/(255 + 0) = 1 massimo dvi
#NIR - red = (0 - 255)/(255 + 0) = -1 minimo dvi
#--> dvi a 8 bit varia tra -1 e 1

# 4 bit
#NIR - red = (16 - 0)(16 + 0) = 1 massimo dvi
#NIR - red = (0 - 16)(16 + 0) = -1 minimo dvi

#--> minimo e massimo teorico sono sempre 1 e -1 quindi posso fare il confronto

ndvi1992=(mato1992[[1]] - mato1992[[2]])/(mato1992[[1]] + mato1992[[2]])
plot(ndvi1992)
ndvi2006=(mato2006[[1]] - mato2006[[2]])/(mato2006[[1]] + mato2006[[2]])
plot(ndvi2006)

#cambiamo i colori nella palette inferno
library(viridis)
plot(ndvi1992, col=inferno(100))
plot(ndvi2006, col=inferno(100))

#processo semplificato con imageRy
dvi1992=im.dvi(mato1992,1,2)
dvi2006=im.dvi(mato2006,1,2)
plot(dvi1992, col=inferno(100))
plot(dvi2006, col=inferno(100))

ndvi1992=im.ndvi(mato1992,1,2)
ndvi2006=im.ndvi(mato2006,1,2)
plot(ndvi1992, col=mako(100)) #possiamo anche cambiare colore
plot(ndvi2006, col=mako(100))


par(mfrow=c(2,2))
plot(ndvi1992, col=magma(100))
plot(ndvi2006, col=magma(100))
plot(ndvi1992, col=magma(100)) 
plot(ndvi2006, col=magma(100))
