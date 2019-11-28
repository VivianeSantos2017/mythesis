#----------------------
##03_Raster_Dist_Rios
#----------------------

#Este script cria um raster de distancia da foz os rios costeiros do Brasil (em metros) para todo o poligono da Zona Economica Exclusiva (ZEE). Essa e uma variavel preditora a ser utilizada nas analises dos dados de rodolitos para a tese e os papers da BC e de modelagem (Outubro/2019). Desenvolvido por Viviane Santos. Maiores detalhes das tentativas e erros ate chegar aqui estao no README, item 03.


#carregando os pacotes
require(sp)
require(rgdal)
require(raster)
require(maps)
require(rgeos)

#importando shape ZEE para rasterizar

ZEE = readOGR("Data/Shape/ZEE.shp")
ZEE
plot(ZEE)

##importando rasters modelos batimetria e cloro

bat = raster("Data/TIFF/RasterZEE_AA/batZEE.tif")
bat
plot(bat)

cloro = raster("Data/TIFF/RasterZEE/_Present.Benthic.Max.Depth.Chlorophyll.Range.tif")
cloro
plot(cloro)

#rasterizando ZEE com base em raster bat ou bio-Oracle

ZEEraster = rasterize(ZEE, bat)
ZEEraster
plot(ZEEraster)

ZEEbio = rasterize(ZEE, cloro)
ZEEbio
plot(ZEEbio)

#reamostrando raster ZEE com base nos rasters batimetria e bio-oracle

ZEEresampled = resample(ZEEraster, bat)
ZEEresampled
plot(ZEEresampled)

ZEEresampled2 = resample(ZEEbio, cloro)
ZEEresampled2
plot(ZEEresampled2)

writeRaster(ZEEresampled, "Data/TIFF/RasterZEE_AA/ZEEraster.tif", overwrite = TRUE, format = "GTiff")

writeRaster(ZEEresampled2, "Data/TIFF/RasterZEE/ZEEbio.tif", overwrite = TRUE, format = "GTiff")


#importando shape foz dos rios federais

rios = readOGR("Data/Shape/FozRiosFederais.shp")
rios
plot(rios)

#rasterizando shape rios, com base no raster ZEE e atribuindo o valor 0.0001 para os pontos foz dos rios (aqui basta escolher ZEEresampled ou ZEEresampled2 para altissima ou alta resolucao e seguir adiante)

rios.raster = rasterize(rios, ZEEresampled2, 0.0001) 
rios.raster 
plot(rios.raster)

getValues (rios.raster)
hasValues (rios.raster)#checando se o raster criado tem valores ou somente NA

dist.rios = distance(rios.raster) #valor dos pixels NA vira a distancia entre eles e as celulas de rios com valor 0.0001, que passam a ser ZERO (ponto inicial)
dist.rios
plot(dist.rios)

writeRaster(dist.rios,"Data/TIFF/RasterZEE/DistRiosBRUTO", overwrite = TRUE, format = "GTiff")

#cortar o raster bruto com base no shape ZEE, usando mesma fórmula utilizada para os Bio-Oracle, usando primeiro a funcao mask e depois a trim

rios.masked = mask(dist.rios, ZEE)#essa funcao usa o recorte do poligono/shape
rios.masked#coloca NA em tudo e mantem o extent do BRUTO
plot(rios.masked)

rios.trimmed = trim(rios.masked)#exclui todas as linhas e colunas que tem apenas NA.
plot(rios.trimmed)

#finalmente salvando o raster contendo os valores de distancia de foz dos rios com a mesma resolucao dos rasters bio-Oracle e recorte da ZEE

writeRaster(rios.trimmed,"Data/TIFF/RasterZEE/DistRios.tif", overwrite = TRUE, format = "GTiff")
