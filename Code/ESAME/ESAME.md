>> ### Esame di Telerilevamento geo-ecologico in R 2026
> > Marta Marrone mat. [INSERISCI MATRICOLA]

# Analisi temporale della degradazione della foresta tropicale nel Parco Nazionale di Tesso Nilo, Sumatra 
### 🐯🦧🐘 Monitoraggio della perdita di habitat di specie endemiche per via della trasformazione in colture di palma da olio
---

<img width="512" height="394" alt="Dargo4" src="https://github.com/user-attachments/assets/d4bb40ba-e20c-4ce5-ad92-137608c44ae3" />

> Elefante di Sumatra (*Elephas maximus sumatranus*)

# 🌏 Introduzione e area di studio 

Il progetto parte dal desiderio di indagare un esempio di uno dei maggiori fattori di rischio per la fauna selvatica, la perdita e degradazione degli habitat. Sull'isola di Sumatra, il **Parco Nazionale di Tesso Nilo** è un'area protetta situata nella provincia di Riau, comprende un ecosistema di foresta tropicale che rappresenta uno degli ultimi habitat fondamentali per specie endemiche e in pericolo critico di estinzione come la **tigre di Sumatra** (*Panthera tigris sumatrae*), l'**orangotango di Sumatra** (*Pongo abelii*) e l'**elefante di Sumatra** (*Elephas maximus sumatranus*) (Susant et al., 2026).  Nonostante l'area sia protetta dalla presenza del Parco Nazionale, istituito nel 2004, la foresta ad oggi ha perso più del 50% della sua copertura totale (Susant et al., 2026). Negli ultimi decenni Riau è stata la provincia con il più alto tasso di deforestazione dell'intera Sumatra, principalmente a causa dell'espansione illegale delle coltivazioni di palma da olio, anche all'interno dei confini del Parco (Pramudita et al., 2025).


<img width="1753" height="1240" alt="Sumatra_Tesso_Nilo" src="https://github.com/user-attachments/assets/8469fc04-0e3e-456e-a858-eaf399b28831" />

> Area di studio: Parco Nazionale di Tasso Nilo, Riau, Sumatra.
> Immagine realizzata tramite il software QGIS


L'obiettivo del progetto è quindi di analizzare e rendere evidente, attraverso il telerilevamento, l'aumento del suolo nudo e della vegetazione secondaria (habitat degradati e soprattutto coltivaziono di palama da olio) a scapito della riduzione della foresta primaria del parco. In questo studio sono stati presi in esame gli anni più recenti della trasformazione:

- **2016** (Utilizzato come baseline): situazione del parco prima dell'intensificarsi delle pressioni antropiche più recenti.
- **2021** (Fase intermedia): avanzamento della deforestazione con l'aumento di suolo nudo.
- **2025** (Situazione attuale): larga espansione e stabilizzazione delle colture di palme da olio.


# Materiali e metodi

Le immagini sono state acquisite tramite il portale [Google Earth Engine](https://earthengine.google.com/), ritagliando l'area sui confini ufficiali del Parco Nazionale di Tesso Nilo (dataset `WCMC/WDPA/current/polygons`). Per ciascun anno le immagini sono state filtrate sulla stagione secca (maggio-ottobre), in modo da minimizzare la copertura nuvolosa e gli effetti fenologici stagionali, e sono state selezionate come mediana della collezione filtrata.

- **2016**: composito Landsat 8 (Collection 2, Level 2), con maschera delle nuvole tramite banda QA_PIXEL e applicazione dei fattori di scala ufficiali USGS. Le bande sono state rinominate (SR_B2→B2, SR_B3→B3, SR_B4→B4, SR_B5→B8, SR_B6→B11, SR_B7→B12) per renderle direttamente confrontabili con quelle di Sentinel-2.
- **2021** e **2025**: composito Sentinel-2 SR Harmonized, con maschera delle nuvole tramite banda SCL.

Le sei bande esportate per ciascun anno sono: **B2 (Blu), B3 (Verde), B4 (Rosso), B8 (NIR), B11 (SWIR1), B12 (SWIR2)**.

> [!NOTE]
> Il codice JavaScript utilizzato per l'acquisizione e l'esportazione delle immagini è disponibile nel file `code.js`.

### Caratteristiche dei sensori

| Sensore | Anno | Risoluzione spaziale (bande usate) |
| :---: | :---: | :--- |
| **Landsat 8** | 2016 | 30 m (ricampionata/rinominata per coincidere con S2) |
| **Sentinel-2** | 2021, 2025 | 10 m |

| Banda | Nome comune |
| :---: | :--- |
| **B2** | Blu |
| **B3** | Verde |
| **B4** | Rosso |
| **B8** | Vicino Infrarosso (NIR) |
| **B11** | SWIR 1 |
| **B12** | SWIR 2 |


### Pacchetti utilizzati in R

````r
library(terra)
library(imageRy)
library(viridis)
library(ggplot2)
library(patchwork)
library(ggridges)
````

# Importazione e visualizzazione delle immagini

````r
setwd("C:\\Users\\mmmar\\Desktop\\Uni2\\Telerilevamento geo-ecologico\\Progetto") #impostare la working directori

tn_2016 = rast("immagini_tessonilo/tessonilo_2016_pre.tif")        #importazione delle immagini
tn_2021 = rast("immagini_tessonilo/tessonilo_2021_durante.tif")
tn_2025 = rast("immagini_tessonilo/tessonilo_2025_dopo.tif")
````

## Bande spettrali

````r
plot(tn_2016, col = magma(100))
plot(tn_2021, col = magma(100))
plot(tn_2025, col = magma(100))
````

<img width="3600" height="2400" alt="bande_2016" src="https://github.com/user-attachments/assets/7d3c9f3d-76ea-448c-b8aa-4d2a52df8677" />

> Visualizzazione delle 6 bande spettrali (B2, B3, B4, B8, B11, B12) dell'anno 2016.

<img width="3600" height="2400" alt="bande_2021" src="https://github.com/user-attachments/assets/729d9481-bf38-4519-93fe-478587ecb7ed" />

> Visualizzazione delle 6 bande spettrali (B2, B3, B4, B8, B11, B12) dell'anno 2021.

<img width="3600" height="2400" alt="bande_2025" src="https://github.com/user-attachments/assets/e5c4c631-80f5-40e2-a228-effa5f5f271b" />

> Visualizzazione delle 6 bande spettrali (B2, B3, B4, B8, B11, B12) dell'anno 2025.

> [!NOTE]
> Tutte le immagini in questo progetto sono state esportate impostando larghezza (12 o 15, unità: inches), altezza (8 o 5, unità: inches) e risoluzione (300 DPI) per assicurare una maggiore visibilità di tutte le caratteristiche.

## Composizione in colori naturali (True Color)

````r
par(mfrow=c(1,3))
plotRGB(tn_2016, 3, 2, 1, stretch="lin", main = "2016")
plotRGB(tn_2021, 3, 2, 1, stretch="lin", main = "2021")
plotRGB(tn_2025, 3, 2, 1, stretch="lin", main = "2025")
dev.off()
````

<img width="4500" height="1500" alt="tn_tc" src="https://github.com/user-attachments/assets/ff4357b4-4b59-4fd2-a2e0-39001c33875e" />

> Confronto in colori naturali (RGB 3,2,1) tra 2016, 2021 e 2025.

## Composizione in falsi colori (NIR-Red-Green)

````r
par(mfrow=c(1,3))
plotRGB(tn_2016, 4, 3, 2, stretch="lin", main = "2016")
plotRGB(tn_2021, 4, 3, 2, stretch="lin", main = "2021")
plotRGB(tn_2025, 4, 3, 2, stretch="lin", main = "2025")
dev.off()
````

<img width="4500" height="1500" alt="tn_fc" src="https://github.com/user-attachments/assets/ff84fb2b-c3e8-4d4d-a6af-c4d963dde85d" />

> Confronto in falsi colori (RGB 4,3,2): la vegetazione sana appare in rosso acceso, mentre il suolo nudo e le infrastrutture assumono tonalità chiare/spente. Il confronto tra i tre anni evidenzia già a colpo d'occhio la contrazione della componente rossa più intensa, corrispondente alla foresta primaria, in particolare nel settore orientale del parco.

# 🛰️ Indici 

## DVI (Difference Vegetation Index)

$` DVI = NIR - RED `$

````r
dvi_2016 = im.dvi(tn_2016, 4, 3)
dvi_2021 = im.dvi(tn_2021, 4, 3)
dvi_2025 = im.dvi(tn_2025, 4, 3)

par(mfrow=c(1,3)) 
plot(dvi_2016, col=inferno(100), main="DVI 2016") 
plot(dvi_2021, col=inferno(100), main="DVI 2021") 
plot(dvi_2025, col=inferno(100), main="DVI 2025")
````

<img width="4500" height="1500" alt="tn_dvi" src="https://github.com/user-attachments/assets/fd1b6451-3015-4244-8512-786388e387e7" />

## Differenze temporali del DVI

````r
ddvi_16_21 = dvi_2016 - dvi_2021
ddvi_21_25 = dvi_2021 - dvi_2025
ddvi_16_25 = dvi_2016 - dvi_2025

par(mfrow=c(1,3))
plot(ddvi_16_21, col=turbo(100), main="Diff DVI 2016 - 2021")
plot(ddvi_21_25, col=turbo(100), main="Diff DVI 2021 - 2025")
plot(ddvi_16_25, col=turbo(100), main="Diff DVI 2016 - 2025 (Prima - Dopo)")
````

<img width="4500" height="1500" alt="tn_ddvi" src="https://github.com/user-attachments/assets/5f9e6300-ac7a-46c4-b7ec-b8ce107b4b88" />

## NDVI (Normalized Difference Vegetation Index)

$NDVI = \frac{NIR - RED}{NIR + RED}$

````r
ndvi_2016 = im.ndvi(tn_2016, 4, 3)
ndvi_2021 = im.ndvi(tn_2021, 4, 3)
ndvi_2025 = im.ndvi(tn_2025, 4, 3)

par(mfrow=c(1,3)) 
plot(ndvi_2016, col=inferno(100), main="NDVI 2016") 
plot(ndvi_2021, col=inferno(100), main="NDVI 2021") 
plot(ndvi_2025, col=inferno(100), main="NDVI 2025")
````

<img width="4500" height="1500" alt="tn_ndvi" src="https://github.com/user-attachments/assets/08418a4c-4d41-4533-84f1-c97670a9f395" />

> **COMMENTO**
>
> [Spazio per il tuo commento personale: descrivi qui cosa noti confrontando i valori di NDVI tra 2016, 2021 e 2025 nelle diverse zone del parco]

## Differenze temporali dell'NDVI

````r
dndvi_16_21 = ndvi_2016 - ndvi_2021
dndvi_21_25 = ndvi_2021 - ndvi_2025
dndvi_16_25 = ndvi_2016 - ndvi_2025

par(mfrow=c(1,3))
plot(dndvi_16_21, col=turbo(100), main="Diff NDVI 2016 - 2021")
plot(dndvi_21_25, col=turbo(100), main="Diff NDVI 2021 - 2025")
plot(dndvi_16_25, col=turbo(100), main="Diff NDVI 2016 - 2025 (Prima - Dopo)")
````

<img width="4500" height="1500" alt="tn_dndvi" src="https://github.com/user-attachments/assets/5f26b14a-f474-4a86-ac1c-1b3bd586dc20" />

## NDWI di Gao (Normalized Difference Water Index)

L'NDWI di Gao sfrutta la differente risposta spettrale tra la banda del vicino infrarosso (NIR, B8) e la banda SWIR1 (B11), ed è particolarmente sensibile al contenuto d'acqua e all'umidità della vegetazione. È stato utilizzato in questo progetto perché, a differenza del solo NDVI, permette di cogliere meglio la differenza di umidità tra la foresta primaria (più umida, chiusa e ombreggiata) e la vegetazione secondaria/palma da olio (più aperta e meno idratata).

$` NDWI = \frac{NIR - SWIR1}{NIR + SWIR1} `$

````r
ndwi_2016 = (tn_2016[[4]] - tn_2016[[5]]) / (tn_2016[[4]] + tn_2016[[5]])
ndwi_2021 = (tn_2021[[4]] - tn_2021[[5]]) / (tn_2021[[4]] + tn_2021[[5]])
ndwi_2025 = (tn_2025[[4]] - tn_2025[[5]]) / (tn_2025[[4]] + tn_2025[[5]])

par(mfrow=c(1,3)) 
plot(ndwi_2016, col=inferno(100), main="NDWI 2016") 
plot(ndwi_2021, col=inferno(100), main="NDWI 2021") 
plot(ndwi_2025, col=inferno(100), main="NDWI 2025")
````

L'utilizzo combinato di più indici nasce dalla necessità di superare i limiti del solo NDVI, che da solo non è risultato sufficientemente efficace nel discriminare in modo netto la foresta primaria residua dalla vegetazione secondaria (palma da olio) e dalle aree antropizzate.

<img width="4500" height="1500" alt="tn_ndwi" src="https://github.com/user-attachments/assets/98e6c314-e637-48e2-a87d-d6acd52eadaa" />

> **COMMENTO**
>
> [Spazio per il tuo commento personale: descrivi qui come l'NDWI evidenzia meglio dell'NDVI la contrazione della foresta primaria umida, in particolare nel settore ovest del parco]

## Differenze temporali dell'NDWI

````r
dndwi_16_21 = ndwi_2016 - ndwi_2021
dndwi_21_25 = ndwi_2021 - ndwi_2025
dndwi_16_25 = ndwi_2016 - ndwi_2025

par(mfrow=c(1,3))
plot(dndwi_16_21, col=turbo(100), main="Diff NDWI 2016 - 2021")
plot(dndwi_21_25, col=turbo(100), main="Diff NDWI 2021 - 2025")
plot(dndwi_16_25, col=turbo(100), main="Diff NDWI 2016 - 2025 (Prima - Dopo)")
````

<img width="4500" height="1500" alt="tn_diff_ndwi" src="https://github.com/user-attachments/assets/24ebab59-1c94-43a5-88df-87c1a800c544" />

## UI (Urban Index)

L'Urban Index sfrutta il contrasto tra la banda SWIR2 (B12), sensibile a suoli nudi e superfici impermeabili, e la banda NIR (B8), sensibile alla vegetazione. È stato incluso in questo progetto perché evidenzia in modo più diretto rispetto agli indici di vegetazione l'espansione dei suoli nudi e delle infrastrutture (strade, piazzole, insediamenti) ai margini della foresta primaria residua.

$` UI = \frac{SWIR2 - NIR}{SWIR2 + NIR} `$

````r
ui_2016 = (tn_2016[[6]] - tn_2016[[4]]) / (tn_2016[[6]] + tn_2016[[4]])
ui_2021 = (tn_2021[[6]] - tn_2021[[4]]) / (tn_2021[[6]] + tn_2021[[4]])
ui_2025 = (tn_2025[[6]] - tn_2025[[4]]) / (tn_2025[[6]] + tn_2025[[4]])

par(mfrow=c(1,3)) 
plot(ui_2016, col=inferno(100), main="UI 2016") 
plot(ui_2021, col=inferno(100), main="UI 2021") 
plot(ui_2025, col=inferno(100), main="UI 2025")
````

<img width="4500" height="1500" alt="tn_ui" src="https://github.com/user-attachments/assets/1e49ac8e-77c2-4cf7-af7a-e7fab66abb42" />

> **COMMENTO**
>
> [Spazio per il tuo commento personale: descrivi qui dove si concentra l'espansione dei suoli nudi/infrastrutture secondo l'UI, e se coincide con le aree di conversione della foresta primaria]

## Differenze temporali dell'UI

````r
dui_16_21 = ui_2016 - ui_2021
dui_21_25 = ui_2021 - ui_2025
dui_16_25 = ui_2016 - ui_2025

par(mfrow=c(1,3))
plot(dui_16_21, col=turbo(100), main="Diff UI 2016 - 2021")
plot(dui_21_25, col=turbo(100), main="Diff UI 2021 - 2025")
plot(dui_16_25, col=turbo(100), main="Diff UI 2016 - 2025 (Prima - Dopo)")
````

<img width="4500" height="1500" alt="tn_diff_ui" src="https://github.com/user-attachments/assets/7d389e9f-5925-4e99-84c5-b2de5dfbb0be" />

# 🗂️ Classificazione

Per stimare la frequenza delle diverse coperture del suolo (foresta primaria, vegetazione secondaria/palma da olio, suolo nudo/infrastrutture) è stata scelta una classificazione non supervisionata a 3 classi, applicata sia all'NDVI sia all'NDWI, così da poter confrontare la capacità dei due indici di discriminare le classi di interesse.

## Classificazione non supervisionata dell'NDVI

````r
class_ndvi_2016_raw = im.classify(ndvi_2016, num_clusters = 3, seed = 42)
class_ndvi_2021_raw = im.classify(ndvi_2021, num_clusters = 3, seed = 42)
class_ndvi_2025_raw = im.classify(ndvi_2025, num_clusters = 3, seed = 42)

par(mfrow=c(1,3))
plot(class_ndvi_2016_raw, main="Classi NDVI 2016")
plot(class_ndvi_2021_raw, main="Classi NDVI 2021")
plot(class_ndvi_2025_raw, main="Classi NDVI 2025")
````

<img width="4500" height="1500" alt="classi_NDVI_1" src="https://github.com/user-attachments/assets/7a5d9824-cf99-49ef-837f-d5a698359179" />

## Calibrazione su base ecologica e riclassificazione NDVI

Le classi individuate dall'algoritmo non supervisionato sono state riordinate sulla base della conoscenza ecologica dell'area, per corrispondere in modo coerente a:
- **Classe 1**: Suolo nudo/Infrastrutture
- **Classe 2**: Palma da olio/Vegetazione secondaria
- **Classe 3**: Vegetazione primaria

````r
class_ndvi_2016 = subst(class_ndvi_2016_raw, from = c(1, 2, 3), to = c(1, 3, 2))
class_ndvi_2021 = subst(class_ndvi_2021_raw, from = c(1, 2, 3), to = c(3, 1, 2))
class_ndvi_2025 = subst(class_ndvi_2025_raw, from = c(1, 2, 3), to = c(1, 2, 3))

colori = c("suolo nudo" = "burlywood4", "vegetazione secondaria" = "darkgoldenrod1", "vegetazione primaria" = "forestgreen")

par(mfrow=c(1,3))
plot(class_ndvi_2016, col=colori, main="Classi NDVI 2016")
plot(class_ndvi_2021, col=colori, main="Classi NDVI 2021")
plot(class_ndvi_2025, col=colori, main="Classi NDVI 2025")

legend("bottomleft", 
       legend = names(colori), 
       fill = colori, 
       bg = "white",
       xpd = TRUE)
````

<img width="4500" height="1500" alt="classi_NDVI" src="https://github.com/user-attachments/assets/77c50c1b-c811-407d-bf39-398d2a079206" />

## Classificazione non supervisionata dell'NDWI e calibrazione ecologica

````r
class_ndwi_2016_raw = im.classify(ndwi_2016, num_clusters = 3, seed = 42)
class_ndwi_2021_raw = im.classify(ndwi_2021, num_clusters = 3, seed = 42)
class_ndwi_2025_raw = im.classify(ndwi_2025, num_clusters = 3, seed = 42)
````

<img width="4500" height="1500" alt="classi_NDWI_1" src="https://github.com/user-attachments/assets/3615695f-d10b-4613-a6e4-88c1b67ccbe9" />


````r
class_ndwi_2016 = subst(class_ndwi_2016_raw, from = c(1, 2, 3), to = c(1, 3, 2))
class_ndwi_2021 = subst(class_ndwi_2021_raw, from = c(1, 2, 3), to = c(3, 2, 1))
class_ndwi_2025 = subst(class_ndwi_2025_raw, from = c(1, 2, 3), to = c(1, 2, 3))

par(mfrow=c(1,3))
plot(class_ndwi_2016, col=colori, main="Classi NDWI 2016")
plot(class_ndwi_2021, col=colori, main="Classi NDWI 2021")
plot(class_ndwi_2025, col=colori, main="Classi NDWI 2025")

legend("bottomleft", 
       legend = names(colori), 
       fill = colori, 
       bg = "white",
       xpd = TRUE)
````

<img width="4500" height="1500" alt="classi_NDWI" src="https://github.com/user-attachments/assets/83c86708-eca8-404d-9cf1-e438dc67360b" />

## Confronto tra la classificazione NDVI e la classificazione NDWI

````r
par(mfrow=c(2,3))
plot(class_ndvi_2016, col=colori, main="Classi NDVI 2016", legend = FALSE)
plot(class_ndvi_2021, col=colori, main="Classi NDVI 2021", legend = FALSE)
plot(class_ndvi_2025, col=colori, main="Classi NDVI 2025", legend = FALSE)
plot(class_ndwi_2016, col=colori, main="Classi NDWI 2016", legend = FALSE)
plot(class_ndwi_2021, col=colori, main="Classi NDWI 2021", legend = FALSE)
plot(class_ndwi_2025, col=colori, main="Classi NDWI 2025", legend = FALSE)
````

<img width="3600" height="2400" alt="classi_confronto" src="https://github.com/user-attachments/assets/e75eaafa-865a-4484-85d4-ac03c7bcfb7f" />

> **COMMENTO**
>
> [Spazio per il tuo commento personale: quale dei due indici (NDVI o NDWI) discrimina meglio le tre classi nel tuo caso, e perché]

## Calcolo delle frequenze percentuali per classe

````r
f2016 = freq(class_ndwi_2016) 
f2021 = freq(class_ndwi_2021) 
f2025 = freq(class_ndwi_2025)

prop2016 = f2016$count / sum(f2016$count) 
prop2021 = f2021$count / sum(f2021$count)
prop2025 = f2025$count / sum(f2025$count) 

perc2016 = prop2016 * 100 
perc2021 = prop2021 * 100 
perc2025 = prop2025 * 100

tabella = data.frame(
  class = c("suolo nudo", "vegetazione secondaria", "vegetazione primaria"),
  percentuale2016 = perc2016,
  percentuale2021 = perc2021,
  percentuale2025 = perc2025
)

tabella
````

| Classe | Percentuale 2016 | Percentuale 2021 | Percentuale 2025 |
| :--- | :---: | :---: | :---: |
| **Suolo nudo** | 19.48 % | 19.10 % | 16.72 % |
| **Vegetazione secondaria** | 37.81 % | 36.30 % | 48.04 % |
| **Vegetazione primaria** | 42.71 % | 44.60 % | 35.24 % |

I dati confermano quantitativamente quanto osservato nelle mappe: la vegetazione primaria, dopo un lieve aumento tra il 2016 e il 2021 (dal 42.71% al 44.60%), subisce un calo netto nel 2025 (35.24%), con una perdita complessiva di circa 7,5 punti percentuali rispetto al 2016. Parallelamente, la vegetazione secondaria (riconducibile in larga parte alla palma da olio) cresce in modo marcato, passando dal 37.81% al 48.04% tra il 2016 e il 2025. Il suolo nudo/infrastrutture, invece, mostra una lieve diminuzione percentuale complessiva, pur restando presente in modo diffuso ai margini del parco.

## Grafici a barre di confronto

````r
p1 = ggplot(tabella, aes(x = class, y = percentuale2016, fill = class)) + 
  geom_bar(stat = "identity") + 
  ylim(c(0,100)) + 
  labs(title="2016", x="Classe", y="Percentuale (%)") +
  scale_fill_manual(values = colori) +
  theme(legend.position="none")

p2 = ggplot(tabella, aes(x = class, y = percentuale2021, fill = class)) + 
  geom_bar(stat = "identity") + 
  ylim(c(0,100)) + 
  labs(title="2021", x="Classe", y="Percentuale (%)") +
  scale_fill_manual(values = colori) +
  theme(legend.position="none")

p3 = ggplot(tabella, aes(x = class, y = percentuale2025, fill = class)) + 
  geom_bar(stat = "identity") + 
  ylim(c(0,100)) + 
  labs(title="2025", x="Classe", y="Percentuale (%)") +
  scale_fill_manual(values = colori) +
  theme(legend.position="none")

p1 + p2 + p3
````

<img width="4500" height="1800" alt="grafico_barre_confronto" src="https://github.com/user-attachments/assets/cf2d2e7e-2151-4249-903a-98886f9703fe" />

## Ridgeline plot della distribuzione dell'NDWI

Per confrontare in un unico grafico la distribuzione continua dei valori di NDWI nei tre anni è stato costruito uno stack dei tre raster e generato un grafico a cresta (ridgeline plot).

````r
ndwi_stack = c(ndwi_2016, ndwi_2021, ndwi_2025)
names(ndwi_stack) = c("NDWI 2016", "NDWI 2021", "NDWI 2025")

im.ridgeline(ndwi_stack, scale=1, palette="plasma") + theme_minimal()
````

<img width="1800" height="1200" alt="ridgeline_plot" src="https://github.com/user-attachments/assets/35b52c65-62de-4d19-ab55-5d16e434b89b" />

> **COMMENTO**
>
> [Spazio per il tuo commento personale: descrivi come si sposta la distribuzione dell'NDWI tra il 2016, il 2021 e il 2025, e cosa indica questo spostamento in termini di umidità/integrità della foresta]

# 📝 Conclusioni

L'analisi multitemporale condotta sul Parco Nazionale di Tesso Nilo tra il 2016 e il 2025 conferma un progressivo processo di conversione della foresta primaria, concentrato in particolare nel settore occidentale del parco, a vantaggio della vegetazione secondaria riconducibile alla palma da olio e, in misura minore, di suoli nudi e infrastrutture. La classificazione ecologica calibrata mostra che la foresta primaria è passata dal 42.71% del 2016 al 35.24% del 2025, mentre la vegetazione secondaria è cresciuta dal 37.81% al 48.04% nello stesso periodo.

Il solo NDVI si è rivelato uno strumento parzialmente limitato nel distinguere con nettezza le tre classi di copertura, motivo per cui l'analisi è stata affiancata dal calcolo dell'NDWI di Gao, più sensibile al contenuto idrico e quindi capace di discriminare meglio la foresta primaria (più chiusa e umida) dalla vegetazione secondaria, e dall'Urban Index, utile per isolare più chiaramente l'espansione dei suoli nudi e delle infrastrutture ai margini della foresta.

Questi risultati sono coerenti con quanto riportato in letteratura sulla provincia di Riau, storicamente una delle aree a più alto tasso di deforestazione dell'intera Sumatra a causa dell'espansione delle piantagioni di palma da olio, e sottolineano l'importanza del monitoraggio satellitare continuo per la tutela di un'area cruciale per la sopravvivenza di specie in pericolo critico come la tigre e l'orangotango di Sumatra.

# 🌐 Sitografia e bibliografia

### Contesto ecologico e conservazionistico
- Margono, B. A., Turubanova, S., Zhuravleva, I., Potapov, P., Tyukavina, A., Baccini, A., Goetz, S., Hansen, M. C. (2012). *Mapping and monitoring deforestation and forest degradation in Sumatra (Indonesia) using Landsat time series data sets from 1990 to 2010*. Environmental Research Letters, 7(3), 034010. Studio di riferimento sulla perdita di foresta primaria a Sumatra, incluso il ruolo della provincia di Riau (dove si trova Tesso Nilo) come una delle aree a maggiore tasso di deforestazione dell'isola.
- Luskin, M. S., Albert, W. R., Tobler, M. W. (2017). *Sumatran tiger survival threatened by deforestation despite increasing densities in parks*. Nature Communications, 8, 1783. Analizza il legame tra perdita di foresta e declino delle popolazioni di tigre di Sumatra, citando esplicitamente Tesso Nilo tra i paesaggi con più alto tasso di deforestazione (2000-2012).
- Lenzen, M., Moran, D., Kanemoto, K., Foran, B., Lobefaro, L., Geschke, A. (2012). *International trade drives biodiversity threats in developing nations*. Nature, 486, 109-112. Discute il ruolo del commercio internazionale, incluso l'olio di palma indonesiano e malese, come driver indiretto delle minacce alla biodiversità.
- Pramudita, S. A. E., Mamesah, T. P. C. (2025). *The Impact of Deforestation on Protected Animal Populations in Sumatra: Analysis of Global Forest Watch and IUCN Red List Data*. Vivaterra: Journal of Nature, Plants and Animals Studies, 1(1), 27-35. Fornisce stime aggiornate sulle popolazioni di orangotango, tigre ed elefante di Sumatra e sul ruolo delle piantagioni di palma da olio e acacia nella deforestazione di Riau, Jambi e Sumatra del Sud.
- Susanto, D., Atmojo, J.T., Nugroho, P. et al. (2026). *Unraveling the vulnerability o0f protected areas to oil palm expansion: The case from Tesso Nilo National Park, Sumatra, Indonesia*. Environmental Management 76, 8.
- https://wwf.panda.org/es/?70060/Elephants-released-in-Indonesias-Tesso-Nilo-National-Park
- https://www.sumatranelephantproject.org/

### Piattaforme dati e librerie software
- **Google Earth Engine**: https://earthengine.google.com/ (Piattaforma cloud per il pre-processing e l'estrazione dei dati raster).
- **CRAN Repository**: https://cran.r-project.org/ (Documentazione ufficiale dei pacchetti R utilizzati: `terra`, `ggplot2`, `imageRy`, `viridis`, `patchwork`, `ggridges`).
- **Copernicus Data Space Ecosystem**: https://dataspace.copernicus.eu/ (Consultato per la verifica delle specifiche tecniche delle bande spettrali di Sentinel-2).
- **World Database on Protected Areas (WDPA)**: dataset dei confini del Parco Nazionale di Tesso Nilo utilizzato in Google Earth Engine (`WCMC/WDPA/current/polygons`).

# Grazie per l'attenzione! 🐯🌴
