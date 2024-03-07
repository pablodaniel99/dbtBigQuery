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