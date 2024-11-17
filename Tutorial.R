# Tutorial draft
# We begin by taking a look at confidence intervals for a simple trees dataset
# Load packages ----
library(ggplot2)

# Loading data
data(trees)

# Build a linear model for trees  
plot(Girth ~ Height, data = trees, pch = 16)
model <- lm(Girth ~ Height, data = trees)
summary(model)
coef(model)

# Plot to check no violation of assumptions
par(mfrow = c(2,2))
plot(model)
# seems okay no clear violation!

plot(Girth ~ Height, data = trees, pch = 16)
abline(model)




# We will now find Confidence intervals for our model.
# R has a built in function to find confidence intervals, however we will manually find these intervals and then test against the function
# We need an understanding of how to find the mean, standard error, t-score, and margins of error
model <- lm(Girth ~ Height, data = trees)

# Learning how to construct a confidence interval in essential in ecology, as we often need to fully understand how to analyse a confidence interval.
# We will print the summary of our model then extract the relevant information
(sum_m <- summary(model))

# We extract the models coeeficients from the estimates in our summary 
model_est <- coef(model)
# We extract the standard errors
model_se <- sum_m$coefficients[, 2]  # the use of 2 takes us to the coeffecients then the 2nd column

# We now find our sample size
sample <- length(trees$Girth)

# We now find the degrees of freedom
# In a simple linear regression model with one predictor variable, 
# the degrees of freedom is calculated as n – 2, where n is the total number of observations.

degrees_freedom <- sample - 2 
degrees_freedom

# Calculate t-score for 95% confidence interval
# We use the qt function here!
alpha <- 0.05 # alpha is 0.05 for a 95% conf interval
score <- qt(p = alpha / 2, df = degrees_freedom, lower.tail = FALSE)

# Calculate margin of error for the coefficients
margin <- score * model_se

# Calculate the confidence intervals (lower and upper bounds)
lower_bounds <- model_est - margin
upper_bounds <- model_est + margin

# Print the confidence intervals
print(cbind(lower_bounds, upper_bounds))


# Compare to the built in r function!
confint(model, level=0.95)

# We will now learn to plot confidence intervals in R!

library(ggplot2)

# Model coefficients and confidence intervals into a data frame
coef_data <- data.frame(
  term = c("Intercept", "Height"),
  estimate = c(-6.0015820, 0.09589546),  # The point estimates of the coefficients
  lower = c(-18.37837106, 0.09589546),  # Lower bounds of the confidence intervals
  upper = c(6.0015820, 0.4155988)       # Upper bounds of the confidence intervals
)
coef_data
# Create the plot

# 95% conf intervals!!
ggplot(data = coef_data) +
  geom_point(aes(x = term, y = estimate), color = "deeppink", size = 2) +
  geom_errorbar(aes(x = term, ymin = lower, ymax = upper), width = 0.4, color = "black", size = 0.5)+
  geom_text(aes(x = term, y = lower, label = lower,  vjust = 1)) +
  geom_text(aes(x = term, y = upper, label = upper,  vjust = -1)) +
  theme_minimal() +
  labs(title = "Confidence Intervals for Model Coefficients",
       x = "Term", 
       y = "Estimate")
  
  



library(ggeffects)  # install the package first if you haven't already, then load it

# Extract the prediction data frame
pred.m <- ggpredict(model, terms = c("Height"))  # this gives overall predictions for the model
pred.m
# Plot the predictions 

(ggplot(pred.m) + 
    geom_line(aes(x = x, y = predicted)) +          # slope
    geom_ribbon(aes(x = x, ymin = predicted - std.error, ymax = predicted + std.error), 
                fill = "lightgrey", alpha = 0.5) +  # error band
    geom_point(data = trees,                      # adding the raw data (scaled values)
               aes(x = Height, y = Girth)) + 
    labs(x = "Height", y = "Girth", 
         title = "Linear Model") + 
    theme_minimal()
)
