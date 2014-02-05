*PostgreSQL Database Definition Language*

create table munitrades (
cusip char(9),
name varchar(60),
issuedate char(9) NULL,
coupon decimal(7,4),
maturity char(9) NULL,
settledate char(9) NULL,
tradedate char(9) NULL,
par decimal(12,0),
price_sale decimal(9,4) NULL,
yield_sale decimal(9,4) NULL,
price_purch decimal(9,4) NULL,
yield_purch decimal(9,4) NULL,
price_inter decimal(9,4) NULL,
yield_inter decimal(9,4) NULL,
tradetime char(9) NULL,
whenis char(10) NULL
);


*PostgreSQL Upload Code*

COPY munitrades(cusip,name,issuedate,coupon,maturity,settledate,tradedate,par,price_sale,yield_sale,price_purch,yield_purch,price_inter,yield_inter,tradetime,whenis)
FROM 'd://munitrades/muniall.csv'
WITH DELIMITER ','
CSV HEADER;


*PostgreSQL De-duplication Code*

select distinct * into table munitrades_unique from munitrades;