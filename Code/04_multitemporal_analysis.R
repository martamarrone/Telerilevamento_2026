library(terra)
library(imageRy)

im.list()

EN_01=im.import("EN_01.png")
EN_01=flip(EN_01)

plot(EN_01)
EN_01
#8 bit, 256 valori 

EN_13=im.import("EN_13.png")
EN_13=flip(EN_13)

plot(EN_13)
EN_13

#Differenza
ENdif = EN_01[[1]] - EN_13[[]]
#valori di azoto del primo momento - quelli del secondo
#differenza alta = valori più alti prima (giallo)
#differenza bassa = valori più alti dopo (blu)
dev.off()
plot(ENdif)

#stack immagini dalla groenlandia
gl_00=im.import("greenland.2000.tif")                                
gl_05=im.import("greenland.2005.tif")                                
gl_10=im.import("greenland.2010.tif")                                
gl_15=im.import("greenland.2015.tif")

stack_gl= c(gl_00,gl_05,gl_10,gl_15)

#oppure lo stack si può fare così:
gr = im.import("greenland")

im.multiframe(1,2)
plot(gr[[1]])
plot(gr[[4]])

dif = gr[[4]] - gr[[1]]
dev.off()
plot(dif)

#RGB
RGB = im.plotRGB(gr, 1, 2, 4)
#tutte le zone che hanno temperature più alte nel 2000 vengono rosse, 
#quelle con temperature più alte nel 2005 vengono verdi, quelle con temperature più alte nel 2015 verrano blu)

im.list()
ndvi= im.import("Sentinel2_NDVI")
hist(ndvi)

#kernel density: distribuzione di frequenza non per istogrammi ma per linee continue --> come se portassimo un istogrmma, attraverso un integrale, 
#ad avere barre sempre più strette, quindi ad essere una linea continua

#intall.packages("ggrigis")

im.ridgeline(ndvi, scale=1, "palette=viridis")
#ndvi: nome dell'immagine, scala: massima altezza
#r non ci da diversi plot ma solo uno 

ndvi
#ci sono 4 sources quindi ma mi dà solo un'immagine perché le variabili si chiamano tutte NDVI, quindi le sovrascrive ogni volta

names(ndvi) = c("02feb", "05may","08aug", "11nov")
im.ridgeline(ndvi, scale=2, "palette=viridis")
#scale=1 vuol dire che ogni grafico arriva a massimo la fine del suo rettangolo, scale=2 è carino perch<è gli dà tridimensionalità
#rende il grafico più bello ma non serve a nulla (oltre 2 no)

plot(ndvi[[1]],ndvi[[2]])
#y = x 
#y = a + bx
#a = 0, b=1
abline(0, 1, col="red")
#la linea non è precisamente a 45 gradi perché i range dell'asse x e asse y non sono uguali
#devo renderli uguali
plot(ndvi[[1]],ndvi[[2]]), xlim=c(-0.3,0.9), ylim=c(-0.3,0-9))
abline(0, 1, col="red")

