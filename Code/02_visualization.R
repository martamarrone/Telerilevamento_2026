# R code for visualizing satellite data

install.packages("viridis")
install.packages("devtools")
library(devtools)
install_github("ducciorocchini/imageRy")
install.packages("patchwork")

library(terra)
library(imageRy)
library(viridis)
library(ggplot2)
library(patchwork)

im.list()
# Sentinel bands:
# https://custom-scripts.sentinel-hub.com/custom-scripts/sentinel-2/bands/

b2 = im.import("sentinel.dolomites.b2.tif")

#cambiare colori della foto che abbiamo importato 

cl = colorRampPalette(c("lightsalmon", "magenta", "mediumpurple1"))(100)
#100 sono le sfumature, si possono specificare fuori
#mettiamo c per creare un vettore
plot(b2, col=cl)

#small number of nuances
cl = colorRampPalette(c("lightsalmon", "magenta", "mediumpurple1"))(3)
#pacchetto viridis, con scale di colore per daltonici (no turbo)
#tutti i pacchetti installati si mettono in cima

plot(b2,col=inferno(100))
#il numero di sfumature stavolta è dentro alla funzione come parentesi del colore
plot(b2,col=mako(100))

cl = colorRampPalette(c("gray13", "gray49", "gray95"))(100)
plot(b2, col=cl)

par(mfrow=c(2)
plot(b2,col=inferno(100))
plot(b2, col=cl)

im.multiframe(1,2)
plot(b2,col=inferno(100))
plot(b2, col=cl)

#importare la terza banda
im.list()
#per vedere la lista di tutte le bande di sentinel
b3= im.import("sentinel.dolomites.b3.tif")
#tutte le componenti che riflettono molto il verde in questa banda diventano gialle
#cambiare palette:
plot(b3, col=plasma(100))

#banda 4 e banda 8
b4 = im.import("sentinel.dolomites.b4.tif")
b8= im.import("sentinel.dolomites.b8.tif") 

#esercizio: multiframe con tutte e 4 le bande e con le legende 
par(mfrow=c(2,2)
cl=colorRampPalette(c("lightblue","blue","darkblue"))(100)
plot(b2, col=cl)
cl=colorRampPalette(c("lightgreen","green","darkgreen"))(100)
plot(b3, col=cl)
cl=colorRampPalette(c("pink","red","darkred"))(100)
plot(b4, col=cl)
cl=colorRampPalette(c("salmon1","salmon3","salmon4"))(100)
plot(b8, col=cl)

plot(b2, col=inferno(100))
plot(b3, col=inferno(100))
plot(b4, col=inferno(100))
plot(b8, col=inferno(100))

#stack
sentinel=c(b2,b3,b4,b8)
plot(sentinel)
plot(sentinel, col =inferno(100)) #per cambiare colore
dev.off() #togllie tutte le grafiche, chiude la finestra
    
#fare subsets
names(sentinel)
plot(sentinel$sentinel.dolomites.b8)
plot(sentinel[[1]])
#mi fa vedere solo il layer 1, quindi b2
#non gli piace il dollaro, usiamo [[layer]]

#usiamo ggplot2
#stack
im.list()
b2=im.import(sentinel.dolomites.b2.tif)                         
b3=im.import(sentinel.dolomites.b3.tif)                         
b4=im.import(sentinel.dolomites.b4.tif)
b8=im.import(sentinel.dolomites.b8.tif)

#install.packages("patchwork")
p1=im.ggplot(b8)
p2=im.ggplot(b4)
p1+p2

#creare un multiframe
#1. par(mfrow=c(1,2))
#2. im.multiframe(1,2)
#3. stack
#4. ggplot2 patchwork

#RGB plot
#1. creare lo stack
sentinel=c(b2,b3,b4,b8)

#layer 1 = b2
#layer 2 = b3
#layer 3 = b4
#layer 4 = b8

#2. im.plotRGB #RGB in maiuscolo
#im.plotRGB(nome, componente R, componente G, componente B)
im.plotRGB(sentinel, r=3, g=2, b=1)
#abbiamo usato solo bande di colore del visibile, 
#otteniamo esattamente i colori naturali 
#con cui vedremmo l'immagine da una altezza di 800m

#vogliamo aggiungere la banda infrarosso, quindi dobbiamo toglierne una
#perché si possono mettere massimo 3 bande
