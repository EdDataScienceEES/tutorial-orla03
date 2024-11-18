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
  
# Have a think, what kind of confidence intervals do we want?
# Narrow confidence intervals show more precision within a model.



library(ggeffects)  # install the package first if you haven't already, then load it

# We have seen how to model the coefficients and the confidence intervals, what about the data we predict?
# Often when working with data in ecology, we want to predict what our future model might look like
# So far, we have plotted confidence intervals for the model parameters - the intercept and slope
# You might be thinking but what about future predictions?
# Good question, lets find out!!

# R has a prediction function within the `ggeffects` package. We can find confidence levels in future predictions.

# Extract the prediction data frame
pred_m <- ggpredict(model, terms = c("Height"))  # this gives overall predictions for the Height
pred_m
print(pred_m, n=Inf)
# Plot the predictions 

ggplot() +
  geom_point(data = trees, aes(x = Height, y = Girth), color = "darkgreen") +
  geom_line(data = pred_m, aes(x = x, y = predicted), color = "red") +
  geom_ribbon(data = pred_m, aes(x = x, ymin = conf.low, ymax = conf.high), 
              fill = "lightgrey", alpha = 0.5) + # add the 95% confidence intervals 
  theme_minimal() +
  labs(x = "Height", y = "Tree Girth", 
       title = "Tree girth is increasing with height")  

# 95% conf intervals!!
ggplot(data = pred_m) +
  geom_point(aes(x = x, y = predicted), color = "red", size = 2) +
  geom_errorbar(aes(x = x, ymin = conf.low, ymax = conf.high), width = 0.4, color = "black", size = 0.5)+
  geom_text(aes(x = x, y = conf.low, label = round(conf.low, 1),  vjust = 1)) +
  geom_text(aes(x = x, y = conf.high, label = round(conf.high, 1),  vjust = -1)) +
  theme_minimal() +
  labs(title = "Confidence Intervals for Model Coefficients",
       x = "Height", 
       y = "Prediction")


# We notice that we have little data points within the `tree` data, hence, we might want to work with a larger
# data set for more accurate results.

(ggplot(pred_m) + 
    geom_line(aes(x = x, y = predicted), color = "red") +  # slope
    geom_ribbon(aes(x = x, ymin = predicted - std.error, ymax = predicted + std.error), 
                fill = "lightgrey", alpha = 0.5) +  # add the error band
    geom_point(data = trees,                      # adding the raw data 
               aes(x = Height, y = Girth), color = "darkgreen") + 
    labs(x = "Height", y = "Tree Girth", 
         title = "Tree girth is increasing with height") + 
    theme_minimal()
)

# We may now ask but what is the difference between a confidence interval and a prediction interval?
# Good question, lets find out!

# A prediction interval is less certain than a confidence interval. 
# A prediction interval predicts an individual number, whereas a confidence interval predicts the mean value

#create data frame with three new values for heigh
new_height <- data.frame(Height= c(90, 100, 110))

#use the fitted model to predict the value for Girth based on the three new values
#for height
predict(model, newdata = new_height)
# example: For a tree with tree height of 90, the predicted tree girth is 16.76 

# create the prediction intervals
predict(model, newdata = new_height, interval = "predict", level = 0.95)
# 95% prediction interval for Tree girth with a height of 90 is 10.58 to 22.93
# level has a default at 95%

# Plot the prediction intervals 
# use model to create prediction intervals
predictions <- predict(model, newdata = trees, interval = "predict", level = 0.95)

#create dataset that contains original data along with prediction intervals
combined <- cbind(data, predictions) # Add new column to combined

ggplot(combined, aes(x = Height, 
                     y = Girth)) + #define x and y axis variables
  geom_point() + #add raw data points
  stat_smooth(method = lm) + # Confidence intervals 
  geom_line(aes(y = lwr), col = "red", linetype = "dashed") + #lower prediction interval
  geom_line(aes(y = upr), col = "red", linetype = "dashed") #upper prediction interval

# What do we expect when we move to a 99% prediction interval?


