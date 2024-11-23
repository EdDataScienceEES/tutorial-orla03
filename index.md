# Intro to Confidence Intervals in R

<center><img src="{{ site.baseurl }}/images/conf.png" alt="Img" style="width: 100%; height: auto;"/></center>

### Tutorial Aims

1. To be able to find confidence intervals corresponding to a simple linear model.
2. To be able to predict estimates and their corresponding prediction intervals.
3. To be able to understand the difference between confidence intervals and prediction intervals.
4. To be able to use visualisation techniques to interpret the intervals.

### Learning Outcome

I can find confidence intervals and visualise these using `ggplot2`. Further to this, 
I can then analyse how widths change depending on significance levels.


#### <a href="#section1"> 1. Introduction </a>
##### <a href="#section1.1"> 1.1 Prerequisites </a>
##### <a href="#section1.2"> 1.2 Understanding Confidence Intervals </a>
##### <a href="#section1.3"> 1.3 Introducing the Data </a>

#### <a href="#section2"> 2. Build a Linear Model </a>
##### <a href="#section2"> 2.1 Construct a confidence Interval </a>

#### <a href="#section3"> 3. Learn how to plot the confidence intervals and compare these.</a>

#### <a href="#section4"> 4. Challenge Yourself!! </a>


<a name="section1"></a>

Often in data science we want to predict where the data might fall. A confidence interval gives us a range of plausible values in which our true value might lie; this is essential in ecologicial data science and often used to assess the importance of true effects!

If you are interested in how to find confidence intervals in R and how to plot these results to better visualise where the true value might lie, this is the tutorial for you!

---------------------------
<a name="section1.1"></a>

## 1.1 Prerequisites

This tutorial is suitable for beginner data scientists, seeking to find out about statistical analysis via confidence intervals. Prior to attempting this tutorial, you should have a basic knowledge of statistical methods and constructing linear models. Being able to construct linear models, analyse plots and interpret graphs will prove beneficial throughout this tutorial.

Having an understanding of how to efficiently lay out your code and maintain a well commented script will prove beneficial to gauge a better understanding of the skills required for this tutorial. Please ensure you have completed the following tutorials prior to this tutorial, as this will enhance your understanding of the concepts underlining confidence and predictions within a model! 

The following tutorials may be useful:
#### <a href="https://ourcodingclub.github.io/tutorials/intro-to-r/"> 1. Getting Started with R </a>
#### <a href="https://ourcodingclub.github.io/tutorials/model-design/"> 2. Intro to Model Design</a>
#### <a href="https://ourcodingclub.github.io/tutorials/etiquette/"> 3. Coding Etiquette</a>

You can get all of the resources for this tutorial from <a href="https://github.com/EdDataScienceEES/tutorial-orla03" target="_blank">this GitHub repository</a>. Clone and download the repo as a zip file, then unzip it.

Having a basic understanding of `ggplot2` will be super beneficial. However, do not worry if you are only a beginner with R language, we will address each step as we make our way through this tutorial.

<a name="section1.2"></a>

## 1.2 Understanding Confidence Intervals

## Why do we want to find confidence intervals?

Confidence intervals often help data scientists make informed decisions based on the data we are working with, 
this allows deeper understanding of their next steps and why data has been modelled in a specific way. 
Confidence intervals are crucial in ecological and environmental data analysis because they provide a way to assess reliability, support decision-making, and improve the interpretability of  data. 
They help ensure that ecological conclusions are based on an understanding of the data at hand and of the variability and uncertainty inherent in ecological data. We often will not have perfect data and will need to 
analyse the data we are using through data wrangling or such techniques!

## How do we begin our approach to finding a suitable confidence interval?

Within this tutorial we want to first find a linear model suitable to the research question we are addressing. 

<a name="section1.3"></a>

## 1.3 Introducing the Data

The data we will be using to begin with is a `trees` dataset built into the `ggplot2` package in R.
Let's load the package and get a basic understanding of the data.

```r
# Load package
library(ggplot2)
library(dplyr)

# If you don't have the package installed already, do so by uncommenting the code below
# install.packages("ggplot2")
# install.packages("dplyr")
# This line of code is essential for installing any packages you don't have already!

# Loading data
data(trees)
# Note: the data will now appear as `trees` in your R Studio environment.
```
Having a basic understanding of the data is essential prior to any task.

### How many variables does the dataset include, and how many observations?

{% capture reveal %}

The data has 31 observations with 3 different variables: Girth, Height and Volume.

{% endcapture %} 
{% include reveal.html button="Click for the answer" content=reveal %}


We will now begin through this tutorial.

<a name="section2"></a>

<center><img src="{{ site.baseurl }}/images/tree_l.png" alt="Img" style="width: 100%; height: auto;"/></center>

## 2. Learning how to use linear models and finding their confidence intervals

We will begin by constructing a simple linear model for the `trees` data and subsequently 
constructing relevant confidence intervals. 
Our aim here is to investigate the correlation between tree `girth` and tree `height`. 

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

<center> <img src="{{ site.baseurl }}/figures/model_1.png" alt="Img" style="width: 500px;"/> </center>

We can see from the top left plot, the residuals seem quite evenly distributed either side of the line.
The QQ-plot shows us that the residuals follow the shape of a normal distribution but could be improved.
The scale-location plot shows signs of linearity. This generally happens in the field of data science, often data is unpredictable and models can struggle to be very well fitted.

For the purpose of this tutorial, we are not focussing on improving our linear model. Note that this model is not perfect and could be improved!
Head to the following tutorial for a thorough guide on how to improve this basic model.
###### <a href="https://ourcodingclub.github.io/tutorials/model-design/"> Intro to Model Design</a>

Continuing on we will analyse the models summary. In r it is **always** a good idea to have a look at the summary to evaluate linear models.

```r
summary(model) # Print the summary of our model
```
<center> <img src="{{ site.baseurl }}/images/summary.jpeg" alt="Img" style="width: 500px;"/> </center>


We will begin by gaining a basic understanding of why the summary is useful for later in the tutorial. 
The red box shows the model estimates for each coefficient; in our case these are the intercept and Height. Followed by the purple box showing the models standard errors.
Finally the blue shows the degrees of freedom for our linear model. 

**What are degrees of freedom?**

These are the number of independent variables that can vary. For example, in our data set we have 31 observations but 2 independent variables in our model, hence 31 - 2 = 29 df.
This will prove beneficial in constructing confidence intervals later.

Final note: the Adjusted R-squared is significantly low for our model at 0.2445. This means only 24% of the data is accounted for by this model. Not ideal!

We can now plot the linear model as follows.

```r
plot(Girth ~ Height, data = trees)
abline(model)
```
<center> <img src="{{ site.baseurl }}/figures/model_2.png" alt="Img" style="width: 500px;"/> </center>

The model shows the raw data points with a consistent increase in tree girth with height.

<a name="section2.1"></a>

## 2.2 Construct a Confidence Interval 

We will now find Confidence intervals for our model. R has a built in function to find confidence intervals, however we will manually find these intervals and then test against the function.
Within data science we generally need an understanding of how to find the mean, standard error, t-score, and margins of error, this step-by-step solution is just the beginning of your statistical analysis!

Learning how to construct a confidence interval in essential in ecology, as we often need to fully understand how to analyse a confidence interval, building these together will give you a thorough understanding of the code R undertakes.

```r
# We will print the summary of our model then extract the relevant information
(sum_m <- summary(model))
# remember if we put brackets around the line of code, the results will be printed, otherwise
# we call call the function by printing the name!

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
```
Correct! The degrees of freedom match our summary!

We will now introduce significance levels; these are highly important and coherent with the level chosen as alpha. 
For example, when computing a 95% confidence interval, this suggests our value of alpha will be 5% and the associated
confidence interval output will give us a numerical value for the data at 2.5% and 97.5%, this is known as a two-sided confidence interval.
In ecology, we often use a two-sided confidence interval rather than a one-sided confidence interval as we generally want
an upper and a lower bound, this has less limitations.

Don't worry too much here, R has a default of 95% level.

We will understand mathematically the formula for a Confidence Interval, this will help with construction in R.

<center> <img src="{{ site.baseurl }}/images/CI.jpeg" alt="Img" style="width: 500px;"/> </center>

```r
# Calculate t-score for 95% confidence interval
# We use the qt function here, this is a form of testine method for our model!
alpha <- 0.05 # alpha is 0.05 for a 95% conf interval
score <- qt(p = alpha / 2, df = degrees_freedom, lower.tail = FALSE)

# Calculate margin of error for the coefficients
margin <- score * model_se # this stems from the equation above.

# Calculate the confidence intervals 
lower_bounds <- model_est - margin # lower bound
upper_bounds <- model_est + margin # upper bound

# Combine the lower and upper bounds
combined_bounds <- cbind(lower_bounds, upper_bounds)

# Print the confidence intervals
print(combined_bounds)

```

<center> <img src="{{ site.baseurl }}/images/bounds.png" alt="Img" style="width: 500px;"/> </center>

This shows us the lower bound at 2.5% and upper bound and 97.5% (because alpha is 5%!) corresponding to both the intercept and the height.

We will now check our values against the built in r function.

```r
# Compare to the built in r function!
confint(model, level=0.95)
```

Success!! These numbers match, this gives us an idea of the way these intervals can be interpreted. It can often
be useful to use the`confint` function for plotting or checking our analysis, but often in data science we need to understand how these numbers are calculated.
For example, using error margins and finding the t-score value proves beneficial depending on the analysis conducted, this is embedded in the `confint` function,
but being able to extract these by manually finding the interval as we have above is a useful skill!

<a name="section3"></a>

## 3. Learn how to plot the confidence intervals and compare these

Simply finding these intervals helps with analysis, but as data scientists we want to be able to visualise our data!

Lets plot the intervals.

```r
library(ggplot2)

# Model coefficients and confidence intervals into a data frame
coef_data <- data.frame(
  term = names(model_est),
  estimate = model_est,             # Point estimates from the model
  lower = lower_bounds,            # Lower bounds of the confidence intervals
  upper = upper_bounds)            # Upper bounds of the confidence intervals

# Create the plot
# 95% conf intervals!!
ggplot(data = coef_data) + 
  geom_point(aes(x = term, y = estimate), color = "deeppink", size = 2) + # plot the points
  geom_errorbar(aes(x = term, ymin = lower, ymax = upper), width = 0.4, color = "black", size = 0.5)+ # plot the bars
  geom_text(aes(x = term, y = lower, label = lower,  vjust = 1)) + # add the numeric values onto the plot
  geom_text(aes(x = term, y = upper, label = upper,  vjust = -1)) +
  theme_minimal() +
  labs(title = "Confidence Intervals for Model Coefficients",
       x = "Term", 
       y = "Estimate")

```
<center> <img src="{{ site.baseurl }}/figures/Conf-Int.png" alt="Img" style="width: 800px;"/> </center>

This shows us that the confidence interval for the intercept is much larger than for the Height variable, we would expect this.

### Have a think, what kind of confidence intervals do we want?

{% capture reveal %}

Narrow confidence intervals show more precision within a model since genrerally a narrow confidence interval represents a better model due to more precision in the estimates. 

{% endcapture %} 
{% include reveal.html button="Click for the answer" content=reveal %}


We have seen how to model the coefficients and the confidence intervals, what about the data we predict?
Often when working with data in ecology, we want to predict what our future model might look like.
So far, we have plotted confidence intervals for the model parameters - the intercept and slope.
You might be thinking but what about future predictions?
Good question, lets find out!!

R has a prediction function within the `ggeffects` package. We can find confidence levels in future predictions.

```r
library(ggeffects)
# install.packages("ggeffects") # uncomment this code if you haven't installed the package yet!

# Extract the prediction data frame
pred_m <- ggpredict(model, terms = c("Height"))  # this gives overall predictions for the Height
```
This gives us predictions for the heights we have values corresponding to.

```r
# 95% conf intervals!!
(ggplot() +
  geom_point(data = trees, aes(x = Height, y = Girth), color = "darkgreen") +
  geom_line(data = pred_m, aes(x = x, y = predicted), color = "red") +
  geom_ribbon(data = pred_m, aes(x = x, ymin = conf.low, ymax = conf.high), 
              fill = "lightgrey", alpha = 0.5) + # add the 95% confidence intervals 
  theme_minimal() +
    theme_bw() +
  labs(x = "Height", y = "Tree Girth", 
       title = "Tree girth is increasing with height"))
```
<center> <img src="{{ site.baseurl }}/figures/Conf-Int-2.png" alt="Img" style="width: 800px;"/> </center>

We will now plot the intervals in an alternative way!

```r
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
```
<center> <img src="{{ site.baseurl }}/figures/Conf-Int-3.png" alt="Img" style="width: 800px;"/> </center>

We may now ask but what is the difference between a confidence interval and a prediction interval?
Good question, lets find out!
A prediction interval is less certain than a confidence interval. 
A prediction interval predicts where possible outcomes will lie, whereas a confidence interval predicts where the true mean will lie.

Now we will find predictions for heights that we do not have values for in the `trees` data.

```r
#create data frame with five new values for height
new_height <- data.frame(Height= c(90, 100, 110, 120, 130))

# Use the fitted model to predict the value for Girth based on the three new values for height
predictions <- predict(model, newdata = new_height, interval = "predict", level = 0.95) # newdata is the new data frame

# Combine into a single data frame (using pipes)
comb <- new_height %>%
  mutate(fit = predictions[, "fit"],      # add the fit column
    lwr = predictions[, "lwr"],    # add the lwr column
    upr = predictions[, "upr"])     # add upr column
```

This shows us that for a tree with tree height of 90, the predicted tree girth is 16.76 **put in a table

We can now plot these prediction intervals using the skills we learnt in section 3.

```r
(pred_int <- (ggplot(data = comb) +
                geom_point(aes(x = Height, y = fit), color = "deeppink", size = 2) + # plot the points
                geom_errorbar(aes(x = Height, ymin = lwr, ymax = upr), width = 0.4, color = "black", size = 0.5)+ # point the bars
                geom_text(aes(x = Height, y = lwr, label = round(lwr, 1),  vjust = 1)) +
                geom_text(aes(x = Height, y = upr, label = round(upr, 1),  vjust = -1)) +
                ylim(0, 40) + 
                xlim(80,140) + # added scale limits
                theme_minimal() +
                theme_bw() +
                labs(title = "Prediction Intervals for New Heights",
                     x = "Height", 
                     y = "Predicted Tree Girth")))

```
<center> <img src="{{ site.baseurl }}/figures/Prediction-int.png" alt="Img" style="width: 800px;"/> </center>

Time to notice a few important points!!
The prediction intervals increase in size as the height increases, this is due to the lack of certainty for the model in the predictions it is making.
Recall that a smaller confidence interval generally means more precision, this applies to prediction intervals too!

We will now predict the intervals for our height values from the `trees` dataframe.

```r
# create the prediction intervals
predictions <- predict(model, newdata = trees, interval = "predict", level = 0.95)
# 95% prediction interval for Tree girth with a height of 90 is 10.58 to 22.93

# create dataframe that contains original data along with prediction intervals
combined <- trees %>%
  mutate(fit = predictions[, "fit"],      # add the fit column
         lwr = predictions[, "lwr"],    # add the lwr column
         upr = predictions[, "upr"])  # add upr column

ggplot(combined, aes(x = Height, y = Girth)) + #define x and y variables
  geom_point() + # add raw data points
  stat_smooth(method = lm) + # add the linear model 
  geom_line(aes(y = lwr), col = "red", linetype = "dashed") + # lower prediction interval
  geom_line(aes(y = upr), col = "red", linetype = "dashed")  + # upper prediction interval
  theme_minimal()

```

<center> <img src="{{ site.baseurl }}/figures/Prediction-plot.png" alt="Img" style="width: 800px;"/> </center>

<a name="section4"></a>
## Challenge!!

Well done for following the basic skills of finding these intervals! 

In this section, we will challenge ourselves to plot both 99% confidence and 95% confidence intervals for the `dragons` data.
This gives us an opportunity to analyse how the change in size of interval effects the results.

We want to estimate the difference in test scores between the mountain ranges, have a read through the data before you begin and build a linear model (*hint: use a simple linear model!).
Once you have constructed a model, build the different confidence intervals and visualise the data to answer the question.
This data is included within the data folder <a href="https://github.com/EdDataScienceEES/tutorial-orla03/tree/master/data" target="_blank">here</a> 
- download and load the data before you begin.

#### Questions to think about before we begin!!

**What do we expect when we move to a 99% from a 95% confidence interval?**
**What does a larger confidence interval imply?**

{% capture reveal %}

```r
load("dragons.RData") # load the dragons data
dragons$bodyLength2 <- scale(dragons$bodyLength, center = TRUE, scale = TRUE) # scale the body length
mountain.lm <- lm(testScore ~ bodyLength2 + mountainRange, data = dragons) # construct a linear model

# Check the plots
par(mfrow = c(2,2))
plot(mountain.lm) # no clear violations, plots okay!!

# Create the confidence intervals
conf_95 <- confint(mountain.lm, level=0.95) # 95% remember this is default!
conf_99 <- confint(mountain.lm, level=0.99) # 99% level

# Model coefficients and confidence intervals into a data frame
coef_95_data <- data.frame(
  term = names(coef(mountain.lm)),
  estimate = coef(mountain.lm), # Point estimates from the model
  lower = conf_95[,1], # Lower bounds of the confidence intervals
  upper = conf_95[,2], # Upper bounds of the confidence intervals
  diff = conf_95[,2] - conf_95[,1]) # add the difference           

# Model coefficients and confidence intervals into a data frame
coef_99_data <- data.frame(
  term = names(coef(mountain.lm)),
  estimate = coef(mountain.lm), # Point estimates from the model
  lower = conf_99[,1], # Lower bounds of the confidence intervals
  upper = conf_99[,2], # Upper bounds of the confidence intervals
  diff = conf_99[,2] - conf_99[,1]) # add the difference         
  
plot_diff <- (ggplot() +
             geom_point(data = coef_99_data, aes(x = term, y = estimate), color = "black", size = 2) +
             geom_errorbar(data = coef_99_data, aes(x = term, ymin = lower, ymax = upper), width = 0.4, color = "red", size = 0.5)+
             geom_text(data = coef_99_data, aes(x = term, y = estimate, label = round(diff, 1), vjust = -0.8, hjust = -0.2), color = "red") +
             geom_point(data = coef_95_data, aes(x = term, y = estimate), color = "black", size = 2) +
             geom_errorbar(data = coef_95_data, aes(x = term, ymin = lower, ymax = upper), width = 0.4, color = "black", size = 0.5)+
             geom_text(data = coef_95_data, aes(x = term, y = estimate, label = round(diff, 1), vjust = 0.8, hjust = -0.2)) +
             theme_minimal() +
             labs(title = "Confidence Intervals for Model Coefficients",
                  x = "Term", 
                  y = "Estimate"))
```
<center> <img src="{{ site.baseurl }}/figures/Diff-int.png" alt="Img" style="width: 800px;"/> </center>

**Answers to the Questions:**

1. Intuitively, when we move to 99% confidence intervals, the interval will be **LARGER** because we are now wanting to be more confident that the estimate is going to lie within the interval,
hence these will become wider.

2. A larger confidence interval implies greater uncertainty about the true value of the estimate lying within a specific range of values.
This essentially means that there is less precision, higher confidence that the value specifically lies in a certain range and so a wider range of possible values.

{% endcapture %} 
{% include reveal.html button="Click for the answer" content=reveal %}

<a name="section5"></a>

## Conclusion

Well done, you've successfully completed the tutorial, happy coding! 

Hopefully you can now feel confident in your ability to:  

##### - Understand the use of confidence intervals and how to construct them for simple linear models
##### - Manually find a confidence interval
##### - Plot regressions and confidence intervals in ggplot2
##### - Know the difference between confidence and prediction intervals

<center> <img src="{{ site.baseurl }}/images/tree.png" alt="Img" style="width: 500px;"/> </center>

For more on `ggplot2`, read the official <a href="https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf" target="_blank">ggplot2 cheatsheet</a>.


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
