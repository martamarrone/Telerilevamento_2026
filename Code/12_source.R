## Funzione da scaricare per R ##
sun = im.import( "Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")
im.kernel(sun[[1]],stat="sd")
kernsun=im.kernel(sun)

setwd("~/Desktop")
source("im.kernel.txt")
#source è utile quando si vuole richiamare un file di testo che contine la funzione che voglio usare
