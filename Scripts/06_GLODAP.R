#----------------------
##Dados GLODAP
#----------------------

#Este script le os dados do GLODAP em .nc, acerta sua projecao de 0 a 360 graus para -180 a 180, corta o raster mundi para a area de estudo (ZEE), reamostra de acordo com a resolucao do raster de batimetria e salva os arquivos em .TIFF. Daqui terei variáveis preditoras adicionais para a camada de superfície para utilizacao nas analises dos dados de rodolitos para a tese e os papers da BC e de modelagem (Outubro/2019). Desenvolvido por Viviane Santos. Detalhes adicionais no README.

library(raster)
library(rgdal)
library(ncdf4)

##Extraindo dados de superficie do GLODAP
alcaSUP <- raster("Data/NC/GLODAPv2.2016b.TAlk.nc", band = 1)
calcSUP <- raster("Data/NC/GLODAPv2.2016b.OmegaC.nc", band=1)
aragSUP <- raster("Data/NC/GLODAPv2.2016b.OmegaA.nc", band=1)
CO2SUP <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=1)

#acertando projecao
alkSUP = rotate(alcaSUP)
plot(alkSUP)
calcaSUP = rotate(calcSUP)
plot(calcaSUP)
aragoSUP = rotate(aragSUP)
plot(aragoSUP)
COOSUP = rotate(CO2SUP)
plot(COOSUP)

#criando um stack para as variaveis GLODAP
glodap = stack(alkSUP, calcaSUP, aragoSUP, COOSUP)
glodap

#importando raster mundi modelo GEBCO

bat = raster("Data/NC/GEBCO_2019.nc")
bat
plot(bat)

#reamostrando rasters Glodap
glodap.resampled = resample(glodap, bat)
plot(glodap.resampled)

#importando shape com a ZEE do Brasil

ZEE = readOGR("Data/Shape/ZEE.shp")
plot(ZEE)

#Recortando raster em 1 passo, pois deu erro ao tentar 2 passos como nos demais

glodap.masked = mask(crop(glodap.resampled,ZEE), ZEE)
glodap.masked
plot(glodap.masked)

#salvando rasters com recorte da ZEE
writeRaster(glodap.masked, "Data/TIFF/RasterZEE/.tif", format = "GTiff", bylayer = TRUE, suffix = "names", overwrite = TRUE) #com o argumento suffix = "names" vc pode pedir para ele manter os nomes originais

##nao ficou com o mesmo extent dos demais devido ao corte em 1 unico passo, enqto os demais foram cortados em 2 passos 
#reamostrar de acordo com um raster modelo bat

bat  = raster("Data/TIFF/Selecao/BAT.tif")
glodap2 = stack("Data/TIFF/Selecao/S_CO2_X.tif", "Data/TIFF/Selecao/S_CAL_X.tif", "Data/TIFF/Selecao/S_ARA_X.tif", "Data/TIFF/Selecao/S_ALKA_X.tif")

glodap2.resampled = resample(glodap2, bat)
plot(glodap2.resampled)

#salvando rasters reamostrados
writeRaster(glodap2.resampled, "Data/TIFF/Selecao/.tif", format = "GTiff", bylayer = TRUE, suffix = "names", overwrite = TRUE)

##ao importar os rasters salvos no script seguinte, acusa extent diferente de novo. Algum problema ao salvar o raster. Repetir a operação de reamostragem direto no próximo script, antes de extrair o dado.
