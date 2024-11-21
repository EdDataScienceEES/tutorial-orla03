# Tutorial script
# Orla Brown, s2201059
# 

# Load packages ----
library(ggplot2)

# Loading data
data(trees)


# Make a plot of points then add prediction intervals 
plot(Girth ~ Height, data = trees, pch = 16)

# testing the correlation between girth and height
model <- lm(Girth ~ Height, data = trees)
summary(model)
coef(model)
plot(Girth ~ Height, data = trees, pch = 16)
abline(model)
model

conf <- confint(model)
conf
library(ggplot2)

# Convert conf_intervals into a data frame
conf_df <- data.frame(
  term = rownames(conf),
  estimate = model$coeff,
  lower = conf[, 1],
  upper = conf[, 2]
)

# Plot using ggplot2
ggplot(model, aes(x = Height, y = Girth)) +
  geom_point() +
geom_ribbon(conf_df, aes( ymin = lower, ymax = upper) )+
  theme_minimal() +
  labs(title = "Confidence Intervals for Model Coefficients",
       x = "Model Coefficients", y = "Confidence Interval")
?geom_line
mean_girth <- mean(trees$Girth)
ggplot(data = trees, aes(x = Girth)) +
  geom_histogram(binwidth = 0.5,
                 fill = "blue", color = "black") +
  geom_vline(xintercept = mean_girth, 
             color = "red", linetype = "dashed") +
  

hist(trees$Girth)

# Fit the linear model
model <- lm(Girth ~ Height, data = trees)

# Get the predicted values and the confidence intervals
new_data <- data.frame(Height = seq(min(trees$Height), max(trees$Height), length.out = 100))
predictions <- predict(model, new_data, interval = "confidence")

# Convert predictions to a data frame
pred_df <- data.frame(
  Height = new_data$Height,
  fit = predictions[, 1],        # Predicted values (fitted line)
  lower = predictions[, 2],      # Lower bound of the confidence interval
  upper = predictions[, 3]       # Upper bound of the confidence interval
)

# Plot the data
library(ggplot2)

ggplot(trees, aes(x = Height, y = Girth)) +
  geom_point(color = "blue") +  # Scatter plot of the original data
  geom_smooth(method = "lm", color = "red", linetype = "dashed", se = FALSE) +  # Fitted regression line
  geom_ribbon(data = pred_df, aes(x = Height, ymin = lower, ymax = upper), 
              fill = "gray80", alpha = 0.5) +  # Confidence interval ribbon
  ggtitle("Girth vs. Height with 95% Confidence Interval") +
  xlab("Height") + ylab("Girth")

ggplot(trees, aes(x = Height, y = Girth)) +
  geom_point(color = "blue") +  # Scatter plot of the original data
  geom_smooth(method = "lm", color = "red", linetype = "dashed", se = FALSE) +  # Fitted regression line
  geom_ribbon(data = pred_df, aes(x = Height, ymin = lower, ymax = upper), 
              fill = "gray80", alpha = 0.5) +  # Confidence interval ribbon
  ggtitle("Girth vs. Height with 95% Confidence Interval") +
  xlab("Height") + ylab("Girth")


ggplot() + 
  # Scatter plot of the original data
  geom_point(data = trees, aes(x = Height, y = Girth), color = "blue") + 
  
  # Fitted regression line (without confidence intervals)
  geom_smooth(data = trees, aes(x = Height, y = Girth), method = "lm", color = "red", linetype = "dashed", se = FALSE) +
  
  # Confidence interval ribbon (using pred_df, which has predictions and their CI)
  geom_ribbon(data = pred_df, aes(x = Height, ymin = lower, ymax = upper), fill = "gray80", alpha = 0.5) + 
  
  ggtitle("Girth vs. Height with 95% Confidence Interval") +
  xlab("Height") + ylab("Girth")
