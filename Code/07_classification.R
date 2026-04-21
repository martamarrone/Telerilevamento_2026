# code for classyfing data

library(terra)
library(imageRy)

im.list()
sun=im.import( "Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")

sunc = im.classify(sun, num_cluster= 3, seed=42)
#c'è già un numero definito di cluster che è 3, quindi potevo anche non metterlo
#seed ci permette di dirgli da quale pixel partire, così abbiamo tutti la stessa immagine con gli stessi numeri

can = im.import("dolansprings_oli_2013088_canyon_lrg.jpg" )
#di solito scegliamo il numero di cluster in modo empirico, quindi guardando l'immagine quanti elementi mi aspetto (acqua, roccia, roccia più scura, nuvole)
canc = im.cassify(can, num_cluster = 4, seed =42)
