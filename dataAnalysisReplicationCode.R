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

#Create Model 0, uses intercept, time of day, and storage time as fixed effects
M0lm <- lm(Concen ~ time + hrs_prior_extr, data = df)
summary(M0lm)
ci <- confint(M0lm)

library(brms)

# Define your formula for the minimal model (M0)
# Assuming your dependent variable is hormone concentration and you have the covariates time_of_sample, time_from_collection, and time_from_extraction
# Including individual as random intercepts

formula_m0 <- bf(Concen ~ time + hrs_prior_extr + (1|ID))

# Define the prior distribution (default student-t priors and half student-t for random effects SD)
priors <- c(
  prior(student_t(3, 0, 10), class = "b"),  # Priors for fixed effects (beta coefficients)
  prior(student_t(3, 0, 10), class = "Intercept"),  # Prior for the intercept
  prior(student_t(3, 0, 10), class = "sd")  # Half student-t prior for random effects SD (for positive SDs)
)

# Fit the model
fit_m0 <- brm(formula_m0, data = df, family = skew_normal(link = "log"), prior = priors)

# Check the model output
summary(fit_m0)
