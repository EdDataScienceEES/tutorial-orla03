# Intro to Confidence Intervals in R

<center><img src="{{ site.baseurl }}/images/conf.png" alt="Img" width="250"></center>

### Tutorial Aims

#### <a href="#section1"> 1. Introduction </a>
##### <a href="#section1.1"> 1.1 Prerequisites </a>

#### <a href="#section2"> 2. Learn how to use linear models and find their confidence intervals.</a>

#### <a href="#section3"> 3. Learn how to plot the confidence intervals and compare these.</a>

Often in data science we want to predict where the data might fall. A confidence interval gives us a range of plausible values in which our true value might lie; this is essential in ecologicial data science and often used to assess the importance of true effects!

If you are interested in how to find confidence intervals in R and how to plot these results to better visualise where the true value might lie, this is the tutorial for you!

---------------------------

## Prerequisites

This tutorial is suitable for beginner data scientists, seeking to find out about statistical analysis via confidence intervals. Prior to attempting this tutorial, you should have a basic knowledge of statistical methods and constructing linear models. Being able to construct linear models, analyse plots and interpret graphs will prove beneficial throughout this tutorial.

Having an understanding of how to efficiently lay out your code and maintain a well commented script will prove beneficial to gauge a better understanding of the skills required for this tutorial. Please ensure you have completed the following tutorials prior to this tutorial, as this will enhance your understanding of the concepts underlining confidence and predictions within a model! 

The following tutorials may be useful:
#### <a href="https://ourcodingclub.github.io/tutorials/intro-to-r/"> 1. Getting Started with R </a>
#### <a href="https://ourcodingclub.github.io/tutorials/model-design/"> 2. Intro to Model Design</a>
#### <a href="https://ourcodingclub.github.io/tutorials/etiquette/"> 3. Coding Etiquette</a>

You can get all of the resources for this tutorial from <a href="https://github.com/EdDataScienceEES/tutorial-orla03" target="_blank">this GitHub repository</a>. Clone and download the repo as a zip file, then unzip it.

Having a basic understanding of `ggplot2` will be super beneficial. However, do not worry if you are only a beginner with R language, we will address each step as we make our way through this tutorial.

<a name="section1"></a>

## 1. Introduction to Confidence Intervals

## Why do we want to find confidence intervals?

Confidence intervals often help data scientists make informed decisions based on the data we are working with, this allows deeper understanding of their next steps and why data has been modelled in a specific way. 

## How do we begin our approach to finding a suitable confidence interval?

We want to first find a linear model suitable to the research question we are addressing. 

The data we will be using to begin with is a dataset built into the `ggplot2` library in R.
Let's load the package and get a basic understanding of the data.

```r
# Load package
library(ggplot2)

# If you don't have the package installed already, do so by uncommenting the code below
# install.packages("ggplot2")
# This line of code is essential for installing any packages you don't have already!

# Loading data
data(trees)
# Note: the data will now appear as `trees` in your R Studio environment.
```

We will now begin through this tutorial.

<a name="section2"></a>

## 2. Learning how to use linear models and find their confidence intervals.

We will begin by constructing a simple linear model for the `trees` data and subsequently 
constructing relevant confidence intervals. Our aim here is to investigate the correlation between tree girth and tree height. 

Before we begin, recall that a simple linear model is built via the response variable being predicted by the predictor.

```r
# Constuct a simple linear model 
model <- lm(Girth ~ Height, data = trees) 
```

Recall from our previous tutorial, we must check there are no violation of the assumptions;
we essentially require constant variance (homoscedasticity), normally distributed residuals and independent variables.


```r
# Plot to check no violation of assumptions
par(mfrow = c(2,2)) # plots the four plots on one panel
plot(model)
# seems okay no clear violation!
```

<center> <img src="{{ site.baseurl }}/figures/model_1.png" alt="Img" style="width: 800px;"/> </center>

We can see from the top left plot, the residuals seem quite evenly distributed either side of the line.
The QQ-plot shows us that the residuals follow the shape of a normal distribution but could be improved.
The scale-location plot shows signs of linearity.

For the purpose of this tutorial, we are not focussing on improving our linear model. Note that this model is not perfect and could be improved!
head to the following tutorial for a thorough guide on how to improve this basic model. 

#### <a href="https://ourcodingclub.github.io/tutorials/model-design/"> Intro to Model Design</a>

Continuing on we will analyse the models summary. In r it is ALWAYS a good idea to have a look at the summary to evaluate linear models.

```r
summary(model) # Print the summary of our model
```

We will begin by gaining a basic understanding of why the summary is useful for later in the tutorial. 
The red box shows the model estimates for each coefficient; in our case these are the intercept and Height. Followed by the purple box showing the models standard errors.
Finally the blue shows the degrees of freedom for our linear model. 

### What are degrees of freedom?

These are the number of independent variables that can vary. For example, in our data set we have 31 observations but 2 independent variables in our model, hence $31 - 2 = 29$ df.
This will prove beneficial in constructing confidence intervals later.

Final note: the Adjusted R-squared is significantly low for our model at 0.2445. This means only 24% of the data is accounted for by this model. Not ideal!

We can now plot the linear model as follows.

```r
plot(Girth ~ Height, data = trees)
abline(model)

```
<center> <img src="{{ site.baseurl }}/figures/model_2.png" alt="Img" style="width: 800px;"/> </center>


We will now find Confidence intervals for our model.
R has a built in function to find confidence intervals, however we will manually find these intervals and then test against the function
We need an understanding of how to find the mean, standard error, t-score, and margins of error

Learning how to construct a confidence interval in essential in ecology, as we often need to fully understand how to analyse a confidence interval.

```r
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

# Combine the lower and upper bounds
combined_bounds <- cbind(lower_bounds, upper_bounds)

# Print the confidence intervals
print(combined_bounds)

```

We will now check opur values against the built in r function.

```r
# Compare to the built in r function!
confint(model, level=0.95)
```



And finally, plot the data:


At this point it would be a good idea to include an image of what the plot is meant to look like so students can check they've done it right. Replace `IMAGE_NAME.png` with your own image file:

<center> <img src="{{ site.baseurl }}/IMAGE_NAME.png" alt="Img" style="width: 800px;"/> </center>

<a name="section1"></a>

## 3. Learn how to plot the confidence intervals and compare these.

```r
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

```
<center> <img src="{{ site.baseurl }}/figures/Conf-Int.png" alt="Img" style="width: 800px;"/> </center>

Have a think, what kind of confidence intervals do we want?
**show answer 
Narrow confidence intervals show more precision within a model.

We have seen how to model the coefficients and the confidence intervals, what about the data we predict?
Often when working with data in ecology, we want to predict what our future model might look like
So far, we have plotted confidence intervals for the model parameters - the intercept and slope
You might be thinking but what about future predictions?
Good question, lets find out!!

R has a prediction function within the `ggeffects` package. We can find confidence levels in future predictions.

```r
# Extract the prediction data frame
pred_m <- ggpredict(model, terms = c("Height"))  # this gives overall predictions for the Height
```

```r
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
```
<center> <img src="{{ site.baseurl }}/figures/Conf-Int-2.png" alt="Img" style="width: 800px;"/> </center>

We may now ask but what is the difference between a confidence interval and a prediction interval?
Good question, lets find out!
A prediction interval is less certain than a confidence interval. 
A prediction interval predicts an individual number, whereas a confidence interval predicts the mean value


```r
#create data frame with three new values for height
new_height <- data.frame(Height= c(90, 100, 110))

#use the fitted model to predict the value for Girth based on the three new values
#for height
predict(model, newdata = new_height)
# example: For a tree with tree height of 90, the predicted tree girth is 16.76 
```

```r
# create the prediction intervals
predict(model, newdata = new_height, interval = "predict", level = 0.95)
# 95% prediction interval for Tree girth with a height of 90 is 10.58 to 22.93
# level has a default at 95%

# Plot the prediction intervals 
# use model to create prediction intervals

predictions <- predict(model, newdata = trees, interval = "predict", level = 0.95)

#create dataset that contains original data along with prediction intervals
combined <- cbind(trees, predictions) # Add new column to combined

ggplot(combined, aes(x = Height, 
                     y = Girth)) + #define x and y axis variables
  geom_point() + #add raw data points
  stat_smooth(method = lm) + # Confidence intervals 
  geom_line(aes(y = lwr), col = "red", linetype = "dashed") + #lower prediction interval
  geom_line(aes(y = upr), col = "red", linetype = "dashed") #upper prediction interval

```

<center> <img src="{{ site.baseurl }}/figures/Prediction-plot.png" alt="Img" style="width: 800px;"/> </center>

What do we expect when we move to a 99% prediction interval?


This is the end of the tutorial. Summarise what the student has learned, possibly even with a list of learning outcomes. In this tutorial we learned:

##### - how to construct a simple linear model and find the subsequent confidence intervals
##### - how to construct a confidence interval in R, line by line
##### - how to plot regressions and confidence intervals in ggplot2
##### - the difference between confidence and prediction intervals

We can also provide some useful links, include a contact form and a way to send feedback.

For more on `ggplot2`, read the official <a href="https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf" target="_blank">ggplot2 cheatsheet</a>.

Everything below this is footer material - text and links that appears at the end of all of your tutorials.

<hr>
<hr>

#### Check out our <a href="https://ourcodingclub.github.io/links/" target="_blank">Useful links</a> page where you can find loads of guides and cheatsheets.

#### If you have any questions about completing this tutorial, please contact us on ourcodingclub@gmail.com

#### <a href="INSERT_SURVEY_LINK" target="_blank">We would love to hear your feedback on the tutorial, whether you did it in the classroom or online!</a>

<ul class="social-icons">
	<li>
		<h3>
			<a href="https://twitter.com/our_codingclub" target="_blank">&nbsp;Follow our coding adventures on Twitter! <i class="fa fa-twitter"></i></a>
		</h3>
	</li>
</ul>

### &nbsp;&nbsp;Subscribe to our mailing list:
<div class="container">
	<div class="block">
        <!-- subscribe form start -->
		<div class="form-group">
			<form action="https://getsimpleform.com/messages?form_api_token=de1ba2f2f947822946fb6e835437ec78" method="post">
			<div class="form-group">
				<input type='text' class="form-control" name='Email' placeholder="Email" required/>
			</div>
			<div>
                        	<button class="btn btn-default" type='submit'>Subscribe</button>
                    	</div>
                	</form>
		</div>
	</div>
</div>
