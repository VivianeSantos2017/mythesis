#carregando os pacotes
require(sp)
require(rgdal)
require(raster)
require(maps)
require(rgeos)


#listando os arquivos alta da pasta altaBAT
lista = list.files(path = "Data/TIFF/Selecao/altaBAT/",
                   pattern = ".tif",#aqui digo quero s? os arquivos com extens?o tif
                   full.names = TRUE) #da o caminho completo dos arquivos
lista #criado um vetor de caracteres, para importar tudo de 1 vez s?

#importando direto os arquivos para o stack
altaBAT = stack(lista)
altaBAT
plot(altaBAT)

#importando raster modelo para reamostrar para resolucao menor

biora = raster ("Data/TIFF/Selecao/B_CV_Max.tif")

#reamostrando rasters BAT para resolucao Bio-Oracle
BAT.resampled = resample(altaBAT, biora)
plot(BAT.resampled)

#salvando rasters reamostrados
writeRaster(BAT.resampled, "Data/TIFF/Selecao/.tif", format = "GTiff", bylayer = TRUE, suffix = "names") #com o argumento suffix = "names" vc pode pedir para ele manter os nomes originais

#listando os arquivos alta da pasta Glodap
lista = list.files(path = "Data/TIFF/Selecao/altaGLODAP/",
                   pattern = ".tif",#aqui digo quero s? os arquivos com extens?o tif
                   full.names = TRUE) #da o caminho completo dos arquivos
lista #criado um vetor de caracteres, para importar tudo de 1 vez s?

#importando direto os arquivos para o stack
altaGLO = stack(lista)
altaGLO
plot(altaGLO)

#reamostrando rasters BAT para resolucao Bio-Oracle
GLO.resampled = resample(altaGLO, biora)
plot(GLO.resampled)

#salvando rasters reamostrados
writeRaster(GLO.resampled, "Data/TIFF/Selecao/.tif", format = "GTiff", bylayer = TRUE, suffix = "names") #com o argumento suffix = "names" vc pode pedir para ele manter os nomes originais

#listando os arquivos alta da pasta BIO
lista = list.files(path = "Data/TIFF/Selecao/altaBIO/",
                   pattern = ".tif",#aqui digo quero s? os arquivos com extens?o tif
                   full.names = TRUE) #da o caminho completo dos arquivos
lista #criado um vetor de caracteres, para importar tudo de 1 vez s?

#importando direto os arquivos para o stack
altaBIO = stack(lista)
altaBIO
plot(altaBIO)

#reamostrando rasters BAT para resolucao Bio-Oracle
BIO.resampled = resample(altaBIO, biora)
plot(BIO.resampled)

#salvando rasters reamostrados
writeRaster(BIO.resampled, "Data/TIFF/Selecao/.tif", format = "GTiff", bylayer = TRUE, suffix = "names") #com o argumento suffix = "names" vc pode pedir para ele manter os nomes originais


