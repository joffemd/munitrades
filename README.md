munitrades
==========

Municipal Bond Trade Data

This repo contains data and code related to Marc Joffe's General Assembly Data Science project.  It is a list of about 1.2 million municipal bond trades.  The database will be used to study the behavior or municipal bond prices stored in the column price_inter.

The data was stored in a PostgreSQL database before being loaded into an R data frame.  That data frame is in this repo under the name munitrades.rda.

Code that loads the data from PostgreSQL and displays the graph is in munitrades.r.

A histogran showing the distribution of trade prices within the database is in Price_Histogram_V2.PDF.

