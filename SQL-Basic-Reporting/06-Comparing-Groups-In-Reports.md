# Comparing Groups in One Report

Find out even more about how you can compare groups in single SQL reports.

Welcome once again! This is the last part of our course, where we'll show you **three different methods for comparing business object groups** in SQL reports.

These techniques won't be anything new to you – quite the opposite! You've already seen them in one way or another. The aim of this part is to consolidate your knowledge. And because these techniques use most of the content you've seen in the course, you'll also have the chance to review what we previously learned.

So, are you ready?

## Method 1

Let's get started! The first method we're going to show allows you to put groups into separate rows.

Suppose we want to show the number of orders shipped to North America and the number of orders shipped to other places in separate rows, like this:

| shipping_continent | order_count  |
|:------------------:|:------------:|
| North America      | 180          |
| Other              | 650          |  

We can use the following query:

```sql
WITH orders_by_group AS (
  SELECT 
    order_id,
    CASE
      WHEN ship_country IN ('USA', 'Canada', 'Mexico')
        THEN 'North America'
      ELSE 'Other' 
    END AS shipping_continent
  FROM orders
)
SELECT
  shipping_continent,
  COUNT(order_id) AS order_count
FROM orders_by_group
GROUP BY shipping_continent;
```

Inside the inner query, we select the `order_id` and use the `CASE WHEN` construction to **classify** orders based on the `ship_country` column. The classification result is stored in a column named `shipping_continent`, which is either `'North America'` or `'Other'`. You can define **as many values as you want**; you don't need to limit yourself to two.

In the outer query, we group all rows from the inner query by the `shipping_continent` column and use the `COUNT(order_id)` function to count matching orders. As a result, each group is shown in a separate row.

### Exercise 1

Count the orders processed by employees from the `'WA'` region and by all other employees. Show two columns: `employee_region` (either `'WA'` or `'Not WA'`), and `order_count`.

```sql
SELECT
  CASE
    WHEN region = 'WA' THEN 'WA'
    ELSE 'Not WA'
  END AS employee_region,
  COUNT(order_id) AS order_count
FROM employees
    JOIN orders USING (employee_id)
GROUP BY employee_region;
```

Output:

| employee_region | order_count |
|:------:|:------:|
| WA | 605 |
| Not WA | 225 |

### Exercise 2

Count the number of products with low, average, and high availability. Show two columns: `availability` (`'Low'` for `10` units or less, `'Average'` for `10` to `30` units, or `'High'` for more than `30` units) and `product_count`.

```sql
SELECT
  CASE
    WHEN units_in_stock <= 10 THEN 'Low'
    WHEN units_in_stock <= 30 THEN 'Average'
    ELSE 'High'
  END AS availability,
  COUNT(product_id) AS product_count
FROM products
GROUP BY availability;
```

Output:

| availability | product_count |
|:------:|:------:|
| Low | 10 |
| Average | 30 |
| High | 15 |

### Exercise 3

Calculate the total revenue generated (after discount) by customers from France and by customers from other countries. Show two columns: `customer_country` (either `'France'` or `'Other'`) and `discount_revenue`. Round the second column to two decimal places.

```sql
SELECT
  CASE
    WHEN country = 'France' THEN 'France'
    ELSE 'Other'
  END AS customer_country,
  ROUND(SUM(oi.unit_price * oi.quantity * (1 - oi.discount)), 2) AS discount_revenue
FROM orders
    JOIN order_items oi USING (order_id)
    JOIN customers USING (customer_id)
GROUP BY customer_country;
```

Output:

| customer_country | discount_revenue |
|:------:|:------:|
| France |  1184434.72 |
| Other |  81358.32 |

## Method 2

Very well done! Let's move on to method two. This method shows different groups in separate columns.

Let's say we want to count the number of orders already shipped and the number of orders not yet shipped:

| orders_shipped | orders_pending     |
|:------------------:|:---------------:|
| 809                | 21              |

Take a look at the query:

```sql
SELECT
  COUNT(CASE
    WHEN shipped_date IS NOT NULL
      THEN order_id
  END) AS orders_shipped,
  COUNT(CASE
    WHEN shipped_date IS NULL
      THEN order_id
  END) AS orders_pending
FROM orders;
```

In this technique, we use multiple `COUNT(CASE WHEN...)` or `SUM(CASE WHEN...)` statements in the query. Each statement is used to show the **metric for a single group in a new column**. We also need to **name** each column using the `X AS alias` construction.

In Method 1, groups were represented as rows and created with a single `CASE WHEN` statement. Here, they are represented as columns and created with separate aggregate function invocations. This is why Method 2 is typically a good choice for a **small number of groups**.

### Exercise 1

Count the number of vegetarian and non-vegetarian products. Show two columns: `non_vegetarian_count` and `vegetarian_count`.

**Hint:** Non-vegetarian products have a `category_id` of `6` or `8`.

```sql
SELECT
  COUNT(CASE
    WHEN category_id IN (6, 8)
      THEN product_id
  END) AS non_vegetarian_count,
  COUNT(CASE
    WHEN category_id NOT IN (6, 8)
      THEN product_id
  END) AS vegetarian_count
FROM products;
```

Output:

| non_vegetarian_count | vegetarian_count |
|:------:|:------:|
| 15 | 30 |

### Exercise 2

Count the total number of line items from orders shipped to Canada that were:

1. sold at full price,
2. or sold at a discounted price.

Show two columns: `full_price_count` and `discounted_price_count`.

```sql
SELECT
  COUNT(CASE
    WHEN discount = 0
      THEN order_id
  END) AS full_price_count,
  COUNT(CASE
    WHEN discount > 0
      THEN order_id
  END) AS discounted_price_count
FROM orders
    JOIN order_items USING (order_id)
    JOIN products USING (product_id)
WHERE ship_country = 'Canada';
```

Output:

| full_price_count | discounted_price_count |
|:------:|:------:|
| 26 | 4 |

## Method 2 with grouping

Good job! One advantage of Method 2 as compared to Method 1 is that we can add another **dimension** to our reports. Take a look:

```sql
SELECT
  customer_id,
  COUNT(CASE
    WHEN shipped_date IS NOT NULL
      THEN order_id
  END) AS orders_shipped,
  COUNT(CASE
    WHEN shipped_date IS NULL
      THEN order_id
  END) AS orders_pending
FROM orders
GROUP BY customer_id;
```

Result:

| customer_id | orders_shipped | orders_pending |
|:------:|:------:|:------:|
|ALFKI	|6|	0|
|ANATR	|4|	0|
|ANTON	|7|	0|

We add the `customer_id` column in the `SELECT` clause, and we also add it later in the `GROUP BY` clause. This way, we can now see how many orders are shipped or pending for each customer.

### Exercise

For each employee, find the total revenue before discount generated by the orders processed for two order groups: `dach_orders` (orders shipped to Germany, Austria, or Switzerland) and `other_orders` (orders shipped to all other countries).

Show the following columns: `employee_id`, `first_name`, `last_name`, `dach_orders`, `other_orders`.

```sql
SELECT
  e.employee_id,
  e.first_name,
  e.last_name,
  COALESCE(SUM(CASE
    WHEN ship_country IN ('Germany', 'Austria', 'Switzerland')
      THEN oi.unit_price * oi.quantity 
  END), 0) AS dach_orders,
  COALESCE(SUM(CASE
    WHEN ship_country NOT IN ('Germany', 'Austria', 'Switzerland')
      THEN oi.unit_price * oi.quantity
  END), 0) AS other_orders
FROM orders
    JOIN order_items oi USING (order_id)
    JOIN employees e USING (employee_id)
GROUP BY e.employee_id, e.first_name, e.last_name;
```

Output:

| employee_id | first_name | last_name | dach_orders | other_orders |
|:------:|:------:|:------:|:------:|:------:|
|9|	Anne|	Dodsworth|	28447.75|	54516.25
|3|	John|	Smith|	78676.17|	134375.13
|5|	Steven|	Buchanan|	9349.60|	66218.15

## Method 3 

Finally, let's take a look at Method 3. It's a bit more complicated. Method 3 is typically the best solution for more **complex reports**, such as ones with percentages or multi-level aggregation.

For each employee, we want to show the percentage of orders that have already been shipped that are going to Germany and the USA. This is what we want to see:

| first_name | last_name | germany_perc | usa_perc  |
|:----------:|:---------:|:------------:|:---------:|
| Nancy      | Davolio   | 100          | 95.24     |
| Andrew     | Fuller    | 92.86        | 100       |
| Janet      | Leverling | 100          | 100       |

And here's the query:

```sql
WITH germany_orders AS (
  SELECT
    employee_id,
    COUNT(CASE
      WHEN shipped_date IS NOT NULL
        THEN order_id
    END) AS count_shipped,
    COUNT(order_id) AS count_all
  FROM orders o
  WHERE o.ship_country = 'Germany'
  GROUP BY employee_id
),
usa_orders AS (
  SELECT
    employee_id,
    COUNT(CASE
      WHEN shipped_date IS NOT NULL
        THEN order_id
    END) AS count_shipped,
    COUNT(order_id) AS count_all
  FROM orders o
  WHERE o.ship_country = 'USA'
  GROUP BY employee_id
)
SELECT
  e.first_name,
  e.last_name,
  ROUND(ge_or.count_shipped / CAST(ge_or.count_all AS decimal) * 100, 2) AS germany_perc,
  ROUND(us_or.count_shipped / CAST(us_or.count_all AS decimal) * 100, 2) AS usa_perc
FROM germany_orders ge_or
FULL OUTER JOIN usa_orders us_or
  ON ge_or.employee_id = us_or.employee_id
JOIN employees e
  ON ge_or.employee_id = e.employee_id
  OR us_or.employee_id = e.employee_id;
```

The general idea is to use **separate CTEs** to calculate metrics for each group, and then **combine** the results in the outer query.

Here, we have separate CTEs for German and American (USA) orders. In each CTE, we group orders by the `employee_id` column and calculate the numerator and denominator needed to find the percentages. In the outer query, we join both CTEs on the `employee_id` column and perform division to get the results.

Note the use of a `FULL OUTER JOIN`. A simple join only shows rows with matching column values in both tables. This means that employees who only shipped orders to one of the two countries wouldn't be shown at all. A `FULL OUTER JOIN` solves this problem.

### Exercise 1

For each `ship_country`, we want to see the percentage of revenue for all orders before discount that has been generated by the employees with the IDs 1 and 2. Show three columns:

- The country to which an order is being shipped (`ship_country`).
- `percentage_employee_1` – the percentage of pre-discount revenue generated by the employee with ID 1.
- `percentage_employee_2` – the percentage of pre-discount revenue generated by the employee with ID 2.

Round the percentages to two decimal places.

```sql
WITH employee_1 AS (
  SELECT
    ship_country,
    CASE WHEN employee_id = 1 
        THEN SUM(unit_price * quantity)
        ELSE 0
    END AS employee_revenue,
    SUM(unit_price * quantity) AS total_revenue
  FROM order_items
  JOIN orders USING (order_id)
  GROUP BY ship_country, employee_id
),
employee_2 AS (
  SELECT
  	ship_country,
    CASE WHEN employee_id = 2 
        THEN SUM(unit_price * quantity)
        ELSE 0
    END AS employee_revenue,
    SUM(unit_price * quantity) AS total_revenue
  FROM order_items
  JOIN orders USING (order_id)
  GROUP BY ship_country, employee_id
)
SELECT
  e2.ship_country,
  ROUND(SUM(e1.employee_revenue) / SUM(e1.total_revenue) * 100, 2) AS percentage_employee_1,
  ROUND(SUM(e2.employee_revenue) / SUM(e2.total_revenue) * 100, 2) AS percentage_employee_2
FROM employee_1 e1
  FULL OUTER JOIN employee_2 e2 ON e1.ship_country = e2.ship_country
GROUP BY e2.ship_country
```

Output:

| ship_country | percentage_employee_1 | percentage_employee_2 |
|:------------:|:---------------------:|:---------------------:|
|Venezuela |	16.42 |	4.92
|Sweden	 | 13.11 |	14.26
|Ireland |	5.42 |	22.91

### Exercise 2

For each employee, show the percentage of total revenue (before discount) generated by orders shipped to the USA and to Germany, with respect to the total revenue generated by that employee. Show the following columns:

1. `employee_id`.
2. `first_name`.
3. `last_name`.
4. `rev_percentage_usa`.
5. `rev_percentage_germany`.

Round the percentages to two decimal places.

```sql
WITH usa_revenue AS (
  SELECT
    employee_id,
    CASE WHEN ship_country = 'USA'
        THEN SUM(unit_price * quantity)
        ELSE 0
    END AS revenue,
    SUM(unit_price * quantity) AS total_revenue
  FROM order_items
  JOIN orders USING (order_id)
  GROUP BY ship_country, employee_id
),
germany_revenue AS (
  SELECT
  	employee_id,
    CASE WHEN ship_country = 'Germany'
        THEN SUM(unit_price * quantity)
        ELSE 0
    END AS revenue,
    SUM(unit_price * quantity) AS total_revenue
  FROM order_items
  JOIN orders USING (order_id)
  GROUP BY ship_country, employee_id
)
SELECT
  e.employee_id,
  e.first_name,
  e.last_name,
  ROUND(SUM(ur.revenue) / SUM(ur.total_revenue) * 100, 2) AS rev_percentage_usa,
  ROUND(SUM(gr.revenue) / SUM(gr.total_revenue) * 100, 2) AS rev_percentage_germany
FROM usa_revenue ur
  FULL OUTER JOIN germany_revenue gr ON ur.employee_id = gr.employee_id
JOIN employees e
  ON ur.employee_id = e.employee_id
  OR gr.employee_id = e.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name
```

Output:

| employee_id | first_name | last_name | rev_percentage_usa | rev_percentage_germany |
|:------:|:------:|:------:|:------:|:------:|
|9	| Anne |	Dodsworth |	21.82 |	19.18
|3	| John |	Smith	| 16.34 |	22.99
|5	| Steven |	Buchanan	| 21.37 |	11.55

## Summary

That's all we wanted to show you in this part! Before we review, let's do a quick summary.

We've talked about three methods to compare different business groups in a single query.

1. In Method 1, we use a `CASE WHEN` construction in a CTE to label business objects. In the outer query, we group the rows by these labels. Groups are shown in separate rows.

    ```sql
    WITH name_of_cte AS (
    SELECT
        ...,
        CASE
        WHEN ...
        ELSE ...
        END AS group_label
    FROM table_name
    )
    SELECT
    group_label,
    COUNT(...) 
    FROM name_of_cte
    GROUP BY group_label;
    ```

2. In Method 2, we use multiple `COUNT/SUM(CASE WHEN...)` statements to create groups. The groups are shown in separate columns. We can also add more groups.

    ```sql
    SELECT
    group_column,
    COUNT(CASE
        WHEN ... THEN ...
    END) AS group_one,
    COUNT(CASE
        WHEN ... THEN ...
    END) AS group_two
    FROM table_name
    GROUP BY group_column;
    ```

3. In Method 3, each group is calculated in a **separate CTE**. Groups are then **combined** in the outer query.

    ```sql
    WITH group_one AS (...), 
    group_two AS (...)
    SELECT
        group_one.column_name,
        group_two.column_name
    FROM group_one
    FULL OUTER JOIN group_two
        ON ...;
    ```

How about a short quiz?

### Exercise 1

Count the number of products with low, average, and high prices. Show two columns:

- `price_category` – `'Low'` for products with a unit price less than or equal to `30`, `'Average'` for products between `30` and `90`, and `'High'` for products with a unit price above `90`.
- `product_count` – the number of products in a given group.

```sql
SELECT
  CASE WHEN unit_price <= 30 THEN 'Low'
    WHEN unit_price <= 90 THEN 'Average'
    ELSE 'High'
  END AS price_category,
  COUNT(product_id) AS product_count
FROM products
GROUP BY price_category;
```

Output:

| price_category | product_count |
|:------:|:------:|
| Low | 10 |
| Average | 30 |
| High | 15 |

### Exercise 2

Let's count how many customers we have in each language group, which is based on the language used in their country of residence. Show three columns:

- `english_count` – the number of customers from UK, Canada, USA, and Ireland.
- `german_count` – the number of customers from Germany, Switzerland, and Austria.
- `other_count` – the number of customers from other countries.

```sql
SELECT
  COUNT(CASE WHEN country IN ('UK', 'Canada', 'USA', 'Ireland') THEN 1 END) AS english_count,
  COUNT(CASE WHEN country IN ('Germany', 'Switzerland', 'Austria') THEN 1 END) AS german_count,
  COUNT(CASE WHEN country NOT IN ('UK', 'Canada', 'USA', 'Ireland', 'Germany', 'Switzerland', 'Austria') THEN 1 END) AS other_count
FROM customers;
```

Output:

| english_count | german_count | other_count |
|:------:|:------:|:------:|
| 4 | 3 | 3 |

### Exercise 3

Create a report to show the percentage of total revenue after discount generated by orders with low (less than or equal to `90.0`) and high (greater than `90.0`) freight values in each country we ship to.

Show the following columns: `ship_country`, `percentage_low_freight`, and `percentage_high_freight`.

Round the percentages to two decimal places.

```sql
WITH low_freight AS (
  SELECT
    ship_country,
    SUM(CASE WHEN freight <= 90.0 THEN oi.unit_price * oi.quantity * (1 - discount) ELSE 0 END) AS low_freight_revenue,
    SUM(oi.unit_price * oi.quantity * (1 - discount)) AS total_revenue
  FROM orders
  JOIN order_items oi USING (order_id)
  GROUP BY ship_country
),
high_freight AS (
  SELECT
    ship_country,
    SUM(CASE WHEN freight > 90.0 THEN oi.unit_price * oi.quantity * (1 - discount) ELSE 0 END) AS high_freight_revenue,
    SUM(oi.unit_price * oi.quantity * (1 - discount)) AS total_revenue
  FROM orders
  JOIN order_items oi USING (order_id)
  GROUP BY ship_country
)
SELECT
  lf.ship_country,
  ROUND(SUM(lf.low_freight_revenue) / SUM(lf.total_revenue) * 100, 2) AS percentage_low_freight,
  ROUND(SUM(hf.high_freight_revenue) / SUM(hf.total_revenue) * 100, 2) AS percentage_high_freight
FROM low_freight lf
  FULL OUTER JOIN high_freight hf ON lf.ship_country = hf.ship_country
GROUP BY lf.ship_country
```

Output:

| ship_country | percentage_low_freight | percentage_high_freight |
|:------:|:------:|:------:|
| Venezuela |	62.72 |	37.28
| Sweden |	31.90 |	68.10
| Ireland |	35.29 |	64.71

## Congratulations

Very well done! That was the last exercise in the entire course – congratulations on finishing it!

You should now be able to create various types of business reports using SQL. You know how to summarize business data and apply custom object classifications. You can also use multi-level aggregation, calculate percentages, and compare different business groups in a single report.
