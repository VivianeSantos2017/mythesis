#----------------------
##Dados Bio-Oracle
#----------------------

#Este script le os dados globais do Bio-Oracle (download from http://www.bio-oracle.org/downloads-to-email.php, August 02 2018; Tyberghein et al. 2012; Assis et al. 2017), corta o raster mundi para a area de estudo (ZEE) e salva os arquivos em .TIFF. Alternativamente, reamostra de acordo com a resolucao mais alta do raster de batimetria e salva os arquivos em .TIFF tambem. Daqui terei variáveis preditoras adicionais am altissima e alta resolucao para a camada de superfície e fundo para utilizacao nas analises dos dados de rodolitos para a tese e os papers da BC e de modelagem (Outubro/2019). Desenvolvido por Viviane Santos. Detalhes adicionais no README.

#carregando os pacotes
require(sp)
require(rgdal)
require(raster)
require(maps)
require(rgeos)

#importando shape com a ZEE do Brasil

ZEE = readOGR("Data/Shape/ZEE.shp")
plot(ZEE)


#listando os arquivos Bio-Oracle da pasta RasterMundi
lista = list.files(path = "Data/TIFF/RasterMundi/",
                   pattern = ".tif",#aqui digo quero s? os arquivos com extens?o tif
                   full.names = TRUE) #da o caminho completo dos arquivos
lista #criado um vetor de caracteres, para importar tudo de 1 vez s?

#importando direto os arquivos para o stack
biora = stack(lista)
biora

#plotando
plot(biora)

#Recortando raster em 2 passos

#primeiro funcao mask: usa o recorte do shape
biora.masked = mask(biora, ZEE)
biora.masked#coloca NA em tudo e mantem o extent do mundo
plot(biora.masked)

#depois a funcao trim: exclui todas as linhas e colunas com NA, dai o Brasil pequenino amplia apos retirada do NA
biora.trimmed = trim(biora.masked)
plot(biora.trimmed)

#salvando rasters com recorte da ZEE
writeRaster(biora.trimmed, "Data/TIFF/RasterZEE/.tif", format = "GTiff", bylayer = TRUE, suffix = "names") #com o argumento suffix = "names" vc pode pedir para ele manter os nomes originais

#importando raster modelo para reamostrar para altissima resolucao

bat = raster ("Data/TIFF/batZEE.tif")

#reamostrando rasters Bio-Oracle para resolucao batimetria GEBCO
biora.resampled = resample(biora.trimmed, bat)
plot(biora.resampled)

#salvando rasters com recorte da ZEE
writeRaster(biora.resampled, "Data/TIFF/RasterZEE_AA/.tif", format = "GTiff", bylayer = TRUE, suffix = "names") #com o argumento suffix = "names" vc pode pedir para ele manter os nomes originais
