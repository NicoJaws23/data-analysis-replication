#Codeeeeeee
library(brms)
library(tidyverse)
f1 <- "https://raw.githubusercontent.com/NicoJaws23/data-analysis-replication/refs/heads/main/DataForModelSelection.csv"
df <- read_csv(f1)
f2 <- "https://raw.githubusercontent.com/NicoJaws23/data-analysis-replication/refs/heads/main/DataForPredAndIntergroup.csv"
pred <- read_csv(f2)
