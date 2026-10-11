SELECT*
FROM bright_coffeeshop.coffeeshop_table.bright_coffeeshop_dataset;
-- Checking the total revenue
SELECT SUM(transaction_qty * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE)) AS revenue
FROM bright_coffeeshop.coffeeshop_table.bright_coffeeshop_dataset;

SELECT transaction_date,
       transaction_time,
       product_detail,
       product_type,
       product_category,
       store_location,
       DAYNAME(transaction_date) AS day_name, -- Extracts the day of the week
       MONTHNAME(transaction_date) AS month_name, --Extract the name of the month
       COUNT(transaction_id) AS number_of_sales,
       SUM(transaction_qty) AS units_sold,--counting the number of units_sold. new column
       COUNT(DISTINCT product_id)AS unique_products,-- check the number of unique  products. new column
       SUM(transaction_qty * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE)) AS revenue,-- checking the total revenue. new column
       COUNT(store_id) AS number_of_stores,-- extracting the number of stores. new column
-- this is used to classify the days by parts of the week. new column
CASE
    WHEN DAYNAME(transaction_date) IN ('Sat','Sun') THEN 'weekend'
    WHEN DAYNAME(transaction_date) IN ('Mon','Tue','Wed','Thur','Fri') THEN 'weekday'
END AS day_classification,
-- this is to classify opareting times by time of day. new column
CASE 
    WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '06:00:00' AND '11:59:59' THEN '01. Morning'
    WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '12:00:00' AND '17:59:59' THEN '02. Afternoon'
    WHEN date_format(transaction_time,'HH:mm:ss') BETWEEN '18:00:00' AND '20:59:59' THEN '03. Evening'
END AS time_classification
FROM bright_coffeeshop.coffeeshop_table.bright_coffeeshop_dataset
GROUP BY transaction_date,
         transaction_time,
         product_type,
         product_detail,
         product_category,
         store_location; 
-- this is to check unique products provided in each store
SELECT DISTINCT product_category,
                product_detail,
                store_location
FROM bright_coffeeshop.coffeeshop_table.bright_coffeeshop_dataset;
-- this code shows the total revenue for every product by month 
SELECT transaction_date,
       Product_category,
SUM (transaction_qty * CAST(REPLACE(unit_price, ',', '.') AS DOUBLE)) AS revenue
FROM bright_coffeeshop.coffeeshop_table.bright_coffeeshop_dataset
GROUP BY Product_category,
         transaction_date
ORDER BY revenue DESC;
-- to check if i have all the months
SELECT MONTHNAME(transaction_date) AS MonthName,
       MONTH(transaction_date) AS MonthNumber
FROM bright_coffeeshop.coffeeshop_table.bright_coffeeshop_dataset
GROUP BY MONTHNAME(transaction_date),
         MONTH(transaction_date)
ORDER BY MonthName ASC;
-- this is to check for any duplicates on my dataset
SELECT product_type,
         product_detail,
         product_category,
         store_location,
         transaction_id,
         transaction_date,
         transaction_time,
         transaction_qty,
         store_id,
         product_id,
         unit_price,
COUNT(*) AS DuplicateCount
FROM bright_coffeeshop.coffeeshop_table.bright_coffeeshop_dataset
GROUP BY product_type,
         product_detail,
         product_category,
         store_location,
         transaction_id,
         transaction_date,
         transaction_time,
         transaction_qty,
         store_id,
         product_id,
         unit_price
HAVING COUNT(*) > 1;

-- This is to check my data, how it looks like before I start processing
SELECT * 
FROM bright_coffeeshop.coffeeshop_table.bright_coffeeshop_dataset
LIMIT 100;

-- How many stores do we have?
-- to check the name of the stores locations that i have
SELECT DISTINCT store_location
FROM bright_coffeeshop.coffeeshop_table.bright_coffeeshop_dataset;

-- What is the period of this data?
-- when did we start collecting this data, and when last did we collect the last record
SELECT MIN(transaction_date) AS start_dt,
       MAX(transaction_date) AS last_dt 
FROM bright_coffeeshop.coffeeshop_table.bright_coffeeshop_dataset;

-- What are the business hours of the shop?
SELECT MIN(transaction_time) AS opening_time,
       MAX(transaction_time) AS closing_time 
FROM bright_coffeeshop.coffeeshop_table.bright_coffeeshop_dataset;

-- how many different products are we selling in total?
SELECT  COUNT(DISTINCT product_id)AS number_of_products
FROM bright_coffeeshop.coffeeshop_table.bright_coffeeshop_dataset;

-- How many products are we selling per store?
SELECT  store_location,
        COUNT(DISTINCT product_id)AS number_of_products
FROM bright_coffeeshop.coffeeshop_table.bright_coffeeshop_dataset
GROUP BY store_location;

-- What are the different product category we have?
SELECT DISTINCT product_category, product_type, product_detail
FROM bright_coffeeshop.coffeeshop_table.bright_coffeeshop_dataset
WHERE product_category IN ('Coffee')
ORDER BY product_type;

SELECT COUNT(*) AS missing_values
FROM bright_coffeeshop.coffeeshop_table.bright_coffeeshop_dataset
WHERE product_detail = ''
OR product_detail is null;


