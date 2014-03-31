library(RPostgreSQL)
library(ggplot2)
library(scales)
library(dplyr)

# Load data from PostgreSQL
drv <- dbDriver('PostgreSQL')
con <- dbConnect(drv, dbname='msrb', user='postgres', password='A1b2c3d4')
munitrades <-dbReadTable(con,'munitrades_unique')

# Input data contain three character columns containing date information
# These statements create new date columns by converting these strings
# The values can then be used for regression analysis
munitrades$issuedate_dt <- as.Date(munitrades$issuedate,format="%d%b%Y")
munitrades$maturity_dt <- as.Date(munitrades$maturity,format="%d%b%Y")
munitrades$tradedate_dt <- as.Date(munitrades$tradedate,format="%d%b%Y")

# Calculate the days remaining before maturity as of the trade date
munitrades$remaining_term <- as.numeric(munitrades$maturity_dt) - as.numeric(munitrades$tradedate_dt)

# Histogram of trades by price
ggplot(data=munitrades, aes(price_inter, fill="red")) + 
  geom_histogram(binwidth=1) + 
  ggtitle("Number of Trades by Price") + 
  xlab("Price") + 
  ylab("Number of Trades") +
  xlim(0,150) +
  theme_bw() +
  scale_y_continuous(labels = comma) +
  theme(legend.position = "none")
attach(munitrades)
summary(price_inter)

# Regress prices against coupon and remaining term
# OLS is sufficient for my purposes as I am just trying to understand the
# determinants of price
regr <- lm(price_inter ~ coupon + remaining_term, data=munitrades, na.action=na.exclude)

# the intercept, coupon and remaining term are all significant at p < 0.001
# and have the expected signs.  Price varies directly with coupon and
# inversely with remaining term
summary(regr)

# Predict prices using the model
# predict(regr, munitrades, interval="prediction")
munitrades$price_resid <- resid(regr)
munitrades$price_fitted <- fitted(regr)

# Create an extract of the full trades table that shows the variance of trade prices for small and large sized
# trades
cusips <- group_by(munitrades, cusip)
cusipsum <- summarise(cusips, count = n(), medianpar=median(par)) 
commonlytraded <- filter(cusipsum, count >= 10)
munitr2 <- merge(munitrades, commonlytraded)
munitr3 <- filter(munitr2, munitr2$par != munitr2$medianpar) 
munitr3$abovemedian <- (munitr3$par - munitr3$medianpar) / abs(munitr3$par - munitr3$medianpar)
cusips2 <- group_by(munitr3,cusip,abovemedian)
cusip2sum <- summarise(cusips2, count = n(), pricevar = var(price_inter)) 

#reshape has to be loaded here; if loaded earlier, it breaks the summarise call with count = n() above
library(reshape)
melted <- melt(data=cusip2sum, id=c(1:2), measure=c(4)) 
casted <- cast(melted, formula = cusip ~ abovemedian) 
names(casted)[2] <- 'belowmedian'
names(casted)[3] <- 'abovemedian'

# Test to determine whether smaller trades have more variance than larger trades
t.test(casted$abovemedian,casted$belowmedian,paired=TRUE)
summary(casted)

# Visualize the difference in variances by plotting the cumulative density functions
castedm <- melt.data.frame(data=casted, id.var='cusip')  # need to melt data to get two curve plot
ggplot(data=castedm, aes(x = value, colour = variable)) + 
  stat_ecdf() + 
  xlim(0,10) + 
  xlab('Variance') + 
  ylab('Cumulative Frequency') + 
  theme_grey() + 
  theme(legend.position="bottom") + 
  theme(legend.title=element_blank())

# Save data frame to a csv and save the workspace
#write.csv(munitrades, file = "d:\\munitrades\\munitrades.csv")
#save.image(file = "d:\\munitrades\\munitrades.RData")