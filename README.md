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

2) Docs/

Contém o arquivo da tese. As versões antigas ficam na pasta "old".

3) Figs/

Constam todos os pngs gerados para apresentações ou resultantes de análises no R.

4) Results/

Arquivos resultantes de análise no R ou modelos.

4.a) Teste realizado em 28/11/19 incluindo as preditoras na resolução Bio-Oracle e aquelas com melhor resposta na PCA exploratoria ("B_CV_Max", "B_CV_Min", "B_CV_R", "B_Light_Max", "B_Light_Min", "B_Light_R", "B_Nit_Max", "B_Nit_Min", "B_Nit_R", "B_PO_Max", "B_PO_Min", "B_PO_R", "B_Sal_Max", "B_Sal_Min", "B_Sal_R", "B_T_Max", "B_T_Min", "B_T_R", "DistRios",  "S_Alka_X",  "S_ARA_X", "S_CALC_X", "S_CO_X"). Maior data clean de todos os testes ate aqui, removendo 7083 pontos de presenca e mantendo somente 879. Warning message: In setup_sdmdata: Your background data had NA values,  9982 points were retained. FAZER EXTRAÇÃO DE DADOS COM VARIAVEIS NA NOVA RESOLUCAO PARA CHECAR ONDE ESTA O PROBLEMA DE NA NOS DADOS DE PRESENCA.
Foram utilizados no teste os algoritmos glm, maxent e rf. Warning messages:

do_many - glm.fit: fitted probabilities numerically 0 or 1 occurred
final_model - In .local(x, ...) : invalid layer names omitted

INFINITAMENTE MAIS RAPIDO. DUROU CERCA DE 1h. Salvo em C:\Viviane\Doutorado\Tese\mythesis\Results\modelos.

5) Scripts/

Todos os scripts construídos durante a tese e relevantes para reacessar os dados gerados.

Os scripts de geração de rasters de variáveis para a ZEE foram elaborados tomando como base a altíssima resolução do raster de batimetria do GEBCO. No entanto, após realizar as análises exploratórias verifiquei que a batimetria e as variáveis derivadas dela pouco explicavam a variância dos dados de presença. Além disso, em testes realizados no ModleR foi verificado um grande aumento do tempo necessário para rodar todas as funções, em especial a do_many. Os rasters em altíssima resolução foram então transferidos para a pasta RasterZEE_AA e uma nova pasta RasterZEE foi aberta para geração de raster em alta resolução, tomando como base a resolução dos rasters da Bio-Oracle, excluindo-se os rasters de batimetria e suas variáveis derivadas. Todos os scripts de corte e tratamento dos rasters Bio-Oracle e Glodap foram revisados e o raster de Distancia de Rios foi gerado novamente a partir de um raster Bio-Oracle.