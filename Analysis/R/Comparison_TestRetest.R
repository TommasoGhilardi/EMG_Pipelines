
####### Libraries ---------------------------------------------------------------

library(lme4)
library(ggplot2)
library(dplyr)

library(performance)
library(effectsize)
library(datawizard)
library(bayestestR)
library(see)
library(gridExtra)

####### Set and read data ---------------------------------------------------------------

directory = "C:\\Users\\krav\\Desktop\\BabyBrain\\Projects\\EMG\\Analysis\\result\\Statistics"


## TEST
test = read.csv(paste(directory,"test.csv", sep = '\\' ))
test$set =  replicate(length(test$Name), "test")
test$Name  <- with(test, reorder(Name, Auc))

# LONG
long =  test
long$Model = NULL
long <- data_to_long(long, cols = 8:9, colnames_to = 'Index')


## RETEST
re_test = read.csv(paste(directory,"retest.csv", sep = '\\' ))
re_test$set =  replicate(length(test$Name), "re_test")

# LONG
relong =  re_test
relong$Model = NULL
relong <- data_to_long(relong, cols = 8:9, colnames_to = 'Index')


####### Plot comparison ---------------------------------------------------------------

DB = rbind(long, relong)
DB$set <- factor(DB$set,levels=c("test","re_test"))

double = ggplot(DB, aes(x =  Name, y= Value, colour  = Name, shape = Index))+
  geom_point( size = 3,)+
  facet_grid(rows = vars(set))+
  labs( x = "",color='Pipelines',shape = "Index")+
  scale_color_see()+  guides(colour = "none")+
  theme(axis.text.x = element_blank(),
        legend.position="top", legend.box="horizontal",
        plot.margin=unit(c(0,0.2,0,0.2),"cm"))


####### Plot comparison ---------------------------------------------------------------


test$Diff  = abs(test$Auc - re_test[match(test$Name, re_test$Name),]$Auc)
write.csv(test,file=paste(directory,"difference_auc.csv", sep  = "\\"))


Diff = ggplot(test, aes(x = Name, y  = Diff, colour  = Name))+
  geom_point( size = 3)+
  labs( x = "Pipelines",color='Pipelines',shape = "Index")+
  guides(color = guide_legend(nrow = 6))+  scale_color_see()+
  theme(axis.text.x = element_blank(),
        legend.position="bottom", legend.box="horizontal",
        plot.margin=unit(c(0,0.2,0,0.2),"cm"))+
  ylim(0, 0.3)




grid.arrange(double, Diff, ncol=1, nrow =2,heights=c(2,1))

g <- arrangeGrob(double, Diff, ncol=1, nrow =2,heights=c(2,1)) #generates g

ggsave(file = paste(directory,"Auc_Pcp_Diff.png", sep  = "\\"), g,width = 20, height = 11.69, units = 'in', dpi=300)





























