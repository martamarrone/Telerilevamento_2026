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
