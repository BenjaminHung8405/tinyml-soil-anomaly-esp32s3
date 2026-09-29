libs <- c("RSAGA")
have <- libs %in% rownames(installed.packages())
if(any(!have)) install.packages(libs[!have])
sapply(libs, function(i) require(i, character.only=TRUE))

library("RSAGA")
env<-rsaga.env();
#first set the working directory
setwd('~')

############ Resample original 1 m grid to 2, 3, 4, 5, 7, and 10 m using the SAGA-GIS GUI
############ 


################_Gaussian filter ####################################
################ the sigma is expressed as a percentage of the search window. Hence, to obtain a 0.5 sigma we ################ must input 1.66667 with the 30 m search window because
################# 1.6667/100 * 30 = 0.5. Sigma is the standard deviation of the normal curve. 95% of the search ################# window is within 2 sigma of the gaussian curve. 
############## if sigma is set to 0.5 pixel, then our 95% gaussian search window curve is 1 pixel.

rsaga.geoprocessor(lib = "grid_filter", module = 1, 
param = list(INPUT= paste(getwd(),"/DEM1.sgrd", sep = ""), 
RESULT = "DEM_gauss_0.5sigma.sgrd",
SIGMA = 1.666667,
KERNEL_RADIUS = 30)) 

rsaga.geoprocessor(lib = "grid_filter", module = 1, 
param = list(INPUT= paste(getwd(),"/DEM1.sgrd", sep = ""), 
RESULT ="DEM_gauss_1.0sigma.sgrd",
SIGMA = 3.333333,
KERNEL_RADIUS = 30)) 

rsaga.geoprocessor(lib = "grid_filter", module = 1, 
param = list(INPUT= paste(getwd(),"/DEM1.sgrd", sep = ""), 
RESULT = "DEM_gauss_1.5sigma.sgrd",
SIGMA = 5,
KERNEL_RADIUS = 30)) 

rsaga.geoprocessor(lib = "grid_filter", module = 1, 
param = list(INPUT= paste(getwd(),"/DEM1.sgrd", sep = ""), 
RESULT = "DEM_gauss_2.0sigma.sgrd",
SIGMA = 6.666667,
KERNEL_RADIUS = 30)) 

rsaga.geoprocessor(lib = "grid_filter", module = 1, 
param = list(INPUT= paste(getwd(),"/DEM1.sgrd", sep = ""), 
RESULT = "DEM_gauss_2.5sigma.sgrd",
SIGMA = 8.333333,
KERNEL_RADIUS = 30)) 

rsaga.geoprocessor(lib = "grid_filter", module = 1, 
param = list(INPUT= paste(getwd(),"/DEM1.sgrd", sep = ""), 
RESULT = "DEM_gauss_3.5sigma.sgrd",
SIGMA = 11.6666667,
KERNEL_RADIUS = 30)) 

rsaga.geoprocessor(lib = "grid_filter", module = 1, 
param = list(INPUT= paste(getwd(),"/DEM1.sgrd", sep = ""), 
RESULT = "DEM_gauss_5.0sigma.sgrd",
SIGMA = 16.66666667,
KERNEL_RADIUS = 30)) 

########### SSC filter
########### simple smoothing circular filter
###########

rsaga.geoprocessor(lib = "grid_filter", module = 0, 
param = list(INPUT= paste(getwd(),"/DEM1.sgrd", sep = ""), 
RESULT = "DEM_SSC1.sgrd",
KERNEL_RADIUS = 1)) 

rsaga.geoprocessor(lib = "grid_filter", module = 0, 
param = list(INPUT= paste(getwd(),"/DEM1.sgrd", sep = ""), 
RESULT = "DEM_SSC2.sgrd",
KERNEL_RADIUS = 2))

rsaga.geoprocessor(lib = "grid_filter", module = 0, 
param = list(INPUT= paste(getwd(),"DEM1", sep = ""), 
RESULT = "DEM_SSC3.sgrd",
KERNEL_RADIUS = 3))

rsaga.geoprocessor(lib = "grid_filter", module = 0, 
param = list(INPUT= paste(getwd(),"/DEM1.sgrd", sep = ""), 
RESULT = "DEM_SSC4.sgrd",
KERNEL_RADIUS = 4))

rsaga.geoprocessor(lib = "grid_filter", module = 0, 
param = list(INPUT= paste(getwd(),"DEM1.sgrd", sep = ""), 
RESULT = "DEM_SSC5.sgrd",
KERNEL_RADIUS = 5))

rsaga.geoprocessor(lib = "grid_filter", module = 0, 
param = list(INPUT= paste(getwd(),"/DEM1.sgrd", sep = ""), 
RESULT = "DEM_SSC7.sgrd",
KERNEL_RADIUS = 7))

rsaga.geoprocessor(lib = "grid_filter", module = 0, 
param = list(INPUT= paste(getwd(),"/DEM1.sgrd", sep = ""), 
RESULT = "DEM_SSC10.sgrd",
KERNEL_RADIUS = 10))

###################### Breach depressions (Lindsay WhiteBox GAT algorithm) gauss

rsaga.geoprocessor(lib = "ta_preprocessor", module = 7, 
param = list(DEM= paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
NOSINKS = "DEM_gauss_0.5sigma.sgrd"))

rsaga.geoprocessor(lib = "ta_preprocessor", module = 7, 
param = list(DEM= paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
NOSINKS = "DEM_gauss_1.0sigma.sgrd"))

rsaga.geoprocessor(lib = "ta_preprocessor", module = 7, 
param = list(DEM= paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
NOSINKS = "DEM_gauss_1.5sigma.sgrd"))

rsaga.geoprocessor(lib = "ta_preprocessor", module = 7, 
param = list(DEM= paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
NOSINKS = "DEM_gauss_2.0sigma.sgrd"))

rsaga.geoprocessor(lib = "ta_preprocessor", module = 7, 
param = list(DEM= paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
NOSINKS = "DEM_gauss_2.5sigma.sgrd"))

rsaga.geoprocessor(lib = "ta_preprocessor", module = 7, 
param = list(DEM= paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
NOSINKS = "DEM_gauss_3.5sigma.sgrd"))

rsaga.geoprocessor(lib = "ta_preprocessor", module = 7, 
param = list(DEM= paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
NOSINKS = "DEM_gauss_5.0sigma.sgrd"))

rsaga.geoprocessor(lib = "ta_preprocessor", module = 7, 
param = list(DEM= paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
NOSINKS = "DEM_gauss_0.5sigma.sgrd"))

###################### Breach depressions (Lindsay WhiteBox GAT algorithm) SSC

rsaga.geoprocessor(lib = "ta_preprocessor", module = 7, 
param = list(DEM= paste(getwd(),"/DEM_SSC1.sgrd", sep = ""), 
NOSINKS = "DEM_nosinks_SSC1.sgrd"))

rsaga.geoprocessor(lib = "ta_preprocessor", module = 7, 
param = list(DEM= paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
NOSINKS = "DEM_nosinks_SSC2_nosinks.sgrd"))

rsaga.geoprocessor(lib = "ta_preprocessor", module = 7, 
param = list(DEM= paste(getwd(),"/DEM_SSC3.sgrd", sep = ""), 
NOSINKS = "DEM_nosinks_SSC3.sgrd"))

rsaga.geoprocessor(lib = "ta_preprocessor", module = 7, 
param = list(DEM= paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
NOSINKS = "DEM_nosinks_SSC4_nosinks.sgrd"))

rsaga.geoprocessor(lib = "ta_preprocessor", module = 7, 
param = list(DEM= paste(getwd(),"/DEM_SSC5.sgrd", sep = ""), 
NOSINKS = "DEM_nosinks_SSC5.sgrd"))

rsaga.geoprocessor(lib = "ta_preprocessor", module = 7, 
param = list(DEM= paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
NOSINKS = "DEM_nosinks_SSC7_nosinks.sgrd"))

rsaga.geoprocessor(lib = "ta_preprocessor", module = 7, 
param = list(DEM= paste(getwd(),"/DEM_SSC10.sgrd", sep = ""), 
NOSINKS = "DEM_nosinks_SSC10.sgrd"))





## Do the Slope

rsaga.slope.asp.curv(in.dem="DEM_res1_nosinks.sgrd", out.slope="slope_DEM1.sgrd",out.aspect="aspect_DEM1.sgrd", out.cgene="curv_DEM1.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_nosinks_SSC1.sgrd", out.slope="slope_SSC1.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_nosinks_SSC2.sgrd", out.slope="slope_SSC2.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_nosinks_SSC3.sgrd", out.slope="slope_SSC3.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_nosinks_SSC4.sgrd", out.slope="slope_SSC4.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_nosinks_SSC5.sgrd", out.slope="slope_SSC5.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_nosinks_SSC7.sgrd", out.slope="slope_SSC7.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_nosinks_SSC10.sgrd", out.slope="slope_SSC10.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())

rsaga.slope.asp.curv(in.dem="DEM_res2_nosinks.sgrd", out.slope="slope_res2.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_res3_nosinks.sgrd", out.slope="slope_res3.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_res4_nosinks.sgrd", out.slope="slope_res4.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_res5_nosinks.sgrd", out.slope="slope_res5.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_res7_nosinks.sgrd", out.slope="slope_res7.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_res10_nosinks.sgrd", out.slope="slope_res10.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())

rsaga.slope.asp.curv(in.dem="DEM_gauss_0.5sigma.sgrd", out.slope="slope_gauss_0.5sigma.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_gauss_1.0sigma.sgrd", out.slope="slope_gauss_1.0sigma.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_gauss_1.5sigma.sgrd", out.slope="slope_gauss_1.5sigma.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_gauss_2.0sigma.sgrd", out.slope="slope_gauss_2.0sigma.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_gauss_2.5sigma.sgrd", out.slope="slope_gauss_2.5sigma.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_gauss_3.5sigma.sgrd", out.slope="slope_gauss_3.5sigma.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_gauss_5.0sigma.sgrd", out.slope="slope_gauss_5.0sigma.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())




##############BRAUNSCHWEIGER FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccBraun_DEM1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 2))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccBraun_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 2))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccBraun_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 2))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccBraun_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 2))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccBraun_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 2))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccBraun_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 2))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccBraun_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 2))#4 is multiple-flow direction



rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccBraun_SSC1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 2))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccBraun_SSC2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 2))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccBraun_SSC3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 2))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccBraun_SSC4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 2))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccBraun_SSC5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 2))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccBraun_SSC7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 2))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccBraun_SSC10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 2))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccBraun_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 2))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccBraun_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 2))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccBraun_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 2))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccBraun_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 2))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccBraun_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 2))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccBraun_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 2))#4 is multiple-flow direction





## Do the SCA

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccBraun_DEM1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Braun_DEM1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC1.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccBraun_SSC1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Braun_SSC1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccBraun_SSC2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Braun_SSC2.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccBraun_SSC3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Braun_SSC3.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccBraun_SSC4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Braun_SSC4.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccBraun_SSC5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Braun_SSC5.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccBraun_SSC7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Braun_SSC7.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccBraun_SSC10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Braun_SSC10.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccBraun_res2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Braun_res2.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccBraun_res3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Braun_res3.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccBraun_res4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Braun_res4.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccBraun_res5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Braun_res5.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccBraun_res7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Braun_res7.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccBraun_res10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Braun_res10.sgrd",sep=""),
METHOD = 1))




## Run the TWI

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_DEM1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Braun_DEM1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Braun.res1.NFNW.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Braun_SSC1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Braun.res1.SSC1.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Braun_SSC2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Braun.res1.SSC2.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Braun_SSC3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Braun.res1.SSC3.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Braun_SSC4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Braun.res1.SSC4.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Braun_SSC5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Braun.res1.SSC5.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Braun_SSC7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Braun.res1.SSC7.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Braun_SSC10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Braun.res1.SSC10.sgrd", sep = ""),
METHOD = 0))




rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Braun_res2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Braun.res2.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Braun_res3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Braun.res3.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Braun_res4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Braun.res4.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Braun_res5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Braun.res5.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Braun_res7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Braun.res7.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Braun_res10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Braun.res10.NFNW.sgrd", sep = ""),
METHOD = 0))



##############       D inf = method 3, FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDinf_DEM1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 3))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDinf_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 3))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDinf_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 3))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDinf_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 3))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDinf_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 3))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDinf_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 3))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDinf_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 3))#4 is multiple-flow direction



rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDinf_SSC1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 3))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDinf_SSC2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 3))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDinf_SSC3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 3))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDinf_SSC4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 3))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDinf_SSC5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 3))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDinf_SSC7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 3))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDinf_SSC10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 3))#4 is multiple-flow direction


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDinf_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 3))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDinf_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 3))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDinf_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 3))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDinf_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 3))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDinf_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 3))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDinf_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 3))#4 is multiple-flow direction





## Do the SCA

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDinf_DEM1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Dinf_DEM1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC1.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDinf_SSC1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Dinf_SSC1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDinf_SSC2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Dinf_SSC2.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDinf_SSC3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Dinf_SSC3.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDinf_SSC4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Dinf_SSC4.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDinf_SSC5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Dinf_SSC5.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDinf_SSC7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Dinf_SSC7.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDinf_SSC10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Dinf_SSC10.sgrd",sep=""),
METHOD = 1))


rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDinf_res2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Dinf_res2.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDinf_res3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Dinf_res3.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDinf_res4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Dinf_res4.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDinf_res5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Dinf_res5.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDinf_res7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Dinf_res7.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDinf_res10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Dinf_res10.sgrd",sep=""),
METHOD = 1))



## Run the TWI

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_DEM1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Dinf_DEM1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Dinf.res1.NFNW.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Dinf_SSC1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Dinf.res1.SSC1.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Dinf_SSC2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Dinf.res1.SSC2.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Dinf_SSC3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Dinf.res1.SSC3.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Dinf_SSC4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Dinf.res1.SSC4.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Dinf_SSC5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Dinf.res1.SSC5.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Dinf_SSC7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Dinf.res1.SSC7.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Dinf_SSC10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Dinf.res1.SSC10.sgrd", sep = ""),
METHOD = 0))




rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Dinf_res2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Dinf.res2.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Dinf_res3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Dinf.res3.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Dinf_res4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Dinf.res4.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Dinf_res5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Dinf.res5.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Dinf_res7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Dinf.res7.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Dinf_res10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Dinf.res10.NFNW.sgrd", sep = ""),
METHOD = 0))


##############       FD8 = method 0, FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccFD8_DEM1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 0))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccFD8_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 0))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccFD8_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 0))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccFD8_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 0))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccFD8_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 0))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccFD8_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 0))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccFD8_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 0))#4 is multiple-flow direction



rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccFD8_SSC1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 0))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccFD8_SSC2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 0))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccFD8_SSC3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 0))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccFD8_SSC4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 0))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccFD8_SSC5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 0))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccFD8_SSC7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 0))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccFD8_SSC10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 0))#4 is multiple-flow direction


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccFD8_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 0))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccFD8_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 0))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccFD8_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 0))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccFD8_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 0))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccFD8_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 0))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccFD8_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 0))#4 is multiple-flow direction





## Do the SCA

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccFD8_DEM1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_FD8_DEM1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC1.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccFD8_SSC1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_FD8_SSC1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccFD8_SSC2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_FD8_SSC2.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccFD8_SSC3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_FD8_SSC3.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccFD8_SSC4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_FD8_SSC4.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccFD8_SSC5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_FD8_SSC5.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccFD8_SSC7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_FD8_SSC7.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccFD8_SSC10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_FD8_SSC10.sgrd",sep=""),
METHOD = 1))


rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccFD8_res2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_FD8_res2.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccFD8_res3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_FD8_res3.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccFD8_res4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_FD8_res4.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccFD8_res5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_FD8_res5.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccFD8_res7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_FD8_res7.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccFD8_res10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_FD8_res10.sgrd",sep=""),
METHOD = 1))




## Run the TWI

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_DEM1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_FD8_DEM1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.FD8.res1.NFNW.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_FD8_SSC1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.FD8.res1.SSC1.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_FD8_SSC2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.FD8.res1.SSC2.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_FD8_SSC3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.FD8.res1.SSC3.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_FD8_SSC4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.FD8.res1.SSC4.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_FD8_SSC5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.FD8.res1.SSC5.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_FD8_SSC7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.FD8.res1.SSC7.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_FD8_SSC10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.FD8.res1.SSC10.sgrd", sep = ""),
METHOD = 0))


rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_FD8_res2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.FD8.res2.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_FD8_res3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.FD8.res3.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_FD8_res4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.FD8.res4.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_FD8_res5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.FD8.res5.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_FD8_res7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.FD8.res7.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_FD8_res10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.FD8.res10.NFNW.sgrd", sep = ""),
METHOD = 0))



##############       Rho8 = method 1, FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccRho8_DEM1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 1))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccRho8_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 1))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccRho8_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 1))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccRho8_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 1))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccRho8_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 1))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccRho8_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 1))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccRho8_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 1))#4 is multiple-flow direction



rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccRho8_SSC1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 1))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccRho8_SSC2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 1))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccRho8_SSC3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 1))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccRho8_SSC4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 1))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccRho8_SSC5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 1))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccRho8_SSC7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 1))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccRho8_SSC10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 1))#4 is multiple-flow direction


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccRho8_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 1))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccRho8_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 1))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccRho8_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 1))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccRho8_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 1))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccRho8_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 1))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccRho8_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 1))#4 is multiple-flow direction





## Do the SCA

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccRho8_DEM1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Rho8_DEM1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC1.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccRho8_SSC1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Rho8_SSC1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccRho8_SSC2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Rho8_SSC2.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccRho8_SSC3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Rho8_SSC3.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccRho8_SSC4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Rho8_SSC4.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccRho8_SSC5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Rho8_SSC5.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccRho8_SSC7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Rho8_SSC7.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccRho8_SSC10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Rho8_SSC10.sgrd",sep=""),
METHOD = 1))


rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccRho8_res2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Rho8_res2.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccRho8_res3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Rho8_res3.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccRho8_res4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Rho8_res4.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccRho8_res5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Rho8_res5.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccRho8_res7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Rho8_res7.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccRho8_res10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Rho8_res10.sgrd",sep=""),
METHOD = 1))


## Run the TWI

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_DEM1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Rho8_DEM1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Rho8.res1.NFNW.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Rho8_SSC1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Rho8.res1.SSC1.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Rho8_SSC2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Rho8.res1.SSC2.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Rho8_SSC3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Rho8.res1.SSC3.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Rho8_SSC4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Rho8.res1.SSC4.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Rho8_SSC5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Rho8.res1.SSC5.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Rho8_SSC7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Rho8.res1.SSC7.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Rho8_SSC10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Rho8.res1.SSC10.sgrd", sep = ""),
METHOD = 0))




rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Rho8_res2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Rho8.res2.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Rho8_res3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Rho8.res3.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Rho8_res4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Rho8.res4.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Rho8_res5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Rho8.res5.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Rho8_res7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Rho8.res7.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Rho8_res10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Rho8.res10.NFNW.sgrd", sep = ""),
METHOD = 0))



##############       MMDGBFD = method 6, FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMMDGBFD_DEM1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 6))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMMDGBFD_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 6))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMMDGBFD_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 6))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMMDGBFD_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 6))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMMDGBFD_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 6))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMMDGBFD_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 6))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMMDGBFD_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 6))#4 is multiple-flow direction



rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMMDGBFD_SSC1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 6))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMMDGBFD_SSC2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 6))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMMDGBFD_SSC3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 6))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMMDGBFD_SSC4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 6))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMMDGBFD_SSC5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 6))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMMDGBFD_SSC7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 6))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMMDGBFD_SSC10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 6))#4 is multiple-flow direction


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMMDGBFD_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 6))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMMDGBFD_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 6))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMMDGBFD_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 6))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMMDGBFD_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 6))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMMDGBFD_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 6))#4 is multiple-flow direction
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMMDGBFD_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 6))#4 is multiple-flow direction





## Do the SCA

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMMDGBFD_DEM1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MMDGBFD_DEM1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC1.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMMDGBFD_SSC1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MMDGBFD_SSC1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMMDGBFD_SSC2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MMDGBFD_SSC2.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMMDGBFD_SSC3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MMDGBFD_SSC3.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMMDGBFD_SSC4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MMDGBFD_SSC4.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMMDGBFD_SSC5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MMDGBFD_SSC5.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMMDGBFD_SSC7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MMDGBFD_SSC7.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMMDGBFD_SSC10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MMDGBFD_SSC10.sgrd",sep=""),
METHOD = 1))


rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMMDGBFD_res2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MMDGBFD_res2.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMMDGBFD_res3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MMDGBFD_res3.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMMDGBFD_res4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MMDGBFD_res4.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMMDGBFD_res5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MMDGBFD_res5.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMMDGBFD_res7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MMDGBFD_res7.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMMDGBFD_res10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MMDGBFD_res10.sgrd",sep=""),
METHOD = 1))






## Run the TWI

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_DEM1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MMDGBFD_DEM1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MMDGBFD.res1.NFNW.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MMDGBFD_SSC1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MMDGBFD.res1.SSC1.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MMDGBFD_SSC2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MMDGBFD.res1.SSC2.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MMDGBFD_SSC3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MMDGBFD.res1.SSC3.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MMDGBFD_SSC4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MMDGBFD.res1.SSC4.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MMDGBFD_SSC5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MMDGBFD.res1.SSC5.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MMDGBFD_SSC7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MMDGBFD.res1.SSC7.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MMDGBFD_SSC10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MMDGBFD.res1.SSC10.sgrd", sep = ""),
METHOD = 0))




rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MMDGBFD_res2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MMDGBFD.res2.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MMDGBFD_res3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MMDGBFD.res3.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MMDGBFD_res4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MMDGBFD.res4.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MMDGBFD_res5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MMDGBFD.res5.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MMDGBFD_res7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MMDGBFD.res7.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MMDGBFD_res10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MMDGBFD.res10.NFNW.sgrd", sep = ""),
METHOD = 0))


##############      MFD0.5 = method 4, FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD0.5_DEM1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 0.5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD0.5_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 0.5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD0.5_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 0.5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD0.5_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 0.5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD0.5_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 0.5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD0.5_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 0.5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD0.5_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 0.5))



rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD0.5_SSC1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 0.5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD0.5_SSC2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 0.5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD0.5_SSC3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 0.5))


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD0.5_SSC4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 0.5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD0.5_SSC5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 0.5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD0.5_SSC7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 0.5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD0.5_SSC10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 0.5))


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD0.5_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 0.5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD0.5_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 0.5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD0.5_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 0.5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD0.5_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 0.5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD0.5_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 0.5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD0.5_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 0.5))

## Do the SCA

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD0.5_DEM1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD0.5_DEM1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC1.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD0.5_SSC1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD0.5_SSC1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD0.5_SSC2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD0.5_SSC2.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD0.5_SSC3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD0.5_SSC3.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD0.5_SSC4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD0.5_SSC4.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD0.5_SSC5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD0.5_SSC5.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD0.5_SSC7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD0.5_SSC7.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD0.5_SSC10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD0.5_SSC10.sgrd",sep=""),
METHOD = 1))


rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD0.5_res2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD0.5_res2.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD0.5_res3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD0.5_res3.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD0.5_res4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD0.5_res4.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD0.5_res5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD0.5_res5.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD0.5_res7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD0.5_res7.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD0.5_res10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD0.5_res10.sgrd",sep=""),
METHOD = 1))





## Run the TWI

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_DEM1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD0.5_DEM1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD0.5.res1.NFNW.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD0.5_SSC1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD0.5.res1.SSC1.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD0.5_SSC2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD0.5.res1.SSC2.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD0.5_SSC3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD0.5.res1.SSC3.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD0.5_SSC4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD0.5.res1.SSC4.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD0.5_SSC5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD0.5.res1.SSC5.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD0.5_SSC7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD0.5.res1.SSC7.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD0.5_SSC10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD0.5.res1.SSC10.sgrd", sep = ""),
METHOD = 0))



rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD0.5_res2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD0.5.res2.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD0.5_res3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD0.5.res3.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD0.5_res4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD0.5.res4.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD0.5_res5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD0.5.res5.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD0.5_res7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD0.5.res7.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD0.5_res10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD0.5.res10.NFNW.sgrd", sep = ""),
METHOD = 0))

##############      MFD1.1 = method 4, FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.1_DEM1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.1_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.1_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.1_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.1_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.1_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.1_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.1))



rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.1_SSC1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.1_SSC2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.1_SSC3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.1))


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.1_SSC4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.1_SSC5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.1_SSC7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.1_SSC10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.1_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.1_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.1_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.1_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.1_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.1_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.1))

## Do the SCA

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.1_DEM1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.1_DEM1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC1.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.1_SSC1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.1_SSC1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.1_SSC2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.1_SSC2.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.1_SSC3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.1_SSC3.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.1_SSC4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.1_SSC4.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.1_SSC5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.1_SSC5.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.1_SSC7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.1_SSC7.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.1_SSC10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.1_SSC10.sgrd",sep=""),
METHOD = 1))


rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.1_res2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.1_res2.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.1_res3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.1_res3.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.1_res4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.1_res4.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.1_res5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.1_res5.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.1_res7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.1_res7.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.1_res10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.1_res10.sgrd",sep=""),
METHOD = 1))



## Run the TWI

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_DEM1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.1_DEM1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.1.res1.NFNW.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.1_SSC1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.1.res1.SSC1.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.1_SSC2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.1.res1.SSC2.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.1_SSC3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.1.res1.SSC3.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.1_SSC4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.1.res1.SSC4.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.1_SSC5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.1.res1.SSC5.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.1_SSC7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.1.res1.SSC7.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.1_SSC10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.1.res1.SSC10.sgrd", sep = ""),
METHOD = 0))



rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.1_res2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.1.res2.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.1_res3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.1.res3.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.1_res4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.1.res4.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.1_res5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.1.res5.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.1_res7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.1.res7.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.1_res10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.1.res10.NFNW.sgrd", sep = ""),
METHOD = 0))

##############      MFD2 = method 4, FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD2_DEM1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD2_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 2))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD2_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 2))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD2_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 2))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD2_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 2))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD2_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 2))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD2_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 2))



rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD2_SSC1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD2_SSC2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD2_SSC3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 2))


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD2_SSC4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD2_SSC5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD2_SSC7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD2_SSC10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 2))


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD2_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 2))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD2_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 2))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD2_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 2))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD2_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 2))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD2_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 2))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD2_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 2))

## Do the SCA

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD2_DEM1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD2_DEM1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC1.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD2_SSC1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD2_SSC1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD2_SSC2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD2_SSC2.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD2_SSC3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD2_SSC3.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD2_SSC4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD2_SSC4.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD2_SSC5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD2_SSC5.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD2_SSC7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD2_SSC7.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD2_SSC10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD2_SSC10.sgrd",sep=""),
METHOD = 1))


rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD2_res2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD2_res2.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD2_res3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD2_res3.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD2_res4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD2_res4.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD2_res5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD2_res5.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD2_res7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD2_res7.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD2_res10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD2_res10.sgrd",sep=""),
METHOD = 1))





## Run the TWI

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_DEM1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD2_DEM1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD2.res1.NFNW.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD2_SSC1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD2.res1.SSC1.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD2_SSC2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD2.res1.SSC2.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD2_SSC3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD2.res1.SSC3.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD2_SSC4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD2.res1.SSC4.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD2_SSC5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD2.res1.SSC5.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD2_SSC7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD2.res1.SSC7.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD2_SSC10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD2.res1.SSC10.sgrd", sep = ""),
METHOD = 0))




rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD2_res2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD2.res2.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD2_res3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD2.res3.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD2_res4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD2.res4.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD2_res5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD2.res5.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD2_res7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD2.res7.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD2_res10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD2.res10.NFNW.sgrd", sep = ""),
METHOD = 0))

##############      MFD5 = method 4, FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD5_DEM1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD5_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD5_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD5_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD5_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD5_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD5_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 5))



rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD5_SSC1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD5_SSC2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD5_SSC3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 5))


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD5_SSC4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD5_SSC5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD5_SSC7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD5_SSC10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 5))


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD5_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD5_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD5_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD5_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD5_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD5_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 5))

## Do the SCA

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD5_DEM1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD5_DEM1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC1.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD5_SSC1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD5_SSC1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD5_SSC2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD5_SSC2.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD5_SSC3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD5_SSC3.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD5_SSC4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD5_SSC4.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD5_SSC5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD5_SSC5.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD5_SSC7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD5_SSC7.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD5_SSC10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD5_SSC10.sgrd",sep=""),
METHOD = 1))


rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD5_res2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD5_res2.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD5_res3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD5_res3.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD5_res4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD5_res4.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD5_res5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD5_res5.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD5_res7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD5_res7.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD5_res10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD5_res10.sgrd",sep=""),
METHOD = 1))





## Run the TWI

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_DEM1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD5_DEM1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD5.res1.NFNW.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD5_SSC1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD5.res1.SSC1.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD5_SSC2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD5.res1.SSC2.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD5_SSC3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD5.res1.SSC3.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD5_SSC4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD5.res1.SSC4.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD5_SSC5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD5.res1.SSC5.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD5_SSC7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD5.res1.SSC7.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD5_SSC10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD5.res1.SSC10.sgrd", sep = ""),
METHOD = 0))



rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD5_res2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD5.res2.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD5_res3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD5.res3.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD5_res4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD5.res4.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD5_res5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD5.res5.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD5_res7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD5.res7.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD5_res10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD5.res10.NFNW.sgrd", sep = ""),
METHOD = 0))

##############      MFD10 = method 4, FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD10_DEM1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 10))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD10_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 10))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD10_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 10))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD10_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 10))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD10_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 10))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD10_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 10))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD10_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 10))



rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD10_SSC1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 10))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD10_SSC2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 10))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD10_SSC3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 10))


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD10_SSC4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 10))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD10_SSC5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 10))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD10_SSC7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 10))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD10_SSC10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 10))


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD10_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 10))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD10_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 10))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD10_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 10))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD10_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 10))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD10_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 10))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD10_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 10))

## Do the SCA

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD10_DEM1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD10_DEM1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC1.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD10_SSC1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD10_SSC1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD10_SSC2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD10_SSC2.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD10_SSC3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD10_SSC3.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD10_SSC4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD10_SSC4.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD10_SSC5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD10_SSC5.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD10_SSC7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD10_SSC7.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD10_SSC10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD10_SSC10.sgrd",sep=""),
METHOD = 1))


rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD10_res2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD10_res2.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD10_res3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD10_res3.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD10_res4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD10_res4.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD10_res5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD10_res5.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD10_res7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD10_res7.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD10_res10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD10_res10.sgrd",sep=""),
METHOD = 1))




## Run the TWI

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_DEM1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD10_DEM1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD10.res1.NFNW.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD10_SSC1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD10.res1.SSC1.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD10_SSC2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD10.res1.SSC2.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD10_SSC3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD10.res1.SSC3.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD10_SSC4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD10.res1.SSC4.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD10_SSC5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD10.res1.SSC5.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD10_SSC7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD10.res1.SSC7.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD10_SSC10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD10.res1.SSC10.sgrd", sep = ""),
METHOD = 0))



rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD10_res2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD10.res2.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD10_res3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD10.res3.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD10_res4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD10.res4.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD10_res5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD10.res5.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD10_res7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD10.res7.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD10_res10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD10.res10.NFNW.sgrd", sep = ""),
METHOD = 0))



##############      MTFD0.5 = method 5, FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD0.5_DEM1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 0.5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD0.5_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 0.5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD0.5_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 0.5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD0.5_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 0.5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD0.5_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 0.5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD0.5_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 0.5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD0.5_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 0.5))



rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD0.5_SSC1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 0.5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD0.5_SSC2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 0.5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD0.5_SSC3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 0.5))


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD0.5_SSC4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 0.5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD0.5_SSC5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 0.5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD0.5_SSC7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 0.5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD0.5_SSC10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 0.5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD0.5_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 0.5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD0.5_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 0.5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD0.5_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 0.5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD0.5_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 0.5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD0.5_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 0.5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD0.5_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 0.5))

## Do the SCA

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD0.5_DEM1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD0.5_DEM1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC1.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD0.5_SSC1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD0.5_SSC1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD0.5_SSC2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD0.5_SSC2.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD0.5_SSC3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD0.5_SSC3.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD0.5_SSC4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD0.5_SSC4.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD0.5_SSC5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD0.5_SSC5.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD0.5_SSC7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD0.5_SSC7.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD0.5_SSC10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD0.5_SSC10.sgrd",sep=""),
METHOD = 1))


rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD0.5_res2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD0.5_res2.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD0.5_res3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD0.5_res3.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD0.5_res4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD0.5_res4.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD0.5_res5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD0.5_res5.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD0.5_res7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD0.5_res7.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD0.5_res10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD0.5_res10.sgrd",sep=""),
METHOD = 1))



## Run the TWI

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_DEM1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD0.5_DEM1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD0.5.res1.NFNW.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD0.5_SSC1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD0.5.res1.SSC1.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD0.5_SSC2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD0.5.res1.SSC2.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD0.5_SSC3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD0.5.res1.SSC3.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD0.5_SSC4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD0.5.res1.SSC4.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD0.5_SSC5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD0.5.res1.SSC5.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD0.5_SSC7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD0.5.res1.SSC7.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD0.5_SSC10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD0.5.res1.SSC10.sgrd", sep = ""),
METHOD = 0))




rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD0.5_res2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD0.5.res2.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD0.5_res3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD0.5.res3.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD0.5_res4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD0.5.res4.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD0.5_res5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD0.5.res5.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD0.5_res7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD0.5.res7.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD0.5_res10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD0.5.res10.NFNW.sgrd", sep = ""),
METHOD = 0))

##############      MTFD1.1 = method 5, FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.1_DEM1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.1_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.1_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.1_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.1_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.1_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.1_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.1))



rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.1_SSC1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.1_SSC2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.1_SSC3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.1))


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.1_SSC4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.1_SSC5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.1_SSC7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.1_SSC10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.1))


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.1_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.1_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.1_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.1_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.1_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.1_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.1))

## Do the SCA

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.1_DEM1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.1_DEM1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC1.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.1_SSC1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.1_SSC1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.1_SSC2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.1_SSC2.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.1_SSC3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.1_SSC3.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.1_SSC4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.1_SSC4.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.1_SSC5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.1_SSC5.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.1_SSC7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.1_SSC7.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.1_SSC10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.1_SSC10.sgrd",sep=""),
METHOD = 1))


rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.1_res2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.1_res2.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.1_res3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.1_res3.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.1_res4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.1_res4.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.1_res5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.1_res5.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.1_res7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.1_res7.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.1_res10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.1_res10.sgrd",sep=""),
METHOD = 1))





## Run the TWI

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_DEM1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.1_DEM1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.1.res1.NFNW.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.1_SSC1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.1.res1.SSC1.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.1_SSC2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.1.res1.SSC2.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.1_SSC3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.1.res1.SSC3.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.1_SSC4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.1.res1.SSC4.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.1_SSC5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.1.res1.SSC5.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.1_SSC7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.1.res1.SSC7.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.1_SSC10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.1.res1.SSC10.sgrd", sep = ""),
METHOD = 0))




rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.1_res2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.1.res2.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.1_res3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.1.res3.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.1_res4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.1.res4.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.1_res5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.1.res5.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.1_res7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.1.res7.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.1_res10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.1.res10.NFNW.sgrd", sep = ""),
METHOD = 0))

##############      MTFD2 = method 5, FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD2_DEM1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD2_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 2))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD2_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 2))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD2_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 2))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD2_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 2))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD2_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 2))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD2_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 2))



rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD2_SSC1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD2_SSC2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD2_SSC3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 2))


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD2_SSC4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD2_SSC5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD2_SSC7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD2_SSC10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 2))


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD2_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 2))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD2_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 2))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD2_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 2))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD2_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 2))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD2_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 2))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD2_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 2))

## Do the SCA

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD2_DEM1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD2_DEM1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC1.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD2_SSC1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD2_SSC1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD2_SSC2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD2_SSC2.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD2_SSC3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD2_SSC3.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD2_SSC4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD2_SSC4.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD2_SSC5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD2_SSC5.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD2_SSC7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD2_SSC7.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD2_SSC10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD2_SSC10.sgrd",sep=""),
METHOD = 1))


rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD2_res2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD2_res2.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD2_res3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD2_res3.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD2_res4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD2_res4.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD2_res5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD2_res5.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD2_res7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD2_res7.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD2_res10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD2_res10.sgrd",sep=""),
METHOD = 1))



## Run the TWI

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_DEM1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD2_DEM1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD2.res1.NFNW.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD2_SSC1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD2.res1.SSC1.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD2_SSC2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD2.res1.SSC2.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD2_SSC3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD2.res1.SSC3.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD2_SSC4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD2.res1.SSC4.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD2_SSC5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD2.res1.SSC5.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD2_SSC7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD2.res1.SSC7.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD2_SSC10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD2.res1.SSC10.sgrd", sep = ""),
METHOD = 0))


rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD2_res2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD2.res2.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD2_res3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD2.res3.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD2_res4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD2.res4.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD2_res5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD2.res5.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD2_res7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD2.res7.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD2_res10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD2.res10.NFNW.sgrd", sep = ""),
METHOD = 0))

##############      MTFD5 = method 5, FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD5_DEM1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD5_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD5_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD5_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD5_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD5_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD5_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 5))



rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD5_SSC1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD5_SSC2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD5_SSC3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 5))


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD5_SSC4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD5_SSC5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD5_SSC7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD5_SSC10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 5))


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD5_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD5_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD5_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD5_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD5_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 5))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD5_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 5))

## Do the SCA

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD5_DEM1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD5_DEM1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC1.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD5_SSC1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD5_SSC1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD5_SSC2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD5_SSC2.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD5_SSC3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD5_SSC3.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD5_SSC4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD5_SSC4.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD5_SSC5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD5_SSC5.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD5_SSC7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD5_SSC7.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD5_SSC10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD5_SSC10.sgrd",sep=""),
METHOD = 1))


rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD5_res2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD5_res2.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD5_res3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD5_res3.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD5_res4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD5_res4.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD5_res5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD5_res5.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD5_res7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD5_res7.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD5_res10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD5_res10.sgrd",sep=""),
METHOD = 1))



## Run the TWI

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_DEM1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD5_DEM1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD5.res1.NFNW.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD5_SSC1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD5.res1.SSC1.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD5_SSC2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD5.res1.SSC2.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD5_SSC3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD5.res1.SSC3.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD5_SSC4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD5.res1.SSC4.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD5_SSC5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD5.res1.SSC5.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD5_SSC7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD5.res1.SSC7.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD5_SSC10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD5.res1.SSC10.sgrd", sep = ""),
METHOD = 0))



rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD5_res2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD5.res2.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD5_res3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD5.res3.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD5_res4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD5.res4.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD5_res5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD5.res5.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD5_res7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD5.res7.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD5_res10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD5.res10.NFNW.sgrd", sep = ""),
METHOD = 0))

##############      MTFD10 = method 5, FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD10_DEM1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 10))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD10_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 10))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD10_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 10))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD10_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 10))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD10_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 10))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD10_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 10))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD10_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 10))



rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD10_SSC1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 10))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD10_SSC2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 10))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD10_SSC3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 10))


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD10_SSC4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 10))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD10_SSC5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 10))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD10_SSC7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 10))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD10_SSC10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 10))


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD10_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 10))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD10_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 10))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD10_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 10))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD10_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 10))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD10_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 10))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD10_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 10))

## Do the SCA

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD10_DEM1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD10_DEM1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC1.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD10_SSC1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD10_SSC1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD10_SSC2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD10_SSC2.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD10_SSC3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD10_SSC3.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD10_SSC4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD10_SSC4.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD10_SSC5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD10_SSC5.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD10_SSC7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD10_SSC7.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD10_SSC10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD10_SSC10.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD10_res2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD10_res2.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD10_res3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD10_res3.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD10_res4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD10_res4.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD10_res5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD10_res5.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD10_res7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD10_res7.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD10_res10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD10_res10.sgrd",sep=""),
METHOD = 1))





## Run the TWI

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_DEM1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD10_DEM1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD10.res1.NFNW.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD10_SSC1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD10.res1.SSC1.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD10_SSC2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD10.res1.SSC2.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD10_SSC3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD10.res1.SSC3.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD10_SSC4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD10.res1.SSC4.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD10_SSC5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD10.res1.SSC5.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD10_SSC7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD10.res1.SSC7.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD10_SSC10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD10.res1.SSC10.sgrd", sep = ""),
METHOD = 0))



rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD10_res2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD10.res2.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD10_res3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD10.res3.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD10_res4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD10.res4.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD10_res5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD10.res5.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD10_res7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD10.res7.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD10_res10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD10.res10.NFNW.sgrd", sep = ""),
METHOD = 0))

###############################  THE SAGA WETNESS INDEX #############################
#########################  ###############################  ########################

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+1.res1.NFNW.sgrd", sep = ""),
SUCTION = 1E+1,
AREA_TYPE=2,
SLOPE_OFF=0.01))

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+2.res1.NFNW.sgrd", sep = ""),
SUCTION = 1E+2,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+4.res1.NFNW.sgrd", sep = ""),
SUCTION = 1E+4,
AREA_TYPE=2,
SLOPE_OFF=0.01))

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+8.res1.NFNW.sgrd", sep = ""),
SUCTION = 1E+8,
AREA_TYPE=2,
SLOPE_OFF=0.01))

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+16.res1.NFNW.sgrd", sep = ""),
SUCTION = 1E+16,
AREA_TYPE=2,
SLOPE_OFF=0.01))

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+32.res1.NFNW.sgrd", sep = ""),
SUCTION = 1E+32,
AREA_TYPE=2,
SLOPE_OFF=0.01))

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+64.res1.NFNW.sgrd", sep = ""),
SUCTION = 1E+64,
AREA_TYPE=2,
SLOPE_OFF=0.01))

##
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+1.res2.NFNW.sgrd", sep = ""),
SUCTION = 1E+1,
AREA_TYPE=2,
SLOPE_OFF=0.01))

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+2.res2.NFNW.sgrd", sep = ""),
SUCTION = 1E+2,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+4.res2.NFNW.sgrd", sep = ""),
SUCTION = 1E+4,
AREA_TYPE=2,
SLOPE_OFF=0.01))

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+8.res2.NFNW.sgrd", sep = ""),
SUCTION = 1E+8,
AREA_TYPE=2,
SLOPE_OFF=0.01))

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+16.res2.NFNW.sgrd", sep = ""),
SUCTION = 1E+16,
AREA_TYPE=2,
SLOPE_OFF=0.01))

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+32.res2.NFNW.sgrd", sep = ""),
SUCTION = 1E+32,
AREA_TYPE=2,
SLOPE_OFF=0.01))

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+64.res2.NFNW.sgrd", sep = ""),
SUCTION = 1E+64,
AREA_TYPE=2,
SLOPE_OFF=0.01))
##

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+1.res3.NFNW.sgrd", sep = ""),
SUCTION = 1E+1,
AREA_TYPE=2,
SLOPE_OFF=0.01))

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+2.res3.NFNW.sgrd", sep = ""),
SUCTION = 1E+2,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+4.res3.NFNW.sgrd", sep = ""),
SUCTION = 1E+4,
AREA_TYPE=2,
SLOPE_OFF=0.01))

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+8.res3.NFNW.sgrd", sep = ""),
SUCTION = 1E+8,
AREA_TYPE=2,
SLOPE_OFF=0.01))

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+16.res3.NFNW.sgrd", sep = ""),
SUCTION = 1E+16,
AREA_TYPE=2,
SLOPE_OFF=0.01))

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+32.res3.NFNW.sgrd", sep = ""),
SUCTION = 1E+32,
AREA_TYPE=2,
SLOPE_OFF=0.01))

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+64.res3.NFNW.sgrd", sep = ""),
SUCTION = 1E+64,
AREA_TYPE=2,
SLOPE_OFF=0.01))


##

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+1.res4.NFNW.sgrd", sep = ""),
SUCTION = 1E+1,
AREA_TYPE=2,
SLOPE_OFF=0.01))

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+2.res4.NFNW.sgrd", sep = ""),
SUCTION = 1E+2,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+4.res4.NFNW.sgrd", sep = ""),
SUCTION = 1E+4,
AREA_TYPE=2,
SLOPE_OFF=0.01))

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+8.res4.NFNW.sgrd", sep = ""),
SUCTION = 1E+8,
AREA_TYPE=2,
SLOPE_OFF=0.01))

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+16.res4.NFNW.sgrd", sep = ""),
SUCTION = 1E+16,
AREA_TYPE=2,
SLOPE_OFF=0.01))

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+32.res4.NFNW.sgrd", sep = ""),
SUCTION = 1E+32,
AREA_TYPE=2,
SLOPE_OFF=0.01))

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+64.res4.NFNW.sgrd", sep = ""),
SUCTION = 1E+64,
AREA_TYPE=2,
SLOPE_OFF=0.01))

##

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+1.res5.NFNW.sgrd", sep = ""),
SUCTION = 1E+1,
AREA_TYPE=2,
SLOPE_OFF=0.01))

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+2.res5.NFNW.sgrd", sep = ""),
SUCTION = 1E+2,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+4.res5.NFNW.sgrd", sep = ""),
SUCTION = 1E+4,
AREA_TYPE=2,
SLOPE_OFF=0.01))

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+8.res5.NFNW.sgrd", sep = ""),
SUCTION = 1E+8,
AREA_TYPE=2,
SLOPE_OFF=0.01))

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+16.res5.NFNW.sgrd", sep = ""),
SUCTION = 1E+16,
AREA_TYPE=2,
SLOPE_OFF=0.01))

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+32.res5.NFNW.sgrd", sep = ""),
SUCTION = 1E+32,
AREA_TYPE=2,
SLOPE_OFF=0.01))

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+64.res5.NFNW.sgrd", sep = ""),
SUCTION = 1E+64,
AREA_TYPE=2,
SLOPE_OFF=0.01))

##

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+1.res7.NFNW.sgrd", sep = ""),
SUCTION = 1E+1,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+2.res7.NFNW.sgrd", sep = ""),
SUCTION = 1E+2,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+4.res7.NFNW.sgrd", sep = ""),
SUCTION = 1E+4,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+8.res7.NFNW.sgrd", sep = ""),
SUCTION = 1E+8,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+16.res7.NFNW.sgrd", sep = ""),
SUCTION = 1E+16,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+32.res7.NFNW.sgrd", sep = ""),
SUCTION = 1E+32,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+64.res7.NFNW.sgrd", sep = ""),
SUCTION = 1E+64,
AREA_TYPE=2,
SLOPE_OFF=0.01))

##

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+1.res10.NFNW.sgrd", sep = ""),
SUCTION = 1E+1,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+2.res10.NFNW.sgrd", sep = ""),
SUCTION = 1E+2,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+4.res10.NFNW.sgrd", sep = ""),
SUCTION = 1E+4,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+8.res10.NFNW.sgrd", sep = ""),
SUCTION = 1E+8,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+16.res10.NFNW.sgrd", sep = ""),
SUCTION = 1E+16,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+32.res10.NFNW.sgrd", sep = ""),
SUCTION = 1E+32,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+64.res10.NFNW.sgrd", sep = ""),
SUCTION = 1E+64,
AREA_TYPE=2,
SLOPE_OFF=0.01))

##

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+1.res1.SSC1.sgrd", sep = ""),
SUCTION = 1E+1,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+2.res1.SSC1.sgrd", sep = ""),
SUCTION = 1E+2,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+4.res1.SSC1.sgrd", sep = ""),
SUCTION = 1E+4,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+8.res1.SSC1.sgrd", sep = ""),
SUCTION = 1E+8,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+16.res1.SSC1.sgrd", sep = ""),
SUCTION = 1E+16,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+32.res1.SSC1.sgrd", sep = ""),
SUCTION = 1E+32,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+64.res1.SSC1.sgrd", sep = ""),
SUCTION = 1E+64,
AREA_TYPE=2,
SLOPE_OFF=0.01))


##

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+1.res1.SSC2.sgrd", sep = ""),
SUCTION = 1E+1,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+2.res1.SSC2.sgrd", sep = ""),
SUCTION = 1E+2,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+4.res1.SSC2.sgrd", sep = ""),
SUCTION = 1E+4,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+8.res1.SSC2.sgrd", sep = ""),
SUCTION = 1E+8,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+16.res1.SSC2.sgrd", sep = ""),
SUCTION = 1E+16,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+32.res1.SSC2.sgrd", sep = ""),
SUCTION = 1E+32,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+64.res1.SSC2.sgrd", sep = ""),
SUCTION = 1E+64,
AREA_TYPE=2,
SLOPE_OFF=0.01))

##

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+1.res1.SSC3.sgrd", sep = ""),
SUCTION = 1E+1,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+2.res1.SSC3.sgrd", sep = ""),
SUCTION = 1E+2,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+4.res1.SSC3.sgrd", sep = ""),
SUCTION = 1E+4,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+8.res1.SSC3.sgrd", sep = ""),
SUCTION = 1E+8,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+16.res1.SSC3.sgrd", sep = ""),
SUCTION = 1E+16,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+32.res1.SSC3.sgrd", sep = ""),
SUCTION = 1E+32,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+64.res1.SSC3.sgrd", sep = ""),
SUCTION = 1E+64,
AREA_TYPE=2,
SLOPE_OFF=0.01))

##

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+1.res1.SSC4.sgrd", sep = ""),
SUCTION = 1E+1,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+2.res1.SSC4.sgrd", sep = ""),
SUCTION = 1E+2,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+4.res1.SSC4.sgrd", sep = ""),
SUCTION = 1E+4,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+8.res1.SSC4.sgrd", sep = ""),
SUCTION = 1E+8,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+16.res1.SSC4.sgrd", sep = ""),
SUCTION = 1E+16,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+32.res1.SSC4.sgrd", sep = ""),
SUCTION = 1E+32,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+64.res1.SSC4.sgrd", sep = ""),
SUCTION = 1E+64,
AREA_TYPE=2,
SLOPE_OFF=0.01))

##

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+1.res1.SSC5.sgrd", sep = ""),
SUCTION = 1E+1,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+2.res1.SSC5.sgrd", sep = ""),
SUCTION = 1E+2,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+4.res1.SSC5.sgrd", sep = ""),
SUCTION = 1E+4,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+8.res1.SSC5.sgrd", sep = ""),
SUCTION = 1E+8,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+16.res1.SSC5.sgrd", sep = ""),
SUCTION = 1E+16,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+32.res1.SSC5.sgrd", sep = ""),
SUCTION = 1E+32,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+64.res1.SSC5.sgrd", sep = ""),
SUCTION = 1E+64,
AREA_TYPE=2,
SLOPE_OFF=0.01))


##

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+1.res1.SSC7.sgrd", sep = ""),
SUCTION = 1E+1,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+2.res1.SSC7.sgrd", sep = ""),
SUCTION = 1E+2,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+4.res1.SSC7.sgrd", sep = ""),
SUCTION = 1E+4,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+8.res1.SSC7.sgrd", sep = ""),
SUCTION = 1E+8,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+16.res1.SSC7.sgrd", sep = ""),
SUCTION = 1E+16,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+32.res1.SSC7.sgrd", sep = ""),
SUCTION = 1E+32,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+64.res1.SSC7.sgrd", sep = ""),
SUCTION = 1E+64,
AREA_TYPE=2,
SLOPE_OFF=0.01))

##

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+1.res1.SSC10.sgrd", sep = ""),
SUCTION = 1E+1,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+2.res1.SSC10.sgrd", sep = ""),
SUCTION = 1E+2,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+4.res1.SSC10.sgrd", sep = ""),
SUCTION = 1E+4,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+8.res1.SSC10.sgrd", sep = ""),
SUCTION = 1E+8,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+16.res1.SSC10.sgrd", sep = ""),
SUCTION = 1E+16,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+32.res1.SSC10.sgrd", sep = ""),
SUCTION = 1E+32,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+64.res1.SSC10.sgrd", sep = ""),
SUCTION = 1E+64,
AREA_TYPE=2,
SLOPE_OFF=0.01))

##


library("RSAGA")
env<-rsaga.env();
#first set the working directory
setwd("~")


################_Gaussian filter ####################################
################ the sigma is expressed as a percentage of the search window. Hence, to obtain a 0.5 sigma we must input 1.66667 because
################# 1.6667/100 * 30 = 0.5
############ the choice of 0.5 – 5 sigma (meters) corresponds to a 95% Gaussian curve encompassing 2*sigma(in meters) for a search window 95% of ##########            1 – 10 m.

rsaga.geoprocessor(lib = "grid_filter", module = 1, 
param = list(INPUT= paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
RESULT = "DEM_gauss_0.5sigma.sgrd",
SIGMA = 1.666667,
KERNEL_RADIUS = 30)) 

rsaga.geoprocessor(lib = "grid_filter", module = 1, 
param = list(INPUT= paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
RESULT ="DEM_gauss_1.0sigma.sgrd",
SIGMA = 3.333333,
KERNEL_RADIUS = 30)) 

rsaga.geoprocessor(lib = "grid_filter", module = 1, 
param = list(INPUT= paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
RESULT = "DEM_gauss_1.5sigma.sgrd",
SIGMA = 5,
KERNEL_RADIUS = 30)) 

rsaga.geoprocessor(lib = "grid_filter", module = 1, 
param = list(INPUT= paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
RESULT = "DEM_gauss_2.0sigma.sgrd",
SIGMA = 6.666667,
KERNEL_RADIUS = 30)) 

rsaga.geoprocessor(lib = "grid_filter", module = 1, 
param = list(INPUT= paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
RESULT = "DEM_gauss_2.5sigma.sgrd",
SIGMA = 8.333333,
KERNEL_RADIUS = 30)) 

rsaga.geoprocessor(lib = "grid_filter", module = 1, 
param = list(INPUT= paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
RESULT = "DEM_gauss_3.5sigma.sgrd",
SIGMA = 11.6666667,
KERNEL_RADIUS = 30)) 

rsaga.geoprocessor(lib = "grid_filter", module = 1, 
param = list(INPUT= paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
RESULT = "DEM_gauss_5.0sigma.sgrd",
SIGMA = 16.66666667,
KERNEL_RADIUS = 30)) 


##############BRAUNSCHWEIGER FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccBraun_gauss_0.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 2))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccBraun_gauss_1.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 2))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccBraun_gauss_1.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 2))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccBraun_gauss_2.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 2))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccBraun_gauss_2.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 2))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccBraun_gauss_3.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 2))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccBraun_gauss_5.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 2))#4 is multiple-flow direction

## Do the SCA

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_0.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccBraun_gauss_0.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Braun_gauss_0.5sigma.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccBraun_gauss_1.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Braun_gauss_1.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccBraun_gauss_1.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Braun_gauss_1.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccBraun_gauss_2.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Braun_gauss_2.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccBraun_gauss_2.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Braun_gauss_2.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_3.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccBraun_gauss_3.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Braun_gauss_3.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_5.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccBraun_gauss_5.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Braun_gauss_5.0sigma.sgrd",sep=""),
METHOD = 1))

## Do the Slope

## Do the Slope for Gaussian


rsaga.slope.asp.curv(in.dem="DEM_gauss_0.5sigma.sgrd", out.slope="slope_gauss_0.5sigma.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_gauss_1.0sigma.sgrd", out.slope="slope_gauss_1.0sigma.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_gauss_1.5sigma.sgrd", out.slope="slope_gauss_1.5sigma.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_gauss_2.0sigma.sgrd", out.slope="slope_gauss_2.0sigma.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_gauss_2.5sigma.sgrd", out.slope="slope_gauss_2.5sigma.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_gauss_3.5sigma.sgrd", out.slope="slope_gauss_3.5sigma.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_gauss_5.0sigma.sgrd", out.slope="slope_gauss_5.0sigma.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())

## Run the TWI
## run it for gaussian

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_0.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Braun_gauss_0.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Braun.res1.gauss_0.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Braun_gauss_1.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Braun.res1.gauss_1.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Braun_gauss_1.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Braun.res1.gauss_1.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Braun_gauss_2.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Braun.res1.gauss_2.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Braun_gauss_2.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Braun.res1.gauss_2.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_3.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Braun_gauss_3.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Braun.res1.gauss_3.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_5.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Braun_gauss_5.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Braun.res1.gauss_5.0sigma.sgrd", sep = ""),
METHOD = 0))


##############       D inf = method 3, FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDinf_gauss_0.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 3))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDinf_gauss_1.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 3))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDinf_gauss_1.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 3))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDinf_gauss_2.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 3))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDinf_gauss_2.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 3))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDinf_gauss_3.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 3))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDinf_gauss_5.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 3))#4 is multiple-flow direction

## Do the SCA

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_0.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDinf_gauss_0.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Dinf_gauss_0.5sigma.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDinf_gauss_1.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Dinf_gauss_1.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDinf_gauss_1.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Dinf_gauss_1.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDinf_gauss_2.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Dinf_gauss_2.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDinf_gauss_2.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Dinf_gauss_2.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_3.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDinf_gauss_3.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Dinf_gauss_3.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_5.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDinf_gauss_5.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Dinf_gauss_5.0sigma.sgrd",sep=""),
METHOD = 1))

## Do the Slope for Gaussian
## Run the TWI
## run it for gaussian

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_0.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Dinf_gauss_0.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Dinf.res1.gauss_0.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Dinf_gauss_1.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Dinf.res1.gauss_1.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Dinf_gauss_1.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Dinf.res1.gauss_1.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Dinf_gauss_2.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Dinf.res1.gauss_2.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Dinf_gauss_2.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Dinf.res1.gauss_2.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_3.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Dinf_gauss_3.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Dinf.res1.gauss_3.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_5.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Dinf_gauss_5.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Dinf.res1.gauss_5.0sigma.sgrd", sep = ""),
METHOD = 0))

##############       FD8 = method 0, FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccFD8_gauss_0.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 0))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccFD8_gauss_1.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 0))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccFD8_gauss_1.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 0))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccFD8_gauss_2.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 0))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccFD8_gauss_2.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 0))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccFD8_gauss_3.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 0))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccFD8_gauss_5.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 0))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_0.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccFD8_gauss_0.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_FD8_gauss_0.5sigma.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccFD8_gauss_1.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_FD8_gauss_1.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccFD8_gauss_1.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_FD8_gauss_1.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccFD8_gauss_2.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_FD8_gauss_2.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccFD8_gauss_2.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_FD8_gauss_2.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_3.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccFD8_gauss_3.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_FD8_gauss_3.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_5.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccFD8_gauss_5.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_FD8_gauss_5.0sigma.sgrd",sep=""),
METHOD = 1))


## Run the TWI

## run it for gaussian

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_0.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_FD8_gauss_0.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.FD8.res1.gauss_0.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_FD8_gauss_1.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.FD8.res1.gauss_1.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_FD8_gauss_1.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.FD8.res1.gauss_1.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_FD8_gauss_2.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.FD8.res1.gauss_2.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_FD8_gauss_2.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.FD8.res1.gauss_2.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_3.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_FD8_gauss_3.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.FD8.res1.gauss_3.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_5.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_FD8_gauss_5.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.FD8.res1.gauss_5.0sigma.sgrd", sep = ""),
METHOD = 0))


##############       Rho8 = method 1, FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccRho8_gauss_0.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 1))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccRho8_gauss_1.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 1))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccRho8_gauss_1.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 1))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccRho8_gauss_2.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 1))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccRho8_gauss_2.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 1))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccRho8_gauss_3.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 1))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccRho8_gauss_5.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 1))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_0.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccRho8_gauss_0.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Rho8_gauss_0.5sigma.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccRho8_gauss_1.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Rho8_gauss_1.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccRho8_gauss_1.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Rho8_gauss_1.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccRho8_gauss_2.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Rho8_gauss_2.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccRho8_gauss_2.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Rho8_gauss_2.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_3.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccRho8_gauss_3.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Rho8_gauss_3.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_5.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccRho8_gauss_5.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_Rho8_gauss_5.0sigma.sgrd",sep=""),
METHOD = 1))

## Run the TWI

## run it for gaussian

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_0.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Rho8_gauss_0.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Rho8.res1.gauss_0.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Rho8_gauss_1.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Rho8.res1.gauss_1.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Rho8_gauss_1.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Rho8.res1.gauss_1.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Rho8_gauss_2.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Rho8.res1.gauss_2.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Rho8_gauss_2.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Rho8.res1.gauss_2.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_3.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Rho8_gauss_3.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Rho8.res1.gauss_3.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_5.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_Rho8_gauss_5.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.Rho8.res1.gauss_5.0sigma.sgrd", sep = ""),
METHOD = 0))

##############       MMDGBFD = method 6, FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMMDGBFD_gauss_0.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 6))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMMDGBFD_gauss_1.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 6))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMMDGBFD_gauss_1.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 6))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMMDGBFD_gauss_2.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 6))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMMDGBFD_gauss_2.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 6))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMMDGBFD_gauss_3.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 6))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMMDGBFD_gauss_5.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 6))#4 is multiple-flow direction

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_0.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMMDGBFD_gauss_0.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MMDGBFD_gauss_0.5sigma.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMMDGBFD_gauss_1.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MMDGBFD_gauss_1.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMMDGBFD_gauss_1.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MMDGBFD_gauss_1.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMMDGBFD_gauss_2.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MMDGBFD_gauss_2.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMMDGBFD_gauss_2.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MMDGBFD_gauss_2.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_3.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMMDGBFD_gauss_3.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MMDGBFD_gauss_3.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_5.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMMDGBFD_gauss_5.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MMDGBFD_gauss_5.0sigma.sgrd",sep=""),
METHOD = 1))

## Run the TWI
## run it for gaussian

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_0.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MMDGBFD_gauss_0.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MMDGBFD.res1.gauss_0.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MMDGBFD_gauss_1.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MMDGBFD.res1.gauss_1.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MMDGBFD_gauss_1.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MMDGBFD.res1.gauss_1.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MMDGBFD_gauss_2.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MMDGBFD.res1.gauss_2.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MMDGBFD_gauss_2.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MMDGBFD.res1.gauss_2.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_3.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MMDGBFD_gauss_3.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MMDGBFD.res1.gauss_3.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_5.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MMDGBFD_gauss_5.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MMDGBFD.res1.gauss_5.0sigma.sgrd", sep = ""),
METHOD = 0))



##############      MFD0.5 = method 4, FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD0.5_gauss_0.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 0.5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD0.5_gauss_1.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 0.5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD0.5_gauss_1.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 0.5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD0.5_gauss_2.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 0.5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD0.5_gauss_2.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 0.5))


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD0.5_gauss_3.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 0.5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD0.5_gauss_5.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 0.5))

## Do the SCA

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_0.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD0.5_gauss_0.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD0.5_gauss_0.5sigma.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD0.5_gauss_1.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD0.5_gauss_1.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD0.5_gauss_1.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD0.5_gauss_1.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD0.5_gauss_2.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD0.5_gauss_2.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD0.5_gauss_2.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD0.5_gauss_2.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_3.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD0.5_gauss_3.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD0.5_gauss_3.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_5.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD0.5_gauss_5.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD0.5_gauss_5.0sigma.sgrd",sep=""),
METHOD = 1))

## Do the Slope

## Do the Slope for Gaussian


## Run the TWI

## run it for gaussian

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_0.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD0.5_gauss_0.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD0.5.res1.gauss_0.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD0.5_gauss_1.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD0.5.res1.gauss_1.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD0.5_gauss_1.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD0.5.res1.gauss_1.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD0.5_gauss_2.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD0.5.res1.gauss_2.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD0.5_gauss_2.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD0.5.res1.gauss_2.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_3.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD0.5_gauss_3.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD0.5.res1.gauss_3.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_5.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD0.5_gauss_5.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD0.5.res1.gauss_5.0sigma.sgrd", sep = ""),
METHOD = 0))

##############      MFD1.1 = method 4, FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.1_gauss_0.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.1_gauss_1.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.1_gauss_1.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.1_gauss_2.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.1_gauss_2.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.1))


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.1_gauss_3.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.1_gauss_5.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_0.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.1_gauss_0.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.1_gauss_0.5sigma.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.1_gauss_1.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.1_gauss_1.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.1_gauss_1.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.1_gauss_1.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.1_gauss_2.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.1_gauss_2.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.1_gauss_2.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.1_gauss_2.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_3.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.1_gauss_3.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.1_gauss_3.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_5.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.1_gauss_5.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.1_gauss_5.0sigma.sgrd",sep=""),
METHOD = 1))

## Do the Slope for Gaussian

## Run the TWI
## run it for gaussian

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_0.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.1_gauss_0.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.1.res1.gauss_0.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.1_gauss_1.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.1.res1.gauss_1.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.1_gauss_1.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.1.res1.gauss_1.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.1_gauss_2.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.1.res1.gauss_2.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.1_gauss_2.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.1.res1.gauss_2.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_3.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.1_gauss_3.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.1.res1.gauss_3.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_5.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.1_gauss_5.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.1.res1.gauss_5.0sigma.sgrd", sep = ""),
METHOD = 0))



##############      MFD1.0 = method 4, FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.0_gauss_0.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.0_gauss_1.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.0_gauss_1.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.0_gauss_2.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.0_gauss_2.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.0))


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.0_gauss_3.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.0_gauss_5.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_0.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.0_gauss_0.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.0_gauss_0.5sigma.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.0_gauss_1.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.0_gauss_1.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.0_gauss_1.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.0_gauss_1.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.0_gauss_2.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.0_gauss_2.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.0_gauss_2.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.0_gauss_2.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_3.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.0_gauss_3.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.0_gauss_3.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_5.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.0_gauss_5.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.0_gauss_5.0sigma.sgrd",sep=""),
METHOD = 1))

## Do the Slope for Gaussian

## Run the TWI
## run it for gaussian

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_0.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.0_gauss_0.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.0.res1.gauss_0.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.0_gauss_1.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.0.res1.gauss_1.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.0_gauss_1.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.0.res1.gauss_1.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.0_gauss_2.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.0.res1.gauss_2.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.0_gauss_2.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.0.res1.gauss_2.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_3.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.0_gauss_3.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.0.res1.gauss_3.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_5.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.0_gauss_5.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.0.res1.gauss_5.0sigma.sgrd", sep = ""),
METHOD = 0))

##############      MFD2 = method 4, FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD2_gauss_0.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD2_gauss_1.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD2_gauss_1.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD2_gauss_2.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD2_gauss_2.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 2))


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD2_gauss_3.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD2_gauss_5.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_0.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD2_gauss_0.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD2_gauss_0.5sigma.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD2_gauss_1.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD2_gauss_1.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD2_gauss_1.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD2_gauss_1.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD2_gauss_2.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD2_gauss_2.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD2_gauss_2.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD2_gauss_2.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_3.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD2_gauss_3.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD2_gauss_3.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_5.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD2_gauss_5.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD2_gauss_5.0sigma.sgrd",sep=""),
METHOD = 1))

## Do the Slope for Gaussian


rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_0.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD2_gauss_0.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD2.res1.gauss_0.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD2_gauss_1.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD2.res1.gauss_1.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD2_gauss_1.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD2.res1.gauss_1.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD2_gauss_2.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD2.res1.gauss_2.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD2_gauss_2.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD2.res1.gauss_2.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_3.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD2_gauss_3.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD2.res1.gauss_3.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_5.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD2_gauss_5.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD2.res1.gauss_5.0sigma.sgrd", sep = ""),
METHOD = 0))

##############      MFD5 = method 4, FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD5_gauss_0.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD5_gauss_1.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD5_gauss_1.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD5_gauss_2.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD5_gauss_2.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 5))


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD5_gauss_3.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD5_gauss_5.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_0.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD5_gauss_0.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD5_gauss_0.5sigma.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD5_gauss_1.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD5_gauss_1.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD5_gauss_1.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD5_gauss_1.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD5_gauss_2.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD5_gauss_2.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD5_gauss_2.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD5_gauss_2.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_3.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD5_gauss_3.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD5_gauss_3.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_5.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD5_gauss_5.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD5_gauss_5.0sigma.sgrd",sep=""),
METHOD = 1))

## Do the Slope for Gaussian

## run it for gaussian
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_0.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD5_gauss_0.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD5.res1.gauss_0.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD5_gauss_1.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD5.res1.gauss_1.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD5_gauss_1.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD5.res1.gauss_1.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD5_gauss_2.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD5.res1.gauss_2.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD5_gauss_2.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD5.res1.gauss_2.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_3.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD5_gauss_3.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD5.res1.gauss_3.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_5.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD5_gauss_5.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD5.res1.gauss_5.0sigma.sgrd", sep = ""),
METHOD = 0))

##############      MFD10 = method 4, FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD10_gauss_0.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 10))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD10_gauss_1.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 10))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD10_gauss_1.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 10))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD10_gauss_2.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 10))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD10_gauss_2.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 10))


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD10_gauss_3.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 10))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD10_gauss_5.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 10))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_0.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD10_gauss_0.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD10_gauss_0.5sigma.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD10_gauss_1.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD10_gauss_1.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD10_gauss_1.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD10_gauss_1.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD10_gauss_2.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD10_gauss_2.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD10_gauss_2.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD10_gauss_2.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_3.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD10_gauss_3.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD10_gauss_3.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_5.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD10_gauss_5.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD10_gauss_5.0sigma.sgrd",sep=""),
METHOD = 1))

## Do the Slope for Gaussian

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_0.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD10_gauss_0.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD10.res1.gauss_0.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD10_gauss_1.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD10.res1.gauss_1.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD10_gauss_1.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD10.res1.gauss_1.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD10_gauss_2.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD10.res1.gauss_2.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD10_gauss_2.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD10.res1.gauss_2.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_3.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD10_gauss_3.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD10.res1.gauss_3.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_5.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD10_gauss_5.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD10.res1.gauss_5.0sigma.sgrd", sep = ""),
METHOD = 0))


##############      MTFD0.5 = method 5, FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD0.5_gauss_0.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 0.5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD0.5_gauss_1.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 0.5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD0.5_gauss_1.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 0.5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD0.5_gauss_2.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 0.5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD0.5_gauss_2.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 0.5))


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD0.5_gauss_3.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 0.5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD0.5_gauss_5.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 0.5))
## Do the SCA
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_0.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD0.5_gauss_0.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD0.5_gauss_0.5sigma.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD0.5_gauss_1.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD0.5_gauss_1.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD0.5_gauss_1.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD0.5_gauss_1.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD0.5_gauss_2.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD0.5_gauss_2.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD0.5_gauss_2.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD0.5_gauss_2.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_3.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD0.5_gauss_3.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD0.5_gauss_3.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_5.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD0.5_gauss_5.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD0.5_gauss_5.0sigma.sgrd",sep=""),
METHOD = 1))
## Do the Slope for Gaussian

## Run the TWI

## run it for gaussian

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_0.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD0.5_gauss_0.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD0.5.res1.gauss_0.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD0.5_gauss_1.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD0.5.res1.gauss_1.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD0.5_gauss_1.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD0.5.res1.gauss_1.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD0.5_gauss_2.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD0.5.res1.gauss_2.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD0.5_gauss_2.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD0.5.res1.gauss_2.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_3.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD0.5_gauss_3.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD0.5.res1.gauss_3.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_5.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD0.5_gauss_5.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD0.5.res1.gauss_5.0sigma.sgrd", sep = ""),
METHOD = 0))

##############      MTFD1.1 = method 5, FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.1_gauss_0.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.1_gauss_1.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.1_gauss_1.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.1_gauss_2.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.1_gauss_2.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.1))


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.1_gauss_3.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.1_gauss_5.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.1))
## Do the SCA
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_0.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.1_gauss_0.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.1_gauss_0.5sigma.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.1_gauss_1.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.1_gauss_1.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.1_gauss_1.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.1_gauss_1.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.1_gauss_2.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.1_gauss_2.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.1_gauss_2.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.1_gauss_2.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_3.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.1_gauss_3.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.1_gauss_3.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_5.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.1_gauss_5.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.1_gauss_5.0sigma.sgrd",sep=""),
METHOD = 1))
## Do the Slope for Gaussian

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_0.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.1_gauss_0.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.1.res1.gauss_0.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.1_gauss_1.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.1.res1.gauss_1.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.1_gauss_1.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.1.res1.gauss_1.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.1_gauss_2.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.1.res1.gauss_2.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.1_gauss_2.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.1.res1.gauss_2.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_3.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.1_gauss_3.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.1.res1.gauss_3.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_5.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.1_gauss_5.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.1.res1.gauss_5.0sigma.sgrd", sep = ""),
METHOD = 0))

##############      MTFD1.0 = method 5, FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.0_gauss_0.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.0_gauss_1.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.0_gauss_1.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.0_gauss_2.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.0_gauss_2.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.0))


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.0_gauss_3.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.0_gauss_5.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.0))
## Do the SCA
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_0.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.0_gauss_0.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.0_gauss_0.5sigma.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.0_gauss_1.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.0_gauss_1.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.0_gauss_1.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.0_gauss_1.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.0_gauss_2.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.0_gauss_2.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.0_gauss_2.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.0_gauss_2.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_3.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.0_gauss_3.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.0_gauss_3.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_5.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.0_gauss_5.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.0_gauss_5.0sigma.sgrd",sep=""),
METHOD = 1))
## Do the Slope for Gaussian

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_0.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.0_gauss_0.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.0.res1.gauss_0.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.0_gauss_1.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.0.res1.gauss_1.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.0_gauss_1.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.0.res1.gauss_1.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.0_gauss_2.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.0.res1.gauss_2.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.0_gauss_2.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.0.res1.gauss_2.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_3.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.0_gauss_3.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.0.res1.gauss_3.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_5.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.0_gauss_5.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.0.res1.gauss_5.0sigma.sgrd", sep = ""),
METHOD = 0))

##############      MTFD2 = method 5, FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD2_gauss_0.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD2_gauss_1.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD2_gauss_1.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD2_gauss_2.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD2_gauss_2.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 2))


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD2_gauss_3.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD2_gauss_5.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_0.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD2_gauss_0.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD2_gauss_0.5sigma.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD2_gauss_1.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD2_gauss_1.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD2_gauss_1.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD2_gauss_1.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD2_gauss_2.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD2_gauss_2.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD2_gauss_2.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD2_gauss_2.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_3.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD2_gauss_3.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD2_gauss_3.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_5.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD2_gauss_5.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD2_gauss_5.0sigma.sgrd",sep=""),
METHOD = 1))
## Do the Slope for Gaussian


rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_0.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD2_gauss_0.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD2.res1.gauss_0.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD2_gauss_1.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD2.res1.gauss_1.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD2_gauss_1.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD2.res1.gauss_1.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD2_gauss_2.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD2.res1.gauss_2.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD2_gauss_2.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD2.res1.gauss_2.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_3.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD2_gauss_3.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD2.res1.gauss_3.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_5.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD2_gauss_5.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD2.res1.gauss_5.0sigma.sgrd", sep = ""),
METHOD = 0))

QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQqqqqqqqqqqXXXXXXXXXXXXXXXXXXXXXXXXXXXXx


##############      MTFD5 = method 5, FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD5_gauss_0.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD5_gauss_1.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD5_gauss_1.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD5_gauss_2.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD5_gauss_2.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 5))


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD5_gauss_3.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD5_gauss_5.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 5))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_0.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD5_gauss_0.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD5_gauss_0.5sigma.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD5_gauss_1.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD5_gauss_1.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD5_gauss_1.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD5_gauss_1.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD5_gauss_2.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD5_gauss_2.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD5_gauss_2.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD5_gauss_2.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_3.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD5_gauss_3.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD5_gauss_3.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_5.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD5_gauss_5.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD5_gauss_5.0sigma.sgrd",sep=""),
METHOD = 1))


rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_0.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD5_gauss_0.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD5.res1.gauss_0.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD5_gauss_1.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD5.res1.gauss_1.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD5_gauss_1.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD5.res1.gauss_1.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD5_gauss_2.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD5.res1.gauss_2.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD5_gauss_2.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD5.res1.gauss_2.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_3.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD5_gauss_3.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD5.res1.gauss_3.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_5.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD5_gauss_5.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD5.res1.gauss_5.0sigma.sgrd", sep = ""),
METHOD = 0))

##############      MTFD10 = method 5, FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD10_gauss_0.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 10))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD10_gauss_1.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 10))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD10_gauss_1.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 10))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD10_gauss_2.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 10))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD10_gauss_2.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 10))


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD10_gauss_3.5sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 10))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD10_gauss_5.0sigma.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 10))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_0.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD10_gauss_0.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD10_gauss_0.5sigma.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD10_gauss_1.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD10_gauss_1.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD10_gauss_1.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD10_gauss_1.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD10_gauss_2.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD10_gauss_2.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD10_gauss_2.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD10_gauss_2.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_3.5sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD10_gauss_3.5sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD10_gauss_3.5sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_5.0sigma.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD10_gauss_5.0sigma.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD10_gauss_5.0sigma.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_0.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD10_gauss_0.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD10.res1.gauss_0.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD10_gauss_1.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD10.res1.gauss_1.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD10_gauss_1.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD10.res1.gauss_1.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD10_gauss_2.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD10.res1.gauss_2.0sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD10_gauss_2.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD10.res1.gauss_2.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_3.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD10_gauss_3.5sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD10.res1.gauss_3.5sigma.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_5.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD10_gauss_5.0sigma.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD10.res1.gauss_5.0sigma.sgrd", sep = ""),
METHOD = 0))


###############################  THE SAGA WETNESS INDEX #############################
#########################  ###############################  ########################
##

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+1.res1.gauss_0.5sigma.sgrd", sep = ""),
SUCTION = 1E+1,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+2.res1.gauss_0.5sigma.sgrd", sep = ""),
SUCTION = 1E+2,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+4.res1.gauss_0.5sigma.sgrd", sep = ""),
SUCTION = 1E+4,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+8.res1.gauss_0.5sigma.sgrd", sep = ""),
SUCTION = 1E+8,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+16.res1.gauss_0.5sigma.sgrd", sep = ""),
SUCTION = 1E+16,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+32.res1.gauss_0.5sigma.sgrd", sep = ""),
SUCTION = 1E+32,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_0.5sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+64.res1.gauss_0.5sigma.sgrd", sep = ""),
SUCTION = 1E+64,
AREA_TYPE=2,
SLOPE_OFF=0.01))


##

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+1.res1.gauss_1.0sigma.sgrd", sep = ""),
SUCTION = 1E+1,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+2.res1.gauss_1.0sigma.sgrd", sep = ""),
SUCTION = 1E+2,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+4.res1.gauss_1.0sigma.sgrd", sep = ""),
SUCTION = 1E+4,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+8.res1.gauss_1.0sigma.sgrd", sep = ""),
SUCTION = 1E+8,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+16.res1.gauss_1.0sigma.sgrd", sep = ""),
SUCTION = 1E+16,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+32.res1.gauss_1.0sigma.sgrd", sep = ""),
SUCTION = 1E+32,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.0sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+64.res1.gauss_1.0sigma.sgrd", sep = ""),
SUCTION = 1E+64,
AREA_TYPE=2,
SLOPE_OFF=0.01))

##

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+1.res1.gauss_1.5sigma.sgrd", sep = ""),
SUCTION = 1E+1,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+2.res1.gauss_1.5sigma.sgrd", sep = ""),
SUCTION = 1E+2,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+4.res1.gauss_1.5sigma.sgrd", sep = ""),
SUCTION = 1E+4,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+8.res1.gauss_1.5sigma.sgrd", sep = ""),
SUCTION = 1E+8,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+16.res1.gauss_1.5sigma.sgrd", sep = ""),
SUCTION = 1E+16,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+32.res1.gauss_1.5sigma.sgrd", sep = ""),
SUCTION = 1E+32,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1.5sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+64.res1.gauss_1.5sigma.sgrd", sep = ""),
SUCTION = 1E+64,
AREA_TYPE=2,
SLOPE_OFF=0.01))

##

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+1.res1.gauss_2.0sigma.sgrd", sep = ""),
SUCTION = 1E+1,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+2.res1.gauss_2.0sigma.sgrd", sep = ""),
SUCTION = 1E+2,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+4.res1.gauss_2.0sigma.sgrd", sep = ""),
SUCTION = 1E+4,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+8.res1.gauss_2.0sigma.sgrd", sep = ""),
SUCTION = 1E+8,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+16.res1.gauss_2.0sigma.sgrd", sep = ""),
SUCTION = 1E+16,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+32.res1.gauss_2.0sigma.sgrd", sep = ""),
SUCTION = 1E+32,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.0sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+64.res1.gauss_2.0sigma.sgrd", sep = ""),
SUCTION = 1E+64,
AREA_TYPE=2,
SLOPE_OFF=0.01))

##

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+1.res1.gauss_2.5sigma.sgrd", sep = ""),
SUCTION = 1E+1,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+2.res1.gauss_2.5sigma.sgrd", sep = ""),
SUCTION = 1E+2,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+4.res1.gauss_2.5sigma.sgrd", sep = ""),
SUCTION = 1E+4,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+8.res1.gauss_2.5sigma.sgrd", sep = ""),
SUCTION = 1E+8,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+16.res1.gauss_2.5sigma.sgrd", sep = ""),
SUCTION = 1E+16,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+32.res1.gauss_2.5sigma.sgrd", sep = ""),
SUCTION = 1E+32,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2.5sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+64.res1.gauss_2.5sigma.sgrd", sep = ""),
SUCTION = 1E+64,
AREA_TYPE=2,
SLOPE_OFF=0.01))


##

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+1.res1.gauss_3.5sigma.sgrd", sep = ""),
SUCTION = 1E+1,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+2.res1.gauss_3.5sigma.sgrd", sep = ""),
SUCTION = 1E+2,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+4.res1.gauss_3.5sigma.sgrd", sep = ""),
SUCTION = 1E+4,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+8.res1.gauss_3.5sigma.sgrd", sep = ""),
SUCTION = 1E+8,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+16.res1.gauss_3.5sigma.sgrd", sep = ""),
SUCTION = 1E+16,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+32.res1.gauss_3.5sigma.sgrd", sep = ""),
SUCTION = 1E+32,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_3.5sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+64.res1.gauss_3.5sigma.sgrd", sep = ""),
SUCTION = 1E+64,
AREA_TYPE=2,
SLOPE_OFF=0.01))

##

rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+1.res1.gauss_5.0sigma.sgrd", sep = ""),
SUCTION = 1E+1,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+2.res1.gauss_5.0sigma.sgrd", sep = ""),
SUCTION = 1E+2,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+4.res1.gauss_5.0sigma.sgrd", sep = ""),
SUCTION = 1E+4,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+8.res1.gauss_5.0sigma.sgrd", sep = ""),
SUCTION = 1E+8,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+16.res1.gauss_5.0sigma.sgrd", sep = ""),
SUCTION = 1E+16,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+32.res1.gauss_5.0sigma.sgrd", sep = ""),
SUCTION = 1E+32,
AREA_TYPE=2,
SLOPE_OFF=0.01))
rsaga.geoprocessor(lib = "ta_hydrology", module = 15, 
param = list(DEM = paste(getwd(),"/DEM_gauss_5.0sigma.sgrd", sep = ""), 
TWI = paste(getwd(),"/SWI1E+64.res1.gauss_5.0sigma.sgrd", sep = ""),
SUCTION = 1E+64,
AREA_TYPE=2,
SLOPE_OFF=0.01))


#####################  #########################



## ALSO, DO THE CONVERGENCE = 1.0 for everything (AKA Quinn)

library("RSAGA")
env<-rsaga.env();
#first set the working directory
setwd("~")


##############      MFD1.0 = method 4, FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.0_DEM1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.0_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.0_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.0_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.0_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.0_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.0_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.0))



rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.0_SSC1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.0_SSC2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.0_SSC3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.0))


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.0_SSC4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.0_SSC5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.0_SSC7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.0_SSC10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.0_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.0_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.0_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.0_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.0_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMFD1.0_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 4,
CONVERGENCE = 1.0))

## Do the SCA

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.0_DEM1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.0_DEM1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC1.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.0_SSC1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.0_SSC1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.0_SSC2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.0_SSC2.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.0_SSC3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.0_SSC3.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.0_SSC4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.0_SSC4.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.0_SSC5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.0_SSC5.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.0_SSC7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.0_SSC7.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.0_SSC10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.0_SSC10.sgrd",sep=""),
METHOD = 1))


rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.0_res2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.0_res2.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.0_res3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.0_res3.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.0_res4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.0_res4.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.0_res5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.0_res5.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.0_res7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.0_res7.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMFD1.0_res10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MFD1.0_res10.sgrd",sep=""),
METHOD = 1))



## Run the TWI

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_DEM1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.0_DEM1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.0.res1.NFNW.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.0_SSC1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.0.res1.SSC1.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.0_SSC2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.0.res1.SSC2.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.0_SSC3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.0.res1.SSC3.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.0_SSC4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.0.res1.SSC4.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.0_SSC5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.0.res1.SSC5.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.0_SSC7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.0.res1.SSC7.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.0_SSC10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.0.res1.SSC10.sgrd", sep = ""),
METHOD = 0))



rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.0_res2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.0.res2.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.0_res3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.0.res3.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.0_res4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.0.res4.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.0_res5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.0.res5.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.0_res7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.0.res7.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MFD1.0_res10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MFD1.0.res10.NFNW.sgrd", sep = ""),
METHOD = 0))

##############      MTFD1.0 = method 5, FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.0_DEM1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.0_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.0_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.0_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.0_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.0_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.0_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.0))



rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.0_SSC1.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.0_SSC2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.0_SSC3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.0))


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.0_SSC4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.0_SSC5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.0_SSC7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.0_SSC10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.0))


rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.0_res2.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.0_res3.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.0_res4.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.0_res5.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.0_res7.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 0, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccMTFD1.0_res10.sgrd", sep = ""),
LINEAR_MIN=50000,
METHOD = 5,
CONVERGENCE = 1.0))

## Do the SCA

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.0_DEM1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.0_DEM1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC1.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.0_SSC1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.0_SSC1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.0_SSC2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.0_SSC2.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.0_SSC3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.0_SSC3.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.0_SSC4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.0_SSC4.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.0_SSC5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.0_SSC5.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.0_SSC7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.0_SSC7.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.0_SSC10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.0_SSC10.sgrd",sep=""),
METHOD = 1))


rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.0_res2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.0_res2.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.0_res3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.0_res3.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.0_res4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.0_res4.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.0_res5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.0_res5.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.0_res7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.0_res7.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccMTFD1.0_res10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_MTFD1.0_res10.sgrd",sep=""),
METHOD = 1))





## Run the TWI

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_DEM1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.0_DEM1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.0.res1.NFNW.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.0_SSC1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.0.res1.SSC1.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.0_SSC2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.0.res1.SSC2.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.0_SSC3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.0.res1.SSC3.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.0_SSC4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.0.res1.SSC4.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.0_SSC5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.0.res1.SSC5.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.0_SSC7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.0.res1.SSC7.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.0_SSC10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.0.res1.SSC10.sgrd", sep = ""),
METHOD = 0))




rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.0_res2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.0.res2.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.0_res3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.0.res3.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.0_res4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.0.res4.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.0_res5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.0.res5.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.0_res7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.0.res7.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_MTFD1.0_res10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.MTFD1.0.res10.NFNW.sgrd", sep = ""),
METHOD = 0))

## Do the Slope

rsaga.slope.asp.curv(in.dem="DEM_res1_nosinks.sgrd", out.slope="slope_DEM1.sgrd",out.aspect="aspect_DEM1.sgrd", out.cgene="curv_DEM1.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_nosinks_SSC1.sgrd", out.slope="slope_SSC1.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_nosinks_SSC2.sgrd", out.slope="slope_SSC2.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_nosinks_SSC3.sgrd", out.slope="slope_SSC3.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_nosinks_SSC4.sgrd", out.slope="slope_SSC4.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_nosinks_SSC5.sgrd", out.slope="slope_SSC5.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_nosinks_SSC7.sgrd", out.slope="slope_SSC7.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_nosinks_SSC10.sgrd", out.slope="slope_SSC10.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())

rsaga.slope.asp.curv(in.dem="DEM_res2_nosinks.sgrd", out.slope="slope_res2.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_res3_nosinks.sgrd", out.slope="slope_res3.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_res4_nosinks.sgrd", out.slope="slope_res4.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_res5_nosinks.sgrd", out.slope="slope_res5.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_res7_nosinks.sgrd", out.slope="slope_res7.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())
rsaga.slope.asp.curv(in.dem="DEM_res10_nosinks.sgrd", out.slope="slope_res10.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", method="poly3haralick",env=rsaga.env())

#rsaga.slope.asp.curv(in.dem="DEM_gauss_0-5sigma.sgrd", #out.slope="slope_gauss_0.5sigma.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", #method="poly3haralick",env=rsaga.env())
#rsaga.slope.asp.curv(in.dem="DEM_gauss_1-0sigma.sgrd", #out.slope="slope_gauss_1.0sigma.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", #method="poly3haralick",env=rsaga.env())
#rsaga.slope.asp.curv(in.dem="DEM_gauss_1-5sigma.sgrd", #out.slope="slope_gauss_1.5sigma.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", #method="poly3haralick",env=rsaga.env())
#rsaga.slope.asp.curv(in.dem="DEM_gauss_2-0sigma.sgrd", #out.slope="slope_gauss_2.0sigma.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", #method="poly3haralick",env=rsaga.env())
#rsaga.slope.asp.curv(in.dem="DEM_gauss_2-5sigma.sgrd", #out.slope="slope_gauss_2.5sigma.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", #method="poly3haralick",env=rsaga.env())
#rsaga.slope.asp.curv(in.dem="DEM_gauss_3-5sigma.sgrd", #out.slope="slope_gauss_3.5sigma.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", #method="poly3haralick",env=rsaga.env())
#rsaga.slope.asp.curv(in.dem="DEM_gauss_5-0sigma.sgrd", #out.slope="slope_gauss_5.0sigma.sgrd",out.aspect="aspect.sgrd", out.cgene="curv.sgrd", #method="poly3haralick",env=rsaga.env())




############## KINEMATIC ROUTING FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########

rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccKRA_DEM1.sgrd", sep = ""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccKRA_res2.sgrd", sep = ""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccKRA_res3.sgrd", sep = ""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccKRA_res4.sgrd", sep = ""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccKRA_res5.sgrd", sep = ""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccKRA_res7.sgrd", sep = ""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccKRA_res10.sgrd", sep = ""),
METHOD = 1))



rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccKRA_SSC1.sgrd", sep = ""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccKRA_SSC2.sgrd", sep = ""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccKRA_SSC3.sgrd", sep = ""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccKRA_SSC4.sgrd", sep = ""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccKRA_SSC5.sgrd", sep = ""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccKRA_SSC7.sgrd", sep = ""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccKRA_SSC10.sgrd", sep = ""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccKRA_res2.sgrd", sep = ""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccKRA_res3.sgrd", sep = ""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccKRA_res4.sgrd", sep = ""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccKRA_res5.sgrd", sep = ""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccKRA_res7.sgrd", sep = ""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccKRA_res10.sgrd", sep = ""),
METHOD = 1))

## Do the SCA

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccKRA_DEM1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_KRA_DEM1.sgrd",sep=""),
METHOD = 2)) ##method 2 is aspect driven

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC1.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccKRA_SSC1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_KRA_SSC1.sgrd",sep=""),
METHOD = 2)) ##method 2 is aspect driven

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccKRA_SSC2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_KRA_SSC2.sgrd",sep=""),
METHOD = 2)) ##method 2 is aspect driven

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccKRA_SSC3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_KRA_SSC3.sgrd",sep=""),
METHOD = 2)) ##method 2 is aspect driven

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccKRA_SSC4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_KRA_SSC4.sgrd",sep=""),
METHOD = 2)) ##method 2 is aspect driven

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccKRA_SSC5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_KRA_SSC5.sgrd",sep=""),
METHOD = 2)) ##method 2 is aspect driven

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccKRA_SSC7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_KRA_SSC7.sgrd",sep=""),
METHOD = 2)) ##method 2 is aspect driven

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccKRA_SSC10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_KRA_SSC10.sgrd",sep=""),
METHOD = 2)) ##method 2 is aspect driven

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccKRA_res2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_KRA_res2.sgrd",sep=""),
METHOD = 2)) ##method 2 is aspect driven
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccKRA_res3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_KRA_res3.sgrd",sep=""),
METHOD = 2)) ##method 2 is aspect driven
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccKRA_res4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_KRA_res4.sgrd",sep=""),
METHOD = 2)) ##method 2 is aspect driven
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccKRA_res5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_KRA_res5.sgrd",sep=""),
METHOD = 2)) ##method 2 is aspect driven
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccKRA_res7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_KRA_res7.sgrd",sep=""),
METHOD = 2)) ##method 2 is aspect driven
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccKRA_res10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_KRA_res10.sgrd",sep=""),
METHOD = 2)) ##method 2 is aspect driven
## Run the TWI

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_DEM1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_KRA_DEM1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.KRA.res1.NFNW.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_KRA_SSC1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.KRA.res1.SSC1.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_KRA_SSC2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.KRA.res1.SSC2.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_KRA_SSC3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.KRA.res1.SSC3.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_KRA_SSC4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.KRA.res1.SSC4.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_KRA_SSC5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.KRA.res1.SSC5.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_KRA_SSC7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.KRA.res1.SSC7.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_KRA_SSC10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.KRA.res1.SSC10.sgrd", sep = ""),
METHOD = 0))



rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_KRA_res2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.KRA.res2.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_KRA_res3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.KRA.res3.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_KRA_res4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.KRA.res4.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_KRA_res5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.KRA.res5.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_KRA_res7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.KRA.res7.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_KRA_res10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.KRA.res10.NFNW.sgrd", sep = ""),
METHOD = 0))



############## DEMON FLOW ALGORITHM########################################
##############.#######################.###########################.#############
#################                        ##############################################    ##########

rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDEMON_DEM1.sgrd", sep = ""),
METHOD = 2))
rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDEMON_res2.sgrd", sep = ""),
METHOD = 2))
rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDEMON_res3.sgrd", sep = ""),
METHOD = 2))
rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDEMON_res4.sgrd", sep = ""),
METHOD = 2))
rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDEMON_res5.sgrd", sep = ""),
METHOD = 2))
rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDEMON_res7.sgrd", sep = ""),
METHOD = 2))
rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDEMON_res10.sgrd", sep = ""),
METHOD = 2))


rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDEMON_SSC1.sgrd", sep = ""),
METHOD = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDEMON_SSC2.sgrd", sep = ""),
METHOD = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDEMON_SSC3.sgrd", sep = ""),
METHOD = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDEMON_SSC4.sgrd", sep = ""),
METHOD = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDEMON_SSC5.sgrd", sep = ""),
METHOD = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDEMON_SSC7.sgrd", sep = ""),
METHOD = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDEMON_SSC10.sgrd", sep = ""),
METHOD = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDEMON_res2.sgrd", sep = ""),
METHOD = 2))
rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDEMON_res3.sgrd", sep = ""),
METHOD = 2))
rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDEMON_res4.sgrd", sep = ""),
METHOD = 2))
rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDEMON_res5.sgrd", sep = ""),
METHOD = 2))
rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDEMON_res7.sgrd", sep = ""),
METHOD = 2))
rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDEMON_res10.sgrd", sep = ""),
METHOD = 2))

## Do the SCA

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res1_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDEMON_DEM1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_DEMON_DEM1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC1.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC1.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDEMON_SSC1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_DEMON_SSC1.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC2.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDEMON_SSC2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_DEMON_SSC2.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC3.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDEMON_SSC3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_DEMON_SSC3.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC4.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDEMON_SSC4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_DEMON_SSC4.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC5.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDEMON_SSC5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_DEMON_SSC5.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC7.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDEMON_SSC7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_DEMON_SSC7.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_nosinks_SSC10.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_SSC10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDEMON_SSC10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_DEMON_SSC10.sgrd",sep=""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res2_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res2.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDEMON_res2.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_DEMON_res2.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res3_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res3.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDEMON_res3.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_DEMON_res3.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res4_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res4.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDEMON_res4.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_DEMON_res4.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res5_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDEMON_res5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_DEMON_res5.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res7_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res7.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDEMON_res7.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_DEMON_res7.sgrd",sep=""),
METHOD = 1))
rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res10_nosinks.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_res10.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDEMON_res10.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_DEMON_res10.sgrd",sep=""),
METHOD = 1))

## Run the TWI

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_DEM1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_DEMON_DEM1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.DEMON.res1.NFNW.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC1.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_DEMON_SSC1.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.DEMON.res1.SSC1.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_DEMON_SSC2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.DEMON.res1.SSC2.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_DEMON_SSC3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.DEMON.res1.SSC3.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_DEMON_SSC4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.DEMON.res1.SSC4.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_DEMON_SSC5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.DEMON.res1.SSC5.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_DEMON_SSC7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.DEMON.res1.SSC7.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_SSC10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_DEMON_SSC10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.DEMON.res1.SSC10.sgrd", sep = ""),
METHOD = 0))


rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res2.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_DEMON_res2.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.DEMON.res2.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res3.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_DEMON_res3.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.DEMON.res3.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res4.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_DEMON_res4.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.DEMON.res4.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res5.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_DEMON_res5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.DEMON.res5.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res7.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_DEMON_res7.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.DEMON.res7.NFNW.sgrd", sep = ""),
METHOD = 0))
rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_res10.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_DEMON_res10.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.DEMON.res10.NFNW.sgrd", sep = ""),
METHOD = 0))



################## KRA gaussian



rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_0-5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccKRA_gauss_0.5.sgrd", sep = ""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1-0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccKRA_gauss_1.0.sgrd", sep = ""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1-5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccKRA_gauss_1.5.sgrd", sep = ""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2-0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccKRA_gauss_2.0.sgrd", sep = ""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2-5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccKRA_gauss_2.5.sgrd", sep = ""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_3-5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccKRA_gauss_3.5.sgrd", sep = ""),
METHOD = 1))

rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_5-0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccKRA_gauss_5.0.sgrd", sep = ""),
METHOD = 1))
## Do the SCA

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res1_NFNW.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccKRA_DEM1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_KRA_DEM1.sgrd",sep=""),
METHOD = 2)) ##method 2 is aspect driven

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_0-5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_0.5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccKRA_gauss_0.5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_KRA_gauss_0.5.sgrd",sep=""),
METHOD = 2)) ##method 2 is aspect driven

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1-0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.0.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccKRA_gauss_1.0.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_KRA_gauss_1.0.sgrd",sep=""),
METHOD = 2)) ##method 2 is aspect driven

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1-5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccKRA_gauss_1.5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_KRA_gauss_1.5.sgrd",sep=""),
METHOD = 2)) ##method 2 is aspect driven

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2-0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.0.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccKRA_gauss_2.0.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_KRA_gauss_2.0.sgrd",sep=""),
METHOD = 2)) ##method 2 is aspect driven

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2-5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccKRA_gauss_2.5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_KRA_gauss_2.5.sgrd",sep=""),
METHOD = 2)) ##method 2 is aspect driven

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_3-5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_3.5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccKRA_gauss_3.5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_KRA_gauss_3.5.sgrd",sep=""),
METHOD = 2)) ##method 2 is aspect driven

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_5-0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_5.0.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccKRA_gauss_5.0.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_KRA_gauss_5.0.sgrd",sep=""),
METHOD = 2)) ##method 2 is aspect driven


rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_5-0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_5.0.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccKRA_gauss_5.0.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_KRA_gauss_5.0.sgrd",sep=""),
METHOD = 2)) ##method 2 is aspect driven

## Run the TWI

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_0.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_KRA_gauss_0.5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.KRA.res1.gauss_0.5.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_KRA_gauss_1.0.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.KRA.res1.gauss_1.0.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_KRA_gauss_1.5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.KRA.res1.gauss_1.5.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_KRA_gauss_2.0.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.KRA.res1.gauss_2.0.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_KRA_gauss_2.5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.KRA.res1.gauss_2.5.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_3.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_KRA_gauss_3.5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.KRA.res1.gauss_3.5.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_5.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_KRA_gauss_5.0.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.KRA.res1.gauss_5.0.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_5.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_KRA_gauss_5.0.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.KRA.res1.gauss_5.0.sgrd", sep = ""),
METHOD = 0))


################## DEMON gaussian



rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_0-5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDEMON_gauss_0.5.sgrd", sep = ""),
METHOD = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1-0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDEMON_gauss_1.0.sgrd", sep = ""),
METHOD = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_1-5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDEMON_gauss_1.5.sgrd", sep = ""),
METHOD = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2-0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDEMON_gauss_2.0.sgrd", sep = ""),
METHOD = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_2-5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDEMON_gauss_2.5.sgrd", sep = ""),
METHOD = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_3-5sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDEMON_gauss_3.5.sgrd", sep = ""),
METHOD = 2))

rsaga.geoprocessor(lib = "ta_hydrology", module = 2, 
param = list(ELEVATION = paste(getwd(),"/DEM_gauss_5-0sigma.sgrd", sep = ""), 
FLOW = paste(getwd(),"/FlowAccDEMON_gauss_5.0.sgrd", sep = ""),
METHOD = 2))
## Do the SCA

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_res1_NFNW.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDEMON_DEM1.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_DEMON_DEM1.sgrd",sep=""),
METHOD = 2)) ##method 2 is aspect driven

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_0-5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_0.5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDEMON_gauss_0.5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_DEMON_gauss_0.5.sgrd",sep=""),
METHOD = 2)) ##method 2 is aspect driven

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1-0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.0.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDEMON_gauss_1.0.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_DEMON_gauss_1.0.sgrd",sep=""),
METHOD = 2)) ##method 2 is aspect driven

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_1-5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_1.5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDEMON_gauss_1.5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_DEMON_gauss_1.5.sgrd",sep=""),
METHOD = 2)) ##method 2 is aspect driven

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2-0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.0.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDEMON_gauss_2.0.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_DEMON_gauss_2.0.sgrd",sep=""),
METHOD = 2)) ##method 2 is aspect driven

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_2-5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_2.5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDEMON_gauss_2.5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_DEMON_gauss_2.5.sgrd",sep=""),
METHOD = 2)) ##method 2 is aspect driven

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_3-5sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_3.5.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDEMON_gauss_3.5.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_DEMON_gauss_3.5.sgrd",sep=""),
METHOD = 2)) ##method 2 is aspect driven

rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_5-0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_5.0.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDEMON_gauss_5.0.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_DEMON_gauss_5.0.sgrd",sep=""),
METHOD = 2)) ##method 2 is aspect driven


rsaga.geoprocessor(lib = "ta_hydrology", module = 19, 
param = list(DEM = paste(getwd(),"/DEM_gauss_5-0sigma.sgrd", sep = ""), 
WIDTH = paste(getwd(),"/FW_gauss_5.0.sgrd", sep = ""),
TCA = paste(getwd(),"/FlowAccDEMON_gauss_5.0.sgrd", sep = ""),
SCA=paste(getwd(),"/SCA_DEMON_gauss_5.0.sgrd",sep=""),
METHOD = 2)) ##method 2 is aspect driven

## Run the TWI

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_0.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_DEMON_gauss_0.5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.DEMON.res1.gauss_0.5.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_DEMON_gauss_1.0.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.DEMON.res1.gauss_1.0.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_1.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_DEMON_gauss_1.5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.DEMON.res1.gauss_1.5.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_DEMON_gauss_2.0.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.DEMON.res1.gauss_2.0.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_2.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_DEMON_gauss_2.5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.DEMON.res1.gauss_2.5.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_3.5sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_DEMON_gauss_3.5.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.DEMON.res1.gauss_3.5.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_5.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_DEMON_gauss_5.0.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.DEMON.res1.gauss_5.0.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_hydrology", module = 20, 
param = list(SLOPE = paste(getwd(),"/slope_gauss_5.0sigma.sgrd", sep = ""), 
AREA = paste(getwd(),"/SCA_DEMON_gauss_5.0.sgrd", sep = ""),
TWI = paste(getwd(),"/TWI.DEMON.res1.gauss_5.0.sgrd", sep = ""),
METHOD = 0))

rsaga.geoprocessor(lib = "ta_lighting", module = 8, 
param = list(DEM = paste(getwd(),"/USGS_one_meter_x39y400_AR_R6_WashingtonCO_2015.sgrd", sep = ""), 
GEOMORPHONS = paste(getwd(),"/Geomorphons_res1_NFNW.sgrd", sep = "")))

################ after terrain analyses are complete use the SAGA-GIS GUI to run
################ “extract values to points" tool to query TWI and SWI values at point locations of the 
################ moisture sensors.

