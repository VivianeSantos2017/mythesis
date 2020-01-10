setwd('dataset2/')

install.packages('sdm')

devtools::install_github('babaknaimi/sdm')


library(sdm)
installAll()
library(rgdal)
library(raster)
#----------

#Loading .csv with rhodolith records after data clean (nas and duplis)
rhodo <- read.csv("Documents/rhodolith/sdmdata_AA_sdm.csv", h = T, sep = ";", dec = ".")
head(rhodo)
tail(rhodo)

coordinates(rhodo) = ~X+Y
CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")
str(rhodo)

sp <- rhodo
sp
head(sp)

vars = "Documents/rhodolith/Data/Selecao_AA/"


lst <- list.files(vars, pattern='.tif', full.names = TRUE)
lst
preds <- stack(lst)
preds
plot(preds[[9]])
points(sp)

#Creating pseudoabsences
pseudo = sampleRandom(preds[[9]], 6000, sp=T)
points(pseudo, col='blue')#ploting pseudoabsences

head(rhodo)
rhodo$species <- 1#considering all lines from "rhodo" = 1 (presence)

head(rhodo@data)
class(rhodo)
class(rhodo@data)

#------

pseudo@data$species <- 0#considering all lines from "pseudo" = 0 (absence)
pseudo@data <- pseudo@data[,'species',drop=F]

head(pseudo@data)
head(rhodo@data)
proj4string(rhodo) <- proj4string(pseudo)

rhodoPA <- rbind(rhodo,pseudo)#creating a matrix considering presence and pseudoabsence data
plot(rhodoPA)
summary(rhodoPA)

#Extracting raster values using rhodo pres/abs
ex <- extract(preds,rhodoPA)
head(ex)
class(ex)
ex <- data.frame(ex)

#Analyzing Variables Correlation

library(usdm)
v1 <- vifstep(ex)#calculates variance inflation factor (VIF) for a set of variables and excludes the highly correlated variables from the set.
v1

v2 = vifcor(ex,th=0.8)#another way to calculate indicating a threshold value 'th = threshold'
v2

preds <- exclude(preds, v2)#not applyed because v2 excluded temperature and this variable is important to run future scenarios

#Selected v2 result but including temperature. All variables excluded were saved in Documents/rhodolith/Data/Selecao_AA/ExcludedVars to reload only selected variables
vars = "Documents/rhodolith/Data/Selecao_AA/"
lst <- list.files(vars, pattern='.tif', full.names = TRUE)
lst
preds <- stack(lst)
preds

#esqueci de transformar em ex de novo...problema do sdm2...

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
write.sdm(d,'Documents/rhodolith/modelos/sdm2b/dataObject', overwrite = T)#write an sdm object to a file.
d <- read.sdm('Documents/rhodolith/modelos/sdm2b/dataObject.sdd')#Read an sdm object from a file.
d

#-------

m <- sdm(species~.,data=d,methods=c('glm','brt','rf', 'maxent', 'svm', 'gam'),#fit using 3 models
         replication=c('sub','boot','cv'),n=1,test.p=30,cv.folds=5,#evaluates using 1 run 'n=1' of subsampling and bootsrapping methods plus 5-folds of cross-validation replication methods, taking 30 percent as test
         modelSettings=list(brt=list(n.trees=2000,shrinkage=0.01)))#override the default settings for the method brt
m #the models explained less than 40% of deviance
# parallel::detectCores() to check the number of cores
write.sdm(m,'Documents/rhodolith/modelos/sdm2b/modelObject.sdm', overwrite = TRUE) # save the sdm object
m <- read.sdm('Documents/rhodolith/modelos/sdm2b/modelObject.sdm') # read the saved sdm object
roc(m)#Plot the Receiver Operating Characteristics (ROC) curve with AUC statistic in the legend.
dev.off()#provide control over multiple graphics devices
getVarImp(m,10)#calculates relative importance of different variables in the models using several approaches
plot(getVarImp(m,10))# if be put in plot function, a barplot is generated

getModelInfo(m)#returns a data.frame summarising some information relevant to the fitted models including modelID, method name, whether the model is fitted successfully, whether and what replication procedure is used for data partitioning, etc. getModelInfo helps to get the unique model IDs for all or certain models given the parameters that users specify.

rcurve(m,id=25)#Calculate the response of species to the range of values in each predictor variable based on the fitted models in a sdmModels object, in this case 'id=24' is 'modelID=24'
#------------
p <- predict(m, preds, filename='Documents/rhodolith/modelos/sdm2b/predict_sdm.img')#'predict' make a Raster or matrix object (depending on input dataset) with predictions from one or several fitted models in sdmModels object
p <- read.sdm('Documents/rhodolith/modelos/sdm2b/predict_sdm.img') # read the saved sdm object
p
getZ(p)#Initial functions for a somewhat more formal approach to get or set z values (e.g. time) associated with layers of Raster* objects.
plot(p[[1:4]])#ploting the first 4 models
plot(p[[10:13]])#ploting 4 models cv for brt
plot(p[[17:20]])#ploting 4 models cv for rf
plot(p[[24:27]])#ploting 4 models cv for maxent
plot(p[[31:34]])#ploting 4 models cv for svm


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
