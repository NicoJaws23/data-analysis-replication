#Codeeeeeee
library(brms)
library(tidyverse)
library(cowplot)
f1 <- "https://raw.githubusercontent.com/NicoJaws23/data-analysis-replication/refs/heads/main/DataForModelSelection.csv"
df <- read_csv(f1)
names(df)
f2 <- "https://raw.githubusercontent.com/NicoJaws23/data-analysis-replication/refs/heads/main/DataForPredAndIntergroup.csv"
pred <- read_csv(f2)
names(pred)
df <- mutate(df, Rain = df$`Rainfall (mm)`)
df <- na.omit(df)
rainMax <- df |>
  group_by(DateRE) |>
  summarise(max)
#Plotting rain, temp_min, and temp_max
r <- ggplot(data = df, mapping = aes(x = DateRE, y = Rain, group = 1)) +
  geom_line()
tMAX <- ggplot(data = df, mapping = aes(x = DateRE, y = Temp_MAX, group = 1)) +
  geom_line()
tMIN <- ggplot(data = df, mapping = aes(x = DateRE, y = Temp_MIN, group = 1)) +
  geom_line()
plot_grid(r, tMAX, tMIN)

#Recreating the plots in the paper
FCM_seed <- ggplot(data = df, mapping = aes(x = Seed.Avail, y = Concen)) +
  geom_point()

FCM_minTemp <- ggplot(data = df, mapping = aes(x = Temp_MIN, y = Concen)) +
  geom_point()

FCM_rain <- ggplot(data = df, mapping = aes(x = Rain, y = Concen, na.rm = TRUE)) +
  geom_point() +
  facet_wrap("Season")

FCM_alarm <- ggplot(data = pred, mapping = aes(x = Alarm, y = Concen)) +
  geom_point() +
  facet_wrap("Num.Obs")

#Skew normal dist
skew_normal()

#Model 0


#Food as fixed effects
#Random intercept set to individual ID, +1/indiv id, look at brm documentation
food <- brm(Concen ~ Fruit.Avail + Leaf.Avail + Seed.Avail + (1 | ID), data = df, family = skew_normal())
summary(food)
plot(food)
