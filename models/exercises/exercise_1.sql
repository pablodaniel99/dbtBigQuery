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