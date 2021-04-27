#----------------
##Testes ModleR
#----------------

##Instalando o ModleR
# Without vignette
remotes::install_github("Model-R/modleR", build = TRUE)
# With vignette
remotes::install_github("Model-R/modleR", build = TRUE,
                        build_opts = c("--no-resave-data", "--no-manual"))

#carragenado os pacotes necessarios
library(modleR)
library(raster)

#lendo os arquivos com os registros de ocorrência
#o arquivo deve estar salvo em .csv
registros = read.table("Data/Tabela/sdmdata_AA_sdm.csv", h = T, sep = ";", dec = ".")
registros
head(registros)
tail(registros)

#registros = coordenadas #exemplo com dado do R
#comando abaixo ajuda a fazer eventualmente modelo com 2 esp?cies, mas aqui esa voltado para 1 esp?cie s?
(especies = unique(registros$sp)) #cria objeto "especies" com todas as especies que tem na tabela
(especie = as.vector(especies[[1]])) #cria objeto "especie" com somente a especie 1

#importando as variáveis ambientais, criar uma pasta (exemplo/env) dentro da pasta que vc esta trabalhando para incluir os arquivos das suas variaveis, depois usar o comando abaixo com o nome dessa pasta criada
pasta = "Data/TIFF/Selecao/"#para teste com rasters de altissima resolucao

#caso seus rasters nao estejam no formato .tif precisa mudar o argumento pattern

lista = list.files(pasta,
                   pattern = ".tif",#aqui digo quero so os arquivos com extensao tif
                   full.names = TRUE) #da o caminho completo dos arquivos
lista #criado um vetor de caracteres, para importar tudo de 1 vez s?

#importando direto os arquivos para o stack
preditoras = stack(lista)
preditoras
names(preditoras) #vem sua lista de preditoras numeradas
plot(preditoras[[2]]) #pedi para plotar so a preditora 19 (DistRios)
#predictors = example_vars  #arquivo modelo do R para teste

ocorrencias <- registros[registros$sp == especie, c("lon", "lat")] #criando objeto ocorrencias com coluna da especie que selecionou no objeto especie e as colunas de lon e lat, facilita deixar sua tabela de especie com as colunas com esses nomes (especie, lon e lat)

sdmdata_1sp <- setup_sdmdata(species_name = especie,
                             occurrences = ocorrencias,
                             predictors = preditoras,
                             models_dir = "./Results/modleR",
                             partition_type = "crossvalidation",
                             cv_partitions = 3,
                             cv_n = 1,
                             seed = 512,
                             buffer_type = NULL,
                             plot_sdmdata = T,
                             n_back = 6000,
                             clean_dupl = F,
                             clean_uni = F,
                             clean_nas = T,
                             geo_filt = F, 
                             geo_filt_dist = NULL,
                             select_variables = F
                             )

do_many(species_name = especie,
        predictors = preditoras,
        models_dir = "./Results/modleR",
        write_png = T,
        write_bin_cut = F,
        bioclim = F,
        domain = F, 
        glm = T,
        svmk = T,
        svme = T, 
        maxent = T, 
        maxnet = F,
        rf = T,
        mahal = F, 
        brt = T, 
        equalize = T)

final_model(species_name = especie,
            algorithms = c("glm", "svmk", "svme", "maxent", "rf", "brt"), #if null it will take all the in-disk algorithms 
            models_dir = "./Results/modleR",
            select_partitions = TRUE,
            select_par = "TSSmax",
            select_par_val = 0.7,
            which_models = c("cut_mean"),
            consensus_level = 0.5,
            uncertainty = T,
            overwrite = T)

ens <- ensemble_model(especie,
                      occurrences = ocorrencias,
                      which_final = c("cut_mean"),
                      models_dir = "./Results/modleR",
                      overwrite = TRUE)

