#----------------------
##Dados Bio-Oracle
#----------------------

#Este script le os dados globais do Bio-Oracle, corta o raster mundi para a area de estudo (ZEE), reamostra de acordo com a resolucao mais alta do raster de batimetria e salva os arquivos em .TIFF. Daqui terei variáveis preditoras adicionais para a camada de superfície e fundo para utilizacao nas analises dos dados de rodolitos para a tese e os papers da BC e de modelagem (Outubro/2019). Desenvolvido por Viviane Santos. Detalhes adicionais no README.

#carregando os pacotes
require(sp)
require(rgdal)
require(raster)
require(maps)
require(rgeos)

#importando shape com a ZEE do Brasil

ZEE = readOGR("Data/Shape/ZEE.shp")
plot(ZEE)

##importando rasters para um stac

#Recortando raster em 2 passos

#primeiro funcao mask: usa o recorte do shape
biora.masked = mask(biora, ZEE)
biora.masked#coloca NA em tudo e mantem o extent do mundo
plot(biora.masked)

#depois a funcao trim: exclui todas as linhas e colunas com NA, dai o Brasil pequenino amplia apos retirada do NA
biora.trimmed = trim(biora.masked)
plot(biora.trimmed)

#importando raster modelo

bat = raster ("Data/TIFF/batZEE.tif")

#reamostrando rasters Bio-Oracle
biora.resampled = resample(biora.trimmed, bat)
plot(biora.resampled)

#salvando rasters com recorte da ZEE
writeRaster(biora.resampled, "Data/TIFF/RasterZEE/.tif", format = "GTiff", bylayer = TRUE, suffix = "names") #com o argumento suffix = "names" vc pode pedir para ele manter os nomes originais
