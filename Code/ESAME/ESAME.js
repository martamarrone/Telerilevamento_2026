
var parcoDataset = ee.FeatureCollection('WCMC/WDPA/current/polygons')
  .filter(ee.Filter.eq('NAME_ENG', 'Tesso Nilo'));

var Sumatra_Test = parcoDataset.geometry();
Map.centerObject(Sumatra_Test, 11);

// Funzione 1: Pulizia nuvole e RISOLUZIONE DEL BIANCO per Landsat 8 (Collection 2 L2)
function prepareLandsat8(image) {
  var qa = image.select('QA_PIXEL');
  var cloudShadowBitMask = 1 << 3;
  var cloudBitMask = 1 << 5;
  var mask = qa.bitwiseAnd(cloudShadowBitMask).eq(0)
               .and(qa.bitwiseAnd(cloudBitMask).eq(0));
               
  // APPLICAZIONE DEI FATTORI DI SCALA UFFICIALI USGS PER EVITARE LA SATURAZIONE BIANCA
  var opticalBands = image.select('SR_B.').multiply(0.0000275).add(-0.2);
  
  // Rinominazione delle bande per renderle identiche a quelle di Sentinel-2
  var renamedBands = opticalBands.select(
    ['SR_B2', 'SR_B3', 'SR_B4', 'SR_B5', 'SR_B6', 'SR_B7'], // Nomi Landsat
    ['B2',    'B3',    'B4',    'B8',    'B11',   'B12']    // Nuovi nomi stile S2
  );
  
  return renamedBands.updateMask(mask);
}

// Funzione 2: Pulizia avanzata delle nuvole per Sentinel-2 (SCL)
function maskAdvancedS2(image) {
  var scl = image.select('SCL');
  var mask = scl.neq(3).and(scl.neq(8)).and(scl.neq(9)).and(scl.neq(10));
  return image.updateMask(mask).divide(10000);
}

// CARICAMENTO IMMAGINI

// --- 1. PRE-DEFORESTAZIONE (Stagione Secca 2016) - Landsat 8 Calibrato ---
var colPre = ee.ImageCollection('LANDSAT/LC08/C02/T1_L2')
               .filterBounds(Sumatra_Test)
               .filterDate('2016-05-01', '2016-10-31')          
               .filter(ee.Filter.lt('CLOUD_COVER', 30)) 
               .map(prepareLandsat8);                                  
var compositePre = colPre.median().clip(Sumatra_Test);

// --- 2. DURANTE IL TAGLIO (Stagione Secca 2021) - Sentinel-2 ---
var colDurante = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
                   .filterBounds(Sumatra_Test)
                   .filterDate('2021-05-01', '2021-10-31')             
                   .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 30)) 
                   .map(maskAdvancedS2);                                  
var compositeDurante = colDurante.median().clip(Sumatra_Test);

// --- 3. DOPO / PIANTAGIONE (Stagione Secca 2025) - Sentinel-2 ---
var colDopo = ee.ImageCollection('COPERNICUS/S2_SR_HARMONIZED')
                .filterBounds(Sumatra_Test)
                .filterDate('2025-05-01', '2025-10-31')            
                .filter(ee.Filter.lt('CLOUDY_PIXEL_PERCENTAGE', 40)) 
                .map(maskAdvancedS2);                                  
var compositeDopo = colDopo.median().clip(Sumatra_Test);                               

// VISUALIZZAZIONE SULLA MAPPA

var vizFalsoColore = {
  bands: ['B8', 'B4', 'B3'],  
  min: 0,
  max: 0.3
};

Map.addLayer(compositePre, vizFalsoColore, '1. Pre-Deforestazione (2016 - Landsat 8 Ricalibrato)');
Map.addLayer(compositeDurante, vizFalsoColore, '2. Durante il Taglio (2021 - S2)');
Map.addLayer(compositeDopo, vizFalsoColore, '3. Dopo - Situazione Attuale (2025 - S2)');

// ESPORTAZIONE DELLE 6 BANDE UTILI SU GOOGLE DRIVE

var bandsToExport = ['B2', 'B3', 'B4', 'B8', 'B11', 'B12'];

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
