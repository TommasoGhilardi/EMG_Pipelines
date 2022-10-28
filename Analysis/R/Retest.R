
####### Libraries ---------------------------------------------------------------

library(lme4)
library(ggplot2)
library(dplyr)

library(performance)
library(effectsize)
library(datawizard)
library(bayestestR)
library(see)



####### Function ---------------------------------------------------------------

outliers_removal <- function(d) {
  
  for(outl in 3:4){
    m = mean(d[,outl])
    s = sd(d[,outl])
    
    d[d[,outl] < m-2*s | d[,outl] > m+2*s, outl] = NaN
  }
  
  return(d)
}



####### Set and read data ---------------------------------------------------------------

directory = "C:\\Users\\krav\\Desktop\\BabyBrain\\Projects\\EMG\\Analysis\\result\\Pipelines"
output_dir = "C:\\Users\\krav\\Desktop\\BabyBrain\\Projects\\EMG\\Analysis\\result\\Statistics"

# LIST OF FILES IN FOLDER
xlist<-list.files(directory ,pattern = "*.csv")

my_data <- lapply(xlist, function(i){
  read.csv(paste(directory,i, sep = '\\' ))})



####### Basic preprocessing ---------------------------------------------------------------

Subjects = c(79, 17, 87, 88, 13, 38, 63, 86, 42, 43, 93, 98, 56, 85, 70, 20, 34, 
        24 ,29, 15, 77, 68, 39, 25,  4 ,73, 55, 27, 69, 65, 16,  6 ,57, 23, 91, 
        53, 89, 41, 90,  2, 18, 40, 12, 45,  9, 81, 44, 62,  8, 82)
#Subjects= seq(2,100,2)

retest = list()
dat = data.frame()
out = data.frame(Pieline =character(),Corr=double(),Zyg =double())
names = character()

for(x in 1:length(my_data)){
  
  names[x] =  paste(strsplit(xlist[x],'\\_|\\.')[[1]][2], 
                    strsplit(xlist[x],'\\_|\\.')[[1]][1], sep='_' )[[1]] #extract neames pipelines
  
  df = my_data[[x]]
  df = df[df[,2] != 2,]   # remove neutral
  df[df[,2] == 3,2] = 0   # set sad to 0
  
  df = outliers_removal(df) # remove outliers
  out[nrow(out) + 1,] = list(names[x],sum(is.na(df$Corr)), sum(is.na(df$Zyg))) # save outliers number
  
  # Subset in training and test
  retest[[x]] = filter(df,! Id %in% Subjects)
  retest[[x]]$Id = factor(retest[[x]]$Id)   # making sure they are factors
  retest[[x]]$Emotion = factor(retest[[x]]$Emotion) # making sure they are factors
  
  
  rm(df)
  
}

rm(my_data)



####### Models ---------------------------------------------------------------


# Extract all logistic models
models= list()
DB <- data.frame(Sensitivity =double(),Specificity =double(),Model=character(), Auc = double())


for(y in 1:length(retest)){
  
  models[[y]] = glm(Emotion ~ Corr*Zyg, family = binomial(), data= retest[[y]])
  
  db  = as.data.frame(performance_roc(models[[y]]))
  db$Model = names[y]
  DB = rbind(DB,db)
  rm(db)
}



####### Extract all the features ---------------------------------------------------------------

# Auc for each row
DB <- DB %>% 
  group_by(Model) %>%
  mutate(Auc = area_under_curve(Specificity, Sensitivity))

# Auc summarized
DF <- DB %>% 
  group_by(Model) %>%
  summarize(Auc = area_under_curve(Specificity, Sensitivity))

# Remaining Features 
comp = compare_performance(models,metrics = c('AIC','BIC','RMSE','AUC','PCP'))
comp$Name =  names
comp$Auc = DF$Auc
comp <- comp[order(comp$Auc) , ]  # order for AUC
comp$Name  <- with(comp, reorder(Name, Auc))  # charge order of factor level for visualization
write.csv(comp,file=paste(output_dir,"retest.csv", sep  = "\\"))



# Plot ROC
DB$Model  <- with(DB, reorder(Model, Auc))

ggplot(DB, aes(x = Specificity, y = Sensitivity, colour = Model,alpha = Auc))+
  geom_abline(slope = 1, intercept = 0, linetype = "dotted", alpha = .8, size =1.5) +
  geom_line(size  =2) +
  ylim(c(0, 1)) +
  xlim(c(0, 1)) +
  labs(x = "1 - Specificity (False Positive Rate)",
       y = "Sensitivity (True Positive Rate)")+scale_color_see()
ggsave(paste(output_dir,"Auc_Retest.png", sep  = "\\"), width = 20, height = 11.69, units = 'in', dpi=300)



# Plot AUC and PCP
long =  comp
long$Model = NULL
long <- data_to_long(long, cols = 7:8, colnames_to = 'Index')
write.csv(long,file=paste(output_dir,"retest_long.csv", sep  = "\\"))


ggplot(long, aes(x =  Name, y= Value, colour  = Name, shape = Index))+
  geom_point( size = 3)+
  labs( x = "Pipelines",color='Pipelines',shape = "Index")+
  #guides(shape = "none")+
  theme(axis.text.x = element_blank(),
        legend.position="bottom", legend.box="horizontal")+
  guides(color = guide_legend(nrow = 6))+  scale_color_see()
ggsave(paste(output_dir,"Auc_Pcp_Retest.png", sep  = "\\"), width = 20, height = 11.69, units = 'in', dpi=300)





