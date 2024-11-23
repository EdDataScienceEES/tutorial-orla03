# Tutorial draft
# We begin by taking a look at confidence intervals for a simple trees dataset
# Load packages ----
library(ggplot2)
library(dplyr)
library(ggeffects)

# Loading data
data(trees)

# Section 2 ----
# Build a linear model for trees  
plot(Girth ~ Height, data = trees)
model <- lm(Girth ~ Height, data = trees)
summary(model)
coef(model)

# Plot to check no violation of assumptions
par(mfrow = c(2,2))
plot(model)
# seems okay no clear violation!

# Save  plot to figures folder
png("figures/model_1.png")
par(mfrow = c(2,2))
plot(model)
dev.off()

plot(Girth ~ Height, data = trees, pch = 16)
abline(model)

# Save  plot to figures folder
png("figures/model_2.png")
plot(Girth ~ Height, data = trees)
abline(model)
dev.off()

# 2.2 ----
# We will now find Confidence intervals for our model.
model <- lm(Girth ~ Height, data = trees)

# Print model summary
(sum_m <- summary(model))

# We extract the models coefficients from the estimates in our summary 
model_est <- coef(model)
# We extract the standard errors
model_se <- sum_m$coefficients[, 2]  # the use of 2 takes us to the coeffecients then the 2nd column

# We now find our sample size
sample <- length(trees$Girth)

# Find df
degrees_freedom <- sample - 2 
degrees_freedom

# Calculate t-score for 95% confidence interval
# We use the qt function here
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

# 3 ----
# Model coefficients and confidence intervals into a data frame
coef_data <- data.frame(
  term = names(model_est),
  estimate = model_est,             # Point estimates from the model
  lower = lower_bounds,            # Lower bounds of the confidence intervals
  upper = upper_bounds            # Upper bounds of the confidence intervals
)

coef_data
# 95% conf intervals!!
(conf_int <- (ggplot(data = coef_data) +
  geom_point(aes(x = term, y = estimate), color = "deeppink", size = 2) +
  geom_errorbar(aes(x = term, ymin = lower, ymax = upper),  # add errorbar of intervals
                width = 0.4, color = "black", size = 0.5)+
  geom_text(aes(x = term, y = lower, label = lower,  vjust = 1)) +
  geom_text(aes(x = term, y = upper, label = upper,  vjust = -1)) + # add text to plot
  theme_minimal() +
    theme_bw() +
  labs(title = "Confidence Intervals for Model Coefficients",
       x = "Term", 
       y = "Estimate")))

ggsave("figures/Conf-Int.png", 
       plot = conf_int, 
       width = 10, 
       height = 5)


# Extract the prediction data frame
pred_m <- ggpredict(model, terms = c("Height"))  # this gives overall predictions for the Height
pred_m
print(pred_m, n=Inf)
# Plot the predictions 

conf_2 <- (ggplot() +
  geom_point(data = trees, aes(x = Height, y = Girth), color = "darkgreen") +
  geom_line(data = pred_m, aes(x = x, y = predicted), color = "red") +
  geom_ribbon(data = pred_m, aes(x = x, ymin = conf.low, ymax = conf.high), 
              fill = "lightgrey", alpha = 0.5) + # add the 95% confidence intervals 
  theme_minimal() +
    theme_bw() +
  labs(x = "Height", y = "Tree Girth", 
       title = "Tree girth is increasing with height")  )

ggsave("figures/Conf-Int-2.png", 
       plot = conf_2, 
       width = 10, 
       height = 5)

# 95% conf intervals!!
conf_3 <- (ggplot(data = pred_m) +
  geom_point(aes(x = x, y = predicted), color = "red", size = 2) + # plot predictions as points
  geom_errorbar(aes(x = x, ymin = conf.low, ymax = conf.high), # plot the upper and lower conf intervals
                width = 0.4, color = "black", size = 0.5)+
  geom_text(aes(x = x, y = conf.low, 
                label = round(conf.low, 1),  vjust = 1)) + # round to one decimal place and vertically adjust
  geom_text(aes(x = x, y = conf.high, 
                label = round(conf.high, 1),  vjust = -1)) +
  theme_minimal() +
  labs(title = "Confidence Intervals for Model Coefficients",
       x = "Height", 
       y = "Prediction"))

ggsave("figures/Conf-Int-3.png", 
       plot = conf_3, 
       width = 10, 
       height = 5)


#create data frame with five new values for height
new_height <- data.frame(Height= c(90, 100, 110, 120, 130))
new_height

#use the fitted model to predict the value for Girth based on the three new values
#for height
predict(model, newdata = new_height)
# example: For a tree with tree height of 90, the predicted tree girth is 16.76 

# create the prediction intervals
predictions <- predict(model, newdata = new_height, interval = "predict", level = 0.95)
predictions
# 95% prediction interval for Tree girth with a height of 90 is 10.58 to 22.93

# level has a default at 95%
# create combined data frame
comb <- new_height %>%
  mutate(fit = predictions[, "fit"],      # add the fit column
    lwr = predictions[, "lwr"],    # add the lwr column
    upr = predictions[, "upr"])     # add upr column
  
comb

(pred_int <- (ggplot(data = comb) +
                geom_point(aes(x = Height, y = fit), color = "deeppink", size = 2) +
                geom_errorbar(aes(x = Height, ymin = lwr, ymax = upr), width = 0.4, color = "black", size = 0.5)+
                geom_text(aes(x = Height, y = lwr, label = round(lwr, 1),  vjust = 1)) +
                geom_text(aes(x = Height, y = upr, label = round(upr, 1),  vjust = -1)) +
                ylim(0, 40) + 
                xlim(80,140) + # added scale limits
                theme_minimal() +
                theme_bw() +
                labs(title = "Prediction Intervals for New Heights",
                     x = "Height", 
                     y = "Predicted Tree Girth")))

ggsave("figures/Prediction-int.png", 
       plot = pred_int, 
       width = 10, 
       height = 5)

# Plot the prediction intervals 

predictions <- predict(model, newdata = trees, interval = "predict", level = 0.95)

#create dataset that contains original data along with prediction intervals
combined <- trees %>%
  mutate(fit = predictions[, "fit"],      # add the fit column
         lwr = predictions[, "lwr"],    # add the lwr column
         upr = predictions[, "upr"])     # add upr column
  

(predict_plot <- (ggplot(combined, aes(x = Height, 
                     y = Girth)) + #define x and y axis variables
  geom_point() + #add raw data points
  stat_smooth(method = lm) + # Confidence intervals 
  geom_line(aes(y = lwr), col = "red", linetype = "dashed") + #lower prediction interval
  geom_line(aes(y = upr), col = "red", linetype = "dashed")) + #upper prediction interval
  theme_minimal())

ggsave("figures/Prediction-plot.png", 
       plot = predict_plot, 
       width = 10, 
       height = 5)





