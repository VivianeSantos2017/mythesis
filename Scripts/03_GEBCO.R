#----------------------
##Extracao Dados GEBCO
#----------------------

#Este script le os dados do GEBCO em .nc, salva a camada de interesse em .TIFF, faz o recorte para a area de estudo (ZEE), salva o raster de batimetria para a ZEE e gera rasters com outras caracteristicas de terreno derivadas da batimetria (slope, aspect, TRI, TPI, roghness e flowdir of water). Desenvolvido por Viviane Santos. Detalhes adicionais no README, item 03.

#carregando os pacotes
library(rgdal)
library(raster)
library(ncdf4)

## Reading GEBCO GeoTIFF file
bat = raster("Data/NC/GEBCO_2019.nc")
bat
plot(bat)

#importando shape com a ZEE do Brasil

ZEE = readOGR("Data/Shape/ZEE.shp")
plot(ZEE)

#Recortando raster em 2 passos

#primeiro funcao mask: usa o recorte do shape
bat.masked = mask(bat, ZEE)
bat.masked#coloca NA em tudo e mantem o extent do mundo
plot(bat.masked)

#depois a funcao trim: exclui todas as linhas e colunas com NA, dai o Brasil pequenino amplia apos retirada do NA
batZEE = trim(bat.masked)
plot(batZEE)

#salvando raster GEBCO com recorte da ZEE
writeRaster(batZEE, "Data/TIFF/RasterZEE/batZEE.tif", format = "GTiff", bylayer = TRUE) 

batZEE = raster("Data/TIFF/RasterZEE/batZEE.tif")
#criando raster slope a partir do raster batimetria
slope = terrain(batZEE, opt="slope", unit="tangent", neighbors=4, filename="Data/TIFF/RasterZEE/slope.tif", format = "GTiff", bylayer = TRUE) #da inclinacao em graus. When neighbors=4, slope and aspect are computed according to Fleming and Hoffer (1979) and Ritter (1987). When neigbors=8, slope and aspect are computed according to Horn (1981). The Horn algorithm may be best for rough surfaces, and the Fleming and Hoffer algorithm may be better for smoother surfaces (Jones, 1997; Burrough and McDonnell, 1998).
plot(slope)

slope2 = terrain(batZEE, opt="slope", unit="tangent", neighbors=8, filename="Data/TIFF/RasterZEE/slope.rough.tif", format = "GTiff", bylayer = TRUE) #da inclinacao em graus
plot(slope2)

#criando raster aspect a partir do raster batimetria
aspect = terrain(batZEE, opt="aspect", unit="degrees", neighbors=4, filename="Data/TIFF/RasterZEE/aspect.tif", format = "GTiff", bylayer = TRUE)#da a direcao da inclinacao, onde 0 e Norte, 90 e Leste, 180 e Sul e 270 e Oeste. When neighbors=4, slope and aspect are computed according to Fleming and Hoffer (1979) and Ritter (1987). When neigbors=8, slope and aspect are computed according to Horn (1981). The Horn algorithm may be best for rough surfaces, and the Fleming and Hoffer algorithm may be better for smoother surfaces (Jones, 1997; Burrough and McDonnell, 1998).
plot(aspect)

aspect2 = terrain(batZEE, opt="aspect", unit="degrees", neighbors=8, filename="Data/TIFF/RasterZEE/aspect.rough.tif", format = "GTiff", bylayer = TRUE)#da a direcao da inclinacao, onde 0 e Norte, 90 e Leste, 180 e Sul e 270 e Oeste
plot(aspect2)

#criando raster TRI (Terrain Ruggedness Index - Indice de Robustez do Terreno) a partir do raster batimetria
TRI = terrain(batZEE, opt="TRI", filename="Data/TIFF/RasterZEE/TRI.tif", format = "GTiff", bylayer = TRUE)#media da diferenca absoluta entre o valor de uma celula e o das suas 8 celulas vizinhas
plot(TRI)

#criando raster TPI (Topographic Position Index) a partir do raster batimetria
TPI = terrain(batZEE, opt="TPI", filename="Data/TIFF/RasterZEE/TPI.tif", format = "GTiff", bylayer = TRUE)#diferenca entre o valor de uma celula e a media das suas 8 celulas vizinhas
plot(TPI)

#criando raster Roughness 'rugosidade' a partir do raster batimetria
roughness = terrain(batZEE, opt="roughness", filename="Data/TIFF/RasterZEE/roughness.tif", format = "GTiff", bylayer = TRUE)#diferenca entre os valores maximo e minimo de uma celula e suas 8 celulas vizinhas
plot(roughness)

#criando raster Flow Direction of Water a partir do raster batimetria
flowdir = terrain(batZEE, opt="flowdir", filename="Data/TIFF/RasterZEE/flowdir.tif", format = "GTiff", bylayer = TRUE)
plot(flowdir)

