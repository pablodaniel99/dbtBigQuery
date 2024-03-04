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