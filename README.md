munitrades
==========

Municipal Bond Trade Data

This repo contains data and code related to Marc Joffe's General Assembly Data Science project.  It is a list of about 1.2 million municipal bond trades.  The database is being used to study the behavior or municipal bond prices stored in the column price_inter.

The data was stored in a PostgreSQL database before being loaded into an R data frame.  That data frame is in this repo under the name munitrades.rda.

Code that loads the data from PostgreSQL and displays the graph is in munitrades.r.  On 3/2/14, this code was modified to compute four derived columns.  The import contained three character fields that had string date representations.  These are now converted to r date fields. Next the number of days between the maturity date and the trade data is calculated. This difference - the number of remaining days to maturity - and the coupon are theorized to be drivers of the intermediate trade price.  Regression analysis validates this assumption.

A histogram showing the distribution of trade prices within the database is in Price_Histogram_V2.PDF.

