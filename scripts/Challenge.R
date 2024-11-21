load("dragons.RData")
dragons$bodyLength2 <- scale(dragons$bodyLength, center = TRUE, scale = TRUE)
mountain.lm <- lm(testScore ~ bodyLength2 + mountainRange, data = dragons)
summary(mountain.lm)

par(mfrow = c(2,2))
plot(mountain.lm)

# Print the confidence interval
conf_95 <- confint(mountain.lm, level=0.95)
conf_99 <- confint(mountain.lm, level=0.99)
conf_99
library(ggplot2)

# Model coefficients and confidence intervals into a data frame
coef_95_data <- data.frame(
  term = names(coef(mountain.lm)),
  estimate = coef(mountain.lm),             # Point estimates from the model
  lower = conf_95[,1],            # Lower bounds of the confidence intervals
  upper = conf_95[,2],
  diff = conf_95[,2] - conf_95[,1])            # Upper bounds of the confidence intervals
coef_95_data

# Model coefficients and confidence intervals into a data frame
coef_99_data <- data.frame(
  term = names(coef(mountain.lm)),
  estimate = coef(mountain.lm),             # Point estimates from the model
  lower = conf_99[,1],            # Lower bounds of the confidence intervals
  upper = conf_99[,2],
  diff = conf_99[,2] - conf_99[,1])            # Upper bounds of the confidence intervals
coef_99_data
# Create the plot

plot_2 <- (ggplot() +
             geom_point(data = coef_99_data, aes(x = term, y = estimate), color = "black", size = 2) +
             geom_errorbar(data = coef_99_data, aes(x = term, ymin = lower, ymax = upper), width = 0.4, color = "red", size = 0.5)+
             geom_text(data = coef_99_data, aes(x = term, y = estimate, label = round(diff, 1), vjust = -0.8, hjust = -0.2), color = "red") +
             geom_point(data = coef_95_data, aes(x = term, y = estimate), color = "black", size = 2) +
             geom_errorbar(data = coef_95_data, aes(x = term, ymin = lower, ymax = upper), width = 0.4, color = "black", size = 0.5)+
             geom_text(data = coef_95_data, aes(x = term, y = estimate, label = round(diff, 1), vjust = 0.8, hjust = -0.2)) +
             theme_minimal() +
             labs(title = "Confidence Intervals for Model Coefficients",
                  x = "Term", 
                  y = "Estimate" ))

ggsave("figures/Diff-int.png", 
       plot = plot_2, 
       width = 10, 
       height = 5)

# Install and load the gridExtra package
install.packages("gridExtra")
library(gridExtra)

