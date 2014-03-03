library(RPostgreSQL)
library(ggplot2)
library(scales)

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
munitrades$remaining_term <- munitrades$maturity_dt - munitrades$tradedate_dt

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

# Regress prices against 
# OLS is sufficient for my purposes as I am just trying to understand the
# determinants of price
regr <- lm(price_inter ~ coupon + remaining_term, data=munitrades)

# the intercept, coupon and remaining term are all significant at p < 0.001
# and have the expected signs.  Price varies directly with coupon and
# inversely with remaining term
summary(regr)

# Save data frame to a csv and save the workspace
write.csv(munitrades, file = "d:\\munitrades\\munitrades.csv")
save.image(file = "d:\\munitrades\\munitrades.RData")