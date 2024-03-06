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

## Models SQL code and comments on them:
#### Exercise 1: What is the number of orders in the year 2023?

```SQL
WITH exercise_1 as ( 
SELECT COUNT(*) as NumOrders
FROM `dbt-bigquery-416012`.dataset.orders_recrutement
WHERE EXTRACT( YEAR FROM date_date) = 2023
)
SELECT * FROM exercise_1
```

With this query we get a table which consis in just one record containing the number of total orders in 2023: 2573
