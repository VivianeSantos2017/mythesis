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

2) Docs/

Cont�m o arquivo da tese. As vers�es antigas ficam na pasta "old".

3) Figs/

Constam todos os pngs gerados para apresenta��es ou resultantes de an�lises no R.

4) Results/

Arquivos resultantes de an�lise no R ou modelos

5) Scripts/

Todos os scripts constru�dos durante a tese e relevantes para reacessar os dados gerados.

Os scripts de gera��o de rasters de vari�veis para a ZEE foram elaborados tomando como base a alt�ssima resolu��o do raster de batimetria do GEBCO. No entanto, ap�s realizar as an�lises explorat�rias verifiquei que a batimetria e as vari�veis derivadas dela pouco explicavam a vari�ncia dos dados de presen�a. Al�m disso, em testes realizados no ModleR foi verificado um grande aumento do tempo necess�rio para rodar todas as fun��es, em especial a do_many. Os rasters em alt�ssima resolu��o foram ent�o transferidos para a pasta RasterZEE_AA e uma nova pasta RasterZEE foi aberta para gera��o de raster em alta resolu��o, tomando como base a resolu��o dos rasters da Bio-Oracle, excluindo-se os rasters de batimetria e suas vari�veis derivadas. Todos os scripts de corte e tratamento dos rasters Bio-Oracle e Glodap foram revisados e o raster de Distancia de Rios foi gerado novamente a partir de um raster Bio-Oracle.