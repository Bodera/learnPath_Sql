# Introduction

Get to know the data model and review some basic SQL concepts.

Hello and welcome to Basic Reporting in SQL! As the name suggests, this course teaches you how to create basic reports in SQL. We're going to write long, complex queries that will return exactly the data you need.

Let's get started!

## Get to know the database

In this course, we're going to work with Microsoft's sample database for SQL Server named **Northwind**. It describes a fictional store and its customers, suppliers, and orders. You can find the original database at [Microsoft's GitHub repository](https://github.com/Microsoft/sql-server-samples/tree/master/samples/databases/northwind-pubs). The database has been slightly modified to better suit the needs of this course.

In upcoming parts, we're going to write lots of queries that will aggregate data from multiple tables to create real SQL reports. For now, let's get to know the tables we'll be using.

### The `employees` table

Let's start with the `employees` table.

It stores information about the people employed at Northwind. Each employee has:

- A unique ID (`employee_id`).
- A first and last name (`first_name` and `last_name`).
- A professional title (`title`).

Pay attention to the column named `reports_to`, which contains the employee ID (from the same table) of the employee's manager. There are also informative columns in this table, such as `hire_date` and `address`.

### Exercise

Select all the information from the `employees` table.

```sql
SELECT * FROM employees;
```

Output:

| employee_id | last_name | first_name | title | birth_date | hire_date | address | city | region | postal_code | country | reports_to |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Davolio | Nancy | Sales Representative | 1968-12-08 | 2012-05-01 | 507 - 20th Ave. E. Apt. 2A | Seattle | WA | 98122 | USA | 2 |
| 2 | Fuller | Andrew | Vice President, Sales | 1972-02-19 | 2012-08-14 | 908 W. Capital Way | Tacoma | WA | 98401 | USA | null |
| 3 | Smith | John | Sales Representative | 1983-08-30 | 2012-04-01 | 722 Moss Bay Blvd. | Kirkland | WA | 98033 | USA | 2 |
| 4 | Peacock | Margaret | Sales Representative | 1957-09-19 | 2013-05-03 | 4110 Old Redmond Rd. | Redmond | WA | 98052 | USA | 2 |

### The `customers` table

Perfect! Let's move on to the `customers` table.

Each customer has a unique `customer_id`, which is a five-letter abbreviation of the full company name stored in the `company_name` column. There are also columns related to the contact person (`contact_name` and `contact_title`) and some related to the customer's address and fax number.

### Exercise

Select each customer's ID, company name, contact name, contact title, city, and country. Order the results by the name of the country.

```sql
SELECT customer_id, company_name, contact_name, contact_title, city, country
FROM customers
ORDER BY country;
```

Output:

Here is the markdown table with the provided data:

| customer_id | company_name | contact_name | contact_title | city | country |
| --- | --- | --- | --- | --- | --- |
| OCEAN | Océano Atlántico Ltda. | Yvonne Moncada | Sales Agent | Buenos Aires | Argentina |
| CACTU | Cactus Comidas para llevar | Patricio Simpson | Sales Agent | Buenos Aires | Argentina |
| RANCH | Rancho grande | Sergio Gutiérrez | Sales Representative | Buenos Aires | Argentina |
| ERNSH | Ernst Handel | Roland Mendel | Sales Manager | Graz | Austria |

### The `products` and `categories` tables

Well done! We'll now discuss the `products` and `categories` tables.

The `products` table stores information about products sold at the Northwind store. Each product has a unique `product_id` and a `product_name`. Each product is supplied by a single supplier (`supplier_id`) and belongs to a single category (`category_id`). Each product also has a certain `unit_price`. The discontinued column contains either a `false` (available in store) or a `true` (discontinued) that reflects the current availability of that product.

Products are organized into categories. The information about categories is stored in the `categories` table. Each category has a unique ID and a `category_name`. There is also a short `description`.

Because the `products` table contains the `category_id` column, you can join it with the `categories` table to get more information about the product's category (e.g., the category name).

### Exercise

For each product, display its name (`product_name`), the name of the category it belongs to (`category_name`), quantity per unit (`quantity_per_unit`), the unit price (`unit_price`), and the number of units in stock (`units_in_stock`). Order the results by unit price.

```sql
SELECT
    product_name,
    category_name,
    quantity_per_unit,
    unit_price,
    units_in_stock
FROM products
    JOIN categories ON products.category_id = categories.category_id
ORDER BY unit_price;
```

Output:

| product_name | category_name | quantity_per_unit | unit_price | units_in_stock |
| --- | --- | --- | --- | --- |
| Geitost | Dairy Products | 500 g | 2.50 | 112 |
| Guaraná Fantástica | Beverages | 12 - 355 ml cans | 4.50 | 20 |
| Konbu | Seafood | 2 kg box | 6.00 | 24 |
| Filo Mix | Grains/Cereals | 16 - 2 kg boxes | 7.00 | 38 |

### The `suppliers` table

Good job! Next, we have the `suppliers` table, which is similar to the `customers` table. Each supplier has a unique `supplier_id` and a `company_name`. There are also columns containing each supplier's contact information.

### Exercise

We'd like to see information about all the suppliers who provide the store **four or more different products**. Show the following columns: `supplier_id`, `company_name`, and `products_count` (the number of products supplied).

```sql
SELECT
    s.supplier_id,
    s.company_name,
    COUNT(p.product_id) AS products_count
FROM suppliers s
    JOIN products p ON s.supplier_id = p.supplier_id
GROUP BY s.supplier_id, company_name
HAVING COUNT(p.product_id) >= 4;
```

Output:

| supplier_id | company_name | products_count |
| :--------: | :---------: | :-----------: |
| 2 | New Orleans Cajun Delights | 4 |
| 16 | Bigfoot Breweries | 6 |
| 7 | Pavlova, Ltd. | 5 |
| 12 | Plutzer Lebensmittelgroßmärkte AG | 5 |

### The `orders` and `order_items` tables

Very well done! Let's now take a look at the `orders` and `order_items` tables.

The `orders` table contains general information about an **order**: the `order_id`, `customer_id`, and `employee_id` related to that sale. There are also timestamp columns (`order_date` and `shipped_date`) and many columns related to the shipment process.

The `order_items` table contains information about order items. Each row represents a single item from an order. You'll find the `order_id` and `product_id` alongside `unit_price`, `quantity`, and (possibly) `discount`.

### Exercise

Display the list of products purchased in the order with ID equal to `10250`. Show the following information: product name (`product_name`), the quantity of the product ordered (`quantity`), the unit price (`unit_price` from the `order_items` table), the discount (`discount`), and the `order_date`. Order the items by `product_name`.

```sql
SELECT
    p.product_name,
    oi.quantity,
    oi.unit_price,
    oi.discount,
    o.order_date
FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON p.product_id = oi.product_id
WHERE o.order_id = 10250
ORDER BY p.product_name;
```

Output:

| product_name | quantity | unit_price | discount | order_date |
| :---------: | :------: | :--------: | :------: | :--------: |
| Jack's New England Clam Chowder | 10 | 7.70 | 0.00 | 2016-07-08 |
| Louisiana Fiery Hot Pepper Sauce | 15 | 16.80 | 0.15 | 2016-07-08 |
| Manjimup Dried Apples | 35 | 42.40 | 0.15 | 2016-07-08 |

## Congratulations

That's it! You now know all seven tables from the Northwind database. Before we move on, let's take a quick summary.

We'll be working with the following tables throughout this course:

- `employees` contains information about the employees of Northwind.
- `customers` contains information about Northwind's customers.
- `products` contains information about the products sold.
- `categories` contains information about product categories.
- `suppliers` contains information about the companies that supply products.
- `orders` contains general information about orders made by Northwind's customers.
- `order_items` contains information about the individual items in each customer order.

In the next part, we'll show you basic business metrics related to the Northwind database. See you there!






















