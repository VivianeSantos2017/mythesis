#----------------------
##Dados Pos-Processamento
#----------------------

##EDITAR TEXTO ABAIXO
#Este script le os dados globais do Bio-Oracle (download from http://www.bio-oracle.org/downloads-to-email.php, August 02 2018; Tyberghein et al. 2012; Assis et al. 2017), corta o raster mundi para a area de estudo (ZEE) e salva os arquivos em .TIFF. Alternativamente, reamostra de acordo com a resolucao mais alta do raster de batimetria e salva os arquivos em .TIFF tambem. Daqui terei variáveis preditoras adicionais am altissima e alta resolucao para a camada de superfície e fundo para utilizacao nas analises dos dados de rodolitos para a tese e os papers da BC e de modelagem (Outubro/2019). Desenvolvido por Viviane Santos. Detalhes adicionais no README.

#instalando os pacotes
install.packages("sf")

#carregando os pacotes
require(sp)
require(rgdal)
require(raster)
require(maps)
require(rgeos)
require(sf)


#importando shape com a ZEE do Brasil

ZEE = readOGR("Data/Shape/ZEEErase.shp")
plot(ZEE)

#importando shapes com usos

blocos = readOGR("Data/Shape/BLOCOS_EXPLORATORIOS_19012021.shp")
plot(blocos)

campos = readOGR("Data/Shape/CAMPOS_PRODUCAO_14012021.shp")
plot(campos)

dnpm = readOGR("Data/Shape/DNPM.shp")
plot(dnpm)

UC = readOGR("Data/Shape/UCsMMA.shp")
plot(UC)
UC = st_crs(UC, parameters="WGS84", value = ZEE, name = UC)#tentando atribuir um crs sem sucesso
UC

#Reprojetando os shapes de usos a partir do crs do objeto/shape ZEE
blocos = spTransform(blocos, crs(ZEE))
campos = spTransform(campos, crs(ZEE))
dnpm = spTransform(dnpm, crs(ZEE))
UC = spTransform(UC, crs(ZEE))

#verificando se esta ok
blocos
campos
dnpm
ZEE

#selecionando apenas a area de interseccao entre os shapes
blocos.sel = intersect(blocos, ZEE)#nao deu mais warning
plot(blocos.sel)

campos.sel = intersect(campos, ZEE)#nao deu mais warning
plot(campos.sel)

dnpm.sel = intersect(dnpm, ZEE)#nao deu mais warning
plot(dnpm.sel)

#--------------------#
#exportando um shapes cortados ####
#--------------------#

writeOGR(
  blocos.sel, #nome do objeto a ser salvo
  dsn="Data/Shape/", #diretorio a ser salvo os resultados
  layer="blocosZEE", #nome do arquivo
  driver="ESRI Shapefile" #formato pretendido para exportação, s?o diversos formatos dispon?veis
)

writeOGR(
  campos.sel, #nome do objeto a ser salvo
  dsn="Data/Shape/", #diretorio a ser salvo os resultados
  layer="camposZEE", #nome do arquivo
  driver="ESRI Shapefile" #formato pretendido para exportação, s?o diversos formatos dispon?veis
)

writeOGR(
  dnpm.sel, #nome do objeto a ser salvo
  dsn="Data/Shape/", #diretorio a ser salvo os resultados
  layer="dnpmZEE", #nome do arquivo
  driver="ESRI Shapefile" #formato pretendido para exportação, s?o diversos formatos dispon?veis
)
