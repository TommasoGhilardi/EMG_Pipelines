
library(tidyverse)
library(randomForest)
library(caret)
library(caTools)
library(cowplot)

####### Settings ---------------------------------------------------------------

setwd("C:\\Users\\tomma\\Desktop\\BabyBrain\\Projects\\EMG")

output_dir = "./Results\\"
set.seed(123)

####### Prepare dataframe ---------------------------------------------------------------

#read the data
df = read.csv(file=paste(output_dir,"AUC.csv", sep  = "\\"))

#Extract columns from string
db = data.frame(str_split_fixed(df$Model, "_", 3))
colnames(db) <- c('Index','Type','x3')
dc = data.frame(str_split_fixed(db$x3, "_", 3))
colnames(dc) <- c('Baseline','W_Muscle','W_Subject')

data = bind_cols(df,db[c('Index', 'Type')], dc[c('Baseline','W_Muscle','W_Subject')])

#Renaming for clarity
data[data == 'Bn' | data== 'Sn' | data == 'Mn'] = 'Not done'
data[data$Baseline == 'Bd',]$Baseline  = 'Division'
data[data$Baseline == 'Bs',]$Baseline  = 'Substraction'
data[data$W_Muscle == 'Ms',]$W_Muscle  = 'Done' 
data[data$W_Subject == 'Ss',]$W_Subject= 'Done'

data[data$Index =='Ab',]$Index = 'Average'
data[data$Index =='Aa',]$Index = 'Raw'

data = data %>%
  mutate(across(c(Index,Type,Baseline,W_Muscle,W_Subject), factor))%>%
  select( -X,-Model,-subsample,-Repetition)


####### Split data ---------------------------------------------------------------

split = sample.split(data, SplitRatio = 0.8) 

data_train = subset(data, split == "TRUE") 
data_test  = subset(data, split == "FALSE") 

####### Prepare Random forest ---------------------------------------------------------------

#tune RF returns the best optimized value of random variable 
tuner <- tuneRF(
  data_train,data_train$Auc,
  ntreeTry   = 100,
  stepFactor = 1,
  improve    = 0.01,
  trace      = T)

tn = as.data.frame(tuner)

ggplot(tn, aes(x = mtry, y=OOBError))+
  geom_line(linewidth = 1.5)+
  geom_point(size =5)


####### Random forest train ---------------------------------------------------------------

model <- randomForest(Auc~.,data= data_train, mtry=2,importance=TRUE, ntree =1000)
model          

plot(model)


####### Check importance of variables ---------------------------------------------------------------

impo = as.data.frame(importance(model))                       # visualizing the importance of variables of the model.
impo$variable = rownames(impo)


## Plot importance of variables
importance = ggplot(impo, aes(x=variable, y=`%IncMSE`)) +
  geom_segment( aes(x=fct_reorder(variable, `%IncMSE`), xend=fct_reorder(variable, `%IncMSE`), y=0, yend=`%IncMSE`),
                color="skyblue", linewidth=3.) +
  geom_point(color="blue", alpha=0.75, size=6.5) +
  coord_flip() +
  scale_x_discrete(labels= c('Feature of interest','Signal averaging',
                             'Baseline correction','Standardisation within subject','Standardisation within muscle'))+
  labs(y= 'Variable importance')+
  theme(panel.grid.major.y = element_blank(),
    panel.border = element_blank(),
    axis.ticks.y = element_blank())+
  theme_bw(base_size = 30)
  
  
ggsave(paste(output_dir,'Figures','ImportanceRandomForest.png', sep='\\'),importance,device = "png", width = 40, height = 20, units = "cm",dpi=300)


####### Partial plot ---------------------------------------------------------------

a = as.data.frame(partialPlot(model,data_train, x.var='W_Muscle',plot = F))
a$indx = 'Standardisation within muscle'

b = as.data.frame(partialPlot(model,data_train, x.var='W_Subject',plot = F))
b$indx = 'Standardisation within subject'

c = as.data.frame(partialPlot(model,data_train, x.var='Baseline',plot = F))
c$indx = 'Baseline correction'

d = as.data.frame(partialPlot(model,data_train, x.var='Index',plot = F))
d$indx ='Signal averaging'
d = d %>% mutate(x, x = ifelse(x =='Average', "First step", "Last step"))

e = as.data.frame(partialPlot(model,data_train, x.var='Type',plot = F))
e$indx =  'Feature of interest'

db = bind_rows(a,b,c,d,e)


# changing factor levels order to make plot nicer
db$indx = factor(db$indx, levels = c('Standardisation within muscle', 'Standardisation within subject', 'Baseline correction', 'Signal averaging','Feature of interest')) 
db$x =  factor(db$x, levels = c('Division','Substraction', 'Done', 'Not done', 'MAV','RMS','iEMG','Last step','First step' ))


partialplot= ggplot(db, aes(x= x,y = y, fill=  indx))+
  geom_bar(stat = 'identity')+
  facet_grid(~ indx , scales="free", drop = TRUE)+
  theme_bw(base_size = 25)+
  theme(legend.position = 'none', axis.text.x = element_text(size = 16))+
  labs(x= '', y='Estimated AUC')

ggsave(paste(output_dir,'Figures','PartialPlot.png', sep='\\'),partialplot ,device = "png", width = 55, height = 28, units = "cm",dpi=300)



####### Extract RMSE from test dataset ---------------------------------------------------------------

pred_test <- predict(model, newdata = data_test, type= "class")

RMSE(pred_test,data_test$Auc)

