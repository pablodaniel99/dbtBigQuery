Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Join the [dbt community](https://getdbt.com/community) to learn from other analytics engineers
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

## DBT models with SQL code and comments on them:
#### Exercise 1: What is the number of orders in the year 2023?

```SQL
/*
This query creates a common table expression (CTE) named exercise_1 to calculate 
the count of orders made in the year 2023 (using the EXTRACT function) from the dataset orders_recrutement
The final query is used on dbt to show the result of the last operation/s, as in this case, the result is 2173
*/
WITH exercise_1 as ( 
SELECT COUNT(*) as NumOrders
FROM `dbt-bigquery-416012`.dataset.orders_recrutement
WHERE EXTRACT( YEAR FROM date_date) = 2023
)
SELECT * FROM exercise_1
```

With this query we get a table which consis in just one record containing the number of total orders in 2023: 2573

#### Exercise 2: What is the number of orders per month in the year 2023?
```SQL
/*
This query creates a common table expression named exercise_2. 
It extracts the year and month from the date_date column, assigns a month name based on the month number, and calculates the count of orders for each month. 
The results are grouped by year and month name, then ordered accordingly. 
Finally, the main query selects all columns from the exercise_2 table expression.
*/
WITH exercise_2 as (
SELECT
   EXTRACT(YEAR FROM date_date) AS year,
   CASE 
    WHEN EXTRACT(MONTH FROM date_date) = 1 THEN 'January'
    WHEN EXTRACT(MONTH FROM date_date) = 2 THEN 'February'
    WHEN EXTRACT(MONTH FROM date_date) = 3 THEN 'March'
    WHEN EXTRACT(MONTH FROM date_date) = 4 THEN 'April'
    WHEN EXTRACT(MONTH FROM date_date) = 5 THEN 'May'
    WHEN EXTRACT(MONTH FROM date_date) = 6 THEN 'June'
    WHEN EXTRACT(MONTH FROM date_date) = 7 THEN 'July'
    WHEN EXTRACT(MONTH FROM date_date) = 8 THEN 'August'
    WHEN EXTRACT(MONTH FROM date_date) = 9 THEN 'September'
    WHEN EXTRACT(MONTH FROM date_date) = 10 THEN 'October'
    WHEN EXTRACT(MONTH FROM date_date) = 11 THEN 'November'
    WHEN EXTRACT(MONTH FROM date_date) = 12 THEN 'December'
   END AS month_name,
  COUNT(*) AS num_orders,
FROM `dbt-bigquery-416012`.dataset.orders_recrutement
WHERE
  EXTRACT(YEAR FROM date_date) = 2023
GROUP BY
  year, month_name
ORDER BY
  year, month_name
)
SELECT * FROM exercise_2
```
#### Exercise 3: What is the average number of products per order for each month of the year 2023?
```SQL
/*
Following the logic on the past exercise, this query calculates the average quantity of products per order for each month in 2023, 
grouping the results by year and month. It assigns month names based on the extracted month numbers.
*/
WITH exercise_3 as (SELECT
  EXTRACT(YEAR FROM date_date) AS year,
  CASE 
    WHEN EXTRACT(MONTH FROM date_date) = 1 THEN 'January'
    WHEN EXTRACT(MONTH FROM date_date) = 2 THEN 'February'
    WHEN EXTRACT(MONTH FROM date_date) = 3 THEN 'March'
    WHEN EXTRACT(MONTH FROM date_date) = 4 THEN 'April'
    WHEN EXTRACT(MONTH FROM date_date) = 5 THEN 'May'
    WHEN EXTRACT(MONTH FROM date_date) = 6 THEN 'June'
    WHEN EXTRACT(MONTH FROM date_date) = 7 THEN 'July'
    WHEN EXTRACT(MONTH FROM date_date) = 8 THEN 'August'
    WHEN EXTRACT(MONTH FROM date_date) = 9 THEN 'September'
    WHEN EXTRACT(MONTH FROM date_date) = 10 THEN 'October'
    WHEN EXTRACT(MONTH FROM date_date) = 11 THEN 'November'
    WHEN EXTRACT(MONTH FROM date_date) = 12 THEN 'December'
  END AS month_name,
  AVG(qty) AS avg_products_per_order
FROM
  dataset.sales_recrutement
WHERE
  EXTRACT(YEAR FROM date_date) = 2023
GROUP BY
  year, month_name
ORDER BY
  year, month_name
)
SELECT * FROM exercise_3
```

#### Exercise 4: Create a table (1 line per order) for all orders in the year 2022 and 2023; this table is similar to orders with an additional column: the qty_product column that gives the quantity of products in the order, for all orders in 2022 and 2023
```SQL
/*
This query selects specific columns from a dataset and calculates the total quantity of products per order using a subquery.
This subquery is used to create a column name "qty_product" that shows the number of product per order
It filters the data for the years 2022 and 2023, then presents the resulting table.
*/
WITH orders_qty_product AS
(SELECT
  orders_id,
  date_date,
  customers_id,
  CA_ht,
  (SELECT SUM(qty) FROM dataset.sales_recrutement WHERE transaction_id = orders_id) AS qty_product
FROM
  dataset.orders_recrutement
WHERE
  EXTRACT(YEAR FROM date_date) IN (2022, 2023)
)

SELECT * FROM orders_qty_product
```

#### Exercise 5 and 6: Create a table (1 line per order) for all orders of the year 2023 only; with an additional column: the order_segmentation column which gives the segment of this order
```SQL
/*
The query has two main parts. The first part selects customer and order information for the year 2023 from the orders_recrutement dataset. 
The second part calculates the number of orders made by each customer in the previous year and categorizes them into segments based on their order history. 
These two parts are then joined together based on the customers' IDs to produce the final result table.
This final table will have 
*/
WITH orders_2023Segmentation AS
(SELECT
    segmentClient.customers_id,
    segmentClient.orders_id,
    segmentClient.date_date,
    CASE
        WHEN pastClient.orders_past_year = 0 THEN 'New'
        WHEN pastClient.orders_past_year BETWEEN 1 AND 3 THEN 'Returning'
        ELSE 'VIP'
    END AS order_segmentation
FROM (
    SELECT
        customers_id,
        orders_id,
        date_date
    FROM
        dataset.orders_recrutement
    WHERE
        EXTRACT(YEAR FROM date_date) = 2023
) segmentClient
LEFT JOIN (
    SELECT
        customers_id,
        COUNT(*) AS orders_past_year
    FROM
        dataset.orders_recrutement
    GROUP BY
        customers_id
) pastClient
ON
    segmentClient.customers_id = pastClient.customers_id)

SELECT * FROM orders_2023Segmentation
```
