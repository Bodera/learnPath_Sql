# Multiple Metrics in One Report

Discover how to include multiple metrics in a single report.

Hello and welcome back! This part will teach you how to combine multiple metrics in a single SQL report. More importantly, you'll learn how to deal with proportions and percentages – an important concept and one frequently found in various business reports.

Let's get started!

## Multiple metrics for a single object – explanation

We will start with a simple report that shows multiple metrics for the same business object. Let's say we need to show the number of products and the total price for each order. Take a look at the query below:

```sql
SELECT
  order_id,
  COUNT(product_id) AS products,
  SUM(unit_price * quantity) AS total_price
FROM order_items 
GROUP BY order_id;
```

We use `COUNT()` and `SUM()` in two separate columns to show two different metrics for the same business object (i.e., for the same order). In this case, we used the order_items table to show the number of line items and the total price for each order. Note that we use the `GROUP BY` statement to compute metrics for different orders in one query.

### Exercise 1

We want to see each customer's ID alongside the number of orders they placed and the total revenue (after discount) that their purchases generated for us. Show three columns:

- The customer's ID (`customer_id`).
- The number of orders (as `order_count`).
- The total price paid for all orders after discounts (as `total_revenue_after_discount`).

**Not very performant way:**

```sql
SELECT
  customer_id,
  COUNT(DISTINCT order_id) AS order_count,
  SUM(unit_price * quantity * (1 - discount)) AS total_revenue_after_discount
FROM orders o
JOIN order_items USING (order_id)
GROUP BY customer_id;
```

**More performant way:**

```sql
WITH order_values AS (
  SELECT
    order_id,
    SUM(unit_price * quantity * (1 - discount)) AS total_revenue_after_discount
  FROM order_items
  GROUP BY order_id
)

SELECT
  customer_id,
  COUNT(order_id) AS order_count,
  SUM(total_revenue_after_discount) AS total_revenue_after_discount
FROM orders o
JOIN order_values USING (order_id)
GROUP BY customer_id;
```

Output:

| customer_id | order_count | total_revenue_after_discount |
|:------:|:------:|:------:|
| ALFKI |	6	|  4273.0000 |
| ANATR |	4	| 1402.9500 |
| ANTON |	7	| 7023.9775 |

### Exercise 2

For each employee, determine their performance for 2016: Compute the total number and the total revenue for orders processed by each employee. Show the employee's first name (`first_name`), last name (`last_name`), and the two metrics in columns named `order_count` (total number of orders processed by the employee) and `order_revenue` (total revenue for orders processed by the employee).

**Not very performant way:**

```sql
SELECT
  e.first_name,
  e.last_name,
  COUNT(DISTINCT o.order_id) AS order_count,
  SUM(oi.unit_price * oi.quantity * (1 - oi.discount)) AS order_revenue
FROM employees e
  JOIN orders o USING (employee_id)
  JOIN order_items oi USING (order_id)
WHERE o.order_date BETWEEN '2016-01-01' AND '2016-12-31'
GROUP BY e.employee_id, e.first_name, e.last_name;
```

**More performant way:**

```sql
WITH order_values AS (
  SELECT
    order_id,
    SUM(unit_price * quantity * (1 - discount)) AS order_revenue
  FROM order_items
  GROUP BY order_id
)

SELECT
  e.first_name,
  e.last_name,
  COUNT(o.order_id) AS order_count,
  SUM(ov.order_revenue) AS order_revenue
FROM employees e
  JOIN orders o USING (employee_id)
  JOIN order_values ov USING (order_id)
WHERE o.order_date BETWEEN '2016-01-01' AND '2016-12-31'
GROUP BY e.employee_id, e.first_name, e.last_name;
```

Output:

| # | first_name | last_name | order_count | order_revenue  |
|:---:|:----------:|:---------:|:-----------:|:--------------:|
| 1 | Nancy      | Davolio   | 26          | 35764.5150     |
| 2 | Andrew     | Fuller    | 16          | 21757.0600     |
| 3 | John       | Smith     | 18          | 18223.9600     |

## Custom metrics – explanation

Very well done! Often, you want to create reports where you count the number of objects in two different groups, based on your classification. Look at the following query:

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

The report above shows each `customer_id` alongside the number of orders already shipped to that customer and the number of orders that have not yet been shipped. Note that we use `COUNT()` with `CASE WHEN` twice to count the number of objects in the two different groups. Both metrics, however, refer to the same business object (the same customer).

### Exercise 1

For each category, show the number of products in stock (i.e., products where `units_in_stock > 0`) and the number of products not in stock. The report should contain three columns:

- `category_name`
- `products_in_stock`
- `products_not_in_stock`

```sql
SELECT
  category_name,
  COUNT(CASE
    WHEN units_in_stock > 0
      THEN product_id
  END) AS products_in_stock,
  COUNT(CASE
    WHEN units_in_stock = 0
      THEN product_id
  END) AS products_not_in_stock
FROM products
  JOIN categories USING (category_id)
GROUP BY category_name;
```

Output:

| # | category_name  | products_in_stock | products_not_in_stock  |
|:---:|:--------------:|:-----------------:|:----------------------:|
| 1 | Grains/Cereals | 7                 | 0                      |
| 2 | Seafood        | 12                | 0                      |
| 3 | Meat/Poultry   | 3                 | 3                      |

### Exercise 2

For each order, determine how many line items (unique products) were discounted and how many weren't. Show three columns:

- The order ID (`order_id`).
- The number of line items that were not discounted (as `full_price_product_count`).
- The number of line items that were discounted (as `discount_product_count`)

```sql
SELECT
  order_id,
  COUNT(CASE
    WHEN discount = 0
      THEN product_id
  END) AS full_price_product_count,
  COUNT(CASE
    WHEN discount > 0
      THEN product_id
  END) AS discount_product_count
FROM order_items
GROUP BY order_id;
```

Output:

| # | order_id | full_price_product_count | discount_product_count  |
|:---:|:--------:|:------------------------:|:-----------------------:|
| 1 | 11038    | 2                        | 1                       |
| 2 | 10782    | 1                        | 0                       |
| 3 | 10725    | 3                        | 0                       |

## Calculating ratios – step 1

Excellent! How can we compute percentages and ratios in our reports? Let's find out.

Suppose we want to know what percentage of all orders have already been shipped. We'll write this query in a few steps. Here's step 1:

```sql
SELECT
  COUNT(CASE
    WHEN shipped_date IS NOT NULL
      THEN order_id
  END) AS count_shipped,
  COUNT(order_id) AS count_all
FROM orders;
```

In this step, we simply calculate two separate columns: the **numerator** and the **denominator** of our ratio. In this case, the numerator is the number of orders shipped and the denominator is the total number of orders.

Note how we used `COUNT()` with `CASE WHEN` to compute one metric (number of orders shipped) and `COUNT()` to compute the other metric (total number of orders).

### Exercise

We want to find the ratio of the revenue from all discounted items to the total revenue from all items. We'll do this in steps too.

First, show two columns:

1. `discounted_revenue` – the revenue (after discount) from all discounted line items in all orders.
2. `total_revenue` – the total revenue (after discount) from line items in all orders.

```sql
SELECT
  SUM(
    CASE WHEN discount > 0
      THEN unit_price * quantity * (1 - discount)
    END
  ) AS discounted_revenue,
  SUM(unit_price * quantity * (1 - discount)) AS total_revenue
FROM order_items;
```

Output:

| # | discounted_revenue | total_revenue  |
|:---:|:------------------:|:--------------:|
| 1 | 515094.4295        | 1265793.0395   |


## Calculating ratios – step 2

Perfect! Now,we'll add a third column to our query:

```sql
SELECT
  COUNT(CASE
    WHEN shipped_date IS NOT NULL
      THEN order_id
  END) AS count_shipped,
  COUNT(order_id) AS count_all,
  COUNT(CASE
    WHEN shipped_date IS NOT NULL
      THEN order_id
  END) / CAST(COUNT(order_id) AS decimal) AS shipped_ratio
FROM orders;
```

In the third column, we calculate the **ratio** by dividing the expression from the first column by the expression from the second column. However, both of these values are integers, so we need to force SQL to use floating-point division. To do that, we cast one of the metrics to the `decimal` data type: `CAST(COUNT(order_id) AS decimal)`.

### Exercise

Add a third column to the SQL made on previous exercise: `discounted_ratio`. It should contain the ratio of discounted line items (from column 1) to all line items (from column 2).

```sql
SELECT
  SUM(
    CASE WHEN discount > 0
      THEN unit_price * quantity * (1 - discount)
    END
  ) AS discounted_revenue,
  SUM(unit_price * quantity * (1 - discount)) AS total_revenue,
  SUM(
    CASE WHEN discount > 0
      THEN unit_price * quantity * (1 - discount)
    END
  ) / CAST(SUM(unit_price * quantity * (1 - discount)) AS decimal) AS discounted_ratio
FROM order_items;
```

Output:

| # | discounted_revenue | total_revenue | discounted_ratio       |
|:---:|:------------------:|:-------------:|:----------------------:|
| 1 | 515094.4295        | 1265793.0395  | 0.40693416176744587005 |

## Calculating ratios – step 3

Good job! Even though we already computed the final ratio in step 2, we typically also want to round the ratio to a given number of decimal places. To that end, we can use the `ROUND(value, decimal_places)` function. Take a look:

```sql
SELECT
  COUNT(CASE
    WHEN shipped_date IS NOT NULL
      THEN order_id
  END) AS count_shipped,
  COUNT(order_id) AS count_all,
  ROUND(COUNT(CASE
    WHEN shipped_date IS NOT NULL
      THEN order_id
  END) / CAST(COUNT(order_id) AS decimal), 2) AS shipped_ratio
FROM orders;
```

We surrounded the last column with the `ROUND(..., 2)` function invocation. Because the second argument is `2`, we'll get the ratio rounded to **two decimal places**.

### Exercise

Round the ratio from the `discounted_ratio` column to **three decimal places**.

```sql
SELECT 
  SUM(
    CASE WHEN discount > 0 THEN unit_price * quantity * (1 - discount) END
  ) AS discounted_revenue, 
  SUM(
    unit_price * quantity * (1 - discount)
  ) AS total_revenue, 
  ROUND(
    SUM(
      CASE WHEN discount > 0 THEN unit_price * quantity * (1 - discount) END
    ) / SUM(
      unit_price * quantity * (1 - discount)
    ), 
    3
  ) AS discounted_ratio 
FROM 
  order_items;
```

Output:

| # | discounted_revenue | total_revenue | discounted_ratio       |
|:---:|:------------------:|:-------------:|:----------------------:|
| 1 | 515094.4295        | 1265793.0395  | 0.407 |

## Calculating percentages – step 4

Great work! We originally wanted to see a percentage, so let's modify our query a little bit to calculate a percentage instead of a ratio. Here's step 4:

```sql
SELECT
  COUNT(CASE
    WHEN shipped_date IS NOT NULL
      THEN order_id
  END) AS count_shipped,
  COUNT(order_id) AS count_all,
  ROUND(COUNT(CASE
    WHEN shipped_date IS NOT NULL
      THEN order_id
  END) / CAST(COUNT(order_id) AS decimal) * 100, 2) AS shipped_ratio
FROM orders;
```

Note that we multiply the result of the division inside the `ROUND()` function by `100` to get a percentage instead of a ratio.

### Exercise

What is the percentage of discontinued items at Northwind? Show three columns: `count_discontinued`, `count_all`, and `percentage_discontinued`. Round the last column to two decimal places.

```sql
SELECT
  COUNT(
    CASE
        WHEN discontinued
        THEN product_id
    END) AS count_discontinued,
  COUNT(product_id) AS count_all,
  ROUND(COUNT(
    CASE
        WHEN discontinued
        THEN product_id
    END) / CAST(COUNT(product_id) AS decimal) * 100, 2) AS percentage_discontinued
FROM products;
```

Output:

| # | count_discontinued | count_all | percentage_discontinued  |
|:---:|:------------------:|:---------:|:------------------------:|
| 1 | 8                  | 77        | 10.39                    |

## Calculating percentages in groups – explanation

Very well done! One more thing we can do is show ratios/percentages in groups. Take a look:

```sql
SELECT
  ship_country,
  COUNT(CASE
    WHEN shipped_date IS NOT NULL
      THEN order_id
  END) AS count_shipped,
  COUNT(order_id) AS count_all,
  ROUND(COUNT(CASE
    WHEN shipped_date IS NOT NULL
      THEN order_id
  END) / CAST(COUNT(order_id) AS decimal) * 100, 2) AS shipped_ratio
FROM orders
GROUP BY ship_country;
```

We've added the `ship_country` column to the `GROUP BY` and `SELECT` clauses. This way, we'll see the percentage of shipped orders for each country separately.

### Exercise 1

Modify the query from previous exercise so that it shows all data grouped by product category. Add `category_name` as the first column in the `SELECT` clause.

```sql
SELECT
  category_name,
  COUNT(CASE
    WHEN discontinued IS TRUE
      THEN product_id
  END) AS count_discontinued,
  COUNT(product_id) AS count_all,
  ROUND(COUNT(CASE
    WHEN discontinued IS TRUE
      THEN product_id
  END) / CAST(COUNT(product_id) AS decimal) * 100, 2) AS percentage_discontinued
FROM products
JOIN categories USING (category_id)
GROUP BY category_name;
```

Output:

| # | category_name  | count_discontinued | count_all | percentage_discontinued  |
|:---:|:--------------:|:------------------:|:---------:|:------------------------:|
| 1 | Grains/Cereals | 1                  | 7         | 14.29                    |
| 2 | Seafood        | 0                  | 12        | 0.00                     |
| 3 | Meat/Poultry   | 4                  | 6         | 66.67                    |

### Exercise 2

For each employee, find the percentage of all orders they processed that were placed by customers in France. Show five columns: `first_name`, `last_name`, `count_france`, `count_all`, and `percentage_france` (rounded to one decimal point).

Note: To find the country where a customer is based, use the `country` column from the `customers` table.

```sql
SELECT
  e.first_name,
  e.last_name,
  COUNT(CASE
    WHEN c.country = 'France'
      THEN order_id
  END) AS count_france,
  COUNT(order_id) AS count_all,
  ROUND(COUNT(CASE
    WHEN c.country = 'France'
      THEN order_id
  END) / CAST(COUNT(order_id) AS decimal) * 100, 1) AS percentage_france
FROM employees e
JOIN orders o USING (employee_id)
JOIN customers c USING (customer_id)
GROUP BY e.employee_id, e.first_name, e.last_name;
```

Output:

| # | first_name | last_name | count_france | count_all | percentage_france  |
|:---:|:----------:|:---------:|:------------:|:---------:|:------------------:|
| 1 | Margaret   | Peacock   | 14           | 155       | 9.0                |
| 2 | John       | Smith     | 0            | 1         | 0.0                |
| 3 | Michael    | Suyama    | 9            | 67        | 13.4               |
| 4 | Andrew     | Fuller    | 11           | 96        | 11.5               |

## Global vs. specific metrics – explanation

Great! The final report type we'll talk about in this part shows what proportion of the whole each group represents.

Suppose that we want to create a report that shows information about the customers who placed orders in July 2016 and the percentage of total monthly revenue each customer generated. We can use the following code:

```sql
WITH total_sales AS (
  SELECT 
    SUM(quantity * unit_price) AS july_sales 
  FROM order_items oi
  JOIN orders o
    ON o.order_id = oi.order_id
  WHERE order_date >= '2016-07-01' AND order_date < '2016-08-01'
)
SELECT 
  c.customer_id, 
  SUM(quantity * unit_price) AS revenue, 
  ROUND(SUM(quantity * unit_price) / CAST(total_sales.july_sales AS decimal) * 100, 2) AS revenue_percentage
FROM total_sales,
  customers c
JOIN orders o
  ON c.customer_id = o.customer_id 
JOIN order_items oi
  ON oi.order_id = o.order_id
WHERE order_date >= '2016-07-01' AND order_date < '2016-08-01'
GROUP BY c.customer_id, total_sales.july_sales;
```

In the CTE, we simply calculate the **total monthly revenue** from July 2016. In the outer query, we show each `customer_id` alongside that customer's revenue in July 2016. But note what happens in the last column: We divide the customer's revenue (from the previous column) by the `july_sales` value from the CTE. This gives us the revenue percentage generated by a given customer.

Note that we had to add the `july_sales` column to the `GROUP BY` clause because it wasn't used with any aggregate function.

Naturally, the outer query only makes sense when it has the same `WHERE` clause as the inner query. Also, note that we join the `total_sales` and the customers tables in the following way:

```sql
FROM total_sales, customers c
```

This ensures that all rows (here, the only row) from the `total_sales` CTE are combined with all rows from the `customers` table. As a result, the `july_sales` value is available in all rows of the `total_sales`-`customers` combination.

### Exercise 1

We want to see each employee alongside the number of orders they processed in 2017 and the percentage of all orders from 2017 that they generated. Show the following columns:

- `employee_id`.
- `first_name`.
- `last_name`.
- `order_count` – the number of orders processed by that employee in 2017.
- `order_count_percentage` – the percentage of orders from 2017 processed by that employee.

Round the value of the last column to two decimal places.

**Less perfect solution:**

```sql
WITH total_count AS (
  SELECT
    COUNT(order_id) AS all_orders
  FROM orders 
  WHERE EXTRACT(YEAR FROM order_date) = 2017 
)

SELECT
  e.employee_id,
  e.first_name,
  e.last_name,
  COUNT(order_id) as order_count ,
  ROUND(COUNT(order_id) / CAST(total_count.all_orders AS decimal) * 100, 2) AS order_count_percentage
FROM total_count, 
  employees e
JOIN orders o
  ON e.employee_id = o.employee_id
  WHERE EXTRACT(YEAR FROM order_date) = 2017 
GROUP BY e.employee_id,
  e.first_name,
  e.last_name,
total_count.all_orders
```

**More performant solution:**

```sql
SELECT
  e.employee_id,
  e.first_name,
  e.last_name,
  COUNT(o.order_id) as order_count,
  ROUND(COUNT(o.order_id) * 100.0 / SUM(COUNT(o.order_id)) OVER (), 2) AS order_count_percentage
FROM employees e
JOIN orders o
  ON e.employee_id = o.employee_id
WHERE EXTRACT(YEAR FROM o.order_date) = 2017
GROUP BY e.employee_id, e.first_name, e.last_name
```

Output:

| employee_id | first_name | last_name | order_count | order_count_percentage |
| :---: | :---: | :---: | :---: | :---: |
| 1	| Nancy |	Davolio |	55 | 13.48 |
| 2	| Andrew |	Fuller |	41 | 10.05 |
| 3 |	John |	Smith	| 71 | 17.40 |

### Exercise 2

For each country, find the percentage of revenue generated by orders shipped to it in 2018. Show three columns:

- `ship_country`.
- `revenue` – the total revenue generated by all orders shipped to that country in 2018.
- `revenue_percentage` – the percentage of that year's revenue generated by orders shipped to that country in 2018.

Round the percentage to two decimal places. Consider revenue without discount. Order the results in descending order by the `revenue` column.

```sql
WITH total_sales AS (
  SELECT 
    SUM(quantity * unit_price) AS sales_2018 
  FROM order_items oi
  JOIN orders o
    ON o.order_id = oi.order_id
  WHERE EXTRACT(YEAR FROM o.shipped_date) = 2018
)

SELECT
  o.ship_country,
  SUM(oi.unit_price * oi.quantity) AS revenue,
  ROUND(SUM(quantity * unit_price) / total_sales.sales_2018 * 100, 2) AS revenue_percentage
FROM total_sales, orders o
  JOIN order_items oi USING (order_id)
WHERE EXTRACT(YEAR FROM o.shipped_date) = 2018
GROUP BY o.ship_country, total_sales.sales_2018 
ORDER BY revenue DESC;
```

Output:

| ship_country | revenue | revenue_percentage |
| :---: | :---: | :---: |
| USA |	101311.88 |	21.65 |
| Germany |	85970.26 |	18.38 |
| Brazil |	44275.12 |	9.46 |

## Summary

It's time to wrap things up! Let's review the concepts we've covered in this part:

1. We can calculate multiple metrics for a given business object using multiple aggregate functions in a single query.

2. We can use `COUNT(CASE WHEN ...)` multiple times in a single query to count objects in multiple groups.

3. When calculating percentages, remember to cast one of the counts to the `decimal` type. You can also use the `ROUND()` function, like this:

    ```sql
    ROUND(count_shipped / CAST(count_all AS decimal) * 100, 2) AS shipped_ratio
    ```

All right, how about a quiz before we move on?

### Exercise 1

Find the number of products supplied and the average unit price for each supplier. Show three columns: `company_name`, `product_count`, and `avg_unit_price`. Don't show the suppliers who haven't supplied any products.

```sql
SELECT
  s.company_name,
  COUNT(p.product_id) AS product_count,
  AVG(p.unit_price) AS avg_unit_price
FROM products p
JOIN suppliers s
  ON s.supplier_id = p.supplier_id
GROUP BY s.supplier_id, s.company_name
```

Output:

| company_name | product_count | avg_unit_price |
| :---: | :---: | :---: |
| Zaanse Snoepfabriek |	2	| 11.1250000000000000
| Heli Süßwaren GmbH & Co. KG	| 3 |	29.7100000000000000
| PB Knäckebröd AB	| 2 |	15.0000000000000000

### Exercise 2

For each category, find the number of products the store offers and the number of products that have been discontinued. Show three columns: 

- `category_name`,
- `products_available`,
- and `products_discontinued`.

```sql
SELECT
  c.category_name,
  COUNT(CASE WHEN NOT p.discontinued THEN p.product_id END) AS products_available,
  COUNT(CASE WHEN p.discontinued THEN p.product_id END) AS products_discontinued
FROM products p
JOIN categories c
  ON c.category_id = p.category_id
GROUP BY c.category_id, c.category_name
```

Output:

| category_name | products_available | products_discontinued |
| :---: | :---: | :---: |
| Grains/Cereals |	6 |	1
| Dairy Products |	10 |	0
| Meat/Poultry |	2 |	4 

### Exercise 3

What percentage of all products are unavailable (have no units in stock)? Show three columns:

- `count_unavailable`,
- `count_all`,
- and `unavailable_percentage`.

Round the percentage to three decimal places.

```sql
SELECT
  COUNT(CASE WHEN p.units_in_stock = 0 THEN p.product_id END) AS count_unavailable,
  COUNT(p.product_id) AS count_all,
  ROUND(COUNT(CASE WHEN p.units_in_stock = 0 THEN p.product_id END) / CAST(COUNT(p.product_id) AS decimal) * 100, 3) AS unavailable_percentage
FROM products p
```

Output:

| count_unavailable | count_all | unavailable_percentage |
| :---: | :---: | :---: |
| 5 |	77 | 6.494

### Exercise 4

What percentage of all orders placed in 2016 were generated by each customer? Show three columns:

- `customer_id`
- `order_count` – the number of orders placed by that customer in 2016
- `order_count_percentage` – the percentage of orders placed by that customer in 2016, compared to all orders placed in 2016. Round the value to two decimal places.

```sql
SELECT
  c.customer_id,
  COUNT(o.order_id) AS order_count,
  ROUND(COUNT(o.order_id) / CAST(SUM(COUNT(o.order_id)) OVER () AS decimal) * 100, 2) AS order_count_percentage
FROM orders o
JOIN customers c
  ON c.customer_id = o.customer_id
WHERE EXTRACT(YEAR FROM o.order_date) = 2016
GROUP BY c.customer_id
```

Output:

| customer_id | order_count | order_count_percentage |
| :---: | :---: | :---: |
| ANATR |	1 |	0.66
| ANTON |	1 |	0.66
| AROUT |	2 |	1.32

## Congratulations

Very well done! That was the last question, and you solved it perfectly. Congratulations!
