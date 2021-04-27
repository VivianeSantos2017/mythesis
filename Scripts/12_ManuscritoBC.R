#---------------------------------------
##Batimetria, PCA e edicao da tabela BC
#---------------------------------------

#Este script le os dados de batimetria do GEBCO para a ZEE em .tif (download from https://www.gebco.net/data_and_products/gridded_bathymetry_data/, October 11, 2019), faz o recorte para a area da Bacia de Campos (BC), salva o raster de batimetria para a BC e gera rasters com outras caracteristicas de terreno derivadas da batimetria (slope, aspect, TRI, TPI, roghness e flowdir of water). A partir da tabela de dados abióticos criada no Script 07_Data Extraction roda PCAs com os dados da BC, comparando regiões norte e sul para o Manuscrito BC. faz a edição da tabela de ocorrências para insercao nos mapas do manuscrito com os polígonos e sem a nuvem de pontos. Desenvolvido por Viviane Santos. Detalhes adicionais no README, item XX.

##BATIMETRIA----------------------------------------------------

#carregando os pacotes
library(rgdal)
library(raster)
library(ncdf4)

## Reading GEBCO GeoTIFF file
bat = raster("Data/TIFF/Selecao_AA/BAT.tif")
bat
plot(bat)

#importando shape com o limite da BC

BC = readOGR("Data/Shape/LIM_BAC_SED_018.shp")
plot(BC)

#Recortando raster em 2 passos

#primeiro funcao mask: usa o recorte do shape
bat.masked = mask(bat, BC)
bat.masked#coloca NA em tudo e mantem o extent do mundo
plot(bat.masked)

#depois a funcao trim: exclui todas as linhas e colunas com NA, dai o Brasil pequenino amplia apos retirada do NA
batBC = trim(bat.masked)
plot(batBC)

#salvando raster GEBCO com recorte da BC
writeRaster(batBC, "Data/TIFF/batBC.tif", format = "GTiff", bylayer = TRUE) 

batBC = raster ("Data/TIFF/batBC.tif")
plot(batBC)


rc <- function(x) {
  ifelse(x > 0, 0, x)}#criando funcao para colocar 0 quando a profundidade for maior que 0 e manter o x quando a profundidade for menor que 0, o que significa que ela está no mar.

batBCsea <- calc(batBC, fun=rc)
plot(batBCsea)

#salvando raster GEBCO com recorte da BC e somente profundidades marinhas
writeRaster(batBCsea, "Data/TIFF/batBCsea.tif", format = "GTiff", bylayer = TRUE, overwrite = TRUE)

batBCsea = raster ("Data/TIFF/batBCsea.tif")
plot(batBC)

#criando raster slope a partir do raster batimetria
slopeBC = terrain(batBCsea, opt="slope", unit="tangent", neighbors=4, filename="Data/TIFF/slopeBC.tif", format = "GTiff", bylayer = TRUE, overwrite = TRUE) #da inclinacao em graus. When neighbors=4, slope and aspect are computed according to Fleming and Hoffer (1979) and Ritter (1987). When neigbors=8, slope and aspect are computed according to Horn (1981). The Horn algorithm may be best for rough surfaces, and the Fleming and Hoffer algorithm may be better for smoother surfaces (Jones, 1997; Burrough and McDonnell, 1998).
plot(slopeBC)

slope2BC = terrain(batBCsea, opt="slope", unit="tangent", neighbors=8, filename="Data/TIFF/slope.roughBC.tif", format = "GTiff", bylayer = TRUE, overwrite = TRUE) #da inclinacao em graus
plot(slope2BC)

#criando raster aspect a partir do raster batimetria
aspectBC = terrain(batBCsea, opt="aspect", unit="degrees", neighbors=4, filename="Data/TIFF/aspectBC.tif", format = "GTiff", bylayer = TRUE, overwrite = TRUE)#da a direcao da inclinacao, onde 0 e Norte, 90 e Leste, 180 e Sul e 270 e Oeste. When neighbors=4, slope and aspect are computed according to Fleming and Hoffer (1979) and Ritter (1987). When neigbors=8, slope and aspect are computed according to Horn (1981). The Horn algorithm may be best for rough surfaces, and the Fleming and Hoffer algorithm may be better for smoother surfaces (Jones, 1997; Burrough and McDonnell, 1998).
plot(aspectBC)

aspect2BC = terrain(batBCsea, opt="aspect", unit="degrees", neighbors=8, filename="Data/TIFF/aspect.roughBC.tif", format = "GTiff", bylayer = TRUE, overwrite = TRUE)#da a direcao da inclinacao, onde 0 e Norte, 90 e Leste, 180 e Sul e 270 e Oeste
plot(aspect2BC)

#criando raster TRI (Terrain Ruggedness Index - Indice de Robustez do Terreno) a partir do raster batimetria
TRIBC = terrain(batBCsea, opt="TRI", filename="Data/TIFF/TRIBC.tif", format = "GTiff", bylayer = TRUE, overwrite = TRUE)#media da diferenca absoluta entre o valor de uma celula e o das suas 8 celulas vizinhas
plot(TRIBC)

#criando raster TPI (Topographic Position Index) a partir do raster batimetria
TPIBC = terrain(batBCsea, opt="TPI", filename="Data/TIFF/TPIBC.tif", format = "GTiff", bylayer = TRUE, overwrite = TRUE)#diferenca entre o valor de uma celula e a media das suas 8 celulas vizinhas
plot(TPIBC)

#criando raster Roughness 'rugosidade' a partir do raster batimetria
roughnessBC = terrain(batBCsea, opt="roughness", filename="Data/TIFF/roughnessBC.tif", format = "GTiff", bylayer = TRUE, overwrite = TRUE)#diferenca entre os valores maximo e minimo de uma celula e suas 8 celulas vizinhas
plot(roughnessBC)

#criando raster Flow Direction of Water a partir do raster batimetria
flowdirBC = terrain(batBCsea, opt="flowdir", filename="Data/TIFF/flowdirBC.tif", format = "GTiff", bylayer = TRUE, overwrite = TRUE)
plot(flowdirBC)

##PCA BC Norte e Sul-------------------------------------------------------------------

#Carregando pacotes

library("PerformanceAnalytics")#permite construir matriz analitica
library("corrplot")#permite construir matriz de correl visual
library(caret)
library(GGally)
library(vegan)
library(FactoMineR)
library(factoextra)
library(ggplot2)

#importando tabela, sem os NA

rhodoBR = read.csv("Data/Tabela/AbioRodolitosSNA.csv", sep = ";", dec = ".")
head(rhodoBR)
dimnames(rhodoBR)
tail(rhodoBR)
str(rhodoBR)
dim(rhodoBR)
class(rhodoBR)
summary(rhodoBR)


vars = BC[,c(8:63)]
correl = cor(vars)
correl

corrplot(correl, type="upper", order="hclust", 
         tl.col="black", tl.srt=45)#gerando matriz visual de correlacao

rhodoBC = rhodoBR[rhodoBR$Basin=="BC", ]#escolhendo as linhas onde a coluna Basin é igual a BC e mantendo os valores de todas as colunas de rodolitos 3
rhodoBC
head(rhodoBC)
dimnames(rhodoBC)

#PCA para a BC, com batimetria, derivadas batimetria, rios, glodap sup e bio-oracle min e max
pca.BC.all = PCA(rhodoBC[,c("CB.region", "Aspect_R", "Aspect_S", "B_CV_Max", "B_CV_Min", "B_Fe_Max", "B_Fe_Min", "B_Light_Max", "B_Light_Min", "B_NIT_Max", "B_NIT_Min", "B_PO4_Max", "B_PO4_Min", "B_SAL_Max", "B_SAL_Min", "B_T_Max", "B_T_Min", "BAT", "FlowDir", "River", "Roughness", "S_ALKA_X", "S_ARA_X", "S_CAL_X", "S_CO2_X", "Slope_R", "Slope_S", "TPI", "TRI")], scale.unit=T, ncp=5, quali.sup=1, graph=T)#explicou 69.2 da variancia dos dados.
summary(pca.BC.all)

# Contributions of variables to PC1
fviz_contrib(pca.BC.all, choice = "var", axes = 1, top = 10)#1o eixo dos nutrientes, T, sal e CV
# Contributions of variables to PC2
fviz_contrib(pca.BC.all, choice = "var", axes = 2, top = 10)#2o eixo dos demais recursos (luzMin e calcitaX), batimetria, distrios e FerroMax (ref a Iron em cavalcanti et al. 2014 e 2018, McCoy2015, Millar2017, Darrenougue_2013, Dromgoole and Walter 1990)
# Contributions of variables to PC1 and PC2
fviz_contrib(pca.BC.all, choice = "var", axes = 1:2, top = 10)

plot.PCA(pca.BC.all, axes=c(1, 2), choix = "ind", habillage=1, label = "var", title = "PCA.BC.all") #plotando os pontos colorindo pela variavel "BC.region" pelo argumento habillage = 1

fviz_pca_biplot(pca.BC.all,  geom = c("point", "text"), habillage=1, label = "var", title = "PCA.BC.all")#plotando eixos variaveis com os pontos por regiao da BC

fviz_pca_biplot(pca.BC.all, habillage = 1, addEllipses = TRUE, title = "PCA.BC.all", col.var = "blue", label = "var") + scale_color_brewer(palette="Dark2")+ theme_minimal()#plotando com elipses, em acordo com a coluna "BC.region" dada por habillage = 1

#Repetindo PCA.BC, mantendo uma variavel entre as que tinham alta correl (retirados fosfato, aragonita, alcalinidade, aspects, TPI e FlowDir)
pca.BC1 = PCA(rhodoBC[,c("CB.region", "B_CV_Max", "B_CV_Min", "B_Fe_Max", "B_Light_Max", "B_Light_Min", "B_NIT_Max", "B_NIT_Min", "B_SAL_Max", "B_SAL_Min", "B_T_Max", "B_T_Min", "BAT", "River", "Roughness", "S_CAL_X", "S_CO2_X", "Slope_R", "Slope_S", "TRI")], scale.unit=T, ncp=5, quali.sup=1, graph=T)#explicou 76,3 da variancia dos dados.
summary(pca.BC1)

# Contributions of variables to PC1
fviz_contrib(pca.BC1, choice = "var", axes = 1, top = 10)#mantidas as variaveis do PC1 anterior, com aumento do %  de explicação, acrescentando rugosidade e TRI
# Contributions of variables to PC2
fviz_contrib(pca.BC1, choice = "var", axes = 2, top = 10)#mantidas as variaveis do PC2 anterior, com aumento do %  de explicação, acrescentando Light_Max
fviz_contrib(pca.BC1, choice = "var", axes = 1:2, top = 15)


plot.PCA(pca.BC1, axes=c(1, 2), choix = "ind", habillage=1, label = "var", title = "PCA BC 1") #plotando os pontos colorindo pela variavel "BC.region" pelo argumento habillage = 1

fviz_pca_biplot(pca.BC1,  geom = c("point", "text"), habillage=1, label = "var", title = "PCA BC 1")#plotando eixos variaveis com os pontos por regiao da BC

fviz_pca_biplot(pca.BC1, habillage = 1, addEllipses = TRUE, title = "PCA BC 1", col.var = "blue", label = "var") + scale_color_brewer(palette="Dark2")+ theme_minimal()#plotando com elipses, em acordo com a coluna "BC.region" dada por habillage = 1

#Repetindo PCA.BC, trocando min e max de T e sal por range e retirando variaveis derivadas da batimetria devido alta correl entre ela e NIT_Max

pca.BC2 = PCA(rhodoBC[,c("CB.region", "B_CV_Max", "B_CV_Min", "B_Fe_Max", "B_Light_Max", "B_Light_Min", "B_NIT_Max", "B_NIT_Min", "B_SAL_R", "B_T_R", "BAT", "River", "S_CAL_X", "S_CO2_X")], scale.unit=T, ncp=5, quali.sup=1, graph=T)#aumentou a explicação para 79,74 da variancia dos dados.
summary(pca.BC2)

# Contributions of variables to PC1
fviz_contrib(pca.BC2, choice = "var", axes = 1, top = 10)#mantidas as variaveis do PC1 all (nutrientes, T, sal e CV)
# Contributions of variables to PC2
fviz_contrib(pca.BC2, choice = "var", axes = 2, top = 10)#mantidas as variaveis do PC2 anterior, com aumento do %  de explicação
fviz_contrib(pca.BC2, choice = "var", axes = 1:2, top = 15)


plot.PCA(pca.BC2, axes=c(1, 2), choix = "ind", habillage=1, label = "var", title = "PCA BC 2") #plotando os pontos colorindo pela variavel "BC.region" pelo argumento habillage = 1

fviz_pca_biplot(pca.BC2,  geom = c("point", "text"), habillage=1, label = "var", title = "PCA BC 2")#plotando eixos variaveis com os pontos por regiao da BC

fviz_pca_biplot(pca.BC2, habillage = 1, addEllipses = TRUE, title = "PCA BC 2", col.var = "blue", label = "var") + scale_color_brewer(palette="Dark2")+ theme_minimal()#plotando com elipses, em acordo com a coluna "BC.region" dada por habillage = 1

#Repetindo PCA.BC, trocando min e max de NIT por range e retirando CV_Min devido alta correl positiva com T e Sal

pca.BC3 = PCA(rhodoBC[,c("CB.region", "B_CV_Max", "B_Fe_Max", "B_Light_Max", "B_Light_Min", "B_NIT_R", "B_SAL_R", "B_T_R", "BAT", "River", "S_CAL_X", "S_CO2_X")], scale.unit=T, ncp=5, quali.sup=1, graph=T)#reduziu a explicação para 75,54 da variancia dos dados.
summary(pca.BC3)

# Contributions of variables to PC1
fviz_contrib(pca.BC3, choice = "var", axes = 1, top = 10)#inverteu a lógica dos eixos, PC1 com nitrato_range + as IPC dos PC2 anteriores (calcita, CO2, batimetria, Fe e LuzMin)
# Contributions of variables to PC2
fviz_contrib(pca.BC3, choice = "var", axes = 2, top = 10)#com inversão as IPC foram T, sal, CV_max e luzMax
fviz_contrib(pca.BC3, choice = "var", axes = 1:2, top = 15)


plot.PCA(pca.BC3, axes=c(1, 2), choix = "ind", habillage=1, label = "var", title = "PCA BC 3") #plotando os pontos colorindo pela variavel "BC.region" pelo argumento habillage = 1

fviz_pca_biplot(pca.BC3,  geom = c("point", "text"), habillage=1, label = "var", title = "PCA BC 3")#plotando eixos variaveis com os pontos por regiao da BC

fviz_pca_biplot(pca.BC3, habillage = 1, addEllipses = TRUE, title = "PCA BC 3", col.var = "blue", label = "var") + scale_color_brewer(palette="Dark2")+ theme_minimal()#plotando com elipses, em acordo com a coluna "BC.region" dada por habillage = 1

#Repetindo PCA.BC, deixando NIT_Max e Light_Min, tirando os opostos

pca.BC4 = PCA(rhodoBC[,c("CB.region", "B_CV_Max", "B_Fe_Max", "B_Light_Min", "B_NIT_Max", "B_SAL_R", "B_T_R", "BAT", "River", "S_CAL_X", "S_CO2_X")], scale.unit=T, ncp=5, quali.sup=1, graph=T)#maior explicação 81,44 da variancia dos dados.
summary(pca.BC4)

# Contributions of variables to PC1
fviz_contrib(pca.BC4, choice = "var", axes = 1, top = 10)#mantida a lógica invertida dos eixos, PC1 com nitrato + as IPC dos PC2 anteriores (CO2, batimetria, Fe e rio no lugar de LuzMin), exceto calcita
# Contributions of variables to PC2
fviz_contrib(pca.BC4, choice = "var", axes = 2, top = 10)#com inversão as IPC foram T, sal, CV_max e calcita (nitrato_max e luz_min estranhamente entraram aqui tb)
fviz_contrib(pca.BC4, choice = "var", axes = 1:2, top = 15)


plot.PCA(pca.BC4, axes=c(1, 2), choix = "ind", habillage=1, label = "var", title = "PCA BC 4") #plotando os pontos colorindo pela variavel "BC.region" pelo argumento habillage = 1

fviz_pca_biplot(pca.BC4,  geom = c("point", "text"), habillage=1, label = "var", title = "PCA BC 4")#plotando eixos variaveis com os pontos por regiao da BC

fviz_pca_biplot(pca.BC4, habillage = 1, addEllipses = TRUE, title = "PCA BC 4", col.var = "blue", label = "var") + scale_color_brewer(palette="Dark2")+ theme_minimal()#plotando com elipses, em acordo com a coluna "BC.region" dada por habillage = 1

#Repetindo PCA.BC com base na BC 2, retirando Ferro, NIT_Min devido alta correl com CV_Max e retirando CV_Min devido alta correl positiva com T e Sal. O mesmo conjunto com Ferro explica menos.

pca.BC5 = PCA(rhodoBC[,c("CB.region", "B_CV_Max", "B_Light_Max", "B_Light_Min", "B_NIT_Max", "B_SAL_R", "B_T_R", "BAT", "River", "S_CAL_X", "S_CO2_X")], scale.unit=T, ncp=5, quali.sup=1, graph=T)#explica 79,03 da variancia dos dados.
summary(pca.BC5)

# Contributions of variables to PC1
fviz_contrib(pca.BC5, choice = "var", axes = 1, top = 10)#inverteu a lógica dos eixos, PC1 com nitrato_range + as IPC dos PC2 anteriores (calcita, CO2, batimetria, Fe e LuzMin)
# Contributions of variables to PC2
fviz_contrib(pca.BC5, choice = "var", axes = 2, top = 10)#com inversão as IPC foram T, sal, CV_max e luzMax
fviz_contrib(pca.BC5, choice = "var", axes = 1:2, top = 15)


plot.PCA(pca.BC5, axes=c(1, 2), choix = "ind", habillage=1, label = "var", title = "PCA BC 5") #plotando os pontos colorindo pela variavel "BC.region" pelo argumento habillage = 1

fviz_pca_biplot(pca.BC5,  geom = c("point", "text"), habillage=1, label = "var", title = "PCA BC 5")#plotando eixos variaveis com os pontos por regiao da BC

fviz_pca_biplot(pca.BC5, habillage = 1, addEllipses = TRUE, title = "PCA BC 5", col.var = "blue", label = "var") + scale_color_brewer(palette="Dark2")+ theme_minimal()#plotando com elipses, em acordo com a coluna "BC.region" dada por habillage = 1

#Repetindo PCA.BC4, a de maior explicacao, retirando Ferro e River

pca.BC6 = PCA(rhodoBC[,c("CB.region", "B_CV_Max", "B_Light_Min", "B_NIT_Max", "B_SAL_R", "B_T_R", "BAT", "S_CAL_X", "S_CO2_X")], scale.unit=T, ncp=5, quali.sup=1, graph=T)#maior explicação 81,44 da variancia dos dados.
summary(pca.BC6)

# Contributions of variables to PC1
fviz_contrib(pca.BC6, choice = "var", axes = 1, top = 10)#mantida a lógica invertida dos eixos, PC1 com nitrato + as IPC dos PC2 anteriores (CO2, batimetria, Fe e rio no lugar de LuzMin), exceto calcita
# Contributions of variables to PC2
fviz_contrib(pca.BC6, choice = "var", axes = 2, top = 10)#com inversão as IPC foram T, sal, CV_max e calcita (nitrato_max e luz_min estranhamente entraram aqui tb)
fviz_contrib(pca.BC6, choice = "var", axes = 1:2, top = 15)


plot.PCA(pca.BC6, axes=c(1, 2), choix = "ind", habillage=1, label = "var", title = "PCA BC 6") #plotando os pontos colorindo pela variavel "BC.region" pelo argumento habillage = 1

fviz_pca_biplot(pca.BC6,  geom = c("point", "text"), habillage=1, label = "var", title = "PCA BC 6")#plotando eixos variaveis com os pontos por regiao da BC

fviz_pca_biplot(pca.BC6, habillage = 1, addEllipses = TRUE, title = NULL, col.var = "black", label = "var") + scale_color_brewer(palette="Dark2")+ theme_minimal()#plotando com elipses, em acordo com a coluna "BC.region" dada por habillage = 1

#Repetindo PCA.BC4, a de maior explicacao, retirando Ferro

pca.BC7 = PCA(rhodoBC[,c("CB.region", "B_CV_Max", "River", "B_Light_Min", "B_NIT_Max", "B_SAL_R", "B_T_R", "BAT", "S_CAL_X", "S_CO2_X")], scale.unit=T, ncp=5, quali.sup=1, graph=T)#maior explicação 81,44 da variancia dos dados.
summary(pca.BC7)

# Contributions of variables to PC1
fviz_contrib(pca.BC7, choice = "var", axes = 1, top = 10)#mantida a lógica invertida dos eixos, PC1 com nitrato + as IPC dos PC2 anteriores (CO2, batimetria, Fe e rio no lugar de LuzMin), exceto calcita
# Contributions of variables to PC2
fviz_contrib(pca.BC7, choice = "var", axes = 2, top = 10)#com inversão as IPC foram T, sal, CV_max e calcita (nitrato_max e luz_min estranhamente entraram aqui tb)
fviz_contrib(pca.BC7, choice = "var", axes = 1:2, top = 15)


plot.PCA(pca.BC7, axes=c(1, 2), choix = "ind", habillage=1, label = "var", title = "PCA BC 7") #plotando os pontos colorindo pela variavel "BC.region" pelo argumento habillage = 1

fviz_pca_biplot(pca.BC7,  geom = c("point", "text"), habillage=1, label = "var", title = "PCA BC 7")#plotando eixos variaveis com os pontos por regiao da BC

fviz_pca_biplot(pca.BC7, habillage = 1, addEllipses = TRUE, title = NULL, col.var = "black", label = "var") + scale_color_brewer(palette="Dark2")+ theme_minimal()#plotando com elipses, em acordo com a coluna "BC.region" dada por habillage = 1


##em todos os testes os setores da BC ficaram bem separados com somente 2 outliers do setor norte junto ao setor sul. INVESTIGAR

##SUMMARY BY CB REGION------------------------------------------------------------

rhodoBCnorte = rhodoBC[rhodoBC$CB.region == "N", ]
summary(rhodoBCnorte)
StdDev(rhodoBCnorte$S_CO2_X)
StdDev(rhodoBCnorte$S_CAL_X)
StdDev(rhodoBCnorte$B_Light_Min)

rhodoBCsul = rhodoBC[rhodoBC$CB.region == "S", ]
summary(rhodoBCsul)
StdDev(rhodoBCsul$S_CO2_X)
StdDev(rhodoBCsul$S_CAL_X)
StdDev(rhodoBCsul$B_Light_Min)

##TABELA DE OCORRENCIAS FINAL PARA O MANUSCRITO----------------------------------------------
#editando tabela de pontos de ocorrencia para inserção nos mapas com polígonos de ocorrência

rhodoBR = read.csv("Data/Tabela/PresencaRodolitos.csv", sep = ";")
rhodoBR
head(rhodoBR)
#indexando somente as linhas da BC
rhodoBC = rhodoBR[rhodoBR$Basin=="BC", ]
rhodoBC
head(rhodoBC)
dimnames(rhodoBC)

write.table(rhodoBC, "Data/Tabela/rhodoBC.csv", sep = ";", dec = ".")#retirei as nuvens de pontos dire nexcel e salvei como rhodoBCclean1.csv 

rhodoBC2 = read.csv("Data/Tabela/rhodoBCclean1.csv", sep = ";")#recarregando tabela sem os pontos dos polígonos
head(rhodoBC2)
dimnames(rhodoBC2)

install.packages("CoordinateCleaner")
install.packages("maps")

library(CoordinateCleaner)
library(maps)
library(modleR)

#checando se tem algum par de coordenadas identicas para exclusao
BC.clean <- cc_equ (x = rhodoBC2, 
                    lon = "lon",
                    lat = "lat",
                    test = "identical", 
                    value = "clean",
                    verbose = TRUE)#ZERO removed
head(BC.clean)
dimnames(BC.clean)
rhodoBCnorte = rhodoBC2[rhodoBC2$BC.region == "N", ]
rhodoBCsul = rhodoBC2[rhodoBC2$BC.region == "S", ]





(especies = unique(rhodoBCnorte$Project)) #para saber referencias das ocorrências ao norte
(especiesul = unique(rhodoBCsul$Project)) #para saber referencias das ocorrências ao norte
