
library(tidyverse)
library(easystats)
library(cowplot)

####### Settings ---------------------------------------------------------------

setwd("C:\\Users\\tomma\\Desktop\\BabyBrain\\Projects\\EMG") #project dir
output_dir = "./Results\\"

SE <- function(xx) {
  sd(xx)/sqrt(length(xx))
}


####### AUC ---------------------------------------------------------------

## Prepare
df = read.csv(file=paste(output_dir,"AUC.csv", sep  = "\\"))

AUC <- df %>% 
  group_by(Model) %>%
  summarize(AUC = mean(Auc, na.rm = TRUE),
            Err = SE(Auc))

AUC = AUC %>%
  arrange(AUC)%>%
  mutate(Model=factor(Model, levels=Model))



## Plot
notzoomed = ggplot(AUC, aes( y = AUC, x = Model, color =Model))+
  geom_point2(size =1.5)+
  geom_errorbar(aes(ymin = AUC-Err, ymax = AUC+Err), width = 0.2)+
  labs(x = "", y = "Area Under the Curve")+
  annotate("rect", xmin =48.5, xmax = 72.5, ymin = 0.75, ymax = 0.82,alpha = .2)+
  scale_color_see()+
  theme_bw(base_size=15)+
  theme(axis.text.x = element_text(angle = 50, vjust = 1, hjust=1, size=12),
        axis.text.y = element_text(size=20),
        axis.title.y = element_text(size=20),
        legend.position="none", legend.box="horizontal")+
  guides(colour = guide_legend(nrow = 6))


zoomed = ggplot(AUC, aes( y = AUC, x = Model, color =Model))+
  geom_point2(size =4)+
  geom_errorbar(aes(ymin = AUC-Err, ymax = AUC+Err), width = 0.2,linewidth = 1.2)+
  labs(x = "", y = "Area Under the Curve")+
  scale_color_see()+
  theme_bw(base_size = 20)+
  theme(legend.position="none",
        axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))+
  scale_x_discrete(limits =AUC[AUC['AUC']>= 0.75,]$Model)+
  ylim(0.76,0.791)
  
plot_grid(notzoomed, NULL, zoomed, nrow = 3,rel_heights = c(5,0.2,3))
ggsave2(paste(output_dir, 'Figures','AucPlot_double.jpg', sep = '\\'),
        width = 50,  height = 28,  units = "cm",  dpi = 300)







####### ROC ---------------------------------------------------------------

## Prepare
db = read.csv(file=paste(output_dir,"ROC.csv", sep  = "\\"))

ROC  = db %>%
  group_by(Model,Specificity)%>%
  summarise(Specificity = mean(Specificity),
            Sensitivity = mean(Sensitivity))

ROC$Model <- factor(ROC$Model, levels = levels(AUC$Model))


## Plot
ggplot(ROC, aes(x = Specificity, y = Sensitivity, colour = Model))+
  geom_abline(slope = 1, intercept = 0, linetype = "dotted", alpha = 1, linewidth =1) +
  geom_step(linewidth  =1.2, alpha=0.4) +
  
  labs(x = "Specificity (False Positive Rate)",
       y = "Sensitivity (True Positive Rate)")+scale_color_see()+
  theme(axis.text.x = element_blank(),
        legend.position="bottom", legend.box="horizontal")+
  guides(colour = guide_legend(nrow = 6))

ggsave2(paste(output_dir, 'Figures','RocPlot.png', sep = '\\'),
        width = 50,  height = 28,  units = "cm",  dpi = 300)




