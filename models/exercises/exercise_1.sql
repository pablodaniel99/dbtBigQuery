WITH exercise_1 as ( 
SELECT COUNT(*) as NumOrders
FROM `dbt-bigquery-416012`.dataset.orders_recrutement
WHERE EXTRACT( YEAR FROM date_date) = 2023
)

SELECT * FROM exercise_1