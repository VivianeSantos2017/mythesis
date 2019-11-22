#-------------------------------------
##Data Extraction
#-------------------------------------

#Este script le todos dados ambientais padronizados de acordo com a resolucao da batimetria e extrai as informacoes referentes aos registros de ocorrencia de rodolitos obtidos. Essas informacoes serao utilizadas nas analises dos dados de rodolitos para a tese e os papers da BC e de modelagem (Novembro/2019). Desenvolvido por Viviane Santos. Detalhes adicionais no README.

library(raster)
library(rgdal)

#Lendo tabela de registros rodolitos

tabela = read.table("Data/Tabela/PresencaRodolitos.csv", header = T, sep = ";", dec=".")
tabela
head(tabela)
tail(tabela)

colnames(tabela)

#listando os arquivos tif da pasta SELECAO
lista = list.files(path = "Data/TIFF/Selecao/",
                   pattern = ".tif",#aqui digo quero so os arquivos com extensao tif
                   full.names = TRUE) #da o caminho completo dos arquivos
lista #criado um vetor de caracteres, para importar tudo de 1 vez so

#importando direto os arquivos para o stack
abio = stack(lista)
abio

#Extraindo os valores das variaveis para os registros de rodolitos

valores = extract(abio, tabela[ , c("X","Y")])#selecionando as colunas X e Y, pois so preciso da lat e long
head(valores)

abiorodolitos = cbind(tabela, valores)#unindo os valores a tabela original dos pontos
abiorodolitos
head(abiorodolitos)
tail(abiorodolitos)

#Exportando tabela dos pontos com os dados extraidos dos rasters
write.table(abiorodolitos, "Data/Tabela/AbioRodolitos.csv", sep = ";", dec = ".")
