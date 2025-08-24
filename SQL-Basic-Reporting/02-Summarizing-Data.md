# Summarizing Data in SQL

Learn how to create simple yet useful business metrics.

In this part, we're going to create **basic reports**. We'll also show you how to enrich them with some fundamental metrics. This will prepare you for the advanced reports we'll create later in this course.

Are you ready?

## Detail reports

Let's get started. The easiest type of report we can create contains a lot of **detailed information** about one or more business objects. The information we need may be scattered across multiple tables, so we want to bring it all together into a single report. In SQL, we use one or more `JOIN` clauses to do this. Take a look:

```sql
SELECT
  c.company_name AS customer_company_name, 
  e.first_name AS employee_first_name, 
  e.last_name AS employee_last_name,
  o.order_date,
  o.shipped_date,
  o.ship_country
FROM orders o
JOIN employees e
  ON o.employee_id = e.employee_id
JOIN customers c
  ON o.customer_id = c.customer_id
WHERE o.ship_country = 'France';
```

In the above query, we want to collect various information about orders shipped to France. We want some details about the customers and employees involved in those orders, so we need to join the `orders` table with the `employees` and `customers` tables. Note that each table was given a one-letter alias (such as `e` for employees). This reduces the amount of code we have to write and is a common practice when working with long SQL queries.

### Exercise

Your turn now!

Show the following information related to all items with `order_id = 10248`: the **product name**, the **unit price** (taken from the `order_items` table), the **quantity**, and the name of the **supplier's company** (as `supplier_name`).

```sql
SELECT
    p.product_name,
    oi.unit_price,
    oi.quantity,
    s.company_name AS supplier_name
FROM order_items oi
    JOIN products p ON p.product_id = oi.product_id
    JOIN suppliers s ON s.supplier_id = p.supplier_id
WHERE oi.order_id = 10248;
```

Output:

| product_name | unit_price | quantity | supplier_name |
| :---------: | :-------: | :------: | :----------: |
| Queso Cabrales | 14.00 | 12 | Cooperativa de Quesos 'Las Cabras' |
| Singaporean Hokkien Fried Mee | 9.80 | 10 | Leka Trading |
| Mozzarella di Giovanni | 34.80 | 5 | Formaggi Fortini s.r.l. |

### Detail reports – exercise

Excellent! Let's try a similar exercise.

Show the following information for each product: the **product name**, the **company name** of the product supplier (use the `suppliers` table), the **category name**, the **unit price**, and the **quantity per unit**.

```sql
SELECT
    p.product_name,
    s.company_name,
    c.category_name,
    p.unit_price,
    p.quantity_per_unit
FROM products p
    JOIN suppliers s ON s.supplier_id = p.supplier_id
    JOIN categories c ON c.category_id = p.category_id;
```

Output:

| product_name | company_name | category_name | unit_price | quantity_per_unit |
| :---------: | :---------: | :----------: | :-------: | :--------------: |
| Chai | Exotic Liquids | Beverages | 18.00 | 10 boxes x 20 bags |
| Chang | Exotic Liquids | Beverages | 19.00 | 24 - 12 oz bottles |
| Aniseed Syrup | Exotic Liquids | Condiments | 10.00 | 12 - 550 ml bottles |
| Chef Anton's Cajun Seasoning | New Orleans Cajun Delights | Condiments | 22.00 | 48 - 6 oz jars |

## Time-constrained reports

Good job! Another common report type is a report on certain objects, often based on a time filter. Take a look:

```sql
SELECT
  COUNT(*)
FROM orders
WHERE order_date >= '2016-07-01' AND  order_date < '2016-08-01';
```

In this query, we count the number of orders placed in July 2016. Note how we used the `WHERE` clause to get the time limit we're interested in.

Also note that dates in SQL are always placed inside single quotes and are typically formatted as `YYYY-MM-DD` (i.e., year-month-day). This may be a bit counterintuitive in countries that use other date formats, so watch out. Depending on the exact database engine you use and its configuration, your database may use a different date format. When in doubt, check your database documentation.

### Exercise

Count the number of employees hired in 2013. Name the result `number_of_employees`.

```sql
SELECT COUNT(*) AS number_of_employees
FROM employees
WHERE hire_date BETWEEN '2013-01-01' AND '2014-01-01';
```

| number_of_employees |
| :---------: |
| 3 |

## Computations for multiple objects

Well done! In business reports, we often want to calculate certain metrics for multiple business objects at the same time. For instance:

```sql
SELECT
  o.order_id,
  COUNT(*) AS order_items_count
FROM orders o
JOIN order_items oi
  ON o.order_id = oi.order_id
WHERE o.order_id BETWEEN 10200 AND 10300
GROUP BY o.order_id;
```

In the query above, we count the number of items in each order with an `order_id` in the specified range. By joining the `orders` and `order_items` tables, we can display information about a single order item and its parent order on the same row. Then, we **group** all rows by their parent order and use `COUNT(*)` to find the number of items in each order.

### Exercise

Show each `supplier_id` alongside the `company_name` and the number of products they supply (as the `products_count` column). Use the `products` and `suppliers` tables.

```sql
SELECT
    s.supplier_id,
    s.company_name,
    COUNT(p.product_id) AS products_count
FROM suppliers s
    JOIN products p ON s.supplier_id = p.supplier_id
GROUP BY s.supplier_id, company_name;
```

Output:

| supplier_id | company_name | products_count |
| :--------: | :---------: | :-----------: |
| 22 | Zaanse Snoepfabriek | 2 |
| 11 | Heli Süßwaren GmbH & Co. KG | 3 |
| 9 | PB Knäckebröd AB | 2 |
| 26 | Pasta Buttini s.r.l. | 2 |

## Total order value

Good job! In sales reports, we frequently need to calculate the **total amount** paid for an order. Let's take a look at how we can do that:

```sql
SELECT
  SUM(unit_price * quantity) AS total_price
FROM orders o
JOIN order_items oi
  ON o.order_id = oi.order_id
WHERE o.order_id = 10250;
```

We want to find the total price (before discount) for the order with ID of `10250`. As you can see, we use `SUM(unit_price * quantity)`. Like `COUNT()`, `SUM()` is frequently used in business reports.

### Exercise

The template code shows the query from the explanation. The Northwind store offers its customers discounts for some products. The discount for each item is stored in the `discount` column of the `order_items` table. (For example, a `0.20` discount means that the customer pays `1 - 0.2 = 0.8` of the original price.) Your task is to add a second column named `total_price_after_discount`.

```sql
SELECT
  SUM(unit_price * quantity) AS total_price,
  SUM(unit_price * quantity * (1 - discount)) AS total_price_after_discount
FROM orders o
JOIN order_items oi
  ON o.order_id = oi.order_id
WHERE o.order_id = 10250;
```

Output:

| total_price | total_price_after_discount |
| :---------: | :----------------------: |
| 1813.00 | 1552.6000 |

## Order values for multiple orders

Good job!

We know how to calculate the total price for a single order. However, real-world reports are typically more complicated. For example, you often need to provide the **total values for multiple orders**. The query below shows you how to do this:

```sql
SELECT
  o.order_id,
  c.company_name AS customer_company_name, 
  SUM(unit_price * quantity) AS total_price
FROM orders o
JOIN customers c
  ON o.customer_id = c.customer_id
JOIN order_items oi
  ON o.order_id = oi.order_id
WHERE o.ship_country = 'France'
GROUP BY o.order_id, c.company_name;
```

We want to find the total price (before discount) for each order shipped to France. We also want the order ID and the name of the company that placed the order. That's why we used a `GROUP BY` clause.

Even though it would be enough to group the rows by `order_id`, we also added `company_name` in the `GROUP BY`. This is because every column in the `SELECT` that **isn't used with an aggregate function** (e.g., `COUNT()`, `SUM()`, etc.) **must appear** in the `GROUP BY` clause. Otherwise, the query won't work.

### Exercise

We want to know the number of orders processed by each employee. Show the following columns: `employee_id`, `first_name`, `last_name`, and the number of orders processed as `orders_count`.

```sql
SELECT
    e.employee_id,
    e.first_name,
    e.last_name,
    COUNT(o.order_id) AS orders_count
FROM employees e
    JOIN orders o ON e.employee_id = o.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name;
```

Output:

| employee_id | first_name | last_name | orders_count |
| :--------: | :-------: | :------: | :---------: |
| 9 | Anne | Dodsworth | 43 |
| 3 | John | Smith | 127 |
| 5 | Steven | Buchanan | 42 |
| 4 | Margaret | Peacock | 155 |

### Products in stock per category

Good job! Let's try another exercise using computations for multiple objects.

How much are the products in stock in each category worth? Show three columns: `category_id`, `category_name`, and `category_total_value`. You'll calculate the third column as the sum of unit prices multiplied by the number of units in stock for all products in the given category.

```sql
SELECT
    c.category_id,
    c.category_name,
    SUM(p.unit_price * p.units_in_stock) AS category_total_value
FROM categories c
    JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_id, c.category_name;
```

Output:

| category_id | category_name | category_total_value |
| :--------: | :----------: | :----------------: |
| 5 | Grains/Cereals | 5594.50 |
| 4 | Dairy Products | 11271.20 |
| 6 | Meat/Poultry | 5729.45 |
| 2 | Condiments | 12023.55 |

## Grouping by the correct columns

Perfect! Now that we know how to show metrics for multiple business objects in a single report, we would like to show order counts for each employee at Northwind. You might be tempted to write the following query:

```sql
SELECT
  e.first_name,
  e.last_name,
  COUNT(*) AS orders_count
FROM orders o
JOIN employees e
  ON o.employee_id = e.employee_id
GROUP BY e.first_name,
  e.last_name;
```

The query seems fine at first sight, but it can actually produce incorrect results. Employees' first and last names may not be unique – imagine two employees that share the same name. In such a case, their orders will be grouped together, which is incorrect. Luckily, we can easily fix the query:

```sql
SELECT
  e.employee_id,
  e.first_name,
  e.last_name,
  COUNT(*) AS orders_count
FROM orders o
JOIN employees e
  ON o.employee_id = e.employee_id
GROUP BY e.employee_id,
  e.first_name,
  e.last_name;
```

We've added the `employee_id` column to the `GROUP BY` and `SELECT` clauses. Because employee IDs are unique, the query will now produce correct results.

Remember, you should always `GROUP BY` unique columns that **differentiate between various business objects**.

### Exercise

Count the number of orders placed by each customer. Show the `customer_id`, `company_name`, and `orders_count` columns.

```sql
SELECT
    c.customer_id,
    c.company_name,
    COUNT(o.order_id) AS orders_count
FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.company_name;
```

Output:

| customer_id | company_name | orders_count |
| :--------: | :---------: | :---------: |
| FOLKO | Folk och fä HB | 19 |
| FRANS | Franchi S.p.A. | 6 |
| HILAA | HILARION-Abastos | 18 |
| WARTH | Wartian Herkku | 15 |

## Choosing information to show

Excellent! Let's take a look at the correct query from the previous exercise once again:

```sql
SELECT
  e.employee_id,
  e.first_name,
  e.last_name,
  COUNT(*) AS orders_count
FROM orders o
JOIN employees e
  ON o.employee_id = e.employee_id
GROUP BY e.employee_id,
  e.first_name,
  e.last_name;
```

We're grouping by `employee_id`, but that doesn't mean we need to include it in the `SELECT` clause. The following query will work just fine:

```sql
SELECT
  e.first_name,
  e.last_name,
  COUNT(*) AS orders_count
FROM orders o
JOIN employees e
  ON o.employee_id = e.employee_id
GROUP BY e.employee_id,
  e.first_name,
  e.last_name;
```

We've already learned that all columns in the `SELECT` clause that aren't used in an aggregate function must appear in the `GROUP BY` clause. The opposite, however, is not true: You don't have to `SELECT` all columns used in the `GROUP BY` clause.

### Exercise

Which customers paid the most for orders made in June 2016 or July 2016? Show two columns:

1. `company_name`
2. `total_paid`, calculated as the total price (after discount) paid for all orders made by a given customer in June 2016 or July 2016.

Sort the results by `total_paid` in descending order.

```sql
SELECT
    c.company_name,
    SUM(oi.unit_price * oi.quantity * (1 - oi.discount)) AS total_paid
FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_date BETWEEN '2016-06-01' AND '2016-07-31'
GROUP BY c.company_name
ORDER BY total_paid DESC;
```

Output:

| company_name | total_paid |
| :---------: | :--------: |
| Suprêmes délices | 3597.9000 |
| Frankenversand | 3536.6000 |
| Ernst Handel | 3488.6800 |
| Hanari Carnes | 2997.4000 |

## Review of the COUNT() function

Well done! When creating business reports, you should remember the difference between `COUNT(*)` and `COUNT(column_name)`. Suppose we want to find the number of orders to be shipped to each country and the number of orders already shipped. Take a look at the query below:

```sql
SELECT
  ship_country,
  COUNT(*) AS all_orders,
  COUNT(shipped_date) AS shipped_orders
FROM orders
GROUP BY ship_country;
```

`COUNT(*)` will count all orders in `ship_country`. `COUNT(shipped_date)` will count only the rows where the `shipped_date` column value is not `NULL`. In our database, a `NULL` in the `shipped_date` column means an order hasn't been shipped yet. In other words, `COUNT(shipped_date)` only counts orders that have already been shipped.

### Exercise

Count the total number of customers and all those with a fax number. Show two columns: `all_customers_count` and `customers_with_fax_count`.

```sql
SELECT
    COUNT(*) AS all_customers_count,
    COUNT(fax) AS customers_with_fax_count
FROM customers;
```

Output:

| all_customers_count | customers_with_fax_count |
| :----------------: | :---------------------: |
| 91 | 69 |

## Counting occurrences of business objects

Perfect! When writing reports in SQL, you have to remember that some objects may not exist. In this exercise we discuss a very common error in using `COUNT()` with `LEFT JOIN`. The next report we'd like to create should count orders for three different customer IDs: `'ALFKI'`, `'FISSA'`, and `'PARIS'`:

```sql
SELECT
  c.customer_id,
  COUNT(o.order_id) AS order_count
FROM customers c
LEFT JOIN orders o
  ON o.customer_id = c.customer_id
WHERE c.customer_id IN ('ALFKI', 'FISSA', 'PARIS')
GROUP BY c.customer_id;
```

Note the following:

- We used `LEFT JOIN` to make sure we'll see all three customer IDs in the report. If we used a simple `JOIN` and any of the customers placed no orders, they would not be shown in the report.
- We used `COUNT(o.order_id)` instead of `COUNT(*)`. This ensures that we only count rows with non-NULL `order_id` column values. This is important if a customer hasn't ordered anything – in that case, `COUNT(*)` would return `1` instead of `0` because there would be one row with the given `customer_id` and a `NULL` value in the `order_id` column.

### Exercise

Find the total number of products provided by each supplier. Show the `company_name` and `products_count` (the number of products supplied) columns. Include suppliers that haven't provided any products.

```sql
SELECT
    s.company_name,
    COUNT(p.product_id) AS products_count
FROM suppliers s
    LEFT JOIN products p ON s.supplier_id = p.supplier_id
GROUP BY s.company_name;
```

Output:

| company_name | products_count |
| :---------: | :-----------: |
| Heli Süßwaren GmbH & Co. KG | 3 |
| Escargots Nouveaux | 1 |
| Pavlova, Ltd. | 5 |
| Leka Trading | 3 |

## Counting distinct objects

Good job! Suppose we want to find the number of items in each order, but we know that the same product might appear multiple times in one order. In that case, we want the number of unique products in each order. The following query will give us both the total count and the number of unique items:

```sql
SELECT 
  order_id, 
  COUNT(product_id) AS products_count, 
  COUNT(DISTINCT product_id) AS unique_products_count
FROM order_items
GROUP BY order_id;
```

We used `COUNT(product_id)` and `COUNT(DISTINCT product_id)`. The difference is that `COUNT(product_id)` counts all products in an order and `COUNT(DISTINCT product_id)` only counts unique products. This means that `COUNT(DISTINCT product_id)` will yield a lower value than `COUNT(product_id)` when a `product_id` appears more than once in a given order. (The same `product_id` can appear several times in an order – even though we've got a quantity column – when a customer adds more products into his or her order at a later time).

### Exercise

Show the number of unique customers (as `number_of_customers`) that had orders shipped to Spain.

```sql
SELECT
    COUNT(DISTINCT customer_id) AS number_of_customers
FROM orders
WHERE ship_country = 'Spain';
```

Output:

| number_of_customers |
| :-----------------: |
| 4 |

## Summary

It's time to wrap things up for this part. First, let's review what we learned:

1. SQL reports often require joining a lot of tables.
2. Every column listed in the `SELECT` statement that's **NOT** used with an aggregate function must appear in the `GROUP BY` clause.
3. Not every column from the `GROUP BY` clause must appear in the `SELECT` clause.
4. Watch out when using `COUNT()`.

| Type of count | What is counted |
| :----------: | :------------: |
| COUNT(\*) | all rows |
| COUNT(column_name) | rows with non-NULL values in column_name |
| COUNT(DISTINCT column_name) | only the unique non-NULL values in column_name |

5. Avoid using `LEFT JOIN`s with `COUNT(*)`. Use `COUNT(column_name)` instead.

How about a short quiz before we start the next part?

### Exercise

Find the total number of products supplied by each supplier. Show the following columns: `supplier_id`, `company_name`, and `products_supplied_count` (the number of products supplied by that company). Show also suppliers that supply no products.

```sql
SELECT
    s.supplier_id,
    s.company_name,
    COUNT(p.product_id) AS products_supplied_count
FROM suppliers s
    LEFT JOIN products p ON s.supplier_id = p.supplier_id
GROUP BY s.supplier_id, s.company_name;
```

Output:

| supplier_id | company_name | products_supplied_count |
| :--------: | :---------: | :-------------------: |
| 22 | Zaanse Snoepfabriek | 2 |
| 11 | Heli Süßwaren GmbH & Co. KG | 3 |
| 9 | PB Knäckebröd AB | 2 |
| 15 | Norske Meierier | 0 |

### Exercise 2

How many distinct products are there in all orders shipped to France? Name the result `distinct_products`.

```sql
SELECT
    COUNT(DISTINCT product_id) AS distinct_products
FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.ship_country = 'France';
```

Output:

| distinct_products |
| :---------------: |
| 65 |

### Exercise 3

Show three kinds of information about product suppliers:

1. `all_suppliers` (the total number of suppliers)
2. `suppliers_region_assigned` (the total number of suppliers who are assigned to a region)
3. `unique_supplier_regions` (the number of unique regions suppliers are assigned to)

```sql
SELECT
    COUNT(supplier_id) AS all_suppliers,
    COUNT(region) AS suppliers_region_assigned,
    COUNT(DISTINCT region) AS unique_supplier_regions
FROM suppliers;
```

Output:

| all_suppliers | suppliers_region_assigned | unique_supplier_regions |
| :----------: | :---------------------: | :---------------------: |
| 29 | 9 | 8 |

### Exercise 4

For each employee, compute the total order value before discount from all orders processed by this employee between 5 July 2016 and 31 July 2016. Ignore employees without any orders processed. Show the following columns: `first_name`, `last_name`, and `sum_orders`. Sort the results by `sum_orders` in descending order.

```sql
SELECT
    e.first_name,
    e.last_name,
    SUM(unit_price * quantity) AS sum_orders
FROM employees e
    JOIN orders o ON e.employee_id = o.employee_id
    JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_date BETWEEN '2016-07-05' AND '2016-07-31'
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY sum_orders DESC;
```

Output:

| first_name | last_name | sum_orders |
| :-------: | :------: | :--------: |
| Margaret | Peacock | 11869.00 |
| Anne | Dodsworth | 4955.30 |
| John | Smith | 2998.20 |
| John | Smith | 1119.90 |

## Congratulations

Very well done! This was the last exercise, and you got it. Congratulations!

In the next part, we'll talk about the `CASE WHEN` syntax, which is extremely useful when creating complex reports. See you there!
