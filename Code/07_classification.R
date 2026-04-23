# code for classyfing data

library(terra)
library(imageRy)
library(ggplot2)
library(patchwork)

im.list()
sun=im.import( "Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")

sunc = im.classify(sun, num_cluster= 3, seed=42)
#c'è già un numero definito di cluster che è 3, quindi potevo anche non metterlo
#seed ci permette di dirgli da quale pixel partire, così abbiamo tutti la stessa immagine con gli stessi numeri

can = im.import("dolansprings_oli_2013088_canyon_lrg.jpg" )
#di solito scegliamo il numero di cluster in modo empirico, quindi guardando l'immagine quanti elementi mi aspetto (acqua, roccia, roccia più scura, nuvole)
canc = im.cassify(can, num_cluster = 4, seed =42)
#vediamo che la banda dell'acqua ha accorpato anche le nuvole quindi in realtà ci vorrebbero più classi (cluster)

m2006 = im.import("matogrosso_ast_2006209_lrg.jpg")           
m1992 = im.import("matogrosso_l5_1992219_lrg.jpg")  

m1992c = im.classify(m1992, seed = 42, num_cluster =2 )
m2006c = im.classify(m2006, seed = 42, num_cluster =2 )

#assegnare le etiche alle classe
levels(m1992c) = data.frame(
  value = c(1,2),
  label = c("forest", "human")
)

levels(m2006c) = data.frame(
  value = c(1,2), 
  label = c ("forest", "human")
)

m1992c = im.classify(m1992, seed = 42, num_cluster =2 )
m2006c = im.classify(m2006, seed = 42, num_cluster =2 )

setwd("C:\\Users\\Marta\\Desktop\\Uni 2\\Telerilevamento geo-ecologico")

#importare la funzione dallo script scaricato
source("im.barplot.R")

#farlo manualmente
#calcolare frequenze
freq(m1992c)
freq(m2006c)
# --> proporzioni (e poi moltiplicando per 100 ottengo le percentuali)
perc1992 = ((freq(m1992c))$count/ncell(m1992))*100
perc2006 = ((freq(m2006c))$count/ncell(m2006))*100
#creare colonne della tabella
tab = data.frame(
  class = c("forest","human"),
  perc1992 = c(83, 17),
  perc2006 = c(55, 45)
)

p1 = ggplot(tab, aes(x=class, y=perc1992, color = class)) +   #struttura
  geom_bar(stat="identity", fill = "white") + #definisce la geometria mentre fill dice il colore
  ylim(c(0,100)) + 
  #theme(legend.position = "none") #per rimuovere la legenda se i colori sono gli stessi e quindi due legende non servono
  #theme_minimal() se voglio rimuovere lo sfondo grigio, ma a lui non piace
  #theme_dark "bruttissimo"
#la funzione aesthetic ha x, y e colore
#mettiamo color = class così mette un colore per forest e uno per human

p2 = ggplot(tab, aes(x=class, y=perc2006, color = class)) +   
  geom_bar(stat="identity", fill = "brown") +
  ylim(c(0,100))

p1 + p2 
#posso farlo grazie al pacchetto patchwork

#le scale delle y sono diverse
#--> yllim
