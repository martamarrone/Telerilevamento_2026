
// Estrazione confini del parco 
var parcoDataset = ee.FeatureCollection('WCMC/WDPA/current/polygons')   // Estrae il dataset relativo al Tesso Nilo da un database sulle aree protette presente su GEE 
  .filter(ee.Filter.eq('NAME_ENG', 'Tesso Nilo'));                      // Ho usato il nome in inglese del parco per filtrare l'estrazione

var Sumatra_Test = parcoDataset.geometry();                             // Prende il dataset appena salvato e ne estrae la geometria
Map.centerObject(Sumatra_Test, 11);

// Filtro per le nuvole, Landsat 8 (QA, USGS)
function prepareLandsat8(image) {
  var qa = image.select('QA_PIXEL');
  var cloudShadowBitMask = 1 << 3;                         
  var cloudBitMask = 1 << 5;                               
  var mask = qa.bitwiseAnd(cloudShadowBitMask).eq(0)       // Maschera per le ombre delle nuvole
               .and(qa.bitwiseAnd(cloudBitMask).eq(0));    // Maschera per le nuvole
               
  // Calibrazione dei dati Landsat8
  // Trasformazione dal formato in cui i dati sono immagazzinati (16 bit) a valori di riflettanza (tra 0 e 1)
  var opticalBands = image.select('SR_B.').multiply(0.0000275).add(-0.2);
  
  // Rinominazione delle bande per renderle identiche a quelle di Sentinel2
  var renamedBands = opticalBands.select(                    // Prende le bande calibrate e le rinomina
    ['SR_B2', 'SR_B3', 'SR_B4', 'SR_B5', 'SR_B6', 'SR_B7'],  // Nomi Landsat8
    ['B2',    'B3',    'B4',    'B8',    'B11',   'B12']     // Nuovi nomi stile Sentinel2
  );
  
  return renamedBands.updateMask(mask);                      // Prende le bande calibrate e rinominate e vi applica la maschera (mask) per ombre e nuvole                 
}

// Filtro per le nuvole, Sentinel-2 (SCL, ESA) e calibrazione dei dati
function maskAdvancedS2(image) {
  var scl = image.select('SCL');
  var mask = scl.neq(3).and(scl.neq(8)).and(scl.neq(9)).and(scl.neq(10));    // Esclude i pixel che non hanno ombre di nuvole (3), nuvole (8 e 9) o cirri (10)
  return image.updateMask(mask).divide(10000);                               // Applicazione della maschera
                                                                             // E calibrazione da numeri interi a valori di riflettanza (tra 0 e 1)
} 

// Caricamento delle immagini
// 1. 2016 - Landsat8
var colPre = ee.ImageCollection('LANDSAT/LC08/C02/T1_L2')         // Prende le immagini dal database di GEE
               .filterBounds(Sumatra_Test)                        // Selezionando quelle all'interno del confine estratto del parco
               .filterDate('2016-05-01', '2016-10-31')            // Selezionando quelle in questo intervallo di tempo
               .filter(ee.Filter.lt('CLOUD_COVER', 30))           // Selezionando le immagini che hanno meno del 30% di copertura
               .map(prepareLandsat8);                             // Applica la funzione di filtro a tutte le immagini rimaste
var compositePre = colPre.median().clip(Sumatra_Test);            // Per ogni pixel calcola il valore mediano fra tutte le immagini rimaste

// 2. 2021 - Sentinel2 
var colDurante = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
                   .filterBounds(Sumatra_Test)
                   .filterDate('2021-05-01', '2021-10-31')             
                   .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 30)) 
                   .map(maskAdvancedS2);                                  
var compositeDurante = colDurante.median().clip(Sumatra_Test);

// 3. 2025 - Sentinel-2 
var colDopo = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
                .filterBounds(Sumatra_Test)
                .filterDate('2025-05-01', '2025-10-31')            
                .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 40))       //Ho dovuto impostare un filtro più permissivo sulla presenza delle nuvole 
                .map(maskAdvancedS2);                                  
var compositeDopo = colDopo.median().clip(Sumatra_Test);                               

// Visualizzazione
var vizFalsoColore = {             // Crea una impostazione di visualizzazione a falsi colori 
  bands: ['B8', 'B4', 'B3'],  
  min: 0,
  max: 0.3
};

Map.addLayer(compositePre, vizFalsoColore, '1. 2016 - Landsat 8');    // Aggiunge l'immagine composita ottenuta per ogni anno applicando la visualizzazione a falsi colori  
Map.addLayer(compositeDurante, vizFalsoColore, '2. 2021 - S2');
Map.addLayer(compositeDopo, vizFalsoColore, '3. 2025 - S2');

// Esportazione delle 6 bande su Drive

var bandsToExport = ['B2', 'B3', 'B4', 'B8', 'B11', 'B12'];          // Vettore con le bande da esportare

Export.image.toDrive({
  image: compositePre.select(bandsToExport),
  description: 'TessoNilo_Pre_2016',
  folder: 'GEE_exports',
  fileNamePrefix: 'tessonilo_2016_pre',
  region: Sumatra_Test, scale: 10, crs: 'EPSG:4326', maxPixels: 1e13
});

Export.image.toDrive({
  image: compositeDurante.select(bandsToExport),
  description: 'TessoNilo_Durante_2021',
  folder: 'GEE_exports',
  fileNamePrefix: 'tessonilo_2021_durante',
  region: Sumatra_Test, scale: 10, crs: 'EPSG:4326', maxPixels: 1e13
});

Export.image.toDrive({
  image: compositeDopo.select(bandsToExport),
  description: 'TessoNilo_Dopo_2025',
  folder: 'GEE_exports',
  fileNamePrefix: 'tessonilo_2025_dopo',
  region: Sumatra_Test, scale: 10, crs: 'EPSG:4326', maxPixels: 1e13
});
