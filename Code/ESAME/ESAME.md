>> ### Esame di Telerilevamento geo-ecologico in R 2026
> > Marta Marrone mat. 0001237880

# Analisi temporale della degradazione della foresta tropicale nel Parco Nazionale di Tesso Nilo, Sumatra 
### 🐯🦧🐘 Monitoraggio della perdita di habitat di specie endemiche per via della trasformazione in colture di palma da olio
---

<img width="512" height="394" alt="Dargo4" src="https://github.com/user-attachments/assets/d4bb40ba-e20c-4ce5-ad92-137608c44ae3" />

> Elefante di Sumatra (*Elephas maximus sumatranus*)

# 🌏 Introduzione e area di studio 

Il progetto parte dal desiderio di indagare un esempio di uno dei maggiori fattori di rischio per la fauna selvatica, la perdita e degradazione degli habitat. Sull'isola di Sumatra, il **Parco Nazionale di Tesso Nilo** è un'area protetta situata nella provincia di Riau, comprende un ecosistema di foresta tropicale che rappresenta uno degli ultimi habitat fondamentali per specie endemiche e in pericolo critico di estinzione come la **tigre di Sumatra** (*Panthera tigris sumatrae*), l'**orangotango di Sumatra** (*Pongo abelii*) e l'**elefante di Sumatra** (*Elephas maximus sumatranus*) (Susanto et al., 2026).  Nonostante l'area sia protetta dalla presenza del Parco Nazionale, istituito nel 2004, la foresta ad oggi ha perso più del 50% della sua copertura totale (Susanto et al., 2026). Negli ultimi decenni Riau è stata la provincia con il più alto tasso di deforestazione dell'intera Sumatra, principalmente a causa dell'espansione illegale delle coltivazioni di palma da olio, anche all'interno dei confini del Parco (Pramudita et al., 2025).


<img width="1753" height="1240" alt="Sumatra_Tesso_Nilo" src="https://github.com/user-attachments/assets/8469fc04-0e3e-456e-a858-eaf399b28831" />

> Area di studio: Parco Nazionale di Tasso Nilo, Riau, Sumatra.
> Immagine realizzata tramite il software QGIS

L'obiettivo del progetto è quindi di analizzare e rendere evidente, attraverso il telerilevamento, l'aumento del suolo nudo e della vegetazione secondaria (habitat degradati e soprattutto coltivazion di palma da olio) a scapito della riduzione della foresta primaria del parco. In questo studio sono stati presi in esame gli anni più recenti della trasformazione:

- **2016** (Utilizzato come baseline): situazione del parco prima dell'intensificarsi delle pressioni antropiche più recenti.
- **2021** (Fase intermedia): grande avanzamento della deforestazione con l'aumento di suolo nudo.
- **2025** (Situazione attuale): larga espansione e stabilizzazione delle colture di palme da olio.

# Materiali e metodi

Le immagini sono state acquisite tramite il portale [Google Earth Engine](https://earthengine.google.com/), ritagliando l'area sui confini ufficiali del Parco Nazionale di Tesso Nilo (dataset `WCMC/WDPA/current/polygons`). Per ciascun anno le immagini sono state filtrate sulla stagione secca (maggio-ottobre), in modo da minimizzare la copertura nuvolosa e gli effetti fenologici stagionali, e sono state selezionate come mediana della collezione filtrata.

- **2016**: composito Landsat 8 (Collection 2, Level 2), con maschera delle nuvole tramite banda QA_PIXEL e applicazione dei fattori di scala ufficiali USGS. Le bande sono state rinominate (SR_B2→B2, SR_B3→B3, SR_B4→B4, SR_B5→B8, SR_B6→B11, SR_B7→B12) per renderle direttamente confrontabili con quelle di Sentinel-2.
- **2021** e **2025**: composito Sentinel-2, con maschera delle nuvole tramite banda SCL.

Le sei bande esportate per ciascun anno sono: **B2 (Blu), B3 (Verde), B4 (Rosso), B8 (NIR), B11 (SWIR1), B12 (SWIR2)**.

> [!NOTE]
> Il codice JavaScript utilizzato per l'acquisizione e l'esportazione delle immagini è disponibile nel file `ESAME.js`.

### Caratteristiche dei sensori

| Sensore | Anno | Risoluzione spaziale (bande usate) |
| :---: | :---: | :--- |
| **Landsat 8** | 2016 | 30 m |
| **Sentinel-2** | 2021, 2025 | 10-20 m |

| Banda | Nome comune | Su R |
| :---: | :---: | :--- |
| **B2** | Blu | 1 |
| **B3** | Verde | 2 |
| **B4** | Rosso | 3 |
| **B8** | NIR | 4 |
| **B11** | SWIR 1 | 5 |
| **B12** | SWIR 2 | 6 |

### Pacchetti utilizzati in R

````r
library(terra)        # Lavorazione raster e immagini satellitari
library(imageRy)      # Velocizzazione di analisi, calcoli e visualizzazioni
library(viridis)      # Palette di colori
library(ggplot2)      # Creazione di grafici a barre
library(ggridges)     # Creazione del ridgeline plot  
library(patchwork)    # Visualizzazione rapida del confronto tra i grafici a barre
````

# Importazione e visualizzazione delle immagini

````r
setwd("C:\\Users\\mmmar\\Desktop\\Uni2\\Telerilevamento geo-ecologico\\Progetto")   # Impostazione della working directory

tn_2016 = rast("immagini_tessonilo/tessonilo_2016_pre.tif")                         # Importazione delle immagini
tn_2021 = rast("immagini_tessonilo/tessonilo_2021_durante.tif")
tn_2025 = rast("immagini_tessonilo/tessonilo_2025_dopo.tif")
````

## Bande spettrali

````r
plot(tn_2016, col = magma(100))     # Visualizzazione delle bande importate per ogni immagine
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
> Tutte le immagini in questo progetto sono state esportate impostando larghezza, altezza e risoluzione (300 DPI) per assicurare una maggiore visibilità di tutte le caratteristiche.

## Composizione in colori naturali (True Color)

````r
par(mfrow=c(1,3))                                         # Divisione pannello grafico in una riga e tre colonne
plotRGB(tn_2016, 3, 2, 1, stretch="lin", main = "2016")   # Rappresentazione immagini colori naturali 
plotRGB(tn_2021, 3, 2, 1, stretch="lin", main = "2021")   # r = 3 = B4, g = 2 = B3, b = 1 = B2
plotRGB(tn_2025, 3, 2, 1, stretch="lin", main = "2025")
````

<img width="4500" height="1500" alt="tn_tc" src="https://github.com/user-attachments/assets/ff4357b4-4b59-4fd2-a2e0-39001c33875e" />

> Confronto in colori naturali (RGB 3,2,1) tra 2016, 2021 e 2025.

## Composizione in falsi colori (NIR-Red-Green)

````r
par(mfrow=c(1,3))
plotRGB(tn_2016, 4, 3, 2, stretch="lin", main = "2016")   # Rappresentazione immagini in falsi colori
plotRGB(tn_2021, 4, 3, 2, stretch="lin", main = "2021")   # 4 = B8, 3 = B4, 2 = B3 
plotRGB(tn_2025, 4, 3, 2, stretch="lin", main = "2025")
````

<img width="4500" height="1500" alt="tn_fc" src="https://github.com/user-attachments/assets/ff84fb2b-c3e8-4d4d-a6af-c4d963dde85d" />

> La vegetazione sana appare in rosso acceso, mentre il suolo nudo e le infrastrutture assumono tonalità chiare/spente. Il confronto tra i tre anni evidenzia già a colpo d'occhio la contrazione della componente rossa più intensa, corrispondente alla foresta primaria, in particolare nel settore orientale del parco.

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

> Analizzando le immagini risultanti dalla visualizzazione del DVI si intravede il nucleo della foresta ma esso non appare particolarmente distinto dall'ambiente circostante.

### Differenze temporali del DVI

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

> Valori positivi (arancio/rosso) = DVI diminuito nel tempo = possibile perdita di vegetazione; valori negativi (azzurro/blu) = DVI aumentato = possibile guadagno. Nel complesso il verde/giallo-verde (variazione quasi nulla) domina su gran parte dell’area e le macchie colorate sono sparse, senza disegnare un confine netto fra nucleo della foresta ed esterno.

## NDVI (Normalized Difference Vegetation Index)

$` NDVI = \frac{NIR - RED}{NIR + RED} `$

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

> **LIMITAZIONI NDVI**
>
> Nelle immagini realizzate con l'NDVI la differenza tra la foresta e l'ambiente circostante diventa molto più nitida per gli anni 2016 e 2021. Allo stesso modo nell'anno 2025 i valori alti dell'NDVI aumentano di molto e si espandono anche nella parte occidentale del parco, creando così l'impressione che la foresta si sia ampliata.
>
> Dall'articolo di Susanto et al. (2026) sappiamo che non è così. L'NDVI non riesce quindi a discriminare efficientemente tra vegetazione secondaria (habitat degradati e colture di palma da olio) e vegetazione primaria (la foresta).

### Differenze temporali dell'NDVI

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

> I colori dominanti sono il verde e il blu (rispettivamente cambiamento quasi nullo e guadagno di vegetazione), il limite della foresta rimane poco distintivo.

Per via delle limitazioni rscontrate nell'utilizzo dell'NDVI, ho deciso di cercare altri indici che dessero informazioni aggiuntive in modo da rendere più chiara l'evoluzione del paesaggio all'interno del Parco di Tesso Nilo.

## NDWI di Gao (Normalized Difference Water Index)

L'NDWI di Gao sfrutta la differente risposta spettrale tra la banda del vicino infrarosso (NIR, B8) e la banda SWIR1 (B11), ed è particolarmente sensibile al contenuto d'acqua e all'umidità della vegetazione. A differenza del solo NDVI, permette di cogliere meglio la differenza di umidità tra la foresta primaria (più umida, chiusa e ombreggiata) e la vegetazione secondaria/palma da olio (più aperta e meno idratata).

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

<img width="4500" height="1500" alt="tn_ndwi" src="https://github.com/user-attachments/assets/98e6c314-e637-48e2-a87d-d6acd52eadaa" />

> Dallo studio dell'NDWI la differenza tra la foresta e l'ambiente circostante diventa assolutamente netta. Anche nel 2025, nelle aree in cui l'NDVI aveva valori molto simili a quelli dell'area forestale, l'NDWI ci permette di discriminare in modo netto la vegetazione secondaria dalla foresta e risulta evidente il notevole restringimento di quest'ultima negli anni. 

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

> Valori positivi (arancio/rosso) = NDWI diminuito nel tempo = perdita di umidità/struttura della chioma; valori negativi (blu) = NDWI aumentato = maggiore umidità/struttura della chioma. E' chiaro il nucleo della foresta che rimane invariato (verde).

## UI (Urban Index)

Infine è stato calcolato l'Urban Index, che sfrutta il contrasto tra la banda SWIR2 (B12), particolarmente sensibile a suoli nudi e superfici impermeabili, e la banda NIR (B8), sensibile alla vegetazione. 

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

> A differenza degli indici precedenti l'UI ha valori più alti in corrispondenza di suoli nudi e infrastrutture.
>
> Generalmente usato per rendere evidente l'ampliazione di una zona urbana, in realtà i valori di riflettanza della banda SWIR2 per infrastrutture urbane e suoli nudi sono molto simili. Questo lo rende particolarmente utile per evidenziare l'espansione di questi due elementi a scapito della foresta, possiamo notare infatti che si ristringono intorno ad essa anno dopo anno.
>
> Quindi l'NDWI e l'UI ci danno informazioni complementari, il primo si concentra sulla vegetazione della foresta primaria mentre il secondo sugli impatti antropici che la minacciano e danneggiano.

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

> Valori negativi (blu) = UI aumentato nel tempo = aumento della superficie occupata dal suolo nudo/infrastrutture; valori positivi (arancio/rosso) = UI diminuito nel tempo = aumento della superficie occupata dalla vegetazione. I valori più bassi si concentrano soprattutto ai margini del parco, quindi è una confermadell'espansione di suolo nuso/infrastrutture intorno al nucleo forestale residuo.

# Classificazione

Per stimare la frequenza delle diverse coperture del suolo (foresta primaria, vegetazione secondaria/palma da olio, suolo nudo/infrastrutture) è stata scelta una classificazione a 3 classi (prima non superviosionata e poi corretta su base ecosistemica), applicata sia all'NDVI sia all'NDWI, così da poter confrontare la capacità dei due indici di discriminare le classi di interesse.

## Classificazione non supervisionata dell'NDVI

````r
class_ndvi_2016_raw = im.classify(ndvi_2016, num_clusters = 3, seed = 42)   # Raggruppamento non supervisionato dei pixel in 3 classi
class_ndvi_2021_raw = im.classify(ndvi_2021, num_clusters = 3, seed = 42)   # Impostare un seme serve per rendere il risultato riproducibile
class_ndvi_2025_raw = im.classify(ndvi_2025, num_clusters = 3, seed = 42)

par(mfrow=c(1,3))
plot(class_ndvi_2016_raw, main="Classi NDVI 2016")
plot(class_ndvi_2021_raw, main="Classi NDVI 2021")
plot(class_ndvi_2025_raw, main="Classi NDVI 2025")
````

<img width="4500" height="1500" alt="classi_NDVI_1" src="https://github.com/user-attachments/assets/7a5d9824-cf99-49ef-837f-d5a698359179" />

> Ogni immagine risultante ha tre classi di pixel che dipendono solo dal valore dell'indice in quel pixel, non c'è corrispondenza ecologica tra le classi delle tre immagini.

## Calibrazione su base ecologica e riclassificazione NDVI

Le classi individuate dall'algoritmo non supervisionato sono state riordinate sulla base della conoscenza ecologica dell'area, per corrispondere in modo coerente a:
- **Classe 1**: Suolo nudo/Infrastrutture
- **Classe 2**: Palma da olio/Vegetazione secondaria
- **Classe 3**: Vegetazione primaria

````r
class_ndvi_2016 = subst(class_ndvi_2016_raw, from = c(1, 2, 3), to = c(1, 3, 2))                                               # Riordinazione e assegnazione delle classi corrette 
class_ndvi_2021 = subst(class_ndvi_2021_raw, from = c(1, 2, 3), to = c(3, 1, 2))
class_ndvi_2025 = subst(class_ndvi_2025_raw, from = c(1, 2, 3), to = c(1, 2, 3))

colori = c("suolo nudo" = "burlywood4", "vegetazione secondaria" = "darkgoldenrod1", "vegetazione primaria" = "forestgreen")   # Scelta e assegnazione dei colori per ogni classe

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
par(mfrow=c(2,3))                                                           # Suddivisione del pannello grafico in due righe e 3 colonne
plot(class_ndvi_2016, col=colori, main="Classi NDVI 2016", legend = FALSE)  # La prima riga contiene le classificazioni finali a partire dall'NDVI
plot(class_ndvi_2021, col=colori, main="Classi NDVI 2021", legend = FALSE)
plot(class_ndvi_2025, col=colori, main="Classi NDVI 2025", legend = FALSE)
plot(class_ndwi_2016, col=colori, main="Classi NDWI 2016", legend = FALSE)  # La seconda riga contiene le classificazioni finali a partire dall'NDWI
plot(class_ndwi_2021, col=colori, main="Classi NDWI 2021", legend = FALSE)
plot(class_ndwi_2025, col=colori, main="Classi NDWI 2025", legend = FALSE)
````

<img width="3600" height="2400" alt="classi_confronto" src="https://github.com/user-attachments/assets/e75eaafa-865a-4484-85d4-ac03c7bcfb7f" />

> **CONFRONTO NDVI E NDWI**
>
> Realizzando la divisione in classi con l'NDVI risulta evidente ciò che s'ipotiazzava già con la sola visualizzazione degli indici, ovvero: l'NDVI non riesce a discriminare bene questi due tipi di vegetazione e, nuovamente, la foresta nel 2025 sembrerebbe espandersi.
>
> Invece, la classificazione fatta a partire dall'NDWI ci mostra come nel 2021, anno di intensa deforestazione, aumenti la quantità di suolo nudo intorno alla foresta. Mentre nel 2025 ad aumentare notevolmente è la quantità di vegetazione secondaria fenomeno che, grazie alla letteratura scientifica, sappiamo essere riconducibile all'espansione e stabilizzazione delle colture di palme da olio.
>
> Per questi motivi, per le prossime analisi, utilizzerò l'NDWI invece dell'NDVI, in modo da ottenere risultati più rappresentativi.

## Calcolo delle frequenze percentuali per classe

Per quantificare quanto terreno è occupato dalle varie classi durante gli anni, calcoliamo le frequenze percentuali:

````r
f2016 = freq(class_ndwi_2016)                                                 # Calcolo della frequenza assoluta dei pixel per ciascuna classe
f2021 = freq(class_ndwi_2021) 
f2025 = freq(class_ndwi_2025)

prop2016 = f2016$count / sum(f2016$count)                                     # Calcolo della frequenza relativa
prop2021 = f2021$count / sum(f2021$count)
prop2025 = f2025$count / sum(f2025$count)

# Siccome l'immagine dell'area del parco contiene molti pixel senza alcun valore (NA, spazi bianchi intorno al parco),
# la frequenza relativa non è calcolata rispetto al numero totale di pixel ma al numero totale di pixel che sono associati a una classe 

perc2016 = prop2016 * 100                                                     # Trasformazione delle frequenze relative in valori percentuali
perc2021 = prop2021 * 100 
perc2025 = prop2025 * 100

tabella = data.frame(                                                         # Creazione di una tabella riassuntiva per esporre i risultati
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

I dati mostrano che la vegetazione primaria, dopo un lieve aumento tra il 2016 e il 2021 (dal 42.71% al 44.60%), subisce un calo netto nel 2025 (35.24%), con una perdita complessiva di circa 7,5 punti percentuali rispetto al 2016. Parallelamente, la vegetazione secondaria (riconducibile in larga parte alla palma da olio) cresce in modo marcato, passando dal 37.81% al 48.04% tra il 2016 e il 2025. Il suolo nudo/infrastrutture, invece, pur aumentando la sua presenza intorno alla foresta, diminuisce in modo diffuso con un netto calo soprattutto tra il 2021 e il 2025.


## Grafici a barre di confronto

Ora utilizziamo il pacchetto `ggplot2` per realizzare dei grafici a barre che rappresentino visivamente le frequenze relative percentuali delle varie classi, successivamente utilizziamo il pacchetto `patchwork` per affiancarli e quindi confrontarli più rapidamente.

````r
p1 = ggplot(tabella, aes(x = class, y = percentuale2016, fill = class)) +    # Asse x: nome della classe, asse y = la sua percentuale, colore = colore della classe
  geom_bar(stat = "identity") +                                              # L'altezza delle barre è presa dal valore y stesso  
  ylim(c(0,100)) +                                                           # Valori dell'asse y da 0 a 100 
  labs(title="2016", x="Classe", y="Percentuale (%)") +        
  scale_fill_manual(values = colori) +                                       # Palette precedentemente decisa per le classi
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

p1 + p2 + p3                                                                # Visualizzazione dei grafici affiancati
````

<img width="4500" height="1800" alt="grafico_barre_confronto" src="https://github.com/user-attachments/assets/cf2d2e7e-2151-4249-903a-98886f9703fe" />

## Ridgeline plot della distribuzione dell'NDWI

Per confrontare in un unico grafico la distribuzione continua dei valori di NDWI nei tre anni è stato costruito uno stack dei tre raster e generato un grafico a cresta (ridgeline plot).

````r
ndwi_stack = c(ndwi_2016, ndwi_2021, ndwi_2025)
names(ndwi_stack) = c("NDWI 2016", "NDWI 2021", "NDWI 2025")

im.ridgeline(ndwi_stack, scale=1, palette="plasma") + theme_minimal()   # La funzione si appoggia al pacchetto ggridges 
````

<img width="1800" height="1200" alt="ridgeline_plot" src="https://github.com/user-attachments/assets/35b52c65-62de-4d19-ab55-5d16e434b89b" />

> La distribuzione dei valori dell'NDWI si sposta gradualmente verso valori più bassi: nel 2016 si vede un netto picco nei valori più alti (la foresta), mentre negli anni successi i valori si spostano fino a formare un picco di valori medi nel 2025.
>
> L'NDWI è sensibile al contenuto in acqua della vegetazione e alla sua umidità, valori più alti rappresentano quindi un ecosistema con vegetazione più strutturata e complessa (Gao, 1996). Quindi questo spostamento nei valori dell'NDWI si può interpretare come una trasformazione del suolo da un habitat più complesso e strutturato (la foresta) a habitat più degradati o con meno complessità (monocolture, suolo nudo e infrastrutture urbane), in cui avviene molta più evaporazione e che sono meno in grado di trattenere l'acqua. 

# Conclusioni

L'analisi multitemporale condotta sul Parco Nazionale di Tesso Nilo tra il 2016 e il 2025 conferma un progressivo processo di conversione della foresta primaria, concentrato in particolare nel settore orientale del parco, a vantaggio soprattutto della vegetazione secondaria riconducibile alla palma da olio e, in misura minore, di suoli nudi e infrastrutture. La classificazione ecologica calibrata mostra che la foresta primaria è passata dal 42.71% del 2016 al 35.24% del 2025, mentre la vegetazione secondaria è cresciuta dal 37.81% al 48.04% nello stesso periodo.

Allo stesso modo il confronto tra le classi del 2016 e del 2021, anche essendo visivamente chiaro, a livello quantitativo mostra differenze piccole ma opposte a quelle che ci si aspetterebbe. Per esempio sembrerebbe indicare un leggero aumento della foresta primaria, invece di una diminuzione (come è effettivamente avvenuto, Susanto et al., 2026), questo potrebbe essere implicabile a due fattori: 
+ *L'utilizzo del Satellite Landsat8 per l'anno 2016* - questo satellite ha una risoluzione di 30 m per tutte le bande mentre Sentinel2 ha una risoluzione di 10 m per il NIR e 20 per lo SWIR1. Quindi il satellite Sentinel2 potrebbe essere stato più efficacie nel distinguere le parti forestali più frammentate nel settore ovest del parco.
+ *La variabilità climatica* - Nel 2015 e nel 2016 si è osservato uno dei più forti eventi di El Niño registrato nella storia recente, invece il 2021 era un anno con clima soggetto agli eventi de La Niña (International Research Institute for Climate and Society, 2026). Questo per l'Indonesia vuol dire che il 2016 è stato un anno particolarmente secco con poche precipitazioni (meno umidità e acqua nelle chiome) mentre il 2021 è stato un anno più umido con più precipitazioni (più umidità e acqua nelle chiome), le classificazioni presenti in questo progetto sono state realizzate a partire dall'NDWI che è particolarmente sensibile proprio al fattore umidità e contenuto d'acqua nella vegetazione.

In questo modo il progetto mostra l'importanza di usare in modo integrato diversi indici per avere una visione più completa possibile di ciò che si sta monitorando. Il solo NDVI si è rivelato per esempio uno strumento parzialmente limitato nel distinguere con nettezza le tre classi di copertura, motivo per cui l'analisi è stata affiancata dal calcolo dell'NDWI di Gao, più sensibile al contenuto idrico e quindi capace di discriminare meglio la foresta primaria (più chiusa e umida) dalla vegetazione secondaria, e dall'Urban Index, utile per isolare più chiaramente l'espansione dei suoli nudi e delle infrastrutture ai margini della foresta.

In conclusione questo studio identifica un trend coerente a quello riportato in letteratura, evidenziando un'importante riduzione della copertura forestale nel Parco Nazionale del Tesso Nilo a favore dell'espansione (in gran parte illegale) delle colture di palme da olio, questo corrisponde a una grave perdita di habitat per specie endemiche già a rischio di estinzione. Si delinea quindi come necessario il monitoraggio satellitare continuo per tutelare quest'area di cruciale importanza per la biodiversità

# 🌐 Sitografia e bibliografia

### Contesto ecologico e conservazionistico
- Pramudita, S. A. E., Mamesah, T. P. C. (2025). *The Impact of Deforestation on Protected Animal Populations in Sumatra: Analysis of Global Forest Watch and IUCN Red List Data*. Vivaterra: Journal of Nature, Plants and Animals Studies, 1(1), 27-35.
- Susanto, D., Atmojo, J.T., Nugroho, P. et al. (2026). *Unraveling the vulnerability of protected areas to oil palm expansion: The case from Tesso Nilo National Park, Sumatra, Indonesia*. Environmental Management 76, 8.
- Gao B. (1996). *NDWI—A normalized difference water index for remote sensing of vegetation liquid water from space*
- International Research Institute for Climate and Society. (2026). *ENSO Climate Forecasts*. Columbia Climate School, Columbia University. https://iri.columbia.edu/our-expertise/climate/forecasts/enso/current/ [consultato il 14 luglio 2026]

### Piattaforme dati e librerie software
- **Google Earth Engine**: https://earthengine.google.com/
- **CRAN Repository**: https://cran.r-project.org/ 
- **World Database on Protected Areas (WDPA)**

# Grazie per l'attenzione! 🐯🦧🐘
