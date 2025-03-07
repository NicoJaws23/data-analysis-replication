#Codeeeeeee
library(brms)
library(tidyverse)
f1 <- "https://raw.githubusercontent.com/NicoJaws23/data-analysis-replication/refs/heads/main/DataForModelSelection.csv"
df <- read_csv(f1)
names(df)
f2 <- "https://raw.githubusercontent.com/NicoJaws23/data-analysis-replication/refs/heads/main/DataForPredAndIntergroup.csv"
pred <- read_csv(f2)
names(pred)
df <- mutate(df, Rain = df$`Rainfall (mm)`)

rainMax <- df |>
  group_by(DateRE)
  summarise(max)
#Plotting rain, temp_min, and temp_max
ggplot(data = df, mapping = aes(x = DateRE, y = Rain, group = 1)) +
  geom_line()
