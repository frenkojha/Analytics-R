
# ------------Case Study on Multiple Regression--------------#

# --------------------About the Dataset----------------------#

# A Venture Capital Firm wants to invest in a few Startup firms.
# But is not sure that which parameter should it consider while investing.
# The parameters available are:
# I - for independent variable and D - for dependent variable 

# 1. R&D Spends (I)
# 2. Administration Cost (I)
# 3. Marketing Spends (I)
# 4. State Name (I)
# 5. Profit (D)

# -----------------------Problem----------------------------#

# Please help the firm to decide that which parameter should 
# it consider for investing for better profits in the future.

# Here's a list of 10 startups shared to the Venture Capitalists.
# This dataset is showing financials of these 10 most lucrative 
# startups in California in the year - 2019.

# In that case study Venture Capital Firm wants to achieve profit. 


# -------Importaing the data set
library(dplyr)
getwd()
setwd("C:/Users/91810/Desktop/RStudio files/Assignment Papers")
comData<-read.csv("Start_Ups.csv")
View(comData)

str(comData)
summary(comData)
glimpse(comData)

comData$State <- as.factor(comData$State)
comData <-transform(comData,
        State = as.factor(State)
        # R.D.Spend = as.numeric(as.character(R.D.Spend)),
        # Administration = as.numeric(as.character(Administration)),
        # Marketing.Spend = as.numeric(as.character(Marketing.Spend)),
        # Profit = as.numeric(as.character(Profit))
)
# comData$State<-as.factor(as.character(comData$State))

# ------State wise profit distribution--------------#
library(ggplot2)
ggplot(comData, aes(x =State, y =Profit, color = State)) +
  geom_boxplot()+
  geom_point(size = 2, position = position_jitter(width = 0.2)) +
  stat_summary(fun.y = mean, geom = "point", shape = 20, size = 6, color = "blue")+
  theme_classic()
# +
# facet_grid(.~R.D.Spend)

# -------- Scatter plot-------------#
# Plot the chart.
plot(Profit ~ R.D.Spend, data = comData, xlab = "R & D Spends",
        ylab = "Profit")

plot(Profit ~ Marketing.Spend, data = comData, xlab = "Marketing.Spends",
     ylab = "Profit")

plot(Profit ~ Administration, data = comData, xlab = "Administration Spends",
     ylab = "Profit")

# -------------Boxplot--------------#
boxplot(comData$R.D.Spend)
boxplot(comData$Administration)
boxplot(comData$Marketing.Spend)



# --------------Histogram & Density plot----------------#
# Kernel Density Plot
hist(comData$R.D.Spend)
d <- density(comData$R.D.Spend) # returns the density data
plot(d) # plots the results

hist(comData$Marketing.Spend)
d <- density(comData$Marketing.Spend) # returns the density data
plot(d) # plots the results

hist(comData$Administration)
d <- density(comData$Administration) # returns the density data
plot(d) # plots the results


# ------------removing outliers-------------#

boxplot(comData$Marketing.Spend)
summary(comData)
lower_one_percent <- quantile(comData$Marketing.Spend, .01)
lower_one_percent
#99 percent of the population works under 143670.7 hours per week.
#We can drop the observations above this threshold. 
data_adult_drop <-comData %>%
  filter(Marketing.Spend>lower_one_percent)
dim(data_adult_drop)
View(data_adult_drop)

boxplot(data_adult_drop$Marketing.Spend)
newComData<-data_adult_drop
View(newComData)

# Spliting the data
trainIndexData <- sample(1:nrow(newComData), 0.7*nrow(newComData))
trainData <- newComData[trainIndexData,]
testData <- newComData[-trainIndexData,]
View(trainData)
View(testData)

# Built model on training data 
names(trainData)
str(trainData)
trainData$State <- as.factor(trainData$State)
# trainData$State<-as.factor(as.character(trainData$State))
multi_model <- lm(Profit~
                    R.D.Spend +
                      Administration +
                     Marketing.Spend +
                     State 
                  ,data = trainData)

summary(multi_model)

# equation for the model: 
# Profit = 3.82 + 1.18 * R&D Spends

step(multi_model, direction = "backward")
#Predict----
testData$Pred_Profit <- predict(multi_model,newdata=testData)
View(testData)

mape <- mean(abs((testData$Pred_Profit - testData$Profit))/testData$Profit)
mape

library(Metrics)
mape(testData$Pred_Profit,testData$Profit)


