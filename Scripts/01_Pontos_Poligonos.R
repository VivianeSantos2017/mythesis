#-----------------------------------------#
#Pontos a partir de polígonos rodolitos####
#-----------------------------------------#

library(sp)
library(rgdal)
library(raster)
library(maps)
library(rgeos)

##lendo dados do shape do poligono De La Giustina 2006
BC1 = readOGR("Data/Shape/DellaGiustina2006.shp", encoding = "UTF-8")
BC1
plot(BC1)

#criando pontos aleatorios e gerando tabela com coordenadas
pontosBC1 = spsample(BC1, 250, 'random')
pontosBC1
plot(pontosBC1)
write.table(pontosBC1, "Results/pontosGiustina.csv", sep = ";", dec = ".")

##lendo dados do shape do poligono Peregrino
BC2 = readOGR("Data/Shape/Peregrino21.shp", encoding = "UTF-8")
BC2
plot(BC2)

#criando pontos aleatorios e gerando tabela com coordenadas
pontosBC2 = spsample(BC2, 200, 'random')
pontosBC2
plot(pontosBC2)
write.table(pontosBC2, "Results/pontosPeregrino.csv", sep = ";", dec = ".")

##lendo dados do shape do poligono Abrolhos
abrolhos = readOGR("Data/Shape/megahab.shp", encoding = "UTF-8")
abrolhos
plot(abrolhos)
data.frame(abrolhos)#checando nome da classe que corresponde ao rodolito para selecionar antes de criar a nuvem de pontos

#selecionando megahabitat rodolitos
rodolito.abrolhos = abrolhos[abrolhos$Classe=="Rodolito",]
rodolito.abrolhos
plot(rodolito.abrolhos)

#criando pontos aleatorios e gerando tabela com coordenadas
pontosAbrolhos = spsample(rodolito.abrolhos, 400, 'random')
pontosAbrolhos#projecao esta em UTM
pts.abrolhos=spTransform(pontosAbrolhos, CRS("+proj=longlat +datum=WGS84"))#transformando projecao para longlat em outro objeto
plot(pts.abrolhos, add = TRUE)
write.table(pts.abrolhos, "Results/pontosAbrolhos.csv", sep = ";", dec = ".")

#como pontos Abrolhos estao em 3 bacias sedimentares diferentes (ES, Mucuri e Cumuru), vamos selecionar os conjuntos de dados com base no shape das bacias

#importando shape bacias sedimentares
bacias = readOGR("Data/Shape/Bacias_Sedimentares.shp", encoding = "UTF-8")
bacias
data.frame(bacias)
#definindo o CRS igual ao do objeto com os pontos
crs(bacias) = crs(pts.abrolhos)

#selecionando bacia maritima do ES
BMES = bacias[bacias$NOME_BACIA=="Bacia do Espírito Santo_M",]
BMES
plot(BMES)
plot(pts.abrolhos, add=TRUE)

#selecionar apenas os pontos dentro da bacia do ES
ES.sel = pts.abrolhos[BMES,]
ES.sel
plot(BMES, axes = T)
points(ES.sel, col = 2, pch = 16)
write.table(ES.sel, "Results/pontosAbrolhosES.csv", sep = ";", dec = ".")

#tudo de novo para  selecionar os pontos da bacia maritima de Mucuri
Mucuri = bacias[bacias$NOME_BACIA=="Bacia de Mucuri_M",]
Mucuri
plot(Mucuri)
plot(pts.abrolhos, add=TRUE)

#selecionar apenas os pontos dentro da bacia de Mucuri
mucu.sel = pts.abrolhos[Mucuri,]
mucu.sel
plot(Mucuri, axes = T)
points(mucu.sel, col = 2, pch = 16)
write.table(mucu.sel, "Results/pontosAbrolhosMucuri.csv", sep = ";", dec = ".")

#tudo de novo para  selecionar os pontos da bacia maritima de Cumuruxatiba
Cumuru = bacias[bacias$NOME_BACIA=="Bacia de Cumuruxatiba_M",]
Cumuru
plot(Cumuru)
plot(pts.abrolhos, add=TRUE)

#selecionar apenas os pontos dentro da bacia de Cumuru
cumuru.sel = pts.abrolhos[Cumuru,]
cumuru.sel
plot(Cumuru, axes = T)
points(cumuru.sel, col = 2, pch = 16)
write.table(cumuru.sel, "Results/pontosAbrolhosCumuru.csv", sep = ";", dec = ".")


##lendo dados do shape do poligono PCR-ES
ES = readOGR("Data/Shape/RodolitoCCA_PCR-ES.shp", encoding = "UTF-8")
ES
plot(ES)
data.frame(ES)#checando nome da coluna e valores que correspondem aos rodolitos para selecionar antes de criar a nuvem de pontos

#selecionando Rodolitos e Bancos de algas calcÃ¡rias
rodolito.ES = ES[ES$DESCRICAO=="Rodolitos" | ES$DESCRICAO=="Bancos de algas calcÃ¡rias", ]
rodolito.ES
plot(rodolito.ES)

#criando pontos aleatorios e gerando tabela com coordenadas
pontosES = spsample(rodolito.ES, 300, 'random')
pontosES#projecao esta em UTM
plot(pontosES)
pts.ES=spTransform(pontosES, CRS("+proj=longlat +datum=WGS84"))#transformando projecao para longlat em outro objeto
plot(pts.ES)
write.table(pts.ES, "Results/pontosES.csv", sep = ";", dec = ".")

#como pontos ES estao em 2 bacias sedimentares diferentes (BC e ES), vamos selecionar os conjuntos de dados com base no shape das bacias

#importando shape bacias sedimentares
bacias = readOGR("Data/Shape/Bacias_Sedimentares.shp", encoding = "UTF-8")
bacias
data.frame(bacias)
#definindo o CRS igual ao do objeto com os pontos
crs(bacias) = crs(pts.ES)

#selecionando bacia maritima do ES
BES = bacias[bacias$NOME_BACIA=="Bacia do Espírito Santo_M",]
BES
plot(BES)
plot(pts.ES, add=TRUE)

#selecionar apenas os pontos dentro da bacia do ES
BES.sel = pts.ES[BES,]
BES.sel
plot(BES, axes = T)
points(BES.sel, col = 2, pch = 16)
write.table(BES.sel, "Results/pontosES_BES.csv", sep = ";", dec = ".")

#tudo de novo para  selecionar os pontos da BC
BC = bacias[bacias$NOME_BACIA=="Bacia de Campos_M",]
BC
plot(BC)
plot(pts.ES, add=TRUE)

#selecionar apenas os pontos dentro da bacia de Mucuri
BC.sel = pts.ES[BC,]
BC.sel
plot(BC, axes = T)
points(BC.sel, col = 2, pch = 16)
write.table(BC.sel, "Results/pontosES_BC.csv", sep = ";", dec = ".")


##lendo dados do shape do poligono da Foz
foz = readOGR("Data/Shape/Fundo.shp", encoding = "UTF-8")
foz
plot(foz)
data.frame(foz)#checando nome da coluna e valores que correspondem aos rodolitos para selecionar antes de criar a nuvem de pontos

#selecionando Rhodolito
rodolito.foz = foz[foz$Nome=="Rhodolito", ]
rodolito.foz
plot(rodolito.foz)

#criando pontos aleatorios e gerando tabela com coordenadas
pontosfoz = spsample(rodolito.foz, 150, 'random')
pontosfoz
plot(pontosfoz, add=TRUE)
write.table(pontosfoz, "Results/pontosFoz.csv", sep = ";", dec = ".")

#como pontos Foz estao em 3 bacias sedimentares diferentes (Foz, PAMA e BAR), vamos selecionar os conjuntos de dados com base no shape das bacias

#importando shape bacias sedimentares
bacias = readOGR("Data/Shape/Bacias_Sedimentares.shp", encoding = "UTF-8")
bacias
data.frame(bacias)
#definindo o CRS igual ao do objeto com os pontos
crs(bacias) = crs(pontosfoz)

#selecionando bacia maritima de Foz 
BMfoz = bacias[bacias$NOME_BACIA=="Bacia da Foz do Amazonas_M",]
BMfoz
plot(BMfoz)
plot(pontosfoz, add=TRUE)

#selecionar apenas os pontos dentro da bacia da Foz
foz.sel = pontosfoz[BMfoz,]
foz.sel
plot(BMfoz, axes = T)
points(foz.sel, col = 2, pch = 16)
write.table(foz.sel, "Results/pontosFoz_BMfoz.csv", sep = ";", dec = ".")

#tudo de novo para  selecionar os pontos da bacia Para-Maranhao
PAMA = bacias[bacias$NOME_BACIA=="Bacia Pará-Maranhão",]
PAMA
plot(PAMA)
plot(pontosfoz, add=TRUE)

#selecionar apenas os pontos dentro da bacia PAMA
PAMA.sel = pontosfoz[PAMA,]
PAMA.sel
plot(PAMA, axes = T)
points(PAMA.sel, col = 2, pch = 16)
data.frame(PAMA.sel)#para retirar pontos sobre banco de briozoarios, vizualizei o arquivo no GIS para verificar os IDs e aplicar exclusao aqui (checar se da para fazer no R)
PAMA.sel2 = PAMA.sel[-c(6, 7, 10, 16, 17, 25, 28, 33, 36, 39, 47),]#excluindo 11 pontos que estaosobre banco de briozoarios
data.frame(PAMA.sel2)
plot(PAMA, axes = T)
points(PAMA.sel2, col = 2, pch = 16)
write.table(PAMA.sel2, "Results/pontosFoz_PAMA.csv", sep = ";", dec = ".")

#tudo de novo para  selecionar os pontos da bacia maritima de Barreirinhas
BAR = bacias[bacias$NOME_BACIA=="Bacia de Barreirinhas_M",]
BAR
plot(BAR)
plot(pontosfoz, add=TRUE)

#selecionar apenas os pontos dentro da bacia BAR
BAR.sel = pontosfoz[BAR,]
BAR.sel
plot(BAR, axes = T)
points(BAR.sel, col = 2, pch = 16)
write.table(BAR.sel, "Results/pontosFoz_BAR.csv", sep = ";", dec = ".")


