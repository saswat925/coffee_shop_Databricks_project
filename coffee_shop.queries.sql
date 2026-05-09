--first check raw data
select * from `saswat`.`pintu`.`coffee_shop` limit 100;

use catalog saswat;
use schema pintu;
--row count 
select count(*) from coffee_shop; --149116

select * from coffee_shop;

---DATA CLEANING PART--

--CHECK NULLS
select count(*) from coffee_shop where transaction_id is null; --0
select count(*) from coffee_shop where transaction_date is null; --0
select count(*) from coffee_shop where transaction_time is null; --0
select count(*) from coffee_shop where transaction_qty is null; --0
select count(*) from coffee_shop where store_id is null; --0
select count(*) from coffee_shop where store_location is null; --0
select count(*) from coffee_shop where product_id is null; --0
select count(*) from coffee_shop where unit_price is null; --0
select count(*) from coffee_shop where product_category is null; --0
select count(*) from coffee_shop where product_type is null; --0
select count(*) from coffee_shop where product_detail is null; --0
--no nulls found
--CHECK DUPLICATES
select transaction_id, count(*) from coffee_shop group by transaction_id having count(*) > 1; --no duplicates found
--CHECK DATA TYPES
desc coffee_shop;

---check extra apaces
SELECT count(*)
FROM coffee_shop
WHERE 
    store_location != TRIM(store_location)
    OR product_category != TRIM(product_category)
    OR product_type != TRIM(product_type)
    OR product_detail != TRIM(product_detail); ---extra spaces count 1952 found

--update extra spaces 
UPDATE coffee_shop
SET
    store_location = TRIM(store_location),
    product_category = TRIM(product_category),
    product_type = TRIM(product_type),
    product_detail = TRIM(product_detail);    
    
    ---veryfy 
     SELECT DISTINCT product_category
FROM coffee_shop;

---validation check
SELECT *
FROM coffee_shop
WHERE unit_price <= 0; ----no negative value found

select * from coffee_shop where transaction_qty <= 0
--no negative value found

SELECT MAX(transaction_qty)
FROM coffee_shop; 
--check datatypes
desc coffee_shop;

----create new clean table-----
CREATE OR REPLACE TABLE coffee_shop_clean AS
SELECT
    transaction_id,
    transaction_date,
    transaction_time,
    CAST(transaction_qty AS INT) AS transaction_qty,----data type convert double to int using cast function
    store_id,
    store_location,
    product_id,
    unit_price,
    product_category,
    product_type,
    product_detail,
    CAST(transaction_qty AS INT) * unit_price AS total_revenue ---new column total_revenue = transaction_qty * unit_price
FROM coffee_shop;

---check new table
select * from coffee_shop_clean

select count(*) from coffee_shop_clean;---149116 total rows

--data type check
desc coffee_shop_clean;

----Analysis part from New table---
--all bussines kpi
SELECT
    ROUND(SUM(total_revenue),2) AS total_revenue,
    
    COUNT(transaction_id) AS total_transactions,
    
    SUM(transaction_qty) AS total_quantity_sold,
    
    ROUND(SUM(total_revenue) / COUNT(transaction_id),2) AS avg_order_value,
    
    ROUND(AVG(unit_price),2) AS avg_selling_price,
    
    ROUND(AVG(transaction_qty),2) AS avg_qty_per_transaction

FROM coffee_shop_clean;
---total_revenue= 698812.33
---total_transactions = 149116           
---total_quantity_sold = 214470
---avg_order_value = 4.69
---avg_selling_price = 3.38
---avg_qty_per_transaction = 1.44 

--top selling product_type
select product_type, round(sum(total_revenue),2) as total_revenue from coffee_shop_clean group by product_type order by total_revenue desc limit 10;
--product_type	    total_revenue
--Barista Espresso	 91406.2
--Brewed Chai tea	 77081.95
--Hot chocolate	      72416
--Gourmet brewed coffee 70034.6
--Brewed Black tea	    47932
--Brewed herbal tea	    47539.5
--Premium brewed coffee	 38781.15
--Organic brewed coffee	  37746.5
--Scone	                  36866.12
--Drip coffee	           31984


---top 10 selling products
select product_detail, round(sum(total_revenue),2) as total_revenue from coffee_shop_clean group by product_detail order by total_revenue desc limit 10;
--product_detail	           total_revenue
--Sustainably Grown Organic Lg	21151.75
--Dark chocolate Lg	              21006
--Latte Rg	                     19112.25
--Cappuccino Lg	                 17641.75
--Morning Sunrise Chai Lg	     17384
--Latte	                          17257.5
--Jamaican Coffee River Lg	      16481.25
--Sustainably Grown Organic Rg	   16233.75
--Cappuccino	                    15997.5
--Brazilian Lg	                   15109.5

--category wise revenue
select product_category, round(sum(total_revenue),2) as total_revenue from coffee_shop_clean group by product_category order by total_revenue desc;
--product_category	total_revenue
--Coffee	             269952.45
--Tea	                 196405.95
--Bakery	             82315.64
--Drinking Chocolate	 72416
--Coffee beans	         40085.25
--Branded	             13607
--Loose Tea	             11213.6
--Flavours	             8408.8
--Packaged Chocolate	 4407.64

---category wise quantity sold
select product_category, sum(transaction_qty) as total_quantity_sold from coffee_shop_clean group by product_category order by total_quantity_sold desc; 
--product_category	total_quantity_sold
--Coffee	              89250
--Tea	                  69737
--Bakery	              23214
--Drinking Chocolate	  17457
--Flavours	              10511
--Coffee beans	          1828
--Loose Tea	              1210
--Branded	              776
--Packaged Chocolate	  487

----location wise  revenue and analysis
select store_location, round(sum(total_revenue),2) as total_revenue from coffee_shop_clean 
group by store_location 
order by total_revenue desc;
--store_location	total_revenue
--Hell's Kitchen	236511.17
--Astoria	        232243.91
--Lower Manhattan	230057.25

--location wise quantity sold
select store_location, sum(transaction_qty) as total_quantity_sold from coffee_shop_clean 
group by store_location 
order by total_quantity_sold desc;
--store_location	total_quantity_sold
--Lower Manhattan	71742
--Hell's Kitchen	71737
--Astoria	        70991

---hourly sales analysis
select hour(transaction_time) as hour, round(sum(total_revenue),2) as total_revenue from coffee_shop_clean group by hour 
order by  total_revenue desc;
--Peak performamnce hour
--hours are 8-10 AM ($85K-$89K/hour), generating nearly 25% of daily revenue in just 2 hours. 
--hour       total_revenue
--10	     88673.39
--9	         85169.53
--8	         82699.87

---Daily sales trend
select date(transaction_date) as date, round(sum(total_revenue),2) as total_revenue from coffee_shop_clean 
group by date 
order by total_revenue desc;
--Top 3 revenue days: June 19th ($6,403.91), June 13th ($6,189.36), and June 8th ($6,151.59) represent your best-performing dates—all weekdays in mid-June with tightly clustered revenue ($250 variance) suggesting consistent operational excellence rather than random spikes.
--month name wise analysis
SELECT
    date_format(transaction_date, 'MMMM') AS month,
    ROUND(SUM(total_revenue),2) AS monthly_revenue
FROM coffee_shop_clean
GROUP BY date_format(transaction_date, 'MMMM')
ORDER BY monthly_revenue DESC
--month	    monthly_revenue
--June	    166485.88
--May	    156727.76
--April	    118941.08
--March	    98834.68
--January	81677.74
--February	76145.19

--MoM (Month-over-Month) Growth % ---using common table expression
WITH monthly_sales AS (
    SELECT
        MONTH(transaction_date) AS month,
        ROUND(SUM(total_revenue),2) AS revenue
    FROM coffee_shop_clean
    GROUP BY MONTH(transaction_date)
)

SELECT
    month,
    revenue,

    LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue,

    ROUND(
        ((revenue - LAG(revenue) OVER (ORDER BY month))
        / LAG(revenue) OVER (ORDER BY month)) * 100,
    2) AS mom_growth_percentage

FROM monthly_sales
ORDER BY month;

---$699K total revenue from 149K transactions over 6 months, with revenue doubling from January ($82K) to June ($166K). Coffee dominates at 39% of sales, Hell's Kitchen leads locations, and morning rush (8-10 AM) drives 25% of daily revenue—focus staffing and inventory here.

--Day-to-Day Revenue Growth %
WITH daily_sales AS (
    SELECT
        transaction_date,
        ROUND(SUM(total_revenue),2) AS revenue
    FROM coffee_shop_clean
    GROUP BY transaction_date
)

SELECT
    transaction_date,
    revenue,

    LAG(revenue) OVER (ORDER BY transaction_date) AS previous_day_revenue,

    ROUND(
        ((revenue - LAG(revenue) OVER (ORDER BY transaction_date))
        / LAG(revenue) OVER (ORDER BY transaction_date)) * 100,
    2) AS day_to_day_growth_percentage

FROM daily_sales
ORDER BY transaction_date;
---Day-to-day revenue swings wildly between -26.86% and +33.19%, with consistent drops every month-end (Jan 28: -25.71%, Feb 28: -26.86%, Jun 28: -20.86%) suggesting weekend or operational closures. Early-month recovery pattern: Strong bouncebacks on month-start dates (May 1: +33.19%, Mar 1: +31.55%, Apr 1: +28.11%) indicate successful re-engagement after slower periods—leverage this momentum for promotions.

--contribution percentage%
SELECT
    product_category,

    ROUND(SUM(total_revenue),2) AS revenue,

    ROUND(
        (SUM(total_revenue) /
        (SELECT SUM(total_revenue) FROM coffee_shop_clean)) * 100,
    2) AS contribution_percentage

FROM coffee_shop_clean
GROUP BY product_category
ORDER BY revenue DESC;
---product_category	    revenue	             contribution_percentage
---Coffee	            269952.45	                           38.63%
---Tea	                196405.95	                            28.11%
--Bakery	            82315.64	                            11.78%
--Drinking Chocolate	72416	                                10.36%
--Coffee beans	        40085.25	                             5.74%
--Branded	            13607	                                 1.95%
--Loose Tea	            11213.6	                                 1.6%
--Flavours	 	        8408.8	                                 1.2%
--Packaged Chocolate	4407.64	                                 0.63%





