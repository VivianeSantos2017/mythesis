#----------------
##Testes ModleR
#----------------

##Instalando o ModleR
# Without vignette
remotes::install_github("Model-R/modleR", build = TRUE)
# With vignette
remotes::install_github("Model-R/modleR",
                        build = TRUE,
                        dependencies = TRUE,
                        build_opts = c("--no-resave-data", "--no-manual"),
                        build_vignettes = TRUE)

##Instalando pacote para rescale variaveis
install.packages("sdmvspecies")

##Instalando pacote para ler arquivo .rda
install.packages("gnn")

#carregando os pacotes necessarios
library(modleR)
library(raster)
library(sdmvspecies)
library(gnn)

#lendo os arquivos com os registros de ocorrência
#o arquivo deve estar salvo em .csv
registros = read.table("Data/Tabela/registros.csv", h = T, sep = ";", dec = ".")
registros
head(registros)
tail(registros)

#registros = coordenadas #exemplo com dado do R
#comando abaixo ajuda a fazer eventualmente modelo com 2 esp?cies, mas aqui esa voltado para 1 esp?cie s?
(especies = unique(registros$sp)) #cria objeto "especies" com todas as especies que tem na tabela
(especie = as.vector(especies[[1]])) #cria objeto "especie" com somente a especie 1

#importando as variáveis ambientais, criar uma pasta (exemplo/env) dentro da pasta que vc esta trabalhando para incluir os arquivos das suas variaveis, depois usar o comando abaixo com o nome dessa pasta criada
pasta = "Data/TIFF/Selecao_AA/"#para teste com rasters de baixa resolucao

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

#rescaling preditoras
preditoras2 = rescale(preditoras)
plot(preditoras2[[2]])
names(preditoras2)

ocorrencias <- registros[registros$sp == especie, c("lon", "lat")] #criando objeto ocorrencias com coluna da especie que selecionou no objeto especie e as colunas de lon e lat, facilita deixar sua tabela de especie com as colunas com esses nomes (especie, lon e lat)

sdmdata_1sp <- setup_sdmdata(species_name = especie,
                             occurrences = ocorrencias,
                             predictors = preditoras2,
                             models_dir = "./Results/modleR2",
                             partition_type = "crossvalidation",
                             cv_partitions = 5,
                             cv_n = 1,
                             seed = 512,
                             buffer_type = "NULL",
                             png_sdmdata = T,
                             n_back = 6000,
                             clean_dupl = T,
                             clean_uni = T,
                             clean_nas = T,
                             geo_filt = F, 
                             geo_filt_dist = NULL,
                             select_variables = F
                             )

do_many(species_name = especie,
        predictors = preditoras2,
        models_dir = "./Results/modleR2",
        png_partitions = T,
        write_bin_cut = T,
        write_rda = T,
        bioclim = F,
        domain = F, 
        glm = T,
        svmk = T,
        svme = F, 
        maxent = T, 
        maxnet = T,
        rf = T,
        mahal = F, 
        brt = T, 
        equalize = T)

brt15 = read_rda("Results/4.q_modleR_BAT/rhodolith/present/partitions/brt_model_rhodolith_1_5.rda", names = "mod")

rf2 = read_rda("Results/4.t_AAsem bat/modelos/rodolito/present/partititons/rf_model_rodolito_1_2.rda", names = "mod")


final_model(species_name = especie,
            algorithms = NULL, #if null it will take all the in-disk algorithms 
            models_dir = "./Results/modleR2",
            which_models = c("raw_mean", "raw_mean_th", "raw_mean_cut", "bin_consensus", "bin_mean"),
            consensus_level = 0.5,
            uncertainty = T,
            overwrite = T)

ens <- ensemble_model(especie,
                      occurrences = ocorrencias,
                      performance_metric = "TSSmax",
                      which_final = c("raw_mean_cut"),
                      which_ensemble = c("average", 
                                         "best",
                                         "frequency",
                                         "weighted_average",
                                         "median",
                                         "pca",
                                         "consensus"),
                      consensus_level = 0.5,
                      models_dir = "./Results/modleR2",
                      overwrite = TRUE)

