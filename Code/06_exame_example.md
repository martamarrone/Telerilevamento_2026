# Ice spread: titolo della presentazione 🧊
cancelletto e spazio per fare il titolo: più cancelletti per titoli minori
per emoji due punti e nome dell'emoji

<img width="1800" height="1201" alt="Melecio-Zambrano_LMZ_low_sun_ice_melt" src="https://github.com/user-attachments/assets/3db1956b-d964-478f-9c25-dc12a8636234" />

Intro alle mie analisi (perché ho scelto l'area di studio etc..)

## immagine da internet

Immagine scaricata da [Earth Observatory] (https://science.nasa.gov/earth/earth-observatory/)

Pacchetti usati in R:

```r
library(terra) #
library(imageRy)
```
(3 back ticks, alt96)

Importazione dei dati tramite setwd():
```r
("C:\\Users\\Marta\\Desktop\\Uni 2\\Telerilevamento geo-ecologico")
getwd()
list.files()
```

Dati importati via `rast()`:
```
sat= rast("ISS074-E-417243.jpg")
```
chiedi a chatGPT dei consigli

## Plottaggio delle singole bande 
Le singole bande sono state plottate usando un multiframe:
```
im.multiframe(1,2)
plot(sat[[1]])
plot(sat[[2]])
```

<img width="480" height="480" alt="prime_due_bande" src="https://github.com/user-attachments/assets/86e5247c-987f-4629-bdfb-c582a1cffc02" />

>Nota: l'imagine è già stata analizzata da Earth Observatory

Elenco puntato:
+ punto
+ punto
+ punto

<img width="480" height="480" alt="ist" src="https://github.com/user-attachments/assets/dace51ab-bf0c-48fe-bba0-6c54aa859526" />
