library(RPostgreSQL)
library(ggplot2)
library(scales)
drv <- dbDriver('PostgreSQL')
con <- dbConnect(drv, dbname='msrb', user='postgres', password='********')
munitrades <-dbReadTable(con,'munitrades_unique')
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
