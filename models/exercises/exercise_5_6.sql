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

