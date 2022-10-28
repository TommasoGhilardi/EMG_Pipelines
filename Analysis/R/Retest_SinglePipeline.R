
####### Libraries ---------------------------------------------------------------

library(ggplot2)
library(performance)
library(bayestestR)
library(dplyr)

library(ggtext)
library(gridExtra)
library(datawizard)
library(sjPlot)
library(modelbased)

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

# Best Pipeline
Pipeline = '1_PipelineB9.csv'

file = read.csv(paste(directory,Pipeline, sep = '\\' ))


####### Basic preprocessing ---------------------------------------------------------------

Subjects= seq(1,100,2) # only even number participants


file = file[file[,2] != 2,]   # remove neutral
file[file[,2] == 3,2] = 0   # set sad to 0

file = outliers_removal(file) # remove outliers

# Subset in training and test
test = filter(file, Id %in% Subjects)
test$Id = factor(retest$Id)   # making sure they are factors
test$Emotion = factor(retest$Emotion) # making sure they are factors

retest = filter(file, !Id %in% Subjects)
retest$Id = factor(retest$Id)   # making sure they are factors
retest$Emotion = factor(retest$Emotion) # making sure they are factors



####### Logistic Model ---------------------------------------------------------------

## Test
test_model = glm(Emotion ~ Corr*Zyg, family = binomial(), data= test)
summary(test_model)

binned_residuals(test_model)

### Retest
retest_model = glm(Emotion ~ Corr*Zyg, family = binomial(), data= retest)
summary(retest_model)

binned_residuals(retest_model)



####### Area under the curve ---------------------------------------------------------------

## Test
test_Auc  = performance_roc(test_model)
test_AUC = round(area_under_curve(test_Auc$Specificity, test_Auc$Sensitivity), digits = 3)
test_lab = paste("<span style='color:black'>**AUC = ", test_AUC,"**</span>", sep ='')

## ReTest
retest_Auc  = performance_roc(retest_model)
retest_AUC = round(area_under_curve(retest_Auc$Specificity, retest_Auc$Sensitivity), digits = 3)
retest_lab = paste("<span style='color:black'>**AUC = ", retest_AUC,"**</span>", sep ='')



test_plot = ggplot(test_Auc, aes(x = Specificity, y = Sensitivity))+
  geom_abline(slope = 1, intercept = 0, linetype = "dotted", alpha = .8, size =1.5) +
  geom_line(size  =2, color = '#ca2c29')+
  labs(x = "1 - Specificity (False Positive Rate)",
       y = "Sensitivity (True Positive Rate)")+
  geom_richtext(aes( x=0.15, y=0.80, 
                  label = test_lab )) + ggtitle('Test')
  
retest_plot = ggplot(retest_Auc, aes(x = Specificity, y = Sensitivity))+
  geom_abline(slope = 1, intercept = 0, linetype = "dotted", alpha = .8, size =1.5) +
  geom_line(size  =2, color = '#ca2c29')+
  labs(x = "1 - Specificity (False Positive Rate)",
       y = "Sensitivity (True Positive Rate)")+
  geom_richtext(aes( x=0.15, y=0.80, 
                     label = retest_lab ))+ ggtitle('Retest')


Final_plot = grid.arrange(test_plot, retest_plot, ncol=2)
ggsave(paste(output_dir,"SinglePipelinesAuc.png", sep  = "\\"),Final_plot, width = 20, height = 11.69, units = 'in', dpi=300)



####### Percentage of correct predictions ---------------------------------------------------------------
# PCP based on the proposal from Gelman and Hill 2017, 99, which is defined as the proportion of cases for
# which the deterministic prediction is wrong, i.e. the proportion where the predicted probability is above
# 0.5, although y=0 (and vice versa)

compare_performance(test_model,retest_model)
test_pcp = performance_pcp(test_model)
retest_pcp = performance_pcp(retest_model)



####### Reshape model to long format  ---------------------------------------------------------------


#### Setting up database
Total = data_to_long(retest, select = c(3, 4),
                    colnames_to = "Muscle",values_to = "Activity", rows_to = "Rep")

level = c("Sad","Happy")
Total$Emotion = level[Total$Emotion]



#### Running the model

model = lm(Activity ~ Muscle*Emotion, data= Total)
summary(model)

# Check assumptions
check_model(model)
check_homogeneity(model)
check_outliers(model)
check_heteroscedasticity(model)

# Contrast
estimate_contrasts(model, contrast = c("Muscle", "Emotion"))

performance(model)

#### Plot

plot_model(model, type = "int")
ggsave(paste(output_dir,"InteractionPlotting.png", sep  = "\\"), width = 20, height = 11.69, units = 'in', dpi=300)






