# Classifying Data with CASE WHEN and GROUP BY

Discover how to get metrics based on custom classifications.

Welcome to the third part of our course. In this part, we'll teach you how to **classify and count business objects** based on your own criteria. This way, you'll be able to create more sophisticated business metrics.

Without further ado, let's get started!

## Custom classifications

Suppose we want to show the availability level for each product in a report, but we don't want to simply print the `units_in_stock` column. The column contains a precise number of units available, but we only need an overall level, like `'low'` or `'high'`. How can we do this? Take a look:

```sql
SELECT
  product_id,
  product_name,
  units_in_stock,
  CASE
    WHEN units_in_stock > 100 THEN 'high'
    WHEN units_in_stock > 50 THEN 'moderate'
    WHEN units_in_stock > 0 THEN 'low'
    WHEN units_in_stock = 0 THEN 'none'
  END AS availability
FROM products;
```

We create a brand-new column named `availability`. You can see that we use a special construction called `CASE WHEN`. It returns different values based on the conditions you specify.

How do we build a `CASE WHEN`? We start with the word `CASE`, followed by one or more `WHEN ... THEN ...` conditions. After the list of conditions, we add the `END` keyword to indicate the end of the construction. `CASE WHEN` looks for the first condition satisfied in the `WHEN` part and takes its value from the `THEN` part.

In the query above, `CASE WHEN` checks the value of the `units_in_stock` column. If it's greater than `100`, the availability column gets the value `'high'`. If it's not greater than `100`, but is greater than `50`, the column value is `'moderate'`. And when it's less than `50`, its value is `'low'`. Zero units in stock, of course, gets a value of `'none'`.

Output:

| product_id | product_name | units_in_stock | availability |
| --- | --- | --- | --- |
| 1 | Chai | 39 | low |
| 2 | Grandma's Boysenberry Spread | 120 | high |
| 3 | Chef Anton's Cajun Seasoning | 53 | moderate |
| 4 | Chef Anton's Gumbo Mix | 0 | none |

### Exercise

We want to create a report measuring the level of experience each Northwind employee has with the company. Show the `first_name`, `last_name`, `hire_date`, and `experience` columns for each employee. The `experience` column should display the following values:

- 'junior' for employees hired after Jan. 1, 2014.
- 'middle' for employees hired after Jan. 1, 2013 but before Jan. 1, 2014.
- 'senior' for employees hired on or before Jan. 1, 2013.

```sql
SELECT
  first_name,
  last_name,
  hire_date,
  CASE
    WHEN hire_date > '2014-01-01' THEN 'junior'
    WHEN hire_date > '2013-01-01' THEN 'middle'
    ELSE 'senior'
  END AS experience
FROM employees;
```

Output:

| first_name | last_name | hire_date | experience |
| :--------: | :-------: | :--------: | :--------: |
| Nancy | Davolio | 2012-05-01 | senior |
| Margaret | Peacock | 2013-05-03 | middle |
| Robert | King | 2014-01-02 | junior |

## Non-matching objects

Perfect! Our store is now introducing a new shipping cost policy: Any package shipped to the US or Canada is free! Now we want to create a report that shows the updated shipping cost for selected orders. Here's a query that will do the job:

```sql
SELECT 
  order_id,
  customer_id,
  ship_country,
  CASE
    WHEN ship_country = 'USA' OR ship_country = 'Canada' THEN 0.0
  END AS shipping_cost
FROM orders
WHERE order_id BETWEEN 10720 AND 10730;
```

You may have noticed that we only defined a column value for the US and Canada. What will happen if there's another `ship_country` value? Let's find out.

Output:

| order_id | customer_id | ship_country | shipping_cost |
| :------: | :---------: | :----------: | :-----------: |
| 10720 | QUEDE | Brazil | null |
| 10721 | QUICK | Germany | null |
| 10722 | SAVEA | USA | 0.0 |
| 10724 | MEREP | Canada | 0.0 |

## Fallback values

So, orders shipped outside the USA and Canada had `NULL` `shipping_cost` values. This is because we didn't specify the column value for other countries.

Northwinds' shipping cost for countries other than the US and Canada is $10.00. How can we show that in the report? Take a look:

```sql
SELECT 
  order_id,
  customer_id,
  ship_country,
  CASE
    WHEN ship_country = 'USA' OR ship_country = 'Canada' THEN 0.0
    ELSE 10.0
  END AS shipping_cost
FROM orders
WHERE order_id BETWEEN 10720 AND 10730;
```

We enriched our `CASE WHEN` construction with an `ELSE`. The `ELSE` is executed when no other conditions are satisfied. Thanks to this, all other countries will get a column value of `10.0` instead of `NULL`.

### Exercise

We want to show the following basic customer information (from the `customers` table):

1. `customer_id`
2. `company_name`
3. `country`
4. `language`

The value of the `language` column will be decided by the following rules:

- `'German'` for companies from Germany, Switzerland, and Austria.
- `'English'` for companies from the UK, Canada, the USA, and Ireland.
- `'Other'` for all other countries.

```sql
SELECT
  customer_id,
  company_name,
  country,
  CASE
    WHEN country = 'Germany' OR country = 'Switzerland' OR country = 'Austria' THEN 'German'
    WHEN country = 'UK' OR country = 'Canada' OR country = 'USA' OR country = 'Ireland' THEN 'English'
    ELSE 'Other'
  END AS language
FROM customers;
```

Output:

| customer_id | company_name | country | language |
| :---------: | :----------: | :-----: | :------: |
| ALFKI | Alfreds Futterkiste | Germany | German |
| ANATR | Ana Trujillo Emparedados y helados | Mexico | Other |
| AROUT | Around the Horn | UK | English |

### Exercise 2

Let's create a report that will divide all products into vegetarian and non-vegetarian categories. For each product, show the following columns:

1. `product_name`
2. `category_name`
3. `diet_type`:
  - `'Non-vegetarian'` for products from the categories `'Meat/Poultry'` and `'Seafood'`.
  - `'Vegetarian'` for any other category.

```sql
SELECT
  product_name,
  category_name,
  CASE
    WHEN category_name = 'Meat/Poultry' OR category_name = 'Seafood' THEN 'Non-vegetarian'
    ELSE 'Vegetarian'
  END AS diet_type
FROM products
  JOIN categories USING (category_id);
```

Output:

| product_name | category_name | diet_type |
| :----------: | :-----------: | :--------: |
| Chai | Beverages | Vegetarian |
| Northwoods Cranberry Sauce | Condiments | Vegetarian |
| Mishi Kobe Niku | Meat/Poultry | Non-vegetarian |
| Ikura | Seafood | Non-vegetarian |

## Custom grouping

Before we introduce free shipping to the USA and Canada, we'd like to know how many orders are sent to these countries and how many are sent to other places. Take a look:

```sql
SELECT 
  CASE
    WHEN ship_country = 'USA' OR ship_country = 'Canada' THEN 0.0
    ELSE 10.0
  END AS shipping_cost,
  COUNT(*) AS order_count
FROM orders
GROUP BY
  CASE
    WHEN ship_country = 'USA' OR ship_country = 'Canada' THEN 0.0
    ELSE 10.0
  END;
```

In the `SELECT` clause, we used the `CASE WHEN` construction you've seen before. However, you can also see that the same `CASE WHEN` construction appears in the `GROUP BY` clause, only without the `shipping_cost` alias. Even though we already defined it in the SELECT clause and gave it an alias (`shipping_cost`), most databases don't allow referring to an alias in the `GROUP BY` clause (i.e., we can't write `GROUP BY shipping_cost`). That's why we had to repeat the whole construction. (Note that some databases, like `PostgreSQL` or `MySQL`, allow us to refer to column aliases in `GROUP BY`. However, this is a feature of these databases. The standard SQL doesn't allow it. It's best to know how to write the correct query in both cases.)

Because we now group by the `CASE WHEN` construction, we can add a `COUNT(*)` column in the `SELECT` clause. The query will show:

| shipping_cost | order_count |
| :-----------: | :---------: |
| 10.0 | 678 |
| 0.0 | 152 |

**Remember**: The `CASE WHEN` construction should be the same in both the `GROUP BY` and `SELECT` clauses!

### Exercise

Create a report that shows the number of products supplied from a specific continent. Display two columns: `supplier_continent` and `product_count`. The `supplier_continent` column should have the following values:

- `'North America'` for products supplied from `'USA'` and `'Canada'`.
- `'Asia'` for products from `'Japan'` and `'Singapore'`.
- `'Other'` for other countries.

```sql
SELECT
  CASE
    WHEN country = 'USA' OR country = 'Canada' THEN 'North America'
    WHEN country = 'Japan' OR country = 'Singapore' THEN 'Asia'
    ELSE 'Other'
  END AS supplier_continent,
  COUNT(*) AS product_count
FROM suppliers
  JOIN products USING (supplier_id)
GROUP BY
  CASE
    WHEN country = 'USA' OR country = 'Canada' THEN 'North America'
    WHEN country = 'Japan' OR country = 'Singapore' THEN 'Asia'
    ELSE 'Other'
  END;
```

Output:

| supplier_continent | product_count |
| :----------------: | :-----------: |
| Other | 49 |
| Asia | 9 |
| North America | 19 |

### Exercise 2

We want to create a simple report that will show the number of young and old employees at Northwind. Show two columns: `age` and `employee_count`.

The `age` column has the following values:

- `'young'` for people born after Jan. 1, 1980.
- `'old'` for all other employees.

```sql
SELECT
  CASE
    WHEN birth_date > '1980-01-01' THEN 'young'
    ELSE 'old'
  END AS age,
  COUNT(*) AS employee_count
FROM employees
GROUP BY
  CASE
    WHEN birth_date > '1980-01-01' THEN 'young'
    ELSE 'old'
  END;
```

Output:

| age | employee_count |
| :--: | :------------: |
| young | 5 |
| old | 5 |

## CASE WHEN with COUNT

Very well done!

There's also an alternative way of counting objects based on custom classifications in your reports. Take a look:

```sql
SELECT 
  COUNT(CASE 
    WHEN ship_country = 'USA' OR ship_country = 'Canada' THEN order_id 
  END) AS free_shipping,
  COUNT(CASE
    WHEN ship_country != 'USA' AND ship_country != 'Canada' THEN order_id
  END) AS paid_shipping
FROM orders;
```

The query will show:

| free_shipping | paid_shipping |
| :--: | :------------: |
| 152 | 678 |

The query above may come as a surprise because there's a `CASE WHEN` construction inside the `COUNT()` function. For each row, the `CASE WHEN` construction checks the value in ship_country. If it's `'USA'` or `'Canada'`, the `order_id` is passed to `COUNT()` and counted. If there's a different value in `ship_country`, `CASE WHEN` returns a `NULL` – and you already learned that a `NULL` value isn't counted by `COUNT()`. This way, the `free_shipping` column will **only count orders shipped to the USA or Canada**. The `paid_shipping` column is constructed similarly.

You can see that the technique above involves creating a separate column for each group. The query produces a different result than the query with the `CASE WHEN` in the `GROUP BY` clause, which listed each group as a row, not a column.

### Exercise

How many customers are represented by owners (`contact_title = 'Owner'`), and how many aren't? Show two columns with appropriate values: `represented_by_owner` and `not_represented_by_owner`.

```sql
SELECT
  COUNT(CASE
    WHEN contact_title = 'Owner' THEN customer_id
  END) AS represented_by_owner,
  COUNT(CASE
    WHEN contact_title != 'Owner' THEN customer_id
  END) AS not_represented_by_owner
FROM customers;
```

Output:

| represented_by_owner | not_represented_by_owner |
| :--: | :--: |
| 17 | 74 |

### Exercise 2

Washington (WA) is Northwind's primary region. How many orders have been processed by employees in the WA region, and how many by employees in other regions? Show two columns with their respective counts: `orders_wa_employees` and `orders_not_wa_employees`.

```sql
SELECT
  COUNT(CASE
    WHEN region = 'WA' THEN order_id
  END) AS orders_wa_employees,
  COUNT(CASE
    WHEN region != 'WA' THEN order_id
  END) AS orders_not_wa_employees
FROM orders
  JOIN employees USING (employee_id);
```

Output:

| orders_wa_employees | orders_not_wa_employees |
| :--: | :--: |
| 605 | 0 |

## GROUP BY with CASE WHEN

Good job! We can also use the same technique to split the results into multiple groups:

```sql
SELECT 
  ship_country,
  COUNT(CASE
    WHEN freight < 40.0 THEN order_id
  END) AS low_freight,
  COUNT(CASE
    WHEN freight >= 40.0 AND freight < 80.0 THEN order_id
  END) AS avg_freight,
  COUNT(CASE
    WHEN freight >= 80.0 THEN order_id
  END) AS high_freight
FROM orders
GROUP BY ship_country;
```

Result:

| ship_country | low_freight | avg_freight | high_freight |
| :--: | :--: | :--: | :--: |
| Finland | 16 | 3 | 3 |
| USA | 53 | 22 | 47 |
| Italy | 20 | 6 | 2 |
| ... | ... | ... | ... |

By combining `COUNT(CASE WHEN...)` with `GROUP BY`, we've created a more advanced report that shows the number of orders with low, average, and high freight in each country.

### Exercise

We need a report that will show the number of products with high and low availability in all product categories. Show three columns: `category_name`, `high_availability` (count the products with more than `30` units in stock) and `low_availability` (count the products with `30` or fewer units in stock).

```sql
SELECT
  category_name,
  COUNT(CASE
    WHEN units_in_stock > 30 THEN product_id
  END) AS high_availability,
  COUNT(CASE
    WHEN units_in_stock <= 30 THEN product_id
  END) AS low_availability
FROM products
  JOIN categories USING (category_id)
GROUP BY category_name;
```

Output:

| category_name | high_availability | low_availability |
| :------------: | :---------------: | :--------------: |
| Grains/Cereals | 4 | 3 |
| Seafood | 8 | 4 |
| Meat/Poultry | 1 | 5 |
| Beverages | 6 | 6 |

## CASE WHEN with SUM

Excellent! The same kind of report can also be created using `SUM()` instead of `COUNT()`. Take a look:

```sql
SELECT 
  SUM(CASE
    WHEN ship_country = 'USA' OR ship_country = 'Canada' THEN 1
  END) AS free_shipping,
  SUM(CASE
    WHEN ship_country != 'USA' AND ship_country != 'Canada' THEN 1
  END) AS paid_shipping
FROM orders;
```

In the above query, we used `SUM()` with `CASE WHEN` instead of `COUNT()`. The `CASE WHEN` construction inside the `SUM()` function is very similar to that inside `COUNT()`, but you can see that we pass a `1` to `SUM()` when the condition is satisfied. This is a bit different from `COUNT()`, where we passed in the column name.

Despite their minor differences, both `SUM()` and `COUNT()` produce identical results in this query.

### Exercise

The template presents a solution to the previous exercise. Modify it so that it uses `SUM()` instead of `COUNT()`.

```sql
SELECT 
  SUM(CASE
    WHEN region = 'WA' THEN 1
  END) AS orders_wa_employees,
  SUM(CASE
    WHEN region != 'WA' THEN 0
  END) AS orders_not_wa_employees
FROM employees e
JOIN orders o
  ON e.employee_id = o.employee_id;
```

Output:

| orders_wa_employees | orders_not_wa_employees |
| :-----------------: | :---------------------: |
| 605 | null |

### Exercise 2

There have been a lot of orders shipped to **France**. Of these, how many order items were sold at full price and how many were discounted? Show two columns with the respective counts: `full_price` and `discounted_price`.

```sql
SELECT
  COUNT(CASE
    WHEN discount = 0 THEN unit_price * quantity
  END) AS full_price,
  COUNT(CASE
    WHEN discount > 0 THEN (unit_price * quantity) * (1 - oi.discount)
  END) AS discounted_price
FROM order_items
WHERE order_id IN (
  SELECT order_id
  FROM orders
  WHERE ship_country = 'France'
);
```

Output:

| full_price | discounted_price |
| :--------: | :--------------: |
| 107 | 77 |

## Summing of business values

Perfect! Suppose we now want to show the total amount paid for each order alongside the amount paid for non-vegetarian products. Take a look:

Note: Non-vegetarian products have a `category_id` of 6 and 8.

```sql
SELECT
  o.order_id,
  SUM(oi.quantity * oi.unit_price * (1 - oi.discount)) AS total_price,
  SUM(CASE
    WHEN p.category_id in (6, 8) THEN oi.quantity * oi.unit_price * (1 - oi.discount)
    ELSE 0
  END) AS non_vegetarian_price
FROM orders o
JOIN order_items oi
  ON o.order_id = oi.order_id
JOIN products p
  ON p.product_id = oi.product_id
GROUP BY o.order_id;
```

So far, we wrote the queries with `SUM(CASE WHEN...)` in such a way that they could all be replaced with equivalent `COUNT(CASE WHEN...)` constructions. Here, however, `SUM(CASE WHEN...)` is the only option – we want to sum certain values `(oi.quantity * oi.unit_price * (1 - oi.discount))` instead of merely counting rows.

### Exercise

This time, we want a report that will show each supplier alongside their number of units in stock and their number of expensive units in stock. Show four columns: `supplier_id`, `company_name`, `all_units` (all units in stock supplied by that supplier), and `expensive_units` (units in stock with a unit price over `40.0`, supplied by that supplier).

```sql
SELECT
  supplier_id,
  company_name,
  SUM(units_in_stock) AS all_units,
  SUM(CASE
    WHEN unit_price > 40.0 THEN units_in_stock
    ELSE 0
  END) AS expensive_units
FROM suppliers
  JOIN products USING (supplier_id)
GROUP BY supplier_id, company_name;
```

## Summary

You did well! All right, it's time to wrap things up. First, let's summarize what we've covered in this part:

1. A `CASE WHEN` statement checks for one or more conditions and returns a value when it finds the first matching condition. If there is no `ELSE` clause and no matching conditions, `CASE WHEN` returns `NULL`.

```sql
CASE
  WHEN condition_1 THEN result_1
  WHEN condition_2 THEN result_2
  ...
  ELSE result
END
```

2. To add a new column, and thus a custom classification of business products, you can use `CASE WHEN` in the `SELECT` clause:

```sql
SELECT 
  CASE
    WHEN ... THEN ...
  END AS sample_column
FROM table;
```

3. You can use `CASE WHEN` in a `GROUP BY` clause to create your own grouping. The same `CASE WHEN` clause must also appear in the `SELECT` clause:

```sql
SELECT 
  CASE
    WHEN ... THEN ...
  END AS sample_column,
  COUNT(*) AS sample_count
FROM table
  ...
GROUP BY
  CASE WHEN ... THEN ...
  END;
```

4. You can create a custom count of business objects using `CASE WHEN` inside a `COUNT()` or `SUM()` function:

```sql
SELECT 
  COUNT(CASE
    WHEN ... THEN column_name
  END) AS count_column
FROM table;
SELECT 
  SUM(CASE
    WHEN ... THEN 1
  END) AS count_column
FROM table;
```

How about a short quiz now?

### Exercise 1

For each product, show the following columns: product_id, product_name, unit_price, and price_level. The price_level column should show one of the following values:

- `'expensive'` for products with a unit price above `100`.
- `'average'` for products with a unit price above `40` but no more than `100`.
- `'cheap'` for other products.

```sql
SELECT
  product_id,
  product_name,
  unit_price,
  CASE
    WHEN unit_price > 100 THEN 'expensive'
    WHEN unit_price > 40 AND unit_price <= 100 THEN 'average'
    ELSE 'cheap'
  END AS price_level
FROM products;
```

Output:

| product | price | category |
| :-----: | :----: | :------: |
| Gumbär Gummibärchen | 31.23 | cheap |
| Schoggi Schokolade | 43.90 | average |
| Rössle Sauerkraut | 45.60 | average |
| Thüringer Rostbratwurst | 123.79 | expensive |

### Exercise 2

We would like to categorize all orders based on their total price (before any discount). For each order, show the following columns:

1. `order_id`
2. `total_price` (calculated before discount)
3. `price_group`, which should have the following values:
    - `'high'` for a total price over $2 000.
    - `'average'` for a total price between $600 and $2 000, both inclusive.
    - `'low'` for a total price under $600.

```sql
SELECT
  order_id,
  SUM(quantity * unit_price) AS total_price,
  CASE
    WHEN SUM(quantity * unit_price) > 2000 THEN 'high'
    WHEN SUM(quantity * unit_price) BETWEEN 600 AND 2000 THEN 'average'
    ELSE 'low'
  END AS price_group
FROM order_items
GROUP BY order_id;
```

Output:

| order_id | total_price | price_group |
| :------: | :---------: | :---------: |
| 10518 | 4150.05 | high |
| 10356 | 1106.40 | average |
| 10963 | 68.00 | low |

### Exercise 3

Group all orders based on the freight column. Show three columns in your report:

- `low_freight` – the number of orders where the `freight` value is less than `40.0`.
- `avg_freight` – the number of orders where the `freight` value is greater than equal to or `40.0` but less than 80.0.
- `high_freight` – the number of orders where the `freight` value is greater than equal to or `80.0`.

```sql
SELECT
  SUM(
  	CASE
    	WHEN freight < 40.0 THEN 1
    	ELSE 0
  	END) AS low_freight,
  SUM(
  	CASE
    	WHEN freight >= 40.0 AND freight < 80.0 THEN 1
    	ELSE 0
  	END) AS avg_freight,
  SUM(
  	CASE
    	WHEN freight >= 80.0 THEN 1
    	ELSE 0
  	END) AS high_freight
FROM orders;
```

Output:

Here is the markdown table with the freight categories as columns:
| **Low Freight** | **Avg Freight** | **High Freight** |
| :---: | :---: | :---: |
| 411 | 183 | 236 |

## Congratulations

Congratulations! Those were all the exercises we had for you in this part, and you solved them all. Well done!

In the next part, we'll focus on multi-level aggregations. That's a demanding topic, so get a good rest before you continue. See you there!
