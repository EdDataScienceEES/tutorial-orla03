# Workflow
#1. Load and read the data
#2. Build a simple linear model which helps estimate the difference in test scores.
#3. Check the 3 assumptions are not violated.
#4. Create dataframes of each confidence interval.
#5. Use visualisation techniques to answer the question.

# Load libraries
library(ggplot2)

# Load and read the data
load("data/dragons.RData")
dragons$bodyLength2 <- scale(dragons$bodyLength, center = TRUE, scale = TRUE)

# Build a simple linear model which helps estimate the difference in test scores.
mountain.lm <- lm(testScore ~ bodyLength2 + mountainRange, data = dragons)
summary(mountain.lm)

#Check the 3 assumptions are not violated.
par(mfrow = c(2,2))
plot(mountain.lm)

# Print the confidence interval
conf_95 <- confint(mountain.lm, level=0.95)
conf_99 <- confint(mountain.lm, level=0.99)


# Model coefficients and confidence intervals into a data frame
coef_95_data <- data.frame(
  term = names(coef(mountain.lm)),
  estimate = coef(mountain.lm),             # Point estimates from the model
  lower = conf_95[,1],            # Lower bounds of the confidence intervals
  upper = conf_95[,2], # Upper bounds of the confidence intervals
  diff = conf_95[,2] - conf_95[,1]) # Difference between the bounds     

# Model coefficients and confidence intervals into a data frame
coef_99_data <- data.frame(
  term = names(coef(mountain.lm)),
  estimate = coef(mountain.lm),             # Point estimates from the model
  lower = conf_99[,1],            # Lower bounds of the confidence intervals
  upper = conf_99[,2], # Upper bounds of the confidence intervals
  diff = conf_99[,2] - conf_99[,1])            

# Create the plot
# Use visualisation techniques to answer the question
plot_diff <- (ggplot() +
             geom_point(data = coef_99_data, aes(x = term, y = estimate), 
                        color = "black", size = 2) +
             geom_errorbar(data = coef_99_data, aes(x = term, ymin = lower, ymax = upper), 
                           width = 0.4, color = "red", linewidth = 0.5)+
             geom_text(data = coef_99_data, aes(x = term, y = estimate, label = round(diff, 1), # Plot the 99% CI
                                                vjust = -0.8, hjust = -0.2), color = "red") +
             geom_point(data = coef_95_data, aes(x = term, y = estimate), 
                        color = "black", size = 2) +
             geom_errorbar(data = coef_95_data, aes(x = term, ymin = lower, ymax = upper), 
                           width = 0.4, color = "black", linewidth = 0.5)+
             geom_text(data = coef_95_data, aes(x = term, y = estimate, label = round(diff, 1), # Plot the 95% CI
                                                vjust = 0.8, hjust = -0.2)) +
             theme_minimal() +
             theme_bw() +
             theme(axis.text.x = element_text(angle = 45, hjust = 1)) + # angle the labels on x axis for readability
             labs(title = "Confidence Intervals for Model Coefficients",
                  x = "Term", 
                  y = "Estimate" ))
plot_diff

ggsave("figures/Diff-int.png", 
       plot = plot_diff, 
       width = 10, 
       height = 5)

