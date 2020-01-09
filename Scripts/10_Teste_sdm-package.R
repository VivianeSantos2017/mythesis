setwd('dataset2/')

install.packages('sdm')

devtools::install_github('babaknaimi/sdm')


library(sdm)
installAll()
library(rgdal)
library(raster)
#----------
tabela <- read.csv("Data/Tabela/sdmdata_AA_sdm.csv", h = T, sep = ";", dec = ".")#function shapefile did not run because of missing .prj file
tabela
coordinates(tabela) = ~X+Y 
CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")

str(tabela)

proj4string(tabela)
crs(tabela) <- CRS("+proj=longlat +ellps=GRS80 +no-defs")
tabela

rhodo = readOGR("Data/Shape/Rodolitos_pontos.shp", encoding = "UTF-8")
rhodo
plot(rhodo)

sp <- tabela#function shapefile did not run because of missing .prj file
sp
head(sp)

pasta = "Data/TIFF/Selecao/"#for tests with low res rasters
pasta = "Data/TIFF/Selecao_AA/"#OR for tests with low res rasters


lst <- list.files(pasta, pattern='.tif', full.names = TRUE)
lst
preds <- stack(lst)
preds
plot(preds[[9]])
points(sp)

pseudo = sampleRandom(preds[[9]], 6000, sp=T)
points(pseudo, col='blue')

head(tabela)
tabela$species <- 1

head(tabela@data)
class(tabela)
class(tabela@data )

#------
tabela@data <- sp@data[,'species',drop=F]

pseudo@data$species <- 0
pseudo@data <- pseudo@data[,'species',drop=F]

head(pseudo@data)
head(tabela@data)
proj4string(tabela) <- proj4string(pseudo)

rhodoPA <- rbind(tabela,pseudo)
plot(rhodoPA)
summary(rhodoPA)

###extract raster values using pos pres/abs
ex <- extract(preds,rhodoPA)
head(ex)
class(ex)
ex <- data.frame(ex)





#--------
library(usdm)
v1 <- vifstep(ex)#calculates variance inflation factor (VIF) for a set of variables and excludes the highly correlated variables from the set.
v1

v2 = vifcor(ex,th=0.85)#th = threshold
v2

preds <- exclude(preds, v1)
#------------
head(sp)

df = data.frame(ex, species=rhodoPA$species)

nrow(df)
nrow(df)*70/100

s=sample(nrow(df), 6076)
train = df[s,]
test = df[-s,]
head(train)
head(test)


d <- sdmData(species ~ .,train=df)#Creates a sdmdata objects that holds species (single or multiple) and explanatory variates
d

#-------

m <- sdm(species~.,data=d,methods=c('glm','brt','rf', 'maxent', 'svm', 'gam'),#fit using 3 models
         replication=c('sub','boot','cv'),n=1,test.p=30,cv.folds=5,#evaluates using 1 run 'n=1' of subsampling and bootsrapping methods plus 5-folds of cross-validation replication methods, taking 30 percent as test
         modelSettings=list(brt=list(n.trees=2000,shrinkage=0.01)))#override the default settings for the method brt
m #maxent, svm e gam nao rodaram
# parallel::detectCores() to check the number of cores
write.sdm(m,'modelObject.sdm', overwrite = TRUE) # save the sdm object
m <- read.sdm('modelObject.sdm') # read the saved sdm object
roc(m)#Plot the Receiver Operating Characteristics (ROC) curve with AUC statistic in the legend.
dev.off()#provide control over multiple graphics devices
getVarImp(m,10)#calculates relative importance of different variables in the models using several approaches
plot(getVarImp(m,10))# if be put in plot function, a barplot is generated

getModelInfo(m)#returns a data.frame summarising some information relevant to the fitted models including modelID, method name, whether the model is fitted successfully, whether and what replication procedure is used for data partitioning, etc. getModelInfo helps to get the unique model IDs for all or certain models given the parameters that users specify.

rcurve(m,id=1)#Calculate the response of species to the range of values in each predictor variable based on the fitted models in a sdmModels object, in this case 'id=1' is 'modelID=1', which is glm subsampling.
#------------
p <- predict(m, preds, filename='predict_sdm.img')#'predict' make a Raster or matrix object (depending on input dataset) with predictions from one or several fitted models in sdmModels object
p
getZ(p)#Initial functions for a somewhat more formal approach to get or set z values (e.g. time) associated with layers of Raster* objects.
plot(p[[1:4]])

p[[1]][1000]##model 1 x 1000???

#------
en <- ensemble(m, preds, filename='ensemble_sdm.img',
               setting=list(method='weighted',stat='TSS',opt=2))#Make a Raster object with a weighted averaging over all predictions from several fitted model in a sdmModel object: ensemble using weighted averaging based on TSS statistic # and optimum threshold critesion 2 (i.e., Max(spe+sen))
plot(en)
#########
# to find out which models have TSS >= 0.6
ev <- getEvaluation(m,stat='TSS',opt=2)#evaluates for accuracy, in this case extract the value of TSS, 'opt' is a numeric value that indicates which threshold optimisation criteria should be considered if a threshold-based statistic is selected in stat. The possible value can be between 1 to 10 for "sp=se", "max(se+sp)", "min(cost)", "minROCdist", "max(kappa)", "max(ppv+npv)", "ppv=npv", "max(NMI)", "max(ccr)", "prevalence" criteria, respectively.
ev
id <- ev$modelID[which(ev$TSS >= 0.6)]#selecting models with TSS > 0.6
# we run ensemble by incorporating the models with TSS >= 0.6:
en2 <- ensemble(m, preds, filename='ensemble2_sdm.img',
               setting=list(id=id,method='weighted',stat='TSS',opt=2))#repeating ensemble only with models TSS > 0.6 (object 'id')  
plot(en2)
df$species
e <- evaluates(df$species,extract(en2,df[,c('x','y')]))#evaluates for accuracy
e@statistics#accessing statistics
e@threshold_based$threshold[2]#accessing the threshold
m
pa <- en2
pa[] <- ifelse(en2[] > 0.273647,1,0)#selectig presence area according threshold
plot(pa)#ploting presence area
#-----------------
m@models$species$glm$`1`@evaluation$test.dep@threshold_based#evaluation of glm models
ev2 <- getEvaluation(m,stat=c('AUC','COR','TSS','Sens','spe'),opt=2)# evaluation of all models considering AUC, COR, TSS, sensitivity and specificity
ev2

#-------------------------
##########################

# presence-only:
spp <- sp[sp$Occurrence ==1,]
d2 <- sdmData(Occurrence~. + f(landcove)  ,train=spp,predictors=preds,bg=list(n=1000,method='gRandom',remove=T))
d2
v <- sdm::getVarImp(m,12)
v
plot(v)

a <- rcurve(m,id=15,gg=F)#Calculate the response of species to the range of values in each predictor variable based on the fitted models in a sdmModels object. 'id'	specifies the modelIDs corresponding to the models in the sdmModels object for which the response curves should be generated. 'gg'	is logical, specifies whether the plot should be generated using the ggplot2 package (if the package is installed)
