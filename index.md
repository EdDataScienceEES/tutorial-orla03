<center><img src="{{ site.baseurl }}/images/conf.png" alt="Img"></center>

To add images, replace `tutheaderbl1.png` with the file name of any image you upload to your GitHub repository.

### Tutorial Aims

#### <a href="#section1"> 1. Understand the purpose of Confidence Intervals.</a>

#### <a href="#section2"> 2. Learn how to use linear models and find their confidence intervals.</a>

#### <a href="#section3"> 3. Learn how to plot the confidence intervals and compare these.</a>

Often in data science we want to predict where the data might fall. A confidence interval gives us a range of plausible values in which our true value might lie; this is essential in ecologicial data science and often used to assess the importance of true effects!

If you are interested in how to find confidence intervals in R and how to plot these results to better visualise where the true value might lie, this is the tutorial for you!

Why do we want to find confidence intervals?

These confidence intervals often help data scientists make informed decisions based on the data we are working with, this allows deeper understanding of their next steps and why data has been modelled in a specific way. Genrerally a narrow confidence interval represents a better model due to more precision in the estimates. 

---------------------------
We are using `<a href="#section_number">text</a>` to create anchors within our text. For example, when you click on section one, the page will automatically go to where you have put `<a name="section_number"></a>`.

To create subheadings, you can use `#`, e.g. `# Subheading 1` creates a subheading with a large font size. The more hashtags you add, the smaller the text becomes. If you want to make text bold, you can surround it with `__text__`, which creates __text__. For italics, use only one understore around the text, e.g. `_text_`, _text_.

# Subheading 1
## Subheading 2
### Subheading 3.

This is some introductory text for your tutorial. Explain the skills that will be learned and why they are important. Set the tutorial in context.

You can get all of the resources for this tutorial from <a href="https://github.com/ourcodingclub/CC-EAB-tut-ideas" target="_blank">this GitHub repository</a>. Clone and download the repo as a zip file, then unzip it.

<a name="section1"></a>

## 1. The first section


At the beginning of your tutorial you can ask people to open `RStudio`, create a new script by clicking on `File/ New File/ R Script` set the working directory and load some packages, for example `ggplot2` and `dplyr`. You can surround package names, functions, actions ("File/ New...") and small chunks of code with backticks, which defines them as inline code blocks and makes them stand out among the text, e.g. `ggplot2`.

When you have a larger chunk of code, you can paste the whole code in the `Markdown` document and add three backticks on the line before the code chunks starts and on the line after the code chunks ends. After the three backticks that go before your code chunk starts, you can specify in which language the code is written, in our case `R`.

To find the backticks on your keyboard, look towards the top left corner on a Windows computer, perhaps just above `Tab` and before the number one key. On a Mac, look around the left `Shift` key. You can also just copy the backticks from below.

```r
# Set the working directory
setwd("your_filepath")

# Load packages
library(ggplot2)
library(dplyr)
```

<a name="section2"></a>

## 2. Learning how to use linear models and find their confidence intervals.

We will begin by constructing a simple linear model for the `trees` data and subsequently 
constucting relevant confidence intervals.

```r
# Loading data
data(trees)

# Build a linear model for trees  
plot(Girth ~ Height, data = trees)

model <- lm(Girth ~ Height, data = trees) # Constuct a simple lm model
summary(model) # Print the summary of our model
```

Recall from our previous tutorial, we must check there are no violation of the assumptions
...

```r
# Plot to check no violation of assumptions
par(mfrow = c(2,2))
plot(model)
# seems okay no clear violation!
```

We can now plot the linear model as follows.

```r
plot(Girth ~ Height, data = trees)
abline(model)

```

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



```r
xy_fil <- xy %>%  # Create object with the contents of `xy`
	filter(x_dat < 7.5)  # Keep rows where `x_dat` is less than 7.5
```

And finally, plot the data:

```r
ggplot(data = xy_fil, aes(x = x_dat, y = y_dat)) +  # Select the data to use
	geom_point() +  # Draw scatter points
	geom_smooth(method = "loess")  # Draw a loess curve
```

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

What do we expect when we move to a 99% prediction interval?


This is the end of the tutorial. Summarise what the student has learned, possibly even with a list of learning outcomes. In this tutorial we learned:

##### - how to generate fake bivariate data
##### - how to create a scatterplot in ggplot2
##### - some of the different plot methods in ggplot2

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
