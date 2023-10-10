
####### Libraries ---------------------------------------------------------------

library(tidyverse)
library(easystats)
library(tictoc)


####### Function ---------------------------------------------------------------

outliers_removal = function(d) {
  
  for(outl in 3:4){
    m = mean(d[,outl])
    s = sd(d[,outl])
    
    d[d[,outl] < m-2*s | d[,outl] > m+2*s, outl] = NaN
  }
  
  return(d)
}


Interpolation =  function(Data) {
  step =0.01
  Data_out = data.frame(approx(Data$Specificity ,Data$Sensitivity, seq(0+step, 1, by=step), method="linear", ties = 'ordered'))
  Data_out <- rbind(Data_out,c(0,0))
  Data_out = rename(Data_out, Specificity = x, Sensitivity=y )
  Data_out['Model'] =  Data$Model[1]
  return(Data_out)
}


####### Settings ---------------------------------------------------------------

setwd("C:\\Users\\tomma\\Desktop\\BabyBrain\\Projects\\EMG")
input_dir    = "./Data\\Processing\\Pipelines"
output_dir   = "./Results\\"
subsets_path = "./Data\\SubsamplePipelines\\Subsamples.Rda"

Iterations   = 500

####### Set and read data ---------------------------------------------------------------

load(subsets_path)

# Find all the data in the folder
xlist = list.files(input_dir ,pattern = "*.csv")

# Read the data
my_data <- lapply(xlist, function(i){
  read.csv(paste(input_dir,i, sep = '\\' ))})

# Create empty lists
ROC = list()
AUC = list()

# Loop over the number of iterations
print("Starting...")
tic("Running pipelines")
for(rep in 1:Iterations){ 
  print(paste('REPETITION =',rep))
  
  subRoc = list()
  subAuc = list()
  
  # Loop over the subsets
  for(subsample in 2:4){ 
    print(paste('--Subsample =',subsample-1))
    
    ####### Preprocess the data ---------------------------------------------------------------
    
    # Subset the data in the subset
    Subjects = database[rep, subsample][[1]]
    
    # Preparing empty vectors and data frame
    data = list()
    dat = data.frame()
    out = data.frame(Pieline =character(),Corr=double(),Zyg =double())
    names = character()
    
    
    # Importing all the pipelines
    for(x in 1:length(my_data)){
      
      # Extract the name of the pipelines
      names[x] =  strsplit(xlist[x],'.csv')[[1]] 
      
      df = my_data[[x]]
      df = df[df[,2] != 2,]   # remove neutral
      df[df[,2] == 3,2] = 0   # set sad to 0
      
      # Remove outliers
      df = outliers_removal(df)
      
      # Save outliers number
      out[nrow(out) + 1,] = list(names[x],sum(is.na(df$Corr)), sum(is.na(df$Zyg))) 
      
      # Subset the data in the subset
      data[[x]] = filter(df, Id %in% Subjects)
      data[[x]]$Id = factor(data[[x]]$Id)   # making sure they are factors
      data[[x]]$Emotion = factor(data[[x]]$Emotion) # making sure they are factors
      
      
      rm(df)
      
    }
    
    
    ####### Running all the models ---------------------------------------------------------------
    
    # Extract all logistic models
    DB = data%>%
      map(~glm(Emotion ~ Corr*Zyg, family = binomial(), data= .))%>%
      map(performance_roc)%>%
      map(as.data.frame)
    
    for(y in 1:length(DB)){DB[[y]]$Model = names[y]} #give proper names to glms
    

    ####### Extract Auc ---------------------------------------------------------------
    
    subAuc[[subsample-1]] =  DB%>%
      bind_rows()%>%
      group_by(Model) %>%
      summarize(Auc = area_under_curve(Specificity, Sensitivity))%>%
      mutate(subsample  = subsample-1)%>%
      mutate(Repetition =  rep)

    
    ####### Extract Roc ---------------------------------------------------------------
    
    DB = map_dfr(DB, Interpolation)
    subRoc[[subsample-1]] = DB%>%
      mutate(Subsample   = subsample-1)%>%
      mutate(Repetition  = rep)
    
  }
    
  
  # Combining in list of data-frames
  ROC[[rep]] = subRoc
  AUC[[rep]] = subAuc
  
}

####### Save the data  ---------------------------------------------------------------

# Combing data in one dataframe
ROC =  bind_rows(ROC)
AUC = bind_rows(AUC)

# Save data as CSV
write.csv(AUC,file=paste(output_dir,"AUC.csv", sep  = "\\"))
write.csv(ROC,file=paste(output_dir,"ROC.csv", sep  = "\\"))

toc()


