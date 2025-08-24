# Multi-level Aggregation

Learn how to construct reports that aggregate data on multiple levels.

Let's get started! Suppose we want to know the average total price paid (before discount) per order.

We know that we can use `SUM(unit_price * quantity)` to calculate the total price for a single order. However, we now need the average total price for all orders. In other words, we would like to use the `AVG()` function on values calculated by a call to `SUM(unit_price * quantity)`. Unfortunately, SQL doesn't allow this type of construction: `AVG(SUM(unit_price * quantity))`.

What can we do? Let's find out!

```sql
WITH order_total_prices AS (
  SELECT
    o.order_id, 
    SUM(unit_price * quantity) AS total_price
  FROM orders o
  JOIN order_items oi
    ON o.order_id = oi.order_id
  GROUP BY o.order_id
)
SELECT
  AVG(total_price) AS avg_total_price
FROM order_total_prices;
```

Output:

| avg_total_price |
|:------:|
| 1631.8778192771084337 |

The query above answers the following question: _What is the average total price paid (before discounts) per order?_

## Explanation

The code in the previous exercise used an SQL concept known as a **CTE**, or a **common table expression**. Think of it as a temporary set of rows that you define and use later in the same query. CTEs are similar to subqueries.

The most basic syntax of any common table expression looks like this:

```sql
WITH some_name AS (
  -- your CTE
)
SELECT
  ... 
FROM some_name
```

You need to give your CTE a name (we used `some_name` in the example) and define it within a pair of parentheses. Then, once you close the parentheses, you can select columns from the CTE as if it were a table. We will refer to the CTE as the "inner query" and the part after it as the "outer query." Note that you need to define your CTE first – i.e., before the outer query's `SELECT`.

Back to our example:

```sql
WITH order_total_prices AS (
  SELECT
    o.order_id, 
    SUM(unit_price * quantity) AS total_price
  FROM orders o
  JOIN order_items oi
    ON o.order_id = oi.order_id
  GROUP BY o.order_id
)

SELECT
  AVG(total_price) AS avg_total_price
FROM order_total_prices;
```

Here, the CTE is called `order_total_prices` and allows us to access two columns: `order_id` and `total_price`. In the outer query, we aggregate the `total_price` column using `AVG(total_price)`. As a result, we'll get a single number in the report.

### Exercise

Modify the query from the previous exercise to show the average total price **after discount**. Rename the `avg_total_price` column to `avg_total_discounted_price`.

```sql
WITH order_total_prices AS (
  SELECT
    o.order_id, 
    SUM(unit_price * quantity * (1 - discount)) AS total_price
  FROM orders o
  JOIN order_items oi
    ON o.order_id = oi.order_id
  GROUP BY o.order_id
)
SELECT
  AVG(total_price) AS avg_total_discounted_price
FROM order_total_prices;
```

Output:

| avg_total_discounted_price |
|:------:|
| 1525.0518548192771084 |

### Exercise 2

Good! Now we'll show you how to write your own multi-level aggregation query. As we said earlier, we'll go step by step. Let's start with finding the average number of items in each order.

Now, we'll count the items in each query.

Create a simple query (no CTE needed) that will show two columns: `order_id` and `item_count`. The `item_count` column should show the sum of quantities of all items in a given order.

```sql
SELECT
  o.order_id,
  SUM(quantity) AS item_count
FROM orders o
JOIN order_items oi
  ON o.order_id = oi.order_id
GROUP BY o.order_id;
```

Output:

| order_id | item_count |
|:------:|:------:|
| 11038 | 37 |
| 10782 | 1 |
| 10725 | 22 |
| 10423 | 34 |

### Exercise 3

Okay! Now that we have a query that counts the number of items in each order, let's turn it into a CTE and calculate the **average number of items for all orders**.

Now you need to show a single column named `avg_item_count` that contains the average number of items in a single order.

```sql
WITH order_item_counts AS (
  SELECT
    o.order_id,
    SUM(quantity) AS item_count
  FROM orders o
  JOIN order_items oi
    ON o.order_id = oi.order_id
  GROUP BY o.order_id
)
SELECT
  AVG(item_count) AS avg_item_count
FROM order_item_counts;
```

Output:

| avg_item_count |
|:------:|
| 61.8277108433734940 |

### Exercise 4

Good job! It's not that difficult, as you can see.

Whenever you write a report with multi-level aggregation, it's usually easiest to start by creating the inner query independently, and then turning it into a CTE by adding an outer query.

Now it's time to write your first multi-level aggregation report!

What's the average number of products in each category? Show a single value in a column named `avg_product_count`.

In the inner query, calculate the number of products for each category ID. In the outer query, find the average product count.

```sql
WITH product_counts AS (
  SELECT
    c.category_id,
    COUNT(p.product_id) AS product_count
  FROM categories c
  JOIN products p USING (category_id)
  GROUP BY c.category_id
)
SELECT
  AVG(product_count) AS avg_product_count
FROM product_counts;
```

Output:

| avg_product_count |
|:------:|
| 9.6250000000000000 |

## Alternative syntax

Good job! There is also an alternative CTE syntax that looks like this:

```sql
WITH order_total_prices (order_id, total_price) AS (
  SELECT
    o.order_id, 
    SUM(unit_price * quantity)
  FROM orders o
  JOIN order_items oi
    ON o.order_id = oi.order_id
  GROUP BY o.order_id
)

SELECT
  AVG(total_price) AS avg_total_price
FROM order_total_prices;
```

This time, we provided the column names right after the CTE's name, inside a pair of parentheses:

```sql
WITH order_total_prices (order_id, total_price) AS ...
```

This way, we didn't have to use the AS keyword to name the columns inside the CTE.

This syntax is completely optional. It's up to you whether you want to use it, and it depends on your personal preferences.

### Exercise

Try to rewrite the template query so that it uses the syntax presented in the explanation.

```sql
WITH order_total_prices (order_id, total_price) AS (
  SELECT
    o.order_id, 
    SUM(unit_price * quantity)
  FROM orders o
  JOIN order_items oi
    ON o.order_id = oi.order_id
  GROUP BY o.order_id
)

SELECT
  AVG(total_price) AS avg_total_price
FROM order_total_prices;
```

Output:

| avg_total_price |
|:------:|
| 1631.8778192771084337 |

## Multi-level aggregation in groups – theory

Good job! The queries we've written so far all returned a single value. Let's change that.

Suppose we want to find the average order value for each customer from Canada. How can we do that? Let's find out.

```sql
WITH order_total_prices AS (
  SELECT
    o.order_id,
    o.customer_id,
    SUM(unit_price * quantity) AS total_price
  FROM orders o
  JOIN order_items oi
    ON o.order_id = oi.order_id
  GROUP BY o.order_id, o.customer_id
)

SELECT
  c.customer_id,
  c.company_name,
  AVG(total_price) AS avg_total_price
FROM order_total_prices OTP
JOIN customers c
  ON OTP.customer_id = c.customer_id
WHERE c.country = 'Canada'
GROUP BY c.customer_id, c.company_name;
```

In the query above, we first write a CTE that calculates the total price (before discount) for each order. Note that we also put the `customer_id` column in the `SELECT` clause so that we can refer to it in the outer query.

In the outer query, we use the `AVG()` function as before, but this time, we also group all rows by `customer_id`. We also join the CTE with another table (`customers`) so that we can show company names and select only those customers who come from Canada.

### Exercise 1

For each employee from the Washington (WA) region, show the average value for all orders they placed. Show the following columns: `employee_id`, `first_name`, `last_name`, and `avg_total_price` (calculated as the average total order price, before discount).

In the inner query, calculate the value of each order and select it alongside the ID of the employee who processed it. In the outer query, join the CTE with the `employees` table to show all the required information and filter the employees by region.

```sql
WITH order_total_prices AS (
  SELECT
    o.order_id,
    o.employee_id,
    SUM(unit_price * quantity) AS total_price
  FROM orders o
  JOIN order_items oi USING(order_id)
  GROUP BY o.order_id, o.employee_id
)

SELECT
  e.employee_id,
  e.first_name,
  e.last_name,
  AVG(total_price) AS avg_total_price
FROM order_total_prices OTP
JOIN employees e USING (employee_id)
WHERE e.region = 'WA'
GROUP BY e.employee_id, e.first_name, e.last_name;
```

Output:

| employee_id | first_name | last_name | avg_total_price |
|:------:|:------:|:------:|:------:|
| 1 | Nancy | Davolio | 1643.4447967479674797 |
| 2 | Andrew | Fuller | 1851.5547916666666667 |
| 3 | Janet | Leverling | 1677.5692913385826772 |
| 4 | Margaret | Peacock | 1606.8874193548387097 |

### Exercise 2

For each shipping country, we want to find the average count of unique products in each order. Show the `ship_country` and `avg_distinct_item_count` columns. Sort the results by count, in descending order.

In the inner query, find the number of distinct products in each order and select it alongside the `ship_country` column. In the outer query, apply the proper aggregation.

```sql
WITH order_item_counts AS (
  SELECT
    o.order_id,
    o.ship_country,
    COUNT(DISTINCT p.product_id) AS distinct_item_count
  FROM orders o
  JOIN order_items oi USING (order_id)
  JOIN products p USING (product_id)
  GROUP BY o.order_id, o.ship_country
)

SELECT
  ship_country,
  AVG(distinct_item_count) AS avg_distinct_item_count
FROM order_item_counts
GROUP BY ship_country
ORDER BY avg_distinct_item_count DESC;
```

Output:

| ship_country | avg_distinct_item_count |
|:------:|:------:|
| Austria | 3.1250000000000000 |
| Belgium | 2.9473684210526316 |
| Ireland | 2.8947368421052632 |
| Switzerland | 2.8888888888888889 |

### Exercise 3

For each employee, determine the average number of items they processed per order, for **all orders placed in 2016**. The number of items in an order is defined as the sum of all quantities of all items in that order. Show the following columns: `first_name`, `last_name`, and `avg_item_count`.

```sql
WITH order_item_counts AS (
  SELECT
    o.employee_id,
    e.first_name,
    e.last_name,
    SUM(oi.quantity) AS item_count
  FROM orders o
  JOIN order_items oi USING (order_id)
  JOIN employees e USING (employee_id)
  WHERE o.order_date BETWEEN '2016-01-01' AND '2016-12-31'
  GROUP BY o.order_id, o.employee_id, e.first_name, e.last_name
)

SELECT
  first_name,
  last_name,
  AVG(item_count) AS avg_item_count
FROM order_item_counts
GROUP BY employee_id, first_name, last_name
```

Output:

| first_name | last_name | avg_item_count |
|:------:|:------:|:------:|
| Nancy | Davolio | 62.3076923076923077 |
| Andrew | Fuller | 67.8125000000000000 |
| Janet | Leverling | 52.2222222222222222 |
| Margaret | Peacock | 72.2000000000000000 |

## Multi-level aggregation with CASE WHEN

Perfect! We can also combine multi-level aggregation with custom classifications. Suppose we want to find the number of customers divided into three groups: those with fewer than 10 orders, those with 10–20 orders, and those with more than 20 orders. Here's a query that can do just that:

```sql
WITH customer_order_counts AS (
  SELECT
    customer_id, 
    CASE
      WHEN COUNT(o.order_id) > 20
        THEN 'more than 20' 
      WHEN COUNT(o.order_id) <= 20 AND COUNT(o.order_id) >= 10
        THEN 'between 10 and 20'
      ELSE 'less than 10'
    END AS order_count_cat
  FROM orders o
  GROUP BY customer_id
) 

SELECT
  order_count_cat,
  COUNT(customer_id) AS customer_count
FROM customer_order_counts
GROUP BY order_count_cat;
```

In the inner query, we used the `CASE WHEN` construction to classify each customer into one of three groups. The customer’s group is shown in the `order_count_cat` column. Next, we used the `order_count_cat` column in the outer query with the `COUNT()` function to show the number of customers in each group.

### Exercise 1

Count the number of high value and low value customers. If the total price paid by a given customer for all their orders is **more than $20,000** before discounts, treat the customer as `'high-value'`. Otherwise, treat them as `'low-value'`.

Create a report with two columns: `category` (either `'high-value'` or `'low-value'`) and `customer_count`.

```sql
WITH customer_order_totals AS (
  SELECT
    customer_id,
    SUM(unit_price * quantity) AS total_price
  FROM orders o
  JOIN order_items oi USING (order_id)
  GROUP BY customer_id
)

SELECT
  CASE
    WHEN total_price > 20000
      THEN 'high-value'
    ELSE 'low-value'
  END AS category,
  COUNT(customer_id) AS customer_count
FROM customer_order_totals
GROUP BY category;
```

Output:

| category | customer_count |
|:------:|:------:|
| high-value | 20 |
| low-value | 69 |

### Exercise 2

What is the average number of products in non-vegetarian (`category_id` `6` or `8`) and vegetarian categories (all other `category_id` values)? Show two columns: `product_type` (either `'vegetarian'` or `'non-vegetarian'`) and `avg_product_count`.

```sql
WITH product_counts AS (
  SELECT
    category_id,
    COUNT(product_id) AS product_count,
    CASE
      WHEN category_id IN (6, 8)
        THEN 'non-vegetarian'
      ELSE 'vegetarian'
    END AS product_type
  FROM products
  GROUP BY category_id
)

SELECT
  product_type,
  AVG(product_count) AS avg_product_count
FROM product_counts
GROUP BY product_type
```

Output:

| product_type | avg_product_count |
|:------:|:------:|
| non-vegetarian | 9.0000000000000000 |
| vegetarian | 9.8333333333333333 |

## Three aggregation levels

Very well done!

Sometimes, we need more than two aggregation levels. For instance, we could calculate the average order value for each customer and then find the maximum average. Take a look at the query below:

```sql
WITH order_values AS (
  SELECT
    customer_id,
    SUM(unit_price * quantity) AS total_price
  FROM orders o
  JOIN order_items oi USING (order_id)
  GROUP BY customer_id, o.order_id
),

customer_averages AS (
  SELECT
    customer_id,
    AVG(total_price) AS avg_total_price
  FROM order_values
  GROUP BY customer_id
)

SELECT
  MAX(avg_total_price) AS maximal_average 
FROM customer_averages;
```

Notice that we introduced **two CTEs** this time. There is no `WITH` keyword before the second CTE; we simply need a comma to separate the two.

In the first CTE, we calculate the value of each order and select it alongside `customer_id`. In the second CTE, we compute the average order value for each customer based on the first CTE. Finally, in the outer query, we find the maximum average value from the second CTE.

### Exercise 1

For each employee, calculate the average order value (after discount) and then show the minimum average (name the column `minimal_average`) and the maximum average (name the column `maximal_average`) values.

**Hint:** Use two CTEs. In the first CTE, select the `employee_id` and the total price after discount for each order. In the second CTE, calculate the average order value after discount for each employee. Finally, in the outer query, use the `MIN()` and `MAX()` functions.

```sql
WITH order_values AS (
  SELECT
    employee_id,
    SUM(unit_price * quantity * (1 - discount)) AS total_price
  FROM orders o
  JOIN order_items oi USING (order_id)
  GROUP BY employee_id, o.order_id
),

employee_averages AS (
  SELECT
    employee_id,
    AVG(total_price) AS avg_total_price
  FROM order_values
  GROUP BY employee_id
)

SELECT
  MIN(avg_total_price) AS minimal_average,
  MAX(avg_total_price) AS maximal_average
FROM employee_averages;
```

Output:

| minimal_average | maximal_average |
|:------:|:------:|
| 1103.1810373134328358 | 1797.8620116279069767 |

### Exercise 2 - Intro

Good job! Now, let's take a look at a slightly different example.

Say we want to count the number of orders processed by each employee, and we only want to show the employees whose `order_count` is greater than the average `order_count` for all employees. Have a look:

```sql
WITH order_count_employees AS (
  SELECT
    employee_id,
    COUNT(order_id) AS order_count
  FROM orders
  GROUP BY employee_id
),

avg_order_count AS (
  SELECT
    AVG(order_count) AS avg_order_count
  FROM order_count_employees
)

SELECT
  employee_id,
  order_count,
  avg_order_count
FROM order_count_employees,
  avg_order_count
WHERE order_count > avg_order_count;
```

In the first CTE, we count the number of orders processed by each employee. In the second CTE, we find the average order count based on the first CTE. But look what happens in the outer query: We simply provide both CTE names in the FROM clause, separated with a comma. Thanks to this, we can refer to columns from both CTEs in the `WHERE` clause and show all columns in the `SELECT` clause. As a result, each employee with an above average order count will be shown with their order count. We'll also show the average count for reference:

| employee_id | order_count | avg_order_count |
|:------:|:------:|:------:|
| 1 |	123 |	92 |
| 2 |	96  | 92 |
| 3 |	127 |	92 |
| 4 |	156 |	92 |
| 8 |	104 |	92 |

### Exercise 2 - Practice

Among orders shipped to Italy, show all orders that had an above-average total value (before discount). Show the `order_id`, `order_value`, and `avg_order_value` column. The `avg_order_value` column should show the same average order value for all rows.

```sql
WITH order_values AS (
  SELECT
    order_id,
    SUM(unit_price * quantity) AS order_value
  FROM orders o
  JOIN order_items oi USING (order_id)
  WHERE ship_country = 'Italy'
  GROUP BY order_id
),

avg_order_value AS (
  SELECT
    AVG(order_value) AS avg_order_value
  FROM order_values
)

SELECT
  order_id,
  order_value,
  avg_order_value
FROM order_values,
  avg_order_value
WHERE order_value > avg_order_value;
```

Output:

| order_id | order_value | avg_order_value |
|:------:|:------:|:------:|
| 10300 |	608.00  | 596.6125000000000000 |
| 10404 |	1675.00 |	596.6125000000000000 |
| 10635 |	1380.25 |	596.6125000000000000 |
| 10727 |	1710.00 |	596.6125000000000000 |

## Summary

Good job! Now, let's wrap things up. First, here's a summary of what we've covered in this part:

1. Multi-level aggregations require common table expressions (CTEs). The most basic CTE looks like this:

```sql
WITH inner_query_name AS (
  SELECT
    function(column_1) AS agg_column_1
  FROM ...
)
SELECT
  function(agg_column_1)
FROM inner_query_name;
```

2. We can add a GROUP BY clause in the outer query to show multi-level aggregation for multiple business objects:

```sql
WITH inner_query_name AS (
  SELECT
    function(column_1) AS agg_column_1,
    column_2
  FROM ...
)
SELECT function(agg_column_1)
FROM inner_query_name
GROUP BY column_2;
```

3. We can also use a CASE WHEN construction to introduce our own classifications into multi-level aggregations:

```sql
WITH inner_query_name AS (
  SELECT
    function(column_1) AS agg_column_1, 
    CASE
      WHEN ...
    END AS column_2
  FROM ...
)
SELECT function(agg_column_1)
FROM inner_query_name
GROUP BY column_2;
```

4. Finally, we can use more than one CTE in a query:

```sql
WITH cte_1 AS (...),
cte_2 AS (...),
...,
cte_n AS (...)
SELECT
  ...
```

Let's solve a few problems before we go...

### Exercise 1

What's the average number of orders that were **processed by a single employee and shipped to the USA or Canada**? Show the answer in a column named `avg_order_count`.

```sql
WITH order_count_employees AS (
  SELECT
    employee_id,
    COUNT(order_id) AS order_count
  FROM orders
  WHERE ship_country IN ('USA', 'Canada')
  GROUP BY employee_id
),

avg_order_count AS (
  SELECT
    AVG(order_count) AS avg_order_count
  FROM order_count_employees
)

SELECT
  avg_order_count
FROM avg_order_count;
```

Output:

| avg_order_count |
|:------:|
| 16.8888888888888889 |

### Exercise 2

Find the average order value (after discount) for each customer. Show the `customer_id` and `avg_discounted_price` columns.

```sql
WITH order_values AS (
  SELECT
    customer_id,
    SUM(unit_price * quantity * (1 - discount)) AS total_price
  FROM orders o
  JOIN order_items oi USING (order_id)
  GROUP BY customer_id, o.order_id
),

customer_averages AS (
  SELECT
    customer_id,
    AVG(total_price) AS avg_total_price
  FROM order_values
  GROUP BY customer_id
)

SELECT
  customer_id,
  avg_total_price AS avg_discounted_price
FROM customer_averages;
```

Output:

| customer_id | avg_discounted_price |
|:------:|:------:|
| TOMSP |	796.3566666666666667 |
| OLDWO |	1517.7462500000000000 |
| MAGAA |	717.6215000000000000 |
| QUEEN |	1978.2690384615384615 |

### Exercise 3

We want to see if cheaper products are currently being ordered in larger quantities.

Create a report with two columns: `price_category` (which will contain either `'cheap'` for products with a maximum `unit_price` of `20.0` or `'expensive'` otherwise) and `avg_products_on_order` (the average number of units on order for a given price category).

```sql
WITH order_values AS (
  SELECT
    units_on_order,
    CASE
      WHEN unit_price <= 20.0 THEN 'cheap'
      ELSE 'expensive'
    END AS price_category
  FROM products
)

SELECT
  price_category,
  AVG(units_on_order) AS avg_products_on_order
FROM order_values
GROUP BY price_category;
```

## Congratulations

Very well done! This was the last exercise on multi-level aggregation, and you nailed it. Congratulations!
