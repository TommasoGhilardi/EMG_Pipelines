
####### Libraries ---------------------------------------------------------------

#library(caTools)
library(lme4)
library(ggplot2)
library(dplyr)

library(performance)
library(effectsize)
library(datawizard)
library(bayestestR)
library(see)
library(ggforce)
####### Set and read data ---------------------------------------------------------------

directory = "C:\\Users\\krav\\Desktop\\BabyBrain\\Projects\\EMG\\Analysis"
source(paste(directory,"scripts\\SpyderPlot.R", sep ="\\"))

# LIST OF FILES IN FOLDER
xlist<-list.files(paste(directory,"result\\PipelinesAvg\\", sep  = "\\") ,pattern = "*.csv")

my_data <- lapply(xlist, function(i){
  read.csv(paste(directory,"result\\PipelinesAvg",i, sep = '\\' ))})


####### Basic preprocessing ---------------------------------------------------------------

training = list()
names = list()
dat = data.frame()


for(x in 1:length(my_data)){
  names[x] =  paste(strsplit(xlist[x],'\\_|\\.')[[1]][2], 
                    strsplit(xlist[x],'\\_|\\.')[[1]][1], sep='_' )[[1]]
  df = my_data[[x]]
  df = df[df[,2] != 2,]   # remove neutral
  df[df[,2] == 3,2] = 0
  
  training[[x]] = filter(df, Id %in% seq(1,100,2))   # select only odd IDs
  training[[x]]$Id = factor(training[[x]]$Id)   # making sure they are factors
  
  
  ## Plot for outlier
  df$Pip = replicate(nrow(df) ,paste(strsplit(xlist[x],'\\_|\\.')[[1]][2], 
                                     strsplit(xlist[x],'\\_|\\.')[[1]][1], sep='_' )[[1]])
  dat =  rbind(dat,df)
  
  rm(df)
  
}

rm(my_data)


##Plot to determine outliers for each pipeline

df =  data_to_long(dat,cols = c(3,4),
                   colnames_to = 'muscle', values_to = 'activity'   )
df$Id = factor(df$Id)

for(x in 1:11){
  ggplot(df, aes(x= Id,y =activity, color= muscle))+
    geom_point()+
    facet_wrap_paginate(vars(Pip),nrow = 6, ncol = 1,scales = "free", page = x)
  ggsave(paste("C:\\Users\\krav\\surfdrive\\Projects\\EMG\\out",as.character(x) ,'.png'), width = 20, height = 11.69, units = 'in', dpi=300)
}



##Plot only specific pipelines that have problems


Outt = c('PipelineA1_1','PipelineA2_1','PipelineB1_1','PipelineB7_1','PipelineC1_1',
        'PipelineC2_1','PipelineX1_1','PipelineX2_1','PipelineY1_1','PipelineZ1_1')

DF = df[is.element(df$Pip, Outt),]

for(x in 1:2){
  ggplot(DF, aes(x= Id,y =activity, color= muscle))+
    geom_point()+
    facet_wrap_paginate(vars(Pip),nrow = 5, ncol = 1,scales = "free", page = x)
  ggsave(paste("C:\\Users\\krav\\surfdrive\\Projects\\EMG\\Outliers",as.character(x) ,'.png'), width = 20, height = 11.69, units = 'in', dpi=300)
}

####### Basic preprocessing ---------------------------------------------------------------




















####### ##################################

names[y] =  paste(strsplit(xlist[y],'\\_|\\.')[[1]][2], 
                  strsplit(xlist[y],'\\_|\\.')[[1]][1], sep='_' )[[1]]

models[[y]] = glm(Emotion ~ Corr*Zyg, family = binomial(), data= DF[[y]])


df=  DF[[y]]
df$y_pred = predict(models[[y]], df, type="response")

print(y)
names[y]


df=  DF[[y]]
df$y_pred = predict(models[[y]], df, type="response")

df[df$y_pred >0.999 | df$y_pred <0.005,]


y=y+1


###########################################