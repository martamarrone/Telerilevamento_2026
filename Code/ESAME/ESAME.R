# Installazione e caricamento pacchetti

 # install.packages("terra")
 # install.packages("imageRy")
 # install.packages("viridis")
 # install.packages("ggplot2")
 # install.packages("patchwork")
 # install.packages("ggridges")

library(terra)
library(imageRy)
library(viridis)
library(ggplot2)
library(patchwork)
library(ggridges)

# Working directory

setwd("C:\\Users\\mmmar\\Desktop\\Uni2\\Telerilevamento geo-ecologico\\Progetto")

# Caricamento immagini

tn_2016 = rast("C:\\Users\\mmmar\\Desktop\\Uni2\\Telerilevamento geo-ecologico\\Progetto\\immagini_tessonilo\\tessonilo_2016_pre.tif")
tn_2021 = rast("C:\\Users\\mmmar\\Desktop\\Uni2\\Telerilevamento geo-ecologico\\Progetto\\immagini_tessonilo\\tessonilo_2021_durante.tif")
tn_2025 = rast("C:\\Users\\mmmar\\Desktop\\Uni2\\Telerilevamento geo-ecologico\\Progetto\\immagini_tessonilo\\tessonilo_2025_dopo.tif")

# Visualizzazione immagini scomposte in bande

plot(tn_2016, col = magma(100))
plot(tn_2021, col = magma(100))
plot(tn_2025, col = magma(100))

# Esportazione bande

png("output\\bande_2016.png",width = 12, height = 8, units = "in", res = 300)   
plot(tn_2016, col = magma(100))
dev.off()

png("output\\bande_2021.png",width = 12, height = 8, units = "in", res = 300)   
plot(tn_2021, col = magma(100))
dev.off()

png("output\\bande_2025.png",width = 12, height = 8, units = "in", res = 300)   
plot(tn_2025, col = magma(100))
dev.off()

# Plot immagini true colors

 # [[1]] = Banda 2 (Blue), [[2]] = Banda 3 (Green), [[3]] = Banda 4 (Red)
 # [[4]] = Banda 8 (Infrarosso Vicino - NIR), [[5]] = Banda 11 (SWIR 1), [[6]] = Banda 12 (SWIR 2)

par(mfrow=c(1,3))

plotRGB(tn_2016, 3, 2, 1, stretch="lin", main = "2016")
plotRGB(tn_2021, 3, 2, 1, stretch="lin", main = "2021")
plotRGB(tn_2025, 3, 2, 1, stretch="lin", main = "2025")
dev.off()

# Esportazione true colors

png("output\\tn_tc.png", width = 15, height = 5, units = "in", res = 300)
par(mfrow=c(1,3))
plotRGB(tn_2016, 3, 2, 1, stretch="lin", main = "2016")
plotRGB(tn_2021, 3, 2, 1, stretch="lin", main = "2021")
plotRGB(tn_2025, 3, 2, 1, stretch="lin", main = "2025")
dev.off()

# Plot immagini false colors

 # [[1]] = Banda 2 (Blue), [[2]] = Banda 3 (Green), [[3]] = Banda 4 (Red)
 # [[4]] = Banda 8 (Infrarosso Vicino - NIR), [[5]] = Banda 11 (SWIR 1), [[6]] = Banda 12 (SWIR 2)

par(mfrow=c(1,3))

plotRGB(tn_2016, 4, 3, 2, stretch="lin", main = "2016")
plotRGB(tn_2021, 4, 3, 2, stretch="lin", main = "2021")
plotRGB(tn_2025, 4, 3, 2, stretch="lin", main = "2025")
dev.off()

# Esportazione false colors

png("output\\tn_fc.png", width = 15, height = 5, units = "in", res = 300)
par(mfrow=c(1,3))
plotRGB(tn_2016, 4, 3, 2, stretch="lin", main = "2016")
plotRGB(tn_2021, 4, 3, 2, stretch="lin", main = "2021")
plotRGB(tn_2025, 4, 3, 2, stretch="lin", main = "2025")
dev.off()

# Calolo DVI (Difference Vegetation Index)

dvi_2016 = im.dvi(tn_2016, 4, 3)
dvi_2021 = im.dvi(tn_2021, 4, 3)
dvi_2025 = im.dvi(tn_2025, 4, 3)

# Visualizzazione DVI

par(mfrow=c(1,3)) 

plot(dvi_2016, col=inferno(100), main="DVI 2016") 
plot(dvi_2021, col=inferno(100), main="DVI 2021") 
plot(dvi_2025, col=inferno(100), main="DVI 2025")

# Esportazione DVI

png("output\\tn_dvi.png", width = 15, height = 5, units = "in", res = 300)
par(mfrow=c(1,3))
plot(dvi_2016, col=inferno(100), main="DVI 2016") 
plot(dvi_2021, col=inferno(100), main="DVI 2021") 
plot(dvi_2025, col=inferno(100), main="DVI 2025")
dev.off()

# Differenze DVI

ddvi_16_21 = dvi_2016 - dvi_2021
ddvi_21_25 = dvi_2021 - dvi_2025
ddvi_16_25 = dvi_2016 - dvi_2025

# Visualizzazione differenze DVI

par(mfrow=c(1,3))
plot(ddvi_16_21, col=turbo(100), main="Diff DVI 2016 - 2021")
plot(ddvi_21_25, col=turbo(100), main="Diff DVI 2021 - 2025")
plot(ddvi_16_25, col=turbo(100), main="Diff DVI 2016 - 2025 (Prima - Dopo)")

# Esportazione differenze DVI

png("output\\tn_ddvi.png", width = 15, height = 5, units = "in", res = 300)
par(mfrow=c(1,3))
plot(ddvi_16_21, col=turbo(100), main="Diff DVI 2016 - 2021")
plot(ddvi_21_25, col=turbo(100), main="Diff DVI 2021 - 2025")
plot(ddvi_16_25, col=turbo(100), main="Diff DVI 2016 - 2025 (Prima - Dopo)")
dev.off()

# Calcolo NDVI (Normilized Difference Vegetation Index)

ndvi_2016 = im.ndvi(tn_2016, 4, 3)
ndvi_2021 = im.ndvi(tn_2021, 4, 3)
ndvi_2025 = im.ndvi(tn_2025, 4, 3)

# Visualizzazione NDVI

par(mfrow=c(1,3)) 
plot(ndvi_2016, col=inferno(100), main="NDVI 2016") 
plot(ndvi_2021, col=inferno(100), main="NDVI 2021") 
plot(ndvi_2025, col=inferno(100), main="NDVI 2025")

# Esportazione NDVI 

png("output\\tn_ndvi.png", width = 15, height = 5, units = "in", res = 300)
par(mfrow=c(1,3))
plot(ndvi_2016, col=inferno(100), main="NDVI 2016") 
plot(ndvi_2021, col=inferno(100), main="NDVI 2021") 
plot(ndvi_2025, col=inferno(100), main="NDVI 2025")
dev.off()

# Differenze NDVI

dndvi_16_21 = ndvi_2016 - ndvi_2021
dndvi_21_25 = ndvi_2021 - ndvi_2025
dndvi_16_25 = ndvi_2016 - ndvi_2025

# Visualizzazione differnze NDVI

par(mfrow=c(1,3))
plot(dndvi_16_21, col=turbo(100), main="Diff NDVI 2016 - 2021")
plot(dndvi_21_25, col=turbo(100), main="Diff NDVI 2021 - 2025")
plot(dndvi_16_25, col=turbo(100), main="Diff NDVI 2016 - 2025 (Prima - Dopo)")

# Esportazione differnze NDVI

png("output\\tn_dndvi.png", width = 15, height = 5, units = "in", res = 300)
par(mfrow=c(1,3))
plot(dndvi_16_21, col=turbo(100), main="Diff NDVI 2016 - 2021")
plot(dndvi_21_25, col=turbo(100), main="Diff NDVI 2021 - 2025")
plot(dndvi_16_25, col=turbo(100), main="Diff NDVI 2016 - 2025 (Prima - Dopo)")
dev.off()

# Calcolo NDWI di Gao (Normalized Difference Water Index)

ndwi_2016 = (tn_2016[[4]] - tn_2016[[5]]) / (tn_2016[[4]] + tn_2016[[5]])
ndwi_2021 = (tn_2021[[4]] - tn_2021[[5]]) / (tn_2021[[4]] + tn_2021[[5]])
ndwi_2025 = (tn_2025[[4]] - tn_2025[[5]]) / (tn_2025[[4]] + tn_2025[[5]])

# Visualizzazione NDWI

par(mfrow=c(1,3)) 
plot(ndwi_2016, col=inferno(100), main="NDWI 2016") 
plot(ndwi_2021, col=inferno(100), main="NDWI 2021") 
plot(ndwi_2025, col=inferno(100), main="NDWI 2025")

# Esportazione NDWI

png("output\\tn_ndwi.png", width = 15, height = 5, units = "in", res = 300)
par(mfrow=c(1,3))
plot(ndwi_2016, col=inferno(100), main="NDWI 2016") 
plot(ndwi_2021, col=inferno(100), main="NDWI 2021") 
plot(ndwi_2025, col=inferno(100), main="NDWI 2025")
dev.off()

# Differenze NDWI

dndwi_16_21 = ndwi_2016 - ndwi_2021
dndwi_21_25 = ndwi_2021 - ndwi_2025
dndwi_16_25 = ndwi_2016 - ndwi_2025

# Visualizzazione differenze NDWI

par(mfrow=c(1,3))
plot(dndwi_16_21, col=turbo(100), main="Diff NDWI 2016 - 2021")
plot(dndwi_21_25, col=turbo(100), main="Diff NDWI 2021 - 2025")
plot(dndwi_16_25, col=turbo(100), main="Diff NDWI 2016 - 2025 (Prima - Dopo)")

# Esportazione differenze NDWI

png("output\\tn_diff_ndwi.png", width = 15, height = 5, units = "in", res = 300)
par(mfrow=c(1,3))
plot(dndwi_16_21, col=turbo(100), main="Diff NDWI 2016 - 2021")
plot(dndwi_21_25, col=turbo(100), main="Diff NDWI 2021 - 2025")
plot(dndwi_16_25, col=turbo(100), main="Diff NDWI 2016 - 2025 (Prima - Dopo)")
dev.off()

# Calcolo UI (Urban Index)

ui_2016 = (tn_2016[[6]] - tn_2016[[4]]) / (tn_2016[[6]] + tn_2016[[4]])
ui_2021 = (tn_2021[[6]] - tn_2021[[4]]) / (tn_2021[[6]] + tn_2021[[4]])
ui_2025 = (tn_2025[[6]] - tn_2025[[4]]) / (tn_2025[[6]] + tn_2025[[4]])

# Visualizzazione UI

par(mfrow=c(1,3)) 
plot(ui_2016, col=inferno(100), main="UI 2016") 
plot(ui_2021, col=inferno(100), main="UI 2021") 
plot(ui_2025, col=inferno(100), main="UI 2025")

# Esportazione UI 

png("output\\tn_ui.png", width = 15, height = 5, units = "in", res = 300)
par(mfrow=c(1,3))
plot(ui_2016, col=inferno(100), main="UI 2016") 
plot(ui_2021, col=inferno(100), main="UI 2021") 
plot(ui_2025, col=inferno(100), main="UI 2025")
dev.off()

# Differenze UI

dui_16_21 = ui_2016 - ui_2021
dui_21_25 = ui_2021 - ui_2025
dui_16_25 = ui_2016 - ui_2025

# Visualizzazione differenze UI

par(mfrow=c(1,3))
plot(dui_16_21, col=turbo(100), main="Diff UI 2016 - 2021")
plot(dui_21_25, col=turbo(100), main="Diff UI 2021 - 2025")
plot(dui_16_25, col=turbo(100), main="Diff UI 2016 - 2025 (Prima - Dopo)")

# Esportazione differenze UI

png("output\\tn_diff_ui.png", width = 15, height = 5, units = "in", res = 300)
par(mfrow=c(1,3))
plot(dui_16_21, col=turbo(100), main="Diff UI 2016 - 2021")
plot(dui_21_25, col=turbo(100), main="Diff UI 2021 - 2025")
plot(dui_16_25, col=turbo(100), main="Diff UI 2016 - 2025 (Prima - Dopo)")
dev.off()

# Classificazione NDVI non supervisionata ed esportazione

par(mfrow=c(1,3))
class_ndvi_2016_raw = im.classify(ndvi_2016, num_clusters = 3, seed = 42)
class_ndvi_2021_raw = im.classify(ndvi_2021, num_clusters = 3, seed = 42)
class_ndvi_2025_raw = im.classify(ndvi_2025, num_clusters = 3, seed = 42)

png("output\\classi_NDVI_1.png", width = 15, height = 5, units = "in", res = 300)
par(mfrow=c(1,3))
plot(class_ndvi_2016_raw, main="Classi NDVI 2016")
plot(class_ndvi_2021_raw, main="Classi NDVI 2021")
plot(class_ndvi_2025_raw, main="Classi NDVI 2025")
dev.off()

# Calibrazione su base ecologica e riclassificazione NDVI 
 # Classe 1: Suolo nudo/Infrastrutture
 # Classe 2: Palma da olio/Vegetazione secondaria
 # Classe 3: Vegetazione primaria

class_ndvi_2016 = subst(class_ndvi_2016_raw, from = c(1, 2, 3), to = c(1, 3, 2))
class_ndvi_2021 = subst(class_ndvi_2021_raw, from = c(1, 2, 3), to = c(3, 1, 2))
class_ndvi_2025 = subst(class_ndvi_2025_raw, from = c(1 , 2, 3), to = c(1, 2, 3))

colori = c("suolo nudo" = "burlywood4", "vegetazione secondaria" = "darkgoldenrod1", "vegetazione primaria" = "forestgreen")

plot(class_ndvi_2016, col=colori, main="Classi NDVI 2016")
plot(class_ndvi_2021, col=colori, main="Classi NDVI 2021")
plot(class_ndvi_2025, col=colori, main="Classi NDVI 2025")

legend("bottomleft", 
               legend = names(colori), 
               fill = colori, 
               bg = "white",
               xpd = TRUE)

# Esportazione classificazione finale NDVI

png("output\\classi_NDVI.png", width = 15, height = 5, units = "in", res = 300)
par(mfrow=c(1,3))
plot(class_ndvi_2016, col=colori, main="Classi NDVI 2016")
plot(class_ndvi_2021, col=colori, main="Classi NDVI 2021")
plot(class_ndvi_2025, col=colori, main="Classi NDVI 2025")
legend("bottomleft", 
               legend = names(colori), 
               fill = colori, 
               bg = "white",
               xpd = TRUE)
dev.off()

# Classificazione NDWI non supervisionata ed esportazione

class_ndwi_2016_raw = im.classify(ndwi_2016, num_clusters = 3, seed = 42)
class_ndwi_2021_raw = im.classify(ndwi_2021, num_clusters = 3, seed = 42)
class_ndwi_2025_raw = im.classify(ndwi_2025, num_clusters = 3, seed = 42)

png("output\\classi_NDWI_1.png", width = 15, height = 5, units = "in", res = 300)
par(mfrow=c(1,3))
plot(class_ndwi_2016_raw, main="Classi NDWI 2016")
plot(class_ndwi_2021_raw, main="Classi NDWI 2021")
plot(class_ndwi_2025_raw, main="Classi NDWI 2025")
dev.off()

# Calibrazione su base ecologica
 # Classe 1: Suolo nudo/Infrastrutture
 # Classe 2: Palma da olio/Vegetazione secondaria
 # Classe 3: Vegetazione primaria

class_ndwi_2016 = subst(class_ndwi_2016_raw, from = c(1, 2, 3), to = c(1, 3, 2))
class_ndwi_2021 = subst(class_ndwi_2021_raw, from = c(1, 2, 3), to = c(3, 2, 1))
class_ndwi_2025 = subst(class_ndwi_2025_raw, from = c(1 , 2, 3), to = c(1, 2, 3))

# Esportazione classificazione finale NDWI

png("output\\classi_NDWI.png", width = 15, height = 5, units = "in", res = 300)
par(mfrow=c(1,3))
plot(class_ndwi_2016, col=colori, main="Classi NDWI 2016")
plot(class_ndwi_2021, col=colori, main="Classi NDWI 2021")
plot(class_ndwi_2025, col=colori, main="Classi NDWI 2025")

legend("bottomleft", 
       legend = names(colori), 
       fill = colori, 
       bg = "white",
       xpd = TRUE)

dev.off()

# Confronto classificazione NDVI e NDWI

par(mfrow=c(2,3))
plot(class_ndvi_2016, col=colori, main="Classi NDVI 2016", legend = FALSE)
plot(class_ndvi_2021, col=colori, main="Classi NDVI 2021", legend = FALSE)
plot(class_ndvi_2025, col=colori, main="Classi NDVI 2025", legend = FALSE)
plot(class_ndwi_2016, col=colori, main="Classi NDWI 2016", legend = FALSE)
plot(class_ndwi_2021, col=colori, main="Classi NDWI 2021", legend = FALSE)
plot(class_ndwi_2025, col=colori, main="Classi NDWI 2025", legend = FALSE)

# Esportazione confronto classificazione NDVI e NDWI

png("output\\classi_confronto.png", width = 12, height = 8, units = "in", res = 300)
par(mfrow=c(2,3))
plot(class_ndvi_2016, col=colori, main="Classi NDVI 2016", legend = FALSE)
plot(class_ndvi_2021, col=colori, main="Classi NDVI 2021", legend = FALSE)
plot(class_ndvi_2025, col=colori, main="Classi NDVI 2025", legend = FALSE)
plot(class_ndwi_2016, col=colori, main="Classi NDWI 2016", legend = FALSE)
plot(class_ndwi_2021, col=colori, main="Classi NDWI 2021", legend = FALSE)
plot(class_ndwi_2025, col=colori, main="Classi NDWI 2025", legend = FALSE)
dev.off()

# Calcolo della frequenza assoluta dei pixel per ciascuna classe

f2016 = freq(class_ndwi_2016) 
f2021 = freq(class_ndwi_2021) 
f2025 = freq(class_ndwi_2025)

# Calcolo della proporzione (frequenza relativa)

prop2016 = f2016$count / sum(f2016$count) 
prop2021 = f2021$count / sum(f2021$count)
prop2025 = f2025$count / sum(f2025$count) 

# Conversione delle proporzioni in valori percentuali

perc2016 = prop2016 * 100 
perc2021 = prop2021 * 100 
perc2025 = prop2025 * 100

# Creazione del dataframe riassuntivo

tabella = data.frame(
  class = c("suolo nudo", "vegetazione secondaria", "vegetazione primaria"),
  percentuale2016 = perc2016,
  percentuale2021 = perc2021,
  percentuale2025 = perc2025
)

# Generazione dei grafici a barre per gli anni 2016, 2021 e 2025

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

# Visualizzazione confronto grafici a barre 

p1 + p2 + p3

# Esportazione confronto grafici a barre

ggsave("output/grafico_barre_confronto.png", plot = p1 + p2 + p3, width = 15, height = 6, dpi = 300)

  # Ridgeline plot

ndwi_stack = c(ndwi_2016, ndwi_2021, ndwi_2025)
names(ndwi_stack) = c("NDWI 2016", "NDWI 2021", "NDWI 2025")

im.ridgeline(ndwi_stack, scale=1, palette="plasma") + theme_minimal()  

# Esportazione ridgeline plot

png("output/ridgeline_plot.png", width = 12, height = 8, units = "in", res = 300)
plot(im.ridgeline(ndwi_stack, scale=1, palette="plasma") + theme_minimal())
dev.off()
