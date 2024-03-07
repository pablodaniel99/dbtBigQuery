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