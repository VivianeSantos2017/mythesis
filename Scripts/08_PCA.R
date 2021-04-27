#-------------------------------------
##PCA
#-------------------------------------

#Este script foi criado para explorar os dados ambientais extraidos para os locais de ocorrencia de rodolitos, de modo a buscar o conjunto de variaveis que melhor explique a variancia dos dados, bem como as especificidades de cada ecorregiao (Novembro/2019). Desenvolvido por Viviane Santos. Detalhes adicionais no README.

#instalando e carregando pacotes necessarioa
install.packages("caret")
install.packages("GGally")
install.packages("vegan")
install.packages("FactoMineR")
install.packages("factoextra")
install.packages("corrplot")
install.packages("PerformanceAnalytics")
library("PerformanceAnalytics")#permite construir matriz analitica
library("corrplot")#permite construir matriz de correl visual
library(caret)
library(GGally)
library(vegan)
library(FactoMineR)
library(factoextra)
library(ggplot2)

#lendo a tabela base
rodolitos <- read.csv("Data/Tabela/AbioRodoCalcBottom.csv", sep = ";")
head(rodolitos)
tail(rodolitos)
str(rodolitos)
dim(rodolitos)
class(rodolitos)
resumo = summary(rodolitos)
resumo

#Exportando tabela resumo com dados abioticos rodolitos
write.table(resumo, "Data/Tabela/ResumoAbioRodolitos.csv", sep = ";", dec = ".")

colnames(rodolitos)

vars = rodolitos[,c(8:21)]
correl = cor(vars)
correl #veio tudo NA, pois a planilha tinha muitas linhas NA

#importando nova tabela, sem os NA
rodolitos2 <- read.csv("Data/Tabela/AbioRodolitos2.csv", sep = ";")
head(rodolitos2)
tail(rodolitos2)
str(rodolitos2)
dim(rodolitos2)
class(rodolitos2)
resumo2 = summary(rodolitos2)
resumo2

#Exportando tabela resumo com dados abioticos rodolitos
write.table(resumo2, "Data/Tabela/ResumoAbioRodolitos2.csv", sep = ";", dec = ".")

colnames(rodolitos2)

vars = rodolitos2[,c(8:55)]
correl = cor(vars)
correl #veio tudo NA, pois a planilha tinha muitas linhas NA

write.table(correl,"Data/Tabela/correlabio.csv", sep = ";")

corrplot(correl, type="upper", order="hclust", 
         tl.col="black", tl.srt=45)#gerando matriz visual de correlacao, salva na pasta Figs
chart.Correlation(correl, histogram=TRUE, pch=19)#salvo na pasta Figs mas de dificil visualizacao

#Ha outras formas de vizualizacao com os comandos abaixo, mas deram erro devido ao alto numero de variaveis
pairs(vars)#gera graficos espelho, correlacionando as variaveis do objeto vars
ggpairs(vars)#gera grafico de relacao de variaveis, mas contendo informacoes extras, de distribuicao na diagonal e do valor da correlacao no espelho

#PCA com FactoMineR para a costa brasileira

colnames(rodolitos2)#chamando nomes das colunas da tabela de dados para inclusao na PCA

#PCA para toda a ZEE
pcaZEE = PCA(rodolitos2[,c("Ecoregion", "B_CV_Max", "B_CV_Min", "B_CV_R", "B_CV_X", "B_CV_Xmax", "B_CV_Xmin", "B_Fe_Max", "B_Fe_Min","B_Fe_R", "B_Fe_X", "B_Fe_Xmax", "B_Fe_Xmin", "B_Light_Max", "B_Light_Min", "B_Light_R", "B_Light_X", "B_Light_Xmax", "B_Light_Xmin", "B_NIT_Max", "B_NIT_Min", "B_NIT_R", "B_NIT_X", "B_NIT_Xmax", "B_NIT_Xmin", "B_PO4_Max", "B_PO4_Min", "B_PO4_R", "B_PO4_X", "B_PO4_Xmax", "B_PO4_Xmin", "B_SAL_Max", "B_SAL_Min", "B_SAL_R", "B_SAL_X", "B_SAL_Xmax", "B_SAL_Xmin", "B_T_Max", "B_T_Min", "B_T_R", "B_T_X", "B_T_Xmax", "B_T_Xmin", "BAT", "River", "S_ALKA_X", "S_ARA_X", "S_CAL_X", "S_CO2_X")], scale.unit=T, ncp=5, quali.sup=1, graph=T)#plotando PCA com variaveis explicaram 70,21 da variancia dos dados.
summary(pcaZEE)
plot.PCA(pcaZEE, axes=c(1, 2), choix = "ind", habillage=1, label = "var", title = "PCA ZEE") #plotando os pontos colorindo pela variavel "Ecoregion" pelo argumento habillage = 1

fviz_pca_biplot(pcaZEE,  geom = c("point", "text"), habillage=1, label = "var", title = "PCA ZEE")#plotando eixos variaveis com os pontos por ecorregiao da ZEE

fviz_pca_biplot(pcaZEE, habillage = 1, addEllipses = TRUE, title = "PCA ZEE", col.var = "blue", label = "var") + scale_color_brewer(palette="Dark2")+ theme_minimal()#plotando com elipses, em acordo com a coluna "Ecoregion" dada por habillage = 1

#Repetindo PCA para toda a ZEE, somente com maximos e minimos das Bio-oracle
pcaZEE2 = PCA(rodolitos2[,c("Ecoregion", "B_CV_Max", "B_CV_Min", "B_Fe_Max", "B_Fe_Min","B_Light_Max", "B_Light_Min", "B_NIT_Max", "B_NIT_Min", "B_PO4_Max", "B_PO4_Min", "B_SAL_Max", "B_SAL_Min", "B_T_Max", "B_T_Min", "BAT", "River", "S_ALKA_X", "S_ARA_X", "S_CAL_X", "S_CO2_X")], scale.unit=T, ncp=5, quali.sup=1, graph=T)#Explicou 70,7. Fe, Rios e Batimetria parecem explicar pouco a varianciae rios esta fortemente correlacionado com luz. Nitrato e fosfato muito correlacionados, tb pode sair um.
summary(pcaZEE2)
plot.PCA(pcaZEE2, axes=c(1, 2), choix = "ind", habillage=1, label = "var", title = "PCA ZEE") #plotando os pontos colorindo pela variavel "Ecoregion" pelo argumento habillage = 1, mostrou maior separacao das diferentes categorias em relacao a PCA1

fviz_pca_biplot(pcaZEE2,  geom = c("point", "text"), habillage=1, label = "var", title = "PCA ZEE")#plotando eixos variaveis com os pontos por ecorregiao da ZEE

fviz_pca_biplot(pcaZEE2, habillage = 1, addEllipses = TRUE, title = "PCA ZEE Min.Max", col.var = "blue", label = "var") + scale_color_brewer(palette="Dark2")+ theme_minimal()#plotando com elipses, em acordo com a coluna "Ecoregion" dada por habillage = 1

#Repetindo PCA para toda a ZEE, retirando primeiro Fe, rios e batimetria
pcaZEE3 = PCA(rodolitos2[,c("Ecoregion", "B_CV_Max", "B_CV_Min", "B_Light_Max", "B_Light_Min", "B_NIT_Max", "B_NIT_Min", "B_PO4_Max", "B_PO4_Min", "B_SAL_Max", "B_SAL_Min", "B_T_Max", "B_T_Min", "S_ALKA_X", "S_ARA_X", "S_CAL_X", "S_CO2_X")], scale.unit=T, ncp=5, quali.sup=1, graph=T)#Explicou 81.93 da variancia (maior explicacao).
summary(pcaZEE3)
plot.PCA(pcaZEE3, axes=c(1, 2), choix = "ind", habillage=1, label = "var", title = "PCA ZEE") #plotando os pontos colorindo pela variavel "Ecoregion" pelo argumento habillage = 1, manteve o padrao de melhor separacao das ecoregioes

fviz_pca_biplot(pcaZEE3,  geom = c("point", "text"), habillage=1, label = "var", title = "PCA ZEE")#plotando eixos variaveis com os pontos por ecorregiao da ZEE

fviz_pca_biplot(pcaZEE3, habillage = 1, addEllipses = TRUE, title = "PCA ZEE Min.Max2", col.var = "blue", label = "var") + scale_color_brewer(palette="Dark2")+ theme_minimal()#plotando com elipses, em acordo com a coluna "Ecoregion" dada por habillage = 1, mantido grupo ER74 sem variavel associada

#Repetindo PCA para toda a ZEE, retirando fosfato
pcaZEE4 = PCA(rodolitos2[,c("Ecoregion", "B_CV_Max", "B_CV_Min", "B_Light_Max", "B_Light_Min", "B_NIT_Max", "B_NIT_Min", "B_SAL_Max", "B_SAL_Min", "B_T_Max", "B_T_Min", "S_ALKA_X", "S_ARA_X", "S_CAL_X", "S_CO2_X")], scale.unit=T, ncp=5, quali.sup=1, graph=T)#Explicou 79.6 da variancia.
summary(pcaZEE4)
plot.PCA(pcaZEE4, axes=c(1, 2), choix = "ind", habillage=1, label = "var", title = "PCA ZEE") #plotando os pontos colorindo pela variavel "Ecoregion" pelo argumento habillage = 1, manteve o padrao de melhor separacao das ecoregioes

fviz_pca_biplot(pcaZEE4,  geom = c("point", "text"), habillage=1, label = "var", title = "PCA ZEE")#plotando eixos variaveis com os pontos por ecorregiao da ZEE

fviz_pca_biplot(pcaZEE4, habillage = 1, addEllipses = TRUE, title = "PCA ZEE Min.Max NIT", col.var = "blue", label = "var") + scale_color_brewer(palette="Dark2")+ theme_minimal()#plotando com elipses, em acordo com a coluna "Ecoregion" dada por habillage = 1

#PCA para toda a ZEE, so com a media e o range, mantendo todas variaveis
pcaZEE5 = PCA(rodolitos2[,c("Ecoregion", "B_CV_R", "B_CV_X", "B_Fe_R", "B_Fe_X", "B_Light_R", "B_Light_X", "B_NIT_R", "B_NIT_X", "B_PO4_R", "B_PO4_X", "B_SAL_R", "B_SAL_X", "B_T_R", "B_T_X", "BAT", "River", "S_ALKA_X", "S_ARA_X", "S_CAL_X", "S_CO2_X")], scale.unit=T, ncp=5, quali.sup=1, graph=T)#plotando PCA com variaveis explicaram menos a variancia dos dados (60.93).
summary(pcaZEE5)
plot.PCA(pcaZEE5, axes=c(1, 2), choix = "ind", habillage=1, label = "var", title = "PCA ZEE") #plotando os pontos colorindo pela variavel "Ecoregion" pelo argumento habillage = 1, manteve as ecorregioes razoavelmente separadas

fviz_pca_biplot(pcaZEE5,  geom = c("point", "text"), habillage=1, label = "var", title = "PCA ZEE")#plotando eixos variaveis com os pontos por ecorregiao da ZEE

fviz_pca_biplot(pcaZEE5, habillage = 1, addEllipses = TRUE, title = "PCA ZEE X.Range", col.var = "blue", label = "var") + scale_color_brewer(palette="Dark2")+ theme_minimal()#plotando com elipses, em acordo com a coluna "Ecoregion" dada por habillage = 1
  
##Repetindo tudo adicionando as variaveis derivadas da batimetria

#importando nova tabela, sem os NA
  
rodolitos3 = read.csv("Data/Tabela/AbioRodolitosSNA.csv", sep = ";", dec = ".")
head(rodolitos3)
tail(rodolitos3)
str(rodolitos3)
dim(rodolitos3)
class(rodolitos3)
resumo3 = summary(rodolitos3)
resumo3

#Exportando tabela resumo com dados abioticos rodolitos
write.table(resumo3, "Data/Tabela/ResumoAbioRodolitos3.csv", sep = ";", dec = ".")

colnames(rodolitos3)

vars = rodolitos3[,c(8:63)]
correl = cor(vars)
correl

write.table(correl,"Data/Tabela/correlabio3.csv", sep = ";")

corrplot(correl, type="upper", order="hclust", 
         tl.col="black", tl.srt=45)#gerando matriz visual de correlacao
chart.Correlation(correl, histogram=TRUE, pch=19)#gerando quadro de correlacao, mas de dificil visualizacao

#PCA com FactoMineR para a costa brasileira

colnames(rodolitos3)#chamando nomes das colunas da tabela de dados para inclusao na PCA

#PCA para toda a ZEE, com batimetria, derivadas batimetria, rios, glodap sup e bio-oracle min e max
pca.all = PCA(rodolitos3[,c("Ecoregion", "Aspect_R", "Aspect_S", "B_CV_Max", "B_CV_Min", "B_Fe_Max", "B_Fe_Min", "B_Light_Max", "B_Light_Min", "B_NIT_Max", "B_NIT_Min", "B_PO4_Max", "B_PO4_Min", "B_SAL_Max", "B_SAL_Min", "B_T_Max", "B_T_Min", "BAT", "FlowDir", "River", "Roughness", "S_ALKA_X", "S_ARA_X", "S_CAL_X", "S_CO2_X", "Slope_R", "Slope_S", "TPI", "TRI")], scale.unit=T, ncp=5, quali.sup=1, graph=T)#explicou 53,83 da variancia dos dados.
summary(pca.all)

# Contributions of variables to PC1
fviz_contrib(pca.all, choice = "var", axes = 1, top = 10)
# Contributions of variables to PC2
fviz_contrib(pca.all, choice = "var", axes = 2, top = 10)
# Contributions of variables to PC1 and PC2
fviz_contrib(pca.all, choice = "var", axes = 1:2, top = 10)

plot.PCA(pca.all, axes=c(1, 2), choix = "ind", habillage=1, label = "var", title = "PCA.all") #plotando os pontos colorindo pela variavel "Ecoregion" pelo argumento habillage = 1

fviz_pca_biplot(pca.all,  geom = c("point", "text"), habillage=1, label = "var", title = "PCA.all")#plotando eixos variaveis com os pontos por ecorregiao da ZEE

fviz_pca_biplot(pca.all, habillage = 1, addEllipses = TRUE, title = "PCA.all", col.var = "blue", label = "var") + scale_color_brewer(palette="Dark2")+ theme_minimal()#plotando com elipses, em acordo com a coluna "Ecoregion" dada por habillage = 1


#Repetindo PCA para toda a ZEE, retirando nitrato, aragonita, Fe, batimetria, aspecto, TPI e flowdir
pca.sel1 = PCA(rodolitos3[,c("Ecoregion", "B_CV_Max", "B_CV_Min", "B_Light_Max", "B_Light_Min", "B_PO4_Max", "B_PO4_Min", "B_SAL_Max", "B_SAL_Min", "B_T_Max", "B_T_Min", "River", "Roughness", "S_ALKA_X", "S_CAL_X", "S_CO2_X", "Slope_R", "Slope_S", "TRI")], scale.unit=T, ncp=5, quali.sup=1, graph=T)#explicou 65,12 da variancia dos dados.
summary(pca.sel1)

# Contributions of variables to PC1
fviz_contrib(pca.sel1, choice = "var", axes = 1, top = 10)
# Contributions of variables to PC2
fviz_contrib(pca.sel1, choice = "var", axes = 2, top = 10)
# Contributions of variables to PC1 and PC2
fviz_contrib(pca.sel1, choice = "var", axes = 1:2, top = 15)


plot.PCA(pca.sel1, axes=c(1, 2), choix = "ind", habillage=1, label = "var", title = "PCA Seleção 1") #plotando os pontos colorindo pela variavel "Ecoregion" pelo argumento habillage = 1, nao separou das ecoregioes

fviz_pca_biplot(pca.sel1,  geom = c("point", "text"), habillage=1, label = "var", title = "PCA Seleção 1")#plotando eixos variaveis com os pontos por ecorregiao da ZEE

fviz_pca_biplot(pca.sel1, habillage = 1, addEllipses = TRUE, title = "PCA Seleção 1", col.var = "blue", label = "var") + scale_color_brewer(palette="Dark2")+ theme_minimal()#plotando com elipses, em acordo com a coluna "Ecoregion" dada por habillage = 1

#Repetindo PCA para toda a ZEE, deixando somente Slope_S e Roughness como derivadas de batimetria
pca.sel2 = PCA(rodolitos3[,c("Ecoregion", "B_CV_Max", "B_CV_Min", "B_Light_Max", "B_Light_Min", "B_PO4_Max", "B_PO4_Min", "B_SAL_Max", "B_SAL_Min", "B_T_Max", "B_T_Min", "River", "Roughness", "S_ALKA_X", "S_CAL_X", "S_CO2_X", "Slope_S")], scale.unit=T, ncp=5, quali.sup=1, graph=T)#explicou 67 da variancia dos dados.
summary(pca.sel2)

# Contributions of variables to PC1
fviz_contrib(pca.sel2, choice = "var", axes = 1, top = 10)
# Contributions of variables to PC2
fviz_contrib(pca.sel2, choice = "var", axes = 2, top = 10)
# Contributions of variables to PC1 and PC2
fviz_contrib(pca.sel2, choice = "var", axes = 1:2, top = 15)


plot.PCA(pca.sel2, axes=c(1, 2), choix = "ind", habillage=1, label = "var", title = "PCA Seleção 2") #plotando os pontos colorindo pela variavel "Ecoregion" pelo argumento habillage = 1, separou um pouco as ecoregioes

fviz_pca_biplot(pca.sel2,  geom = c("point", "text"), habillage=1, label = "var", title = "PCA Seleção 2")#plotando eixos variaveis com os pontos por ecorregiao da ZEE

fviz_pca_biplot(pca.sel2, habillage = 1, addEllipses = TRUE, title = "PCA Seleção 2", col.var = "blue", label = "var") + scale_color_brewer(palette="Dark2")+ theme_minimal()#plotando com elipses, em acordo com a coluna "Ecoregion" dada por habillage = 1, muita sobreposicao de ecorregioes


##-------------------------------------

#Repetindo PCA com maior explicacao e separacao das ecorregioes (sem Fe, rios, batimetria e derivadas)
pca.sel.minmax = PCA(rodolitos3[,c("Ecoregion", "B_CV_Max", "B_CV_Min", "B_Light_Max", "B_Light_Min", "B_NIT_Max", "B_NIT_Min", "B_PO4_Max", "B_PO4_Min", "B_SAL_Max", "B_SAL_Min", "B_T_Max", "B_T_Min", "S_ALKA_X", "S_ARA_X", "S_CAL_X", "S_CO2_X")], scale.unit=T, ncp=5, quali.sup=1, graph=T)#Explicou 81.9 da variancia (maior explicacao). Muita sobreposição de minimo e maximo, alta correlacao entre minimos e maximos, nitrato e fosfato ara, alka, cal e CO2, exercitar com media e excluindo altas correlacoes. Baixa contribuicao da luz, trocar por rios.

summary(pca.sel.minmax)

# Contributions of variables to PC1
fviz_contrib(pca.sel.minmax, choice = "var", axes = 1, top = 10)
# Contributions of variables to PC2
fviz_contrib(pca.sel.minmax, choice = "var", axes = 2, top = 10)
# Contributions of variables to PC1 and PC2
fviz_contrib(pca.sel.minmax, choice = "var", axes = 1:2, top = 15)


plot.PCA(pca.sel.minmax, axes=c(1, 2), choix = "ind", habillage=1, label = "var", title = "PCA Seleção Mínimos e Máximos") #plotando os pontos colorindo pela variavel "Ecoregion" pelo argumento habillage = 1, manteve o padrao de melhor separacao das ecoregioes

fviz_pca_biplot(pca.sel.minmax,  geom = c("point", "text"), habillage=1, label = "var", title = "PCA Seleção Mínimos e Máximos")#plotando eixos variaveis com os pontos por ecorregiao da ZEE

fviz_pca_biplot(pca.sel.minmax, habillage = 1, addEllipses = TRUE, title = "PCA Seleção Mínimos e Máximos", col.var = "blue", label = "var") + scale_color_brewer(palette="Dark2")+ theme_minimal()#plotando com elipses, em acordo com a coluna "Ecoregion" dada por habillage = 1, mantido grupo ER74 sem variavel associada


#PCA para toda a ZEE, so com a media, excluindo fosfato, aragonita e CO2 

pca.sel.media = PCA(rodolitos3[,c("Ecoregion", "B_CV_X", "B_NIT_X", "B_SAL_X", "B_T_X", "S_ALKA_X", "S_CAL_X", "River")], scale.unit=T, ncp=5, quali.sup=1, graph=T)#maior explicacao da variancia dos dados (82.59), mas perdeu separacao dos grupos. Motivo pode ser retirada de CurrVel Min e Max

summary(pca.sel.media)

# Contributions of variables to PC1
fviz_contrib(pca.sel.media, choice = "var", axes = 1, top = 5)
# Contributions of variables to PC2
fviz_contrib(pca.sel.media, choice = "var", axes = 2, top = 5)
# Contributions of variables to PC1 and PC2
fviz_contrib(pca.sel.media, choice = "var", axes = 1:2, top = 10)


plot.PCA(pca.sel.media, axes=c(1, 2), choix = "ind", habillage=1, label = "var", title = "PCA Seleção Média") #plotando os pontos colorindo pela variavel "Ecoregion" pelo argumento habillage = 1, manteve as ecorregioes razoavelmente separadas

fviz_pca_biplot(pca.sel.media,  geom = c("point", "text"), habillage=1, label = "var", title = "PCA Seleção Média")#plotando eixos variaveis com os pontos por ecorregiao da ZEE

fviz_pca_biplot(pca.sel.media, habillage = 1, addEllipses = TRUE, title = "PCA Seleção Média", col.var = "blue", label = "var") + scale_color_brewer(palette="Dark2")+ theme_minimal()#plotando com elipses, em acordo com a coluna "Ecoregion" dada por habillage = 1

#PCA para toda a ZEE, so com a media, exceto para CV (Velocidade de corrente) 

pca.sel.X.CV = PCA(rodolitos3[,c("Ecoregion", "B_CV_Max", "B_CV_Min", "B_NIT_X", "B_SAL_X", "B_T_X", "S_ALKA_X", "S_CAL_X", "River")], scale.unit=T, ncp=5, quali.sup=1, graph=T)#perdeu explicacao da variancia dos dados (80.78), mas retomou separacao dos grupos

summary(pca.sel.X.CV)

# Contributions of variables to PC1
fviz_contrib(pca.sel.X.CV, choice = "var", axes = 1, top = 5)
# Contributions of variables to PC2
fviz_contrib(pca.sel.X.CV, choice = "var", axes = 2, top = 5)
# Contributions of variables to PC1 and PC2
fviz_contrib(pca.sel.X.CV, choice = "var", axes = 1:2, top = 10)


plot.PCA(pca.sel.X.CV, axes=c(1, 2), choix = "ind", habillage=1, label = "var", title = "PCA Seleção Final") #plotando os pontos colorindo pela variavel "Ecoregion" pelo argumento habillage = 1, manteve as ecorregioes separadas

fviz_pca_biplot(pca.sel.X.CV,  geom = c("point", "text"), habillage=1, label = "var", title = "PCA Seleção Final")#plotando eixos variaveis com os pontos por ecorregiao da ZEE

fviz_pca_biplot(pca.sel.X.CV, habillage = 1, addEllipses = TRUE, title = "PCA Seleção Final", col.var = "blue", label = "var") + scale_color_brewer(palette="Dark2")+ theme_minimal()#plotando com elipses, em acordo com a coluna "Ecoregion" dada por habillage = 1. Manteve boa separacao da selecao minimos e maximos, mas juntou as ecorregioes de Noronha (ER74) e da CVT (ER77)

#---------------------------------------------------
## Agora uma analise exclusiva para a BC

rodolitosBC = rodolitos3[rodolitos3$Basin=="BC", ]#escolhendo as linhas onde a coluna Basin é igual a BC e mantendo os valores de todas as colunas de rodolitos 3
rodolitosBC
head(rodolitosBC)

#PCA para a BC, com batimetria, derivadas batimetria, rios, glodap sup e bio-oracle min e max
pca.BC.all = PCA(rodolitosBC[,c("BC.region", "Aspect_R", "Aspect_S", "B_CV_Max", "B_CV_Min", "B_Fe_Max", "B_Fe_Min", "B_Light_Max", "B_Light_Min", "B_NIT_Max", "B_NIT_Min", "B_PO4_Max", "B_PO4_Min", "B_SAL_Max", "B_SAL_Min", "B_T_Max", "B_T_Min", "BAT", "FlowDir", "River", "Roughness", "S_ALKA_X", "S_ARA_X", "S_CAL_X", "S_CO2_X", "Slope_R", "Slope_S", "TPI", "TRI")], scale.unit=T, ncp=5, quali.sup=1, graph=T)#explicou 69.2 da variancia dos dado.
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
pca.BC1 = PCA(rodolitosBC[,c("BC.region", "B_CV_Max", "B_CV_Min", "B_Fe_Max", "B_Light_Max", "B_Light_Min", "B_NIT_Max", "B_NIT_Min", "B_SAL_Max", "B_SAL_Min", "B_T_Max", "B_T_Min", "BAT", "River", "Roughness", "S_CAL_X", "S_CO2_X", "Slope_R", "Slope_S", "TRI")], scale.unit=T, ncp=5, quali.sup=1, graph=T)#explicou 76,3 da variancia dos dados.
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

colnames(rodolitosBC)

pca.BC2 = PCA(rodolitosBC[,c("BC.region", "B_CV_Max", "B_CV_Min", "B_Fe_Max", "B_Light_Max", "B_Light_Min", "B_NIT_Max", "B_NIT_Min", "B_SAL_R", "B_T_R", "BAT", "River", "S_CAL_X", "S_CO2_X")], scale.unit=T, ncp=5, quali.sup=1, graph=T)#aumentou a explicação para 79,74 da variancia dos dados.
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

colnames(rodolitosBC)

pca.BC3 = PCA(rodolitosBC[,c("BC.region", "B_CV_Max", "B_Fe_Max", "B_Light_Max", "B_Light_Min", "B_NIT_R", "B_SAL_R", "B_T_R", "BAT", "River", "S_CAL_X", "S_CO2_X")], scale.unit=T, ncp=5, quali.sup=1, graph=T)#reduziu a explicação para 75,54 da variancia dos dados.
summary(pca.BC3)

# Contributions of variables to PC1
fviz_contrib(pca.BC3, choice = "var", axes = 1, top = 10)#inverteu a lógica dos eixos, PC1 com nitrato_range + as IPC dos PC2 anteriores (calcita, CO2, batimetria, Fe e LuzMin)
# Contributions of variables to PC2
fviz_contrib(pca.BC3, choice = "var", axes = 2, top = 10)#com inversão as IPC foram T, sal, CV_max e luzMax
fviz_contrib(pca.BC3, choice = "var", axes = 1:2, top = 15)


plot.PCA(pca.BC3, axes=c(1, 2), choix = "ind", habillage=1, label = "var", title = "PCA BC 3") #plotando os pontos colorindo pela variavel "BC.region" pelo argumento habillage = 1

fviz_pca_biplot(pca.BC3,  geom = c("point", "text"), habillage=1, label = "var", title = "PCA BC 3")#plotando eixos variaveis com os pontos por regiao da BC

fviz_pca_biplot(pca.BC3, habillage = 1, addEllipses = TRUE, title = "PCA BC 3", col.var = "blue", label = "var") + scale_color_brewer(palette="Dark2")+ theme_minimal()#plotando com elipses, em acordo com a coluna "BC.region" dada por habillage = 1

#Repetindo PCA.BC, deixando NIT_Max e Light_Min e tirando os opostos

colnames(rodolitosBC)

pca.BC4 = PCA(rodolitosBC[,c("BC.region", "B_CV_Max", "B_Fe_Max", "B_Light_Min", "B_NIT_Max", "B_SAL_R", "B_T_R", "BAT", "River", "S_CAL_X", "S_CO2_X")], scale.unit=T, ncp=5, quali.sup=1, graph=T)#maior explicação 81,44 da variancia dos dados.
summary(pca.BC4)

# Contributions of variables to PC1
fviz_contrib(pca.BC4, choice = "var", axes = 1, top = 10)#mantida a lógica invertida dos eixos, PC1 com nitrato + as IPC dos PC2 anteriores (CO2, batimetria, Fe e rio no lugar de LuzMin), exceto calcita
# Contributions of variables to PC2
fviz_contrib(pca.BC4, choice = "var", axes = 2, top = 10)#com inversão as IPC foram T, sal, CV_max e calcita (nitrato_max e luz_min estranhamente entraram aqui tb)
fviz_contrib(pca.BC4, choice = "var", axes = 1:2, top = 15)


plot.PCA(pca.BC4, axes=c(1, 2), choix = "ind", habillage=1, label = "var", title = "PCA BC 4") #plotando os pontos colorindo pela variavel "BC.region" pelo argumento habillage = 1

fviz_pca_biplot(pca.BC4,  geom = c("point", "text"), habillage=1, label = "var", title = "PCA BC 4")#plotando eixos variaveis com os pontos por regiao da BC

fviz_pca_biplot(pca.BC4, habillage = 1, addEllipses = TRUE, title = "PCA BC 4", col.var = "blue", label = "var") + scale_color_brewer(palette="Dark2")+ theme_minimal()#plotando com elipses, em acordo com a coluna "BC.region" dada por habillage = 1

##em todos os testes os setores da BC ficaram bem separados com somente 2 outliers do setor norte junto ao setor sul. INVESTIGAR
#Batimetria está com valores absolutos negativos, portanto a leitura é invertida. Retirar o sinal negativo da planilha-base. 
