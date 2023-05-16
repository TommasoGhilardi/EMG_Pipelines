

setwd("C:\\Users\\krav\\Desktop\\BabyBrain\\Projects\\EMG")

####### Setting seed ---------------------------------------------------------------

# How many different seeds
num   =  1000

# Creating the seeds
Seeds = sample(1:1000000, num, replace = FALSE)


####### Extract subsamples---------------------------------------------------------------

database = data.frame()

for(Repetition in 1:1000){
  
  # Retrieve seed number
  Seed = Seeds[Repetition]
  set.seed(Seed) # set seed
  
  # Create random list from 1 to 100 for the subjects
  Subjects = 1:100
  Subjects <- sample(Subjects) # sample the subjects
  
  Subsample1 = I(list(c(Subjects[1:33])))
  Subsample2 = I(list(c(Subjects[34:66])))
  Subsample3 = I(list(c(Subjects[67:99])))
  
  # Put everything in a dataframe
  df =  data.frame(Seed, Subsample1,Subsample2,Subsample3,Repetition)
  
  # Concatenate
  database = rbind(database,df)
}


####### Save as Rda ---------------------------------------------------------------

path =  './Data\\SubsamplePipelines\\Subsamples.Rda'
save(database,file=path)

rstudioapi::getActiveDocumentContext()$path 



