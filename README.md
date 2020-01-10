# mythesis
Everything created during my PhD
Starting on GitHub


1) Data/

A pasta Data foi dividida por formato do dado. Aqui estão todos os dados a serem utilizados como entrada dos scripts e modelagens.

1.a) Subpasta: Data/NC contém os arquivos em formato .nc oriundos das bases de dados GEBCO e GLODAP. Para maiores informacoes sobre as bases, forma de citacao acessar pastas:

C:\Viviane\Doutorado\SIG\BasesDadosAbio\GEBCO
C:\Viviane\Doutorado\SIG\BasesDadosAbio\GLODAP 

1.b) Subpasta: Data/Shape contém todos os arquivos shape gerados a partir dos dados brutos (ex. Foz dos rios, Rodolitos_pontos) ou obtidos de bases de dados (ZEE)

1.c) Subpasta: Data/Tabela contém todas as tabelas .csv geradas a partir de dados brutos. A planilha PresencaRodolitos derivou da planilha excel DadosRodolitos.xls (aba PresencaRodolitosOct19), salva em C:\Viviane\Doutorado\SIG\DadosCalcariasRodolitos\PlanilhasBase. Em ambas as planilhas foram acrescidos pontos resultantes dos polígonos (nuvens de pontos), a partir da planilha PresencaRodolitos.csv foi gerada a planilha PontosBC.csv, tambem salva nesta subpasta para consolidar a analise referente ao artigo BC. BC region N = pontos em latitudes menor ou igual a 21

1.d) Subpasta: Data/TIFF contém dados obtidos por bases de dados, bem como arquivos .nc ou.shp convertidos para .tiff que serão utilizados como dados de entrada de scripts e modelagens.

INSERIR PERIODOS EM QUE OS DADOS DOS DATASET UTILIZADOS FORAM OBTIDOS:

GEBCO - Vizualizar em https://www.gebco.net/data_and_products/gridded_bathymetry_data/gebco_2019/gebco_2019_info.html e descrever aqui para registro.
Bio-Oracle - home page e artigos
Glodap - home page e artigos

2) Docs/

Contém o arquivo da tese. As versões antigas ficam na pasta "old".

3) Figs/

Constam todos os pngs gerados para apresentações ou resultantes de análises no R.

4) Results/

Arquivos resultantes de análise no R ou modelos.

4.a) Teste realizado em 28/11/19 incluindo as preditoras na resolução Bio-Oracle e aquelas 23 com melhor resposta na PCA exploratoria ("B_CV_Max", "B_CV_Min", "B_CV_R", "B_Light_Max", "B_Light_Min", "B_Light_R", "B_Nit_Max", "B_Nit_Min", "B_Nit_R", "B_PO_Max", "B_PO_Min", "B_PO_R", "B_Sal_Max", "B_Sal_Min", "B_Sal_R", "B_T_Max", "B_T_Min", "B_T_R", "DistRios",  "S_Alka_X",  "S_ARA_X", "S_CALC_X", "S_CO_X"). 

Maior data clean de todos os testes ate aqui, removendo 7083 pontos de presenca e mantendo somente 879. 
Warning message: In setup_sdmdata: Your background data had NA values,  9982 points were retained. OBS.: Fiz extracao de dados a partir dos rasters na resolucao de 9.2km e o numero de NA foi o mesmo que o encontrado para a extracao a partir de dados de alta resolucao.

Foram utilizados no teste os algoritmos glm, maxent e rf. 
Warning messages:
do_many - glm.fit: fitted probabilities numerically 0 or 1 occurred
final_model - In .local(x, ...) : invalid layer names omitted

INFINITAMENTE MAIS RAPIDO. DUROU CERCA DE 1h. Salvo em C:\Viviane\Doutorado\Tese\mythesis\Results\modelos.

4.b) Teste com rasters de alta resolucao, com 23 variaveis (excluindo os ranges e a aragonita para acrescentar batimetria e derivadas e manter o mesmo numero de variaveis do teste anterior): "Aspect_R", "B_CV_Max", "B_CV_Min", "B_Light_Max", "B_Light_Min", "B_NIT_Max", "B_NIT_Min", "B_PO4_Max", "B_PO4_Min", "B_SAL_Max", "B_SAL_Min", "B_T_Max", "B_T_Min", "BAT", "FlowDir", "River", "Roughness", "S_ALKA_X", "S_CAL_X", "S_CO2_X", "Slope_R", "TPI", "TRI"

Removidos 5282 e mantendo 2680 clean points, com 2 Warning messages na 1a funcao (setup_sdmdata):
Warning messages:
1: In dismo::randomPoints(mask = pbuffr, n = n_back_mod, p = occurrences,  :
  generated random points = 0.928 times requested number
2: In setup_sdmdata(species_name = especie, occurrences = ocorrencias,  :
  Your background data had NA values,  9158 points were retained
COMECOU 13h DE SABADO

ERRO no final_model (glm) 5:57am de domingo: Erro: não é possível alocar vetor de tamanho 559.3 Mb
Além disso: Warning messages:
1: In list(...) :
  encerrando conexão não utilizada 4 (C:/Users/Marcello/AppData/Local/Temp/RtmpacpnUt/raster/r_tmp_2019-12-01_074157_5328_93601.gri)
2: In list(...) :
  encerrando conexão não utilizada 3 (C:\Users\Marcello\AppData\Local\Temp\RtmpacpnUt\raster\r_tmp_2019-12-01_064904_5328_64817.gri)

ERRO no final_model (maxent) 2:30pm de domingo: Erro: não é possível alocar vetor de tamanho 559.3 Mb
Além disso: Warning messages:
1: In for (i in seq_along(col)) col[i] <- length(scan(file, what = "",  :
  encerrando conexão não utilizada 4 (C:/Users/Marcello/AppData/Local/Temp/RtmpacpnUt/raster/r_tmp_2019-12-01_112844_5328_43751.gri)
2: In for (i in seq_along(col)) col[i] <- length(scan(file, what = "",  :
  encerrando conexão não utilizada 3 (C:\Users\Marcello\AppData\Local\Temp\RtmpacpnUt\raster\r_tmp_2019-12-01_103503_5328_35309.gri)

ERRO no final_model (rf) 6:30pm de domingo: Erro: não é possível alocar vetor de tamanho 559.3 Mb
Além disso: Warning messages:
1: In for (i in seq_along(col)) col[i] <- length(scan(file, what = "",  :
  encerrando conexão não utilizada 4 (C:/Users/Marcello/AppData/Local/Temp/RtmpacpnUt/raster/r_tmp_2019-12-01_142735_5328_86986.gri)
2: In for (i in seq_along(col)) col[i] <- length(scan(file, what = "",  :
  encerrando conexão não utilizada 3 (C:\Users\Marcello\AppData\Local\Temp\RtmpacpnUt\raster\r_tmp_2019-12-01_133708_5328_55382.gri)

Andrea informou que o erro acima é um problema do R ue não roda arquivos grandes. Recomendou rodar as funções rm() e gc() para limpar o workspace e objetos fora de uso. se não der certo deve-se mudar de computador. Rodei as funções mas deu um novo erro:
Error in .calcTest(x[1:5], fun, na.rm, forcefun, forceapply) : 
  cannot use this function

Teste com 50 variaveis de altissima res deu erro abaixo so para glm, depois maxent ficou 1 noite inteira so para rodar 1 particao, abortei a missao
ERRO no do_many, logo no 1o algoritmo "glm":
Erro: não é possível alocar vetor de tamanho 23.8 Mb
+ warning: fitted probabilities numerically 0 or 1 occurred 

4.c) Teste realizado em 02/12/19 incluindo as preditoras na resolução Bio-Oracle e aquelas 23 com melhor resposta na PCA exploratoria ("B_CV_Max", "B_CV_Min", "B_CV_R", "B_Light_Max", "B_Light_Min", "B_Light_R", "B_Nit_Max", "B_Nit_Min", "B_Nit_R", "B_PO_Max", "B_PO_Min", "B_PO_R", "B_Sal_Max", "B_Sal_Min", "B_Sal_R", "B_T_Max", "B_T_Min", "B_T_R", "DistRios",  "S_Alka_X",  "S_ARA_X", "S_CALC_X", "S_CO_X"). 

Mantido padrao de maior data clean de todos os testes do 4.a, mesma Warning message: In setup_sdmdata: Your background data had NA values,  9982 points were retained. 

Foram utilizados no teste os algoritmos svme, svmk e brt. 

4.d) Teste com rasters de alta resolucao, com as mesmas 23 variaveis usando o Azure (início 15:30)

data clean = 4.b, ma teve mais pontos retidos no background data (9855)
Após evaluating model da 1a particao deu erro
Error in get0(oNam, envir = ns) : 
  lazy-load database '/home/modleR/R/x86_64-pc-linux-gnu-library/3.6/kuenm/R/kuenm.rdb' is corrupt
In addition: There were 50 or more warnings (use warnings() to see the first 50)Ç glm.fit: fitted probabilities numerically 0 or 1 occurred

Em fitting models maxent deu erro:
Error in .getMeVersion() : file missing:
/home/modleR/R/x86_64-pc-linux-gnu-library/3.6/dismo/java/maxent.jar.
Please download it here: http://www.cs.princeton.edu/~schapire/maxent/

Na vdd o arquivo .jar está disponivel em http://biodiversityinformatics.amnh.org/open_source/maxent/
Salvei no local solicitado e mantive o arquivo .zip em C:\Viviane\Doutorado\Tese\mythesis\maxent

PERDIDOS 30 MINUTOS NESSE INÍCIO DE RODADA E LOAD DO EXECUTAVEL DO MAXENT. REINICIADO DO_MANY 16:30PM AQUI (8:30AM EM LONDRES), SUBSTITUINDO 'GLM' POR 'BRT'

DEPOIS DE 1H, ERRO NO MAXENT:
Error in get0(oNam, envir = ns) : 
  lazy-load database '/home/modleR/R/x86_64-pc-linux-gnu-library/3.6/kuenm/R/kuenm.rdb' is corrupt
In addition: Warning messages:
1: In get0(oNam, envir = ns) : restarting interrupted promise evaluation
2: In get0(oNam, envir = ns) : internal error -3 in R_decompress1

Recomecei com comando library(kuenm), 11/01 à 9:45am até 19:40.
GLM Warning messages:
1: glm.fit: fitted probabilities numerically 0 or 1 occurred

4.e) Teste com 'sdm' e variáveis em alta resolução

8 variables from the 23 input variables have collinearity problem: 
 
B_PO4_Min B_NIT_Max B_T_Max Slope_R Roughness B_NIT_Min B_T_Min S_ALKA_X 

After excluding the collinear variables, the linear correlation coefficients ranges between: 
min correlation ( TRI ~ B_Light_Max ):  2.806258e-05 
max correlation ( B_Light_Min ~ B_Light_Max ):  0.8294715 

---------- VIFs of the remained variables -------- 
     Variables      VIF
1     Aspect_R 1.267689
2     B_CV_Max 3.853611
3     B_CV_Min 5.206453
4  B_Light_Max 4.201334
5  B_Light_Min 6.786788
6    B_PO4_Max 7.047399
7    B_SAL_Max 5.027409
8    B_SAL_Min 1.566852
9          BAT 4.961808
10     FlowDir 1.259604
11       River 1.885862
12     S_CAL_X 2.815652
13     S_CO2_X 4.160293
14         TPI 1.013820
15         TRI 1.193904

#model run 100% success for glm, brt and rf, but 0% for maxent, svm and gam

#Error in if (wtest == "test.dep") cat("model Mean performance (per species), using test dataset (generated using partitioning):\n") else if (wtest ==  : missing value where TRUE/FALSE needed

#when I tried roc(m) the error message is there is no evaluation in the model object!

4.f) Teste com 'sdm' e variáveis em menor resolução

8 variables from the 23 input variables have collinearity problem: 
 
TRI B_PO4_Min Slope_R B_NIT_Max B_T_Max B_NIT_Min B_T_Min S_ALKA_X 

After excluding the collinear variables, the linear correlation coefficients ranges between: 
min correlation ( TPI ~ B_SAL_Min ):  0.004678436 
max correlation ( B_SAL_Max ~ B_PO4_Max ):  -0.8503158 

---------- VIFs of the remained variables -------- 
     Variables      VIF
1     Aspect_R 3.310995
2     B_CV_Max 4.311676
3     B_CV_Min 5.796469
4  B_Light_Max 3.173400
5  B_Light_Min 5.220199
6    B_PO4_Max 8.646109
7    B_SAL_Max 5.990526
8    B_SAL_Min 1.401129
9          BAT 6.062099
10     FlowDir 3.575467
11       River 2.051211
12   Roughness 1.327747
13     S_CAL_X 2.974318
14     S_CO2_X 4.578802
15         TPI 1.047063

#model run 100% success for glm, brt, rf, and gam but 0% for maxent and svm

#Error in if (wtest == "test.dep") cat("model Mean performance (per species), using test dataset (generated using partitioning):\n") else if (wtest ==  : 
  missing value where TRUE/FALSE needed

#Error in roc(m) : there is no evaluation in the model object!

OBS.: O erro foi pq não foram geradas pseudoausencias (o script só tinha códigos para dados de presença). Adicionando as pseudoausências os códigos rodaram, porém as variáveis explicaram pouco da variância dos dados. O teste foi realizado excluindo as variáveis de salinidade, TRI, slope, nitrato, alcalinidade, flowdir, batimetria e CO2. RODAR NOVO TESTE CONSIDERANDO AS MESMAS VARIÁVEIS EM ALTA RESOLUÇÃO PARA VERIFICAR SE A EXPLICAÇÃO DA VARIÂNCIA MELHORA E DEPOIS RODAR NOVO TESTE EXCLUINDO FOSFATO E INSERINDO SALINIDADE.

4.g) Teste sdm2 (23 variables - all) and sdm2b considerando as variáveis vifcor th = 0.8 + temperaturas (15 variaveis)

10 variables from the 23 input variables have collinearity problem: 
 
B_PO4_Min Slope_R Roughness B_NIT_Max B_T_Max B_NIT_Min B_T_Min S_ALKA_X B_PO4_Max B_Light_Min 

After excluding the collinear variables, the linear correlation coefficients ranges between: 
min correlation ( TPI ~ B_SAL_Min ):  -0.00115684 
max correlation ( BAT ~ B_SAL_Max ):  0.7795429 

---------- VIFs of the remained variables -------- 
     Variables      VIF
1     Aspect_R 1.262577
2     B_CV_Max 2.406146
3     B_CV_Min 2.952365
4  B_Light_Max 1.525514
5    B_SAL_Max 3.996529
6    B_SAL_Min 1.698078
7          BAT 4.875291
8      FlowDir 1.249293
9        River 2.449075
10     S_CAL_X 3.187845
11     S_CO2_X 3.384450
12         TPI 1.018938
13         TRI 1.166223

4.g.1)sdm2: Something wrong. The model ran with all variables... gam did not run, the deviance was low again, maxent perform better again and BAT was the variable with major contribution.

In p <- predict(m, preds, filename='Documents/rhodolith/modelos/sdm2/predict_sdm.img')#'predict' make a Raster or matrix object (depending on input dataset) with predictions from one or several fitted models in sdmModels object
Error in .generateWLP(x = object, newdata = newdata, w = w, species = species,  : 
  the data does not contain some or all of the variables that the model needs...

4.g.2)sdm2b: gam did not run again, the deviance was low again, maxent perform better again and Light_Max, BAT, Calcite and CV were the variables with major contribution. TPI, FlowDir and Aspect were ZERO contribution, River, TPI, CO2, Tmax, Salinity were very low contributors.
In p <- predict(m, preds, filename='Documents/rhodolith/modelos/sdm2/predict_sdm.img')
Error in GDAL.close(new.obj) : 
	GDAL Error 3: Failed to write 230 bytes HFAEntry Projection(Eprj_ProParameters) data, out of disk space?
Error in save(plot, file = filename) : error writing to connection
Graphics error: Plot rendering error
Error in save(plot, file = filename) : error writing to connection
Graphics error: Plot rendering error
*mas salvou arquivos predict_sdm.ige, predict_sdm.img, e predict_sdm_img.aux.xml, com 9,6GB, 59,2KB e 0B, respectivamente.

NOVO ERRO DA FUNÇÃO 'PREDICT' PARECE PROBLEMA DE CONEXÃO ENTRE MÁQUINA E RSTUDIO, TENTAR  DE NOVO COM O SCRIPT ATUAL
DEPOIS TENTAR  DE NOVO EXCLUINDO O 'gam' QUE NÃO RODOU
REPETIR ANÁLISE DE CORREL AUMENTANDO TH PARA 0.85 PARA VERIFICAR SE BAT SAI E/OU VARIÁVEI COM BX CONTRIBUIÇÃO



5) Scripts/

Todos os scripts construídos durante a tese e relevantes para reacessar os dados gerados.

Os scripts de geração de rasters de variáveis para a ZEE foram elaborados tomando como base a altíssima resolução do raster de batimetria do GEBCO. No entanto, após realizar as análises exploratórias verifiquei que a batimetria e as variáveis derivadas dela pouco explicavam a variância dos dados de presença. Além disso, em testes realizados no ModleR foi verificado um grande aumento do tempo necessário para rodar todas as funções, em especial a do_many. Os rasters em altíssima resolução foram então transferidos para a pasta RasterZEE_AA e uma nova pasta RasterZEE foi aberta para geração de raster em alta resolução, tomando como base a resolução dos rasters da Bio-Oracle, excluindo-se os rasters de batimetria e suas variáveis derivadas. Todos os scripts de corte e tratamento dos rasters Bio-Oracle e Glodap foram revisados e o raster de Distancia de Rios foi gerado novamente a partir de um raster Bio-Oracle.

Feito teste BC para alimentar o paper BC (ver Script 08_PCA, a partir da linha 270): Em todos os testes os setores da BC ficaram bem separados com somente 2 outliers do setor norte junto ao setor sul. INVESTIGAR
#Batimetria está com valores absolutos negativos, portanto a leitura é invertida. Retirar o sinal negativo da planilha-base.