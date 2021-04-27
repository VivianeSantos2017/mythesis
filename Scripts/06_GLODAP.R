#----------------------
##Dados GLODAP
#----------------------

#Este script le os dados do GLODAP em .nc (Lauvset et al., 2016; Key et al., 2015; Olsen et al., 2016; download from https://www.glodap.info/index.php/mapped-data-product/, June 22 2019), acerta sua projecao de 0 a 360 graus para -180 a 180, corta o raster mundi para a area de estudo (ZEE), reamostra de acordo com a resolucao do raster de batimetria (altissima resolucao) ou, alternativamente, de clorofila (alta resolução) e salva os arquivos em .TIFF. Daqui terei variáveis preditoras adicionais para a camada de superfície para utilizacao nas analises dos dados de rodolitos para a tese e os papers da BC e de modelagem (Outubro/2019). Desenvolvido por Viviane Santos. Detalhes adicionais no README.

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

#importando raster mundi modelo GEBCO (altissima resolucao)

bat = raster("Data/NC/GEBCO_2019.nc")
bat
plot(bat)

#importando raster mundi modelo Bio-Oracle (alta resolucao)

cloro = raster("Data/TIFF/RasterMundi/Present.Benthic.Max.Depth.Chlorophyll.Range.tif")
cloro
plot(cloro)

#reamostrando rasters Glodap em altissima resolucao
glodap.resampled = resample(glodap, bat)
plot(glodap.resampled)

#altenativa: reamostrando rasters Glodap em alta resolucao
glodap.resampled2 = resample(glodap, cloro)
plot(glodap.resampled2)

#importando shape com a ZEE do Brasil

ZEE = readOGR("Data/Shape/ZEE.shp")
plot(ZEE)

#Recortando rasters em 1 passo, pois deu erro ao tentar 2 passos como nos demais

glodap.masked = mask(crop(glodap.resampled,ZEE), ZEE)
glodap.masked
plot(glodap.masked)

glodap.masked2 = mask(crop(glodap.resampled2,ZEE), ZEE)
glodap.masked2
plot(glodap.masked2)

##Nao ficaram com o mesmo extent dos demais devido ao corte em 1 unico passo, enqto os demais foram cortados em 2 passos 

#reamostrar de acordo com um raster ZEE modelo bat (altissima resolucao)

bat  = raster("Data/TIFF/Selecao/BAT.tif")
glodap2 = stack("Data/TIFF/Selecao/S_CO2_X.tif", "Data/TIFF/Selecao/S_CAL_X.tif", "Data/TIFF/Selecao/S_ARA_X.tif", "Data/TIFF/Selecao/S_ALKA_X.tif")

glodap2.resampled = resample(glodap2, bat)
plot(glodap2.resampled)

#alternativa: reamostrar de acordo com um raster ZEE modelo bio-oracle (alta resolucao)

cloroZEE  = raster("Data/TIFF/RasterZEE/_Present.Benthic.Max.Depth.Chlorophyll.Range.tif")

glodap.resampled3 = resample(glodap.masked2, cloroZEE)
plot(glodap.resampled3)

#salvando rasters com recorte da ZEE
writeRaster(glodap2.resampled, "Data/TIFF/RasterZEE_AA/.tif", format = "GTiff", bylayer = TRUE, suffix = "names", overwrite = TRUE) #com o argumento suffix = "names" vc pode pedir para ele manter os nomes originais

#salvando rasters com recorte da ZEE
writeRaster(glodap.resampled3, "Data/TIFF/RasterZEE/.tif", format = "GTiff", bylayer = TRUE, suffix = "names", overwrite = TRUE) #com o argumento suffix = "names" vc pode pedir para ele manter os nomes originais


#salvando rasters reamostrados
writeRaster(glodap2.resampled, "Data/TIFF/Selecao/.tif", format = "GTiff", bylayer = TRUE, suffix = "names", overwrite = TRUE)


#extraindo todas as camadas para raster mosaico
calc33 = brick("Data/NC/GLODAPv2.2016b.OmegaC.nc")
calc = stack(calc33)
calc
plot(calc)

##Extraindo dados por banda
calcSUP <- raster("Data/NC/GLODAPv2.2016b.OmegaC.nc", band=1)
calc10 <- raster("Data/NC/GLODAPv2.2016b.OmegaC.nc", band=2)
calc20 <- raster("Data/NC/GLODAPv2.2016b.OmegaC.nc", band=3)
calc30 <- raster("Data/NC/GLODAPv2.2016b.OmegaC.nc", band=4)
calc50 <- raster("Data/NC/GLODAPv2.2016b.OmegaC.nc", band=5)
calc75 <- raster("Data/NC/GLODAPv2.2016b.OmegaC.nc", band=6)
calc100 <- raster("Data/NC/GLODAPv2.2016b.OmegaC.nc", band=7)
calc125 <- raster("Data/NC/GLODAPv2.2016b.OmegaC.nc", band=8)
calc150 <- raster("Data/NC/GLODAPv2.2016b.OmegaC.nc", band=9)
calc200 <- raster("Data/NC/GLODAPv2.2016b.OmegaC.nc", band=10)
calc250 <- raster("Data/NC/GLODAPv2.2016b.OmegaC.nc", band=11)
calc300 <- raster("Data/NC/GLODAPv2.2016b.OmegaC.nc", band=12)
calc400 <- raster("Data/NC/GLODAPv2.2016b.OmegaC.nc", band=13)
calc500 <- raster("Data/NC/GLODAPv2.2016b.OmegaC.nc", band=14)
calc600 <- raster("Data/NC/GLODAPv2.2016b.OmegaC.nc", band=15)
calc700 <- raster("Data/NC/GLODAPv2.2016b.OmegaC.nc", band=16)
calc800 <- raster("Data/NC/GLODAPv2.2016b.OmegaC.nc", band=17)
calc900 <- raster("Data/NC/GLODAPv2.2016b.OmegaC.nc", band=18)
calc1000 <- raster("Data/NC/GLODAPv2.2016b.OmegaC.nc", band=19)

calc = stack(calcSUP, calc10, calc20, calc30, calc50, calc75, calc100, calc125, calc150, calc200, calc250, calc300, calc400, calc500, calc600, calc700, calc800, calc900, calc1000)
calc
plot(calc)

#acertando projecao
calc.rotated = rotate(calc)
plot(calc.rotated)

##repetindo mesmo procedimento anterior
#importando raster mundi modelo GEBCO (altissima resolucao)
bat = raster("Data/NC/GEBCO_2019.nc")
bat
plot(bat)

#reamostrando rasters Glodap em altissima resolucao
calc.resampled = resample(calc.rotated, bat)

#importando shape com a ZEE do Brasil

ZEE = readOGR("Data/Shape/ZEEErase.shp")
plot(ZEE)

#Recortando rasters em 1 passo, pois deu erro ao tentar 2 passos como nos demais

calc.masked = mask(crop(calc.resampled,ZEE), ZEE)
calc.masked
plot(calc.masked)

#ALTERNATIVA: Recortando raster em 2 passos

#primeiro funcao mask: usa o recorte do shape
calc.masked = mask(calc.resampled, ZEE)
calc.masked#coloca NA em tudo e mantem o extent do mundo
plot(biora.masked)

#depois a funcao trim: exclui todas as linhas e colunas com NA, dai o Brasil pequenino amplia apos retirada do NA
calc.trimmed = trim(calc.masked)
plot(calc.trimmed)

##Nao ficaram com o mesmo extent dos demais devido ao corte em 1 unico passo, enqto os demais foram cortados em 2 passos 

#reamostrar de acordo com um raster ZEE modelo bat (altissima resolucao)

batZEE  = raster("Data/TIFF/Selecao_AA/BAT.tif")

calc2.resampled = resample(calc.masked, batZEE)
plot(calc2.resampled)

#salvando rasters com recorte da ZEE
writeRaster(calc2.resampled, "Data/TIFF/Glodap/Calc/.tif", format = "GTiff", bylayer = TRUE, suffix = "names", overwrite = TRUE) #com o argumento suffix = "names" vc pode pedir para ele manter os nomes originais

##Extraindo dados CO2 por banda
coSUP <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=1)
co10 <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=2)
co20 <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=3)
co30 <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=4)
co50 <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=5)
co75 <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=6)
co100 <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=7)
co125 <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=8)
co150 <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=9)
co200 <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=10)
co250 <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=11)
co300 <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=12)
co400 <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=13)
co500 <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=14)
co600 <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=15)
co700 <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=16)
co800 <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=17)
co900 <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=18)
co1000 <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=19)
co1100 <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=20)
co1200 <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=21)
co1300 <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=22)
co1400 <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=23)
co1500 <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=24)
co1750 <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=25)
co2000 <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=26)
co2500 <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=27)
co3000 <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=28)
co3500 <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=29)
co4000 <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=30)
co4500 <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=31)
co5000 <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=32)
co5500 <- raster("Data/NC/GLODAPv2.2016b.TCO2.nc", band=28)

co2 = stack(coSUP, co10, co20, co30, co50, co75, co100, co125, co150, co200, co250, co300, co400, co500, co600, co700, co800, co900, co1000)

, co1100, co1200, co1300, co1400, co1500, co1750, co2000, co2500, co3000, co3500, co4000, co4500, co5000, co5500)
co2
plot(co2)

#acertando projecao
co2.rotated = rotate(co2)
plot(co2.rotated)

##repetindo mesmo procedimento anterior
#importando raster mundi modelo GEBCO (altissima resolucao)
bat = raster("Data/NC/GEBCO_2019.nc")
bat
plot(bat)

#reamostrando rasters Glodap em altissima resolucao
co2.resampled = resample(co2.rotated, bat)

#importando shape com a ZEE do Brasil

ZEE = readOGR("Data/Shape/ZEEErase.shp")
plot(ZEE)

#Recortando rasters em 1 passo, pois deu erro ao tentar 2 passos como nos demais

co2.masked = mask(crop(co2.resampled,ZEE), ZEE)
co2.masked
plot(co2.masked)

##Nao ficaram com o mesmo extent dos demais devido ao corte em 1 unico passo, enqto os demais foram cortados em 2 passos 

#reamostrar de acordo com um raster ZEE modelo bat (altissima resolucao)

batZEE  = raster("Data/TIFF/Selecao_AA/BAT.tif")


co2.resampled = resample(co2.masked, batZEE)
plot(co2.resampled)

#salvando rasters com recorte da ZEE
writeRaster(co2.resampled, "Data/TIFF/Glodap/CO2/.tif", format = "GTiff", bylayer = TRUE, suffix = "names", overwrite = TRUE) #com o argumento suffix = "names" vc pode pedir para ele manter os nomes originais

