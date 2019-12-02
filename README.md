# mythesis
Everything created during my PhD
Starting on GitHub


1) Data/

A pasta Data foi dividida por formato do dado. Aqui est�o todos os dados a serem utilizados como entrada dos scripts e modelagens.

1.a) Subpasta: Data/NC cont�m os arquivos em formato .nc oriundos das bases de dados GEBCO e GLODAP. Para maiores informacoes sobre as bases, forma de citacao acessar pastas:

C:\Viviane\Doutorado\SIG\BasesDadosAbio\GEBCO
C:\Viviane\Doutorado\SIG\BasesDadosAbio\GLODAP 

1.b) Subpasta: Data/Shape cont�m todos os arquivos shape gerados a partir dos dados brutos (ex. Foz dos rios, Rodolitos_pontos) ou obtidos de bases de dados (ZEE)

1.c) Subpasta: Data/Tabela cont�m todas as tabelas .csv geradas a partir de dados brutos. A planilha PresencaRodolitos derivou da planilha excel DadosRodolitos.xls (aba PresencaRodolitosOct19), salva em C:\Viviane\Doutorado\SIG\DadosCalcariasRodolitos\PlanilhasBase. Em ambas as planilhas foram acrescidos pontos resultantes dos pol�gonos (nuvens de pontos), a partir da planilha PresencaRodolitos.csv foi gerada a planilha PontosBC.csv, tambem salva nesta subpasta para consolidar a analise referente ao artigo BC. BC region N = pontos em latitudes menor ou igual a 21

1.d) Subpasta: Data/TIFF cont�m dados obtidos por bases de dados, bem como arquivos .nc ou.shp convertidos para .tiff que ser�o utilizados como dados de entrada de scripts e modelagens.

INSERIR PERIODOS EM QUE OS DADOS DOS DATASET UTILIZADOS FORAM OBTIDOS:

GEBCO - Vizualizar em https://www.gebco.net/data_and_products/gridded_bathymetry_data/gebco_2019/gebco_2019_info.html e descrever aqui para registro.
Bio-Oracle - home page e artigos
Glodap - home page e artigos

2) Docs/

Cont�m o arquivo da tese. As vers�es antigas ficam na pasta "old".

3) Figs/

Constam todos os pngs gerados para apresenta��es ou resultantes de an�lises no R.

4) Results/

Arquivos resultantes de an�lise no R ou modelos.

4.a) Teste realizado em 28/11/19 incluindo as preditoras na resolu��o Bio-Oracle e aquelas 23 com melhor resposta na PCA exploratoria ("B_CV_Max", "B_CV_Min", "B_CV_R", "B_Light_Max", "B_Light_Min", "B_Light_R", "B_Nit_Max", "B_Nit_Min", "B_Nit_R", "B_PO_Max", "B_PO_Min", "B_PO_R", "B_Sal_Max", "B_Sal_Min", "B_Sal_R", "B_T_Max", "B_T_Min", "B_T_R", "DistRios",  "S_Alka_X",  "S_ARA_X", "S_CALC_X", "S_CO_X"). 

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

ERRO no final_model (glm) 5:57am de domingo: Erro: n�o � poss�vel alocar vetor de tamanho 559.3 Mb
Al�m disso: Warning messages:
1: In list(...) :
  encerrando conex�o n�o utilizada 4 (C:/Users/Marcello/AppData/Local/Temp/RtmpacpnUt/raster/r_tmp_2019-12-01_074157_5328_93601.gri)
2: In list(...) :
  encerrando conex�o n�o utilizada 3 (C:\Users\Marcello\AppData\Local\Temp\RtmpacpnUt\raster\r_tmp_2019-12-01_064904_5328_64817.gri)

ERRO no final_model (maxent) 2:30pm de domingo: Erro: n�o � poss�vel alocar vetor de tamanho 559.3 Mb
Al�m disso: Warning messages:
1: In for (i in seq_along(col)) col[i] <- length(scan(file, what = "",  :
  encerrando conex�o n�o utilizada 4 (C:/Users/Marcello/AppData/Local/Temp/RtmpacpnUt/raster/r_tmp_2019-12-01_112844_5328_43751.gri)
2: In for (i in seq_along(col)) col[i] <- length(scan(file, what = "",  :
  encerrando conex�o n�o utilizada 3 (C:\Users\Marcello\AppData\Local\Temp\RtmpacpnUt\raster\r_tmp_2019-12-01_103503_5328_35309.gri)

ERRO no final_model (rf) 6:30pm de domingo: Erro: n�o � poss�vel alocar vetor de tamanho 559.3 Mb
Al�m disso: Warning messages:
1: In for (i in seq_along(col)) col[i] <- length(scan(file, what = "",  :
  encerrando conex�o n�o utilizada 4 (C:/Users/Marcello/AppData/Local/Temp/RtmpacpnUt/raster/r_tmp_2019-12-01_142735_5328_86986.gri)
2: In for (i in seq_along(col)) col[i] <- length(scan(file, what = "",  :
  encerrando conex�o n�o utilizada 3 (C:\Users\Marcello\AppData\Local\Temp\RtmpacpnUt\raster\r_tmp_2019-12-01_133708_5328_55382.gri)

Andrea informou que o erro acima � um problema do R ue n�o roda arquivos grandes. Recomendou rodar as fun��es rm() e gc() para limpar o workspace e objetos fora de uso. se n�o der certo deve-se mudar de computador. Rodei as fun��es mas deu um novo erro:
Error in .calcTest(x[1:5], fun, na.rm, forcefun, forceapply) : 
  cannot use this function

Teste com 50 variaveis de altissima res deu erro abaixo so para glm, depois maxent ficou 1 noite inteira so para rodar 1 particao, abortei a missao
ERRO no do_many, logo no 1o algoritmo "glm":
Erro: n�o � poss�vel alocar vetor de tamanho 23.8 Mb
+ warning: fitted probabilities numerically 0 or 1 occurred 


4.c) Teste realizado em 02/12/19 incluindo as preditoras na resolu��o Bio-Oracle e aquelas 23 com melhor resposta na PCA exploratoria ("B_CV_Max", "B_CV_Min", "B_CV_R", "B_Light_Max", "B_Light_Min", "B_Light_R", "B_Nit_Max", "B_Nit_Min", "B_Nit_R", "B_PO_Max", "B_PO_Min", "B_PO_R", "B_Sal_Max", "B_Sal_Min", "B_Sal_R", "B_T_Max", "B_T_Min", "B_T_R", "DistRios",  "S_Alka_X",  "S_ARA_X", "S_CALC_X", "S_CO_X"). 

Mantido padrao de maior data clean de todos os testes do 4.a, mesma Warning message: In setup_sdmdata: Your background data had NA values,  9982 points were retained. 

Foram utilizados no teste os algoritmos svme, svmk e brt. 

5) Scripts/

Todos os scripts constru�dos durante a tese e relevantes para reacessar os dados gerados.

Os scripts de gera��o de rasters de vari�veis para a ZEE foram elaborados tomando como base a alt�ssima resolu��o do raster de batimetria do GEBCO. No entanto, ap�s realizar as an�lises explorat�rias verifiquei que a batimetria e as vari�veis derivadas dela pouco explicavam a vari�ncia dos dados de presen�a. Al�m disso, em testes realizados no ModleR foi verificado um grande aumento do tempo necess�rio para rodar todas as fun��es, em especial a do_many. Os rasters em alt�ssima resolu��o foram ent�o transferidos para a pasta RasterZEE_AA e uma nova pasta RasterZEE foi aberta para gera��o de raster em alta resolu��o, tomando como base a resolu��o dos rasters da Bio-Oracle, excluindo-se os rasters de batimetria e suas vari�veis derivadas. Todos os scripts de corte e tratamento dos rasters Bio-Oracle e Glodap foram revisados e o raster de Distancia de Rios foi gerado novamente a partir de um raster Bio-Oracle.