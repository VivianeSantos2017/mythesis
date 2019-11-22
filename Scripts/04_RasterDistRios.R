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

##importando raster modelo batimetria

bat = raster("Data/TIFF/RasterZEE/batZEE.tif")
bat
plot(bat)

#rasterizando ZEE com base em raster bio-Oracle

ZEEraster = rasterize(ZEE, bat)
ZEEraster
plot(ZEEraster)

#reamostrando raster ZEE com base no raster batimetria

ZEEresampled = resample(ZEEraster, bat)
ZEEresampled
plot(ZEEresampled)

writeRaster(ZEEresampled, "Data/TIFF/RasterZEE/ZEEraster.tif", overwrite = TRUE, format = "GTiff")


#importando shape foz dos rios federais

rios = readOGR("Data/Shape/FozRiosFederais.shp")
rios
plot(rios)

#rasterizando shape rios, com base no raster ZEE e atribuindo o valor 0.0001 para os pontos foz dos rios

rios.raster = rasterize(rios, ZEEresampled, 0.0001) 
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
