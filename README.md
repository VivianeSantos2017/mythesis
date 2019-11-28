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

Arquivos resultantes de análise no R ou modelos

5) Scripts/

Todos os scripts construídos durante a tese e relevantes para reacessar os dados gerados.

Os scripts de geração de rasters de variáveis para a ZEE foram elaborados tomando como base a altíssima resolução do raster de batimetria do GEBCO. No entanto, após realizar as análises exploratórias verifiquei que a batimetria e as variáveis derivadas dela pouco explicavam a variância dos dados de presença. Além disso, em testes realizados no ModleR foi verificado um grande aumento do tempo necessário para rodar todas as funções, em especial a do_many. Os rasters em altíssima resolução foram então transferidos para a pasta RasterZEE_AA e uma nova pasta RasterZEE foi aberta para geração de raster em alta resolução, tomando como base a resolução dos rasters da Bio-Oracle, excluindo-se os rasters de batimetria e suas variáveis derivadas. Todos os scripts de corte e tratamento dos rasters Bio-Oracle e Glodap foram revisados e o raster de Distancia de Rios foi gerado novamente a partir de um raster Bio-Oracle.