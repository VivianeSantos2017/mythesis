#-------------------------------------------------------#
#Criando Shape Octocorals##
#-------------------------------------------------------#

library(sp)
library(raster)
library(rgdal)
library(maps)
library(rgeos)

#importando dado
octo = read.csv("Data/Tabela/Octocorals.csv", header = T, sep=";", dec = ".")
octo
head (octo)
plot(octo[,-1])

#convertendo o objeto dos pontos (tabela) em um shape, um objeto espacial
coordinates(octo) = ~Y+X #todas as outras coisas em fun??o de latitude e longitude. a fun??o cooordinates ? que georrefencia o objeto tabela a partir de lat e lon
octo

#importando shape modelo
rodolitos = readOGR("Data/Shape/Rodolitos_pontos.shp", encoding = "UTF-8")
rodolitos

#definindo o CRS igual ao do objeto com os estados
crs(octo) = crs(rodolitos)
octo
plot(octo)
writeOGR(
  octo, #nome do objeto a ser salvo
  dsn="Data/Shape/octo", #diretorio a ser salvo os resultados
  layer="Octocorals", #nome do arquivo
  driver="ESRI Shapefile", #formato pretendido para exportação, s?o diversos formatos dispon?veis
  overwrite_layer = TRUE
)

ogrDrivers()

crdref <- CRS('+proj=longlat +datum=WGS84')#criando objeto para a projecao e datum

#criando poligono Recife
pols <- spPolygons(lonlat, crs=crdref)
pols
str(pols)#verificando estrutura
plot(pols, axes=TRUE, las=1)#plotando poligono

#criando pontos aleatorios e gerando tabela com coordenadas Recife
pontosRecife = spsample(pols, 100, 'random')
pontosRecife
plot(pontosRecife, add=T)
write.table(pontosRecife, "Results/pontosKempf_Recife.csv", sep = ";", dec = ".")

#criando data.frame para poligono SEAL
lon <- c(-35.924, -35.997, -35.105, -34.84)
lat <- c(-10.243, -10.174, -8.911, -8.916) 
lonlat <- cbind(lon, lat)

#criando poligono SEAL
pols <- spPolygons(lonlat, crs=crdref)
pols
str(pols)#verificando estrutura
plot(pols, axes=TRUE, las=1)#plotando poligono

#criando pontos aleatorios e gerando tabela com coordenadas SEAL
pontosSEAL = spsample(pols, 100, 'random')
pontosSEAL
plot(pontosSEAL, add=T)
write.table(pontosSEAL, "Results/pontosKempf_SEAL.csv", sep = ";", dec = ".")

#criando data.frame para poligono PERN (norte Recife até porcao leste do Rio Grande do Norte)
lon <- c(-34.762, -34.639, -35.486,  -35.205, -35.01, -35.119, -35.076, -35.005, -34.877, -34.919, -34.829, -34.729, -34.753, -34.681, -34.567, -34.467, -34.472, -34.553, -34.539)
lat <- c(-7.971, -7.441, -4.758, -4.749, -5.639, -5.739, -5.81, -5.805, -6.177, -6.243, -6.276, -6.614, -6.681, -6.733, -7.328, -7.48, -7.652, -7.728, -7.98) 
lonlat <- cbind(lon, lat)

#criando poligono PERN
pols <- spPolygons(lonlat, crs=crdref)
pols
str(pols)#verificando estrutura
plot(pols, axes=TRUE, las=1)#plotando poligono

#criando pontos aleatorios e gerando tabela com coordenadas SEAL
pontosPERN = spsample(pols, 200, 'random')
pontosPERN
plot(pontosPERN, add=T)
write.table(pontosPERN, "Results/pontosKempf_PERN.csv", sep = ";", dec = ".")

#criando data.frame para poligono RNPI (Margem Equatorial do Rio Grande do Norte ao Piaui)
lon <- c(-35.306, -35.249, -35.713, -36.041, -36.962, -38.119, -39.603, -41.759, -41.788, -41.695, -41.638, -41.666, -39.939, -36.984, -35.941)
lat <- c(-4.93, -4.78, -4.744, -4.844, -4.559, -3.46, -2.303, -2.217, -2.303, -2.61, -2.567, -2.424, -2.374, -4.602, -4.901) 
lonlat <- cbind(lon, lat)

#criando poligono RNPI
pols <- spPolygons(lonlat, crs=crdref)
pols
str(pols)#verificando estrutura
plot(pols, axes=TRUE, las=1)#plotando poligono

#criando pontos aleatorios e gerando tabela com coordenadas RNPI
pontosRNPI = spsample(pols, 150, 'random')
pontosRNPI
plot(pontosRNPI, add=T)
write.table(pontosRNPI, "Results/pontosKempf_RNPI.csv", sep = ";", dec = ".")

##Os pontos do ultimo poligono estao em duas bacias, devera ser feito o corte para identifica-las na planilha-base. 
#Na ultima planilha foram adicionados pontos dos montes submarinos indicados no  mapa de Kempf(1970). Os pontos foram tirados diretamente no ArcGIS, assim como os pontos que compoem os data.frame dos poligonos acima.

#Carregando novamente a planilha pontosKempf_RNPI.csv, com os pontos dos montes adicionados
RNPI = read.csv("Data/Tabela/pontosKempf_RNPI2.csv", sep=";", dec = ".")
head(RNPI)
tail(RNPI)
pts.RNPI <- SpatialPoints(RNPI[,-1], proj4string=crdref)#excluindo a coluna 1, pois so interessam as colunas X e Y
pts.RNPI
plot(pts.RNPI)

#importando shape bacias sedimentares
bacias = readOGR("Data/Shape/Bacias_Sedimentares.shp", encoding = "UTF-8")
bacias
data.frame(bacias)
#definindo o CRS igual ao do objeto com os pontos
crs(bacias) = crs(pts.RNPI)

#selecionando bacia maritima de Potiguar
POT = bacias[bacias$NOME_BACIA=="Bacia Potiguar_M",]
POT
plot(POT, add=T)

#selecionar apenas os pontos dentro da bacia Potiguar
POT.sel = pts.RNPI[POT,]
POT.sel
plot(POT, axes = T)
points(POT.sel, col = 2, pch = 16)
write.table(POT.sel, "Results/pontosKempf_RNPI_POT.csv", sep = ";", dec = ".")

#tudo de novo para selecionar os pontos da bacia maritima do Ceara
CE = bacias[bacias$NOME_BACIA=="Bacia do Ceará_M ",]
CE#no veio nada, tvz o espaco depois do M esteja impedindo de importar essa parte do shape...
##OBS. O arquivo do Ceara foi trabalhado manualmente e esta em SIG/DadosRodolitos/PontosKempf_RNPI_CE.xls--------###


plot(CE)
plot(CE, add=TRUE)

#selecionar apenas os pontos dentro da bacia do Ceara
CE.sel = pts.RNPI[CE,]
CE.sel
plot(CE, axes = T)
points(CE.sel, col = 2, pch = 16)
write.table(mucu.sel, "Results/pontosKempf_RNPI_CE.csv", sep = ";", dec = ".")
