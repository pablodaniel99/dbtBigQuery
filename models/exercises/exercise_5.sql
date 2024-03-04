WITH orders_2023Segmentation AS
(SELECT
    s.client_id,
    s.transaction_id,
    CASE
        WHEN c.orders_in_past_year = 0 THEN 'New'
        WHEN c.orders_in_past_year BETWEEN 1 AND 3 THEN 'Returning'
        ELSE 'VIP'
    END AS order_segmentation
FROM (
    SELECT
        client_id,
        transaction_id
    FROM
        dataset.sales_recrutement
    WHERE
        EXTRACT(YEAR FROM date_date) = 2023
) s
LEFT JOIN (
    SELECT
        client_id,
        COUNT(*) AS orders_in_past_year
    FROM
        dataset.sales_recrutement
    WHERE
        date_date >= DATE_SUB(DATE('2023-01-01'), INTERVAL 1 YEAR) AND
        date_date < DATE('2023-01-01')
    GROUP BY
        client_id
) c
ON
    s.client_id = c.client_id)

SELECT * FROM orders_2023Segmentation

