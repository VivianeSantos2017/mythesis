

#carregando pacotes
require(sp)
require(rgdal)
require(raster)
require(maps)
require(rgeos)
require(geosphere)


#importando raster do modelo de distribui??o do habitat rodolito
modelo = raster("rodolitos/AnaliseUsos/rodolito_ensemble_average.tif")
modelo
plot(modelo)

#extraindo adequabilidade > 0.5
values(modelo)[values(modelo) < 0.5] = NA
plot(modelo)

#atribuindo o mesmo valor aos pixels
values(modelo)[values(modelo) > 0.4] = 1
plot(modelo)

#convertendo raster em poligono
model.bin <- as(modelo, 'SpatialPolygons')
model.bin
plot(model.bin)

#calculo da area em metros quadrados
area(model.bin)

#Mas precisamos incluir na tabela de atributos, criando uma coluna com os valores de area
model.bin$area = area(model.bin)
model.bin
data.frame(model.bin)
sum(model.bin$area)

#importando shape ZEE
ZEE = readOGR("rodolitos/AnaliseUsos/ZEEErase.shp")
ZEE
plot(ZEE)
#definindo o CRS igual ao do objeto com os pontos
crs(ZEE) = crs(model.bin)
area(ZEE)

#importando shape ecorregioes
ecoregion = readOGR("rodolitos/AnaliseUsos/EcoRE.shp")
ecoregion
plot(ecoregion)
data.frame(ecoregion)
#definindo o CRS igual ao do objeto com os pontos
crs(ecoregion) = crs(model.bin)


#selecionando area por ecoregiao
Amazonia = ecoregion[ecoregion$ECOREGION=="Amazonia",]
Amazonia
plot(Amazonia)
area(Amazonia)

NE = ecoregion[ecoregion$ECOREGION=="Northeastern Brazil",]
NE
plot(NE)
area(NE)

FN.atol = ecoregion[ecoregion$ECOREGION=="Fernando de Naronha and Atoll das Rocas",]
FN.atol
plot(FN.atol)
area(FN.atol)

Leste = ecoregion[ecoregion$ECOREGION=="Eastern Brazil",]
Leste
plot(Leste)
area(Leste)

SE = ecoregion[ecoregion$ECOREGION=="Southeastern Brazil",]
SE
plot(SE)
area(SE)

TDMV = ecoregion[ecoregion$ECOREGION=="Trindade and Martin Vaz Islands",]
TDMV
plot(TDMV)
area(TDMV)

#selecionar os poligonos e calcular area por ecoregiao
Amazonia.sel = model.bin[Amazonia,]
Amazonia.sel
plot(Amazonia.sel, axes = T)
data.frame(Amazonia.sel)
sum(Amazonia.sel$area)

NE.sel = model.bin[NE,]
NE.sel
plot(NE.sel, axes = T)
data.frame(NE.sel)
sum(NE.sel$area)

FN.atol.sel = model.bin[FN.atol,]
FN.atol.sel
plot(FN.atol.sel, axes = T)
data.frame(FN.atol.sel)
sum(FN.atol.sel$area)

Leste.sel = model.bin[Leste,]
Leste.sel
plot(Leste.sel, axes = T)
data.frame(Leste.sel)
sum(Leste.sel$area)

SE.sel = model.bin[SE,]
SE.sel
plot(SE.sel, axes = T)
data.frame(SE.sel)
sum(SE.sel$area)

TDMV.sel = model.bin[TDMV,]
TDMV.sel
plot(TDMV.sel, axes = T)
data.frame(TDMV.sel)
sum(TDMV.sel$area)


#importando dataset O&G e mineracao

blocos = readOGR("rodolitos/AnaliseUsos/BLOCOS_EXPLORATORIOS_19012021.shp")
blocos
plot(blocos)

campos = readOGR("rodolitos/AnaliseUsos/CAMPOS_PRODUCAO_14012021.shp")
campos
plot(campos)

dnpm = readOGR("rodolitos/AnaliseUsos/DNPM.shp")
dnpm
plot(dnpm)

#Reprojetando os shapes O&G a partir do crs do shape model.bin
blocos = spTransform(blocos, crs(model.bin))
campos = spTransform(campos, crs(model.bin))
dnpm = spTransform(dnpm, crs(model.bin))

#verificando se esta ok agora
blocos
model.bin
campos
dnpm

#selecionando apenas a area de interseccao com O&G e mineracao
rodo.bloco = intersect(model.bin, blocos)
rodo.bloco
plot(rodo.bloco)
sum(rodo.bloco$area)

rodo.campos = intersect(model.bin, campos)
rodo.campos
plot(rodo.campos)
sum(rodo.campos$area)

rodo.dnpm = intersect(model.bin, dnpm)
rodo.dnpm
plot(rodo.dnpm)
sum(rodo.dnpm$area)

#importando dataset UCs

UC = readOGR("rodolitos/AnaliseUsos/UC_fed_junho_2020.shp")
UC
plot(UC)

#Reprojetando o shape UC a partir do crs do shape model.bin
UC = spTransform(UC, crs(model.bin))

#verificando se esta ok agora
UC
model.bin

#selecionando apenas a area de interseccao com UCs

rodo.UC = intersect(model.bin, UC)
rodo.UC
plot(rodo.UC)
sum(rodo.UC$area)

#selecionando apenas a area de interseccao UCs com atividades humanas

UC.bloco = intersect(rodo.bloco, rodo.UC)#oba! sem interseccao!!!
UC.bloco
plot(UC.bloco)
sum(UC.bloco$area)

UC.campos = intersect(rodo.campos, rodo.UC)
UC.campos
plot(UC.campos)#deu um poligono estranho...
sum(UC.campos$area)#deu zero

UC.dnpm = intersect(rodo.dnpm, rodo.UC)#deu erro, vou tentar UC e dnpm primeiro e depois com model.bin

UC.dnpm = intersect(dnpm, UC)
UC.dnpm
plot(UC.dnpm)

rodo.UC.dnpm = intersect(model.bin, UC.dnpm)
rodo.UC.dnpm
plot(rodo.UC.dnpm)
sum(rodo.UC.dnpm$area)


writeOGR(
  rodo.UC.dnpm, #nome do objeto a ser salvo
  dsn="rodolitos/AnaliseUsos/resultados", #diretorio a ser salvo os resultados
  layer="rodoUCdnpm", #nome do arquivo
  driver="ESRI Shapefile" #formato pretendido para exportação, s?o diversos formatos dispon?veis
)


#Usando a mesma logica para checar UC.campos
UC.campos = intersect(campos, UC)
UC.campos
plot(UC.campos)

rodo.UC.campos = intersect(model.bin, UC.campos)
rodo.UC.campos
plot(rodo.UC.campos)#deu o mesmo poligono estranho
sum(rodo.UC.campos$area)#nao deu ZERO (12,2km2), onde será?

writeOGR(
  rodo.UC.campos, #nome do objeto a ser salvo
  dsn="rodolitos/AnaliseUsos/resultados", #diretorio a ser salvo os resultados
  layer="rodoUCcampos", #nome do arquivo
  driver="ESRI Shapefile" #formato pretendido para exportação, s?o diversos formatos dispon?veis
)

#Descobrindo - Calcular area de UC em campos e mineracao por ecoregiao
Amazonia.UC.dnpm = rodo.UC.dnpm[Amazonia,]#so mineracao, pois já sabemos que nao tema campos lá, DEU ERRO EM DIMENSAO
Amazonia.UC.dnpm
plot(Amazonia.UC.PI, axes = T)
data.frame(Amazonia.UC.PI)
sum(Amazonia.UC.PI$area)

NE.UC.dnpm = rodo.UC.dnpm[NE,]#DEU ERRO EM DIMENSAO
NE.UC.campos
plot(NE.UC.campos, axes = T)
data.frame(NE.UC.campos)
sum(NE.UC.campos$area)

NE.UC.campos = rodo.UC.campos[NE,]
NE.UC.campos
plot(NE.UC.campos, axes = T)
data.frame(NE.UC.campos)
sum(NE.UC.campos$area)

Leste.UC.campos = rodo.UC.campos[Leste,]
Leste.UC.campos
plot(Leste.UC.campos, axes = T)
data.frame(Leste.UC.campos)
sum(Leste.UC.campos$area)

SE.UC.campos = rodo.UC.campos[SE,]
SE.UC.campos
plot(SE.UC.campos, axes = T)
data.frame(SE.UC.campos)
sum(SE.UC.campos$area)


#indexando UCs de Protecao Integral (PI)
UC$sigla
UC.PI = UC[UC$sigla == "REBIO" | UC$sigla == "PARNA" | UC$sigla == "MONA" | UC$sigla == "REVIS" | UC$sigla == "ESEC",]

#selecionando apenas a area de interseccao com UCs de Protecao Integral (PI)
rodo.UC.PI = intersect(model.bin, UC.PI)
rodo.UC.PI
plot(rodo.UC.PI)
sum(rodo.UC.PI$area)

writeOGR(
  rodo.UC.campos, #nome do objeto a ser salvo
  dsn="rodolitos/AnaliseUsos/resultados", #diretorio a ser salvo os resultados
  layer="rodoUCPI", #nome do arquivo
  driver="ESRI Shapefile" #formato pretendido para exportação, s?o diversos formatos dispon?veis
)

#Calcular area geral UC por ecoregiao
TDMV.UC = rodo.UC[TDMV,]
TDMV.UC
plot(TDMV.UC, axes = T)
data.frame(TDMV.UC)
sum(TDMV.UC$area)

FN.atol.UC = rodo.UC[FN.atol,]
FN.atol.UC
plot(FN.atol.UC, axes = T)
data.frame(FN.atol.UC)
sum(FN.atol.UC$area)

Amazonia.UC = rodo.UC[Amazonia,]
Amazonia.UC
plot(Amazonia.UC, axes = T)
data.frame(Amazonia.UC)
sum(Amazonia.UC$area)

NE.UC = rodo.UC[NE,]
NE.UC
plot(NE.UC, axes = T)
data.frame(NE.UC)
sum(NE.UC$area)

Leste.UC = rodo.UC[Leste,]
Leste.UC
plot(Leste.UC, axes = T)
data.frame(Leste.UC)
sum(Leste.UC$area)

SE.UC = rodo.UC[SE,]
SE.UC
plot(SE.UC, axes = T)
data.frame(SE.UC)
sum(SE.UC$area)

#Calcular area das atividades de O&G e mineracao por ecoregiao
Amazonia.bloco = rodo.bloco[Amazonia,]
Amazonia.bloco
plot(Amazonia.bloco, axes = T)
data.frame(Amazonia.bloco)
sum(Amazonia.bloco$area)

Amazonia.campos = rodo.campos[Amazonia,]
Amazonia.campos
plot(Amazonia.campos, axes = T)
data.frame(Amazonia.campos)
sum(Amazonia.campos$area)

Amazonia.dnpm = rodo.dnpm[Amazonia,]
Amazonia.dnpm
plot(Amazonia.dnpm, axes = T)
data.frame(Amazonia.dnpm)
sum(Amazonia.dnpm$area)

NE.bloco = rodo.bloco[NE,]
NE.bloco
plot(NE.bloco, axes = T)
data.frame(NE.bloco)
sum(NE.bloco$area)

NE.campos = rodo.campos[NE,]
NE.campos
plot(NE.campos, axes = T)
data.frame(NE.campos)
sum(NE.campos$area)

NE.dnpm = rodo.dnpm[NE,]
NE.dnpm
plot(NE.dnpm, axes = T)
data.frame(NE.dnpm)
sum(NE.dnpm$area)

Leste.bloco = rodo.bloco[Leste,]
Leste.bloco
plot(Leste.bloco, axes = T)
data.frame(Leste.bloco)
sum(Leste.bloco$area)

Leste.campos = rodo.campos[Leste,]
Leste.campos
plot(Leste.campos, axes = T)
data.frame(Leste.campos)
sum(Leste.campos$area)

Leste.dnpm = rodo.dnpm[Leste,]
Leste.dnpm
plot(Leste.dnpm, axes = T)
data.frame(Leste.dnpm)
sum(Leste.dnpm$area)

SE.bloco = rodo.bloco[SE,]
SE.bloco
plot(SE.bloco, axes = T)
data.frame(SE.bloco)
sum(SE.bloco$area)

SE.campos = rodo.campos[SE,]
SE.campos
plot(SE.campos, axes = T)
data.frame(SE.campos)
sum(SE.campos$area)

SE.dnpm = rodo.dnpm[SE,]
SE.dnpm
plot(SE.dnpm, axes = T)
data.frame(SE.dnpm)
sum(SE.dnpm$area)

TDMV.bloco = rodo.bloco[TDMV,]
TDMV.bloco
plot(TDMV.bloco, axes = T)
data.frame(TDMV.bloco)
sum(TDMV.bloco$area)

TDMV.campos = rodo.campos[TDMV,]
TDMV.campos
plot(TDMV.campos, axes = T)
data.frame(TDMV.campos)
sum(TDMV.campos$area)

TDMV.dnpm = rodo.dnpm[TDMV,]
TDMV.dnpm
plot(TDMV.dnpm, axes = T)
data.frame(TDMV.dnpm)
sum(TDMV.dnpm$area)

FN.atol.dnpm = rodo.dnpm[FN.atol,]
FN.atol.dnpm
plot(FN.atol.dnpm, axes = T)
data.frame(FN.atol.dnpm)
sum(FN.atol.dnpm$area)


#calculo da area em metros quadrados
area(rodo.bloco)

#Mas precisamos incluir na tabela de atributos, criando uma coluna com os valores de area
rodo.bloco$area = area(rodo.bloco)
rodo.bloco

writeOGR(
  rodo.bloco, #nome do objeto a ser salvo
  dsn="rodolitos/AnaliseUsos/resultados", #diretorio a ser salvo os resultados
  layer="areablocos", #nome do arquivo
  driver="ESRI Shapefile" #formato pretendido para exportação, s?o diversos formatos dispon?veis
)





#plotando
plot(rodo.bloco, axes = T)
plot(veg.sel[veg.sel$DESC_TIPO == "Vegetacao Secundaria e Atividades Agricolas",],
     add = T, col = "tomato")
plot(veg.sel[veg.sel$DESC_TIPO == "Submontana",],
     add = T, col = "green4")

#selecionando os nomes do tipo de vegetacao
tipo = levels(droplevels(veg.sel$DESC_TIPO))#droplevels exclui os n?veis que vc n?o est? usando, os que ficaram forte do corte do buffer do Rio Doce
tipo

#incluindo a legenda
legend("bottomright", legend = tipo, fill = c("tomato", "green4"), cex = 0.7, bg='gray80')

#importando shape da vegetação (IBGE 1992)
veg = readOGR("../../Dataset/_Dataset/shape/veg_1992_ibge.shp", encoding = "UTF-8", p4s = crs(ucs)@projargs)
veg


#explorando o shape da vegetação
data.frame(veg)
veg@data #faz o mesmo que a fun??o acima, s? visualiza os dados de veg
head(data.frame(veg))
names(veg)
levels(veg$NOME)#acessa quantos tipos/classes de vegeta??es que existem, ajudando a pegar o nome para fazer indexa??o por exemplo.

#verificando os objetos dos rios
plot(app.rio, axes = T, col = 'lightblue')
plot(riodoce, axes = T, col = 'darkblue', add = T)
plot(estados, add = T)

#selecionando apenas a area de interseccao entre os shapes
veg.sel = intersect(app.rio, veg)

#ops...deu warning! In intersect(app.rio, veg) : non identical CRS
#qual foi o warning? Significa que o conjunto de coordenadas n?o ? id?ntico. Ent?o ? preciso definir o crs.

#Vamos resolver, reprojetando o shape app.rio a partir do crs do objeto/shape veg
app.rio = spTransform(app.rio, crs(veg))

#verificando se esta ok agora
app.rio
veg

#selecionando apenas a area de interseccao entre os shapes
veg.sel = intersect(app.rio, veg)#n?o deu mais warning
veg.sel

#plotando
plot(veg.sel, axes = T)
plot(veg.sel[veg.sel$DESC_TIPO == "Vegetacao Secundaria e Atividades Agricolas",],
     add = T, col = "tomato")
plot(veg.sel[veg.sel$DESC_TIPO == "Submontana",],
     add = T, col = "green4")

#selecionando os nomes do tipo de vegetacao
tipo = levels(droplevels(veg.sel$DESC_TIPO))#droplevels exclui os n?veis que vc n?o est? usando, os que ficaram forte do corte do buffer do Rio Doce
tipo

#incluindo a legenda
legend("bottomright", legend = tipo, fill = c("tomato", "green4"), cex = 0.7, bg='gray80')


#----------------------------------#
#Calculando a area de um poligono ####
#--------------------------------#

#calculo da area em metros quadrados
area(estados)

#Mas precisamos incluir na tabela de atributos, criando uma coluna com os valores de area
estados$area = area(estados)

estados

#--------------------------------------#
#Calculando o perimetro de um poligono ####
#--------------------------------------#
install.packages("geosphere")
require(geosphere)
#calculo do perimetro ou comprimento em metros
perimeter(estados)

#Mas precisamos incluir na tabela de atributos
estados$perimetro = perimeter(estados)

estados

#---------------------#
#Calculando EOO e AOO ####
#---------------------#

#EOO: extens?o de ocorr?ncia, um dos crit?rios da IUCN para calcular risco
#A EOO pode frequentemente ser medida por um minimo poligono convexo
#(o menor poligono no qual nenhum angulo interno seja maior que 180? e
#que contenha todos os pontos de ocorrencia) (IUCN 2001).

require(dismo)

EOO = convHull(especie.shape)#tran?ando um pol?gono de uma ?rea com base somente nos pontos de ocorr?ncia, mas trabalha com shapes criados a partir de pontos
EOO
str(EOO)
EOO@polygons

plot(EOO@polygons, axes = T, las = 1)
points(especie.shape)

#AOO
#A area de ocupacao edefinida como a area ou
#a soma das areas ocupadas por um taxon no interior da sua extensao de ocorrencia.

#vizualisando a distribuicao da especie
plot(especie.shape, axes = T, las = 1)

#criando um buffer de 50km ou 50000 metros
especie.buffer = buffer(especie.shape, 50000)

#plotando o buffer e adicionando os pontos
plot(especie.buffer, col = "gray70", axes = T, las = 1)
points(especie.shape, col = 2, pch = 16)

#plotando a EOO em cima do buffer
plot(EOO@polygons, add = T, lwd = 2, lty = 1)
#a ?rea de ocupa??o (AOO) ? toda a ?reaa cinza dentro do pol?gono de extens?o de ocorr?ncia
#gerando a AOO
AOO = intersect(especie.buffer, EOO@polygons)
AOO

#plotando
plot(AOO, axes = T, las = 1, col = "gray80", border = "transparent")
points(especie.shape, pch = '.', col = 1, cex = 2)
plot(EOO@polygons, add = T, lwd = 2, lty = 1)

#valor da AOO em metros quadrados
area(AOO)

plot(pontos, add=T)




#----------------------------#
#plotando mapas com o spplot ####
#----------------------------#

#unindo por regiao
regiao = aggregate(estados, by = "regiao_id")

#plot simples
plot(regiao, axes = T)

#definindo os parâmetros da escala e da seta do norte
scale = list("SpatialPolygonsRescale", layout.scale.bar(),
             offset = c(-70,-30), scale = 10, fill=c("transparent","black"))#offset indica a posi??o da escala no mapa, scale indica o tamanho, fill indica a cor de cada elemento da escala
text1 = list("sp.text", c(-70,-28), "0") #texto 1 da escala (0)
text2 = list("sp.text", c(-60,-28), "500 m") #texto 2 da escala (500m)
arrow = list("SpatialPolygonsRescale", layout.north.arrow(),
             offset = c(-40,0), scale = 5)

#um plot mais elaborado considerando os objetos acima
spplot(regiao, scales = list(draw = TRUE), col.regions = 1:5,
       sp.layout = list(scale, text1, text2, arrow))

#ATENCAO!
#para mais possibilidades visite as galerias nos link
