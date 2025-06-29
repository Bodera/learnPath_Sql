# Nulls

NULLs are tricky. Learn how to avoid common mistakes with NULL and what SQL functions there are to deal with NULL.

Welcome to Part 5 of our SQL function course! In this part, we're going to deal with `NULL`s. We'll talk about how regular functions deal with `NULL`s and we'll learn functions designed specifically for `NULL`s.

You're familiar with `NULL`s already, of course. Here, we want to extend your knowledge so that you're aware of all the conundrums.

Ready, steady… go!

## Get to know the table product

All right. Before we start, we'll introduce our today's guest: **Mr. Adams**. He is CEO for Highland Furniture. – a company which sells furniture and home accessories. He's agreed to show us a snippet of his product table. Let's see what's in there before we move on.

### Exercise

Select all columns for the table `product` and study the contents.

```sql
SELECT * FROM product;
```

Output:

| id | category | name | type | price | launch_date | description | production_area | shipping_cost |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | bedroom | Vaatekaappi | wardrobe | 299.99 | 2015-08-01 | Feel invited to take a journey around this spacious wardrobe. Vaatekaappi is the number one choice for every luxurious bedroom! | UE | 0.00 |
| 2 | null | Spisebord | dining table | 109.99 | null | Spisebord is a simple dining table which will fit in every living room. Its wooden pattern makes it ideal for every rustical home. | UE | 0.00 |
| 3 | living room | Salongbord | coffee table | null | 2016-01-01 | Created by a group of French designers, this coffee table will make your life much easier. Be it your favorite drink during afternoon tea time or your legs after a long day at work – Salongbord will satisfy your needs. | China | 5.99 |
| 4 | kitchen | Tekanna | null | 19.99 | 2015-02-25 | This amazing tea kettle is equipped with a number of LED lights. Thanks to it, you will never lose your way when you want a cup of tea at night. | UE | 2.99 |
| 5 | kitchen | Haarukka | fork | 1.99 | 2014-07-05 | This award-winning fork has been with us for a long time. Feel the difference with our Haarukka. You will never get hungry again! | null | 1.99 |
| 6 | bathroom | Handduk | towel | 9.99 | null | Three times smaller than your usual towel, yet still as efficient. Try Handduk today! | China | 1.99 |
| 7 | null | Krus | null | 12.99 | 2013-04-30 | Resistance against hot temperatures makes this mug one of a kind. | null | 2.99 |
| 8 | hall | null | mirror | 19.99 | 2013-01-01 | Let's you see your true inner self. | China | 2.99 |

## NULL – quick review

Good. Let's get started and refresh your memory about `NULL`s.

A `NULL` means that the value in question is **unknown** or **missing**. In a client table, you could have a `NULL` last name because you forgot to ask your client for it.

In your `product` table, you could have a `NULL` product **launch date** if it hasn't been introduced yet. A `NULL` product price doesn't mean that the product is free, it simply means that the price is unknown.

We use the operators `IS NULL` or `IS NOT NULL` to check, respectively, if the value is missing or not, just like this:

```sql
SELECT *
FROM product
WHERE category IS NULL
```

### Exercise 1

Select `name` for all products whose `launch_date` is not a **null**.

```sql
SELECT name
FROM product
WHERE launch_date IS NOT NULL;
```

### Exercise 2

Now, select `name` for all the products whose category is `NULL`.

```sql
SELECT name
FROM product
WHERE category IS NULL;
```

## IS NULL or = NULL?

Nice. Let's explain the behavior of `NULL` in detail. It's very important to understand it well as it is the source of frequent mistakes when writing SQL queries.

Let's talk about `NULL` and equality. The condition:

```sql
price = 5.99
```

is not met when the value for price is `NULL`. Well, that's quite obvious, `NULL` doesn't equal `5.99` after all.

What's more, `NULL` **never** satisfies the equality condition. It may seem less obvious that the condition

```sql
price = NULL
```

is **NEVER** true, even if the price is a `NULL` indeed. Keep in mind that you need to use `IS NULL` or `IS NOT NULL` instead of the equality sign.

### Exercise

See for yourself that the equality sign will not work. In our table, there is a row with a `NULL` `launch_date`.

```sql
SELECT *
FROM product
WHERE launch_date = NULL;
```

## NULL with non-equality

See? The query returned nothing. You **must** use `IS (NOT) NULL` to check for `NULL` and `NOT NULL` values. If you don't use it, the query will return nothing.

It's easy to remember that `x = NULL` is wrong, but this phenomenon is much more difficult to notice with non-equality. Take a look at the column `production_area`. If you want to get all the products which have been produced **outside** EU, you could write:

```sql
SELECT *
FROM product
WHERE production_area != 'EU';
```

... but this query will not return those rows which have `NULL` in the column `production_area`.

Is this correct? It depends. If you want to find all the products which have a set value which is other than `'EU'`, then the condition is OK. If you want to find all the rows with anything other than `'EU'` (including `NULL`s), then we need to use the following construction:

```sql
SELECT *
FROM product
WHERE production_area != 'EU'
  OR production_area IS NULL;
```

### Exercise 1

Select the `name` for all the products with a price **different** than `299.99`. Include `NULL`s!

```sql
SELECT name
FROM product
WHERE price != 299.99
  OR price IS NULL;
```

### Exercise 2

Select the `name` for all products together with their **categories** and **types**. **Exclude** rows with category **'kitchen'** and those rows which **have no** category set.

```sql
SELECT name, category, type
FROM product
WHERE category != 'kitchen'
  AND category IS NOT NULL;
```

## NULL with comparisons

Excellent! **NULL** is also tricky when it comes to comparisons. If you write a query like this:

```sql
SELECT *
FROM product
WHERE price > 0.99;
```

the rows with a `NULL` price will not be displayed at all. This is because the database doesn't know whether `NULL > 0.99` is **true** or **false**, so it just **skips** such rows and doesn't bother.

### Exercise

Mr Amund released a certain series of products on **April 30, 2014**. Now, he would like to get all the **names**, **categories** and **types** of those products which were introduced any time later or which will be introduced in the future (i.e., they don't have a `launch_date` yet). Write the proper query.

```sql
SELECT name, category, type
FROM product
WHERE launch_date > '2014-04-30'
  OR launch_date IS NULL;
```

## NULL with operator IN

Nice! Another place where `NULL` won't work is the construction `IN(a,b,c, ...)`. If you want to select those products which were introduced on **February 25, 2015** or **August 1, 2015** or don't have a `launch_date`, you could think it's correct to write the following:

```sql
SELECT *
FROM product
WHERE launch_date IN ('2015-02-25', '2015-08-01', NULL);
```

But this query is not correct. The proper way to do it is as follows:

```sql
SELECT *
FROM product
WHERE launch_date IN ('2015-02-25','2015-08-01')
  OR launch_date IS NULL;
```

The second method requires more typing, but at least it will include `NULL` too.

### Exercise

Select all the columns for products from **categories**: kitchen, bathroom, or with **unknown** category.

```sql
SELECT *
FROM product
WHERE category IN ('kitchen', 'bathroom')
  OR category IS NULL;
```

## Never trust a NULL

Good! As you can see, you need to keep your eyes open when you work with `NULL`s in your `WHERE` statements.

Remember – every time, think whether some columns can be `NULL`s. If they can, modify your query a tiny bit, just as we did in this section.

## NULL with other functions

Okay, let's move on. You should also watch out for `NULL`s when you work with calculations. Most of them will return a `NULL` if any of the arguments is a `NULL`. This may not be obvious.

For instance, you could think that the following expression:

```sql
firstname || ' ' || lastname
```

with `firstname = 'Anne'` and a `NULL lastname` will return `'Anne '` as a result. That's not true. You will get a `NULL` if any of the columns is `NULL`.

### Exercise

Check it out for yourself. For **all** products, show their `category`, `type` and the following text: `category` and `type` separated with a colon (`:`), for example:

```
kitchen:fork
```

Name the last column `category_type`. Note what happens with the row which doesn't have a category.

```sql
SELECT
  category,
  type,
  category || ':' || type AS category_type
FROM product;
```

## NULL with mathematical operators

Perfect! As you can see, we got a `NULL` when one of the concatenated columns was a `NULL`.

The same goes for mathematical operators: `+`, `-`, `*`, `/`. Adding a `NULL` value to something will return `NULL`. Similarly, multiplying two values, of which one is `NULL`, will always return `NULL`.

### Exercise

A new tax has been imposed on all the products, which is **2%** of the **final price**. Show all product **names** with their **old price** (column name `old_price`) and **new price** rounded to **two decimal points** (column name `new_price`). Note what happens when there is no price.

```sql
SELECT
  name,
  price AS old_price,
  ROUND(price * 1.02, 2) AS new_price
FROM product;
```

## NULL with function length

Correct! The last thing we want to warn you about is the function `length(x)`, which will also return `NULL` when `x` is `NULL`. This is why the query:

```sql
SELECT *
FROM product
WHERE length(category) < 20;
```

will not return a row with a `NULL` category. Is this correct? Again, it depends on what you need.

### Exercise

Mr Amund wants to pick products with short names for his new advertisement. Show the **names** of all products shorter than **8 characters** or those which have a `NULL` name. Show the `description` as the second column so that Mr Amund can think of a (short) name if it's missing for a certain product before the advertisement is published.

```sql
SELECT
  name,
  description
FROM product
WHERE length(name) < 8
  OR name IS NULL;
```

## New keyword: COALESCE

Perfect answer! Well, as you can see, `NULL`s can be troublesome. This is why SQL features a function to help you tackle them: `COALESCE(x,y)`.

`COALESCE(x,y)` returns the first of the two values (`x` or `y`) which is not a `NULL`. Check out the example:

```sql
SELECT name, COALESCE(category, 'none')
FROM product;
```

If a product has a category in the above query, it will be shown. If it has a `NULL` category, the query will show `'none'` instead.

If you're a non-native English speaker, then you may wonder what the word **coalesce** means. It is a verb which can be understood as **'to come together to form one group or mass'**. You can use it literally (ingredients can coalesce) or figuratively (ideas can coalesce, too). Now you understand the choice of the word in SQL.

### Exercise

Select the **names** and **categories** for all products. If any of the columns is a `NULL`, write `'n/a'` instead. Name the columns `name` and `category`.

```sql
SELECT
  COALESCE(name, 'n/a') AS name,
  COALESCE(category, 'n/a') AS category
FROM product;
```

## Data types in COALESCE

Excellent. Keep in mind, though, that both of the values in the function `COALESCE` must be of the same type. For instance, you can't write the following:

```sql
COALESCE(price, '--')
```

because `price` is a **number** and `'–'` is a **text field**. Such a query will return an error.

### Exercise

Check it out for yourself. Try to use `COALESCE` to show the product `name` and the `launch_date` or **'no date'** when there is no `launch_date`.

```sql
SELECT
  name,
  COALESCE(launch_date, 'no date') AS launch_date
FROM product;
```

Output:

```
ERROR: invalid input syntax for type date: "no date" Line: 3 Position in the line: 25
```

## Conversion for COALESCE

Good. `COALESCE` failed, as you can see. How can we cope with this? We can always convert any type to `varchar`:

```sql
COALESCE(CAST(price AS varchar),'--');
```

Let's give it a go.

### Exercise

Second time success! Modify the template to select the product `name` and `launch_date`. Show **'no date'** when there is no `launch_date`. Add `CAST` so that `COALESCE` works properly.

```sql
SELECT
  name,
  COALESCE(CAST(launch_date AS varchar), 'no date') AS launch_date
FROM product;
```

## COALESCE with other functions

Nice! You can also use `COALESCE` with other functions: concatenation, multiplication etc. Take a look:

```sql
COALESCE(category, '') || ':' || COALESCE(type, '')
```

In the above fragment, a `NULL` category or type will be replaced by an empty string. Thanks to this, we can still see the type when the category is `NULL` and vice versa.

### Exercise

Show the following sentence: `Product X is made in Y`. Where **X** is the `name` and **Y** is the `production_area`. If the `name` is not provided, write `'unknown name'` instead. If the `production_area` is not provided, write `'unknown area'`. Name the column `sentence`.

```sql
SELECT
    'Product '
    || COALESCE(name, 'unknown name')
    || ' is made in '
    || COALESCE(production_area, 'unknown area')
    || '.' AS sentence
FROM product;
```

## COALESCE with calculations

Good. You can also use `COALESCE` in calculations in a similar way:

```sql
COALESCE(price, 0) * 1.05
```

The above query will return the price times `1.05` or `0 (0 * 1.05 = 0)` if the price is `NULL`.

### Exercise

The company organized a discount campaign on all prices: **-10%**.

Show the **names** of all products together with their `price` and the **new prices** (name the column `new_price`). If there is no price, show **0.00** in the column `new_price`. Round the result to **two decimal points**.

```sql
SELECT
  name,
  price,
  ROUND(COALESCE(price, 0) * 0.9, 2) AS new_price
FROM product;
```

## COALESCE with more than two parameters

Good job. The last thing you should know about `COALESCE` is that it can take more than two arguments. It will simply look for the first `non-NULL` value in the list and return it.

```sql
COALESCE(name, CAST(id AS varchar), 'n/a')
```

The above function will try to show the `name` of a given product. If the `name` is unknown, it will try to show its `id` instead. If the `id` is unknown too, it will simply show **'n/a'**.

### Exercise

Show the `name` of each product together with its `type`. When the `type` is unknown, show the `category`. When the category is missing too, show **'No clue what that is'**. Name the column `type`.

```sql
SELECT
  name,
  COALESCE(type, category, 'No clue what that is') AS type
FROM product;
```

## New function NULLIF

Okay! Another nice function, albeit less frequently applied, is `NULLIF`. `NULLIF(x, y)` returns `NULL` if both `x` and `y` are equal. Otherwise, it returns the first argument. For example, `NULLIF(5, 4)` will return **5** while `NULLIF(5, 5)` will return `NULL`.

You might wonder how you can use this function in your queries. The answer is: it helps you **avoid dividing by zero**. Take a look at this theoretical example:

Let's say we have **$10,000** and we want to give equal portions of this amount to some people. We know that the number of these people is stored in the column `all_people`. But we also know that there are some people who are rich already, so they don't need the money from us. Their number is stored in the column `rich_people`. Now, if we want to decide how much a single "not-rich" person should get, we could write:

```sql
10000 / (all_people - rich_people)
```

And the query works fine… unless all the people are rich. We will then get a **0** in the denominator. As you know, we **can't** divide by **0**, so the database will return an error.

Luckily, we can use `NULLIF`:

```sql
10000 / NULLIF((all_people - rich_people), 0)
```

`NULLIF` checks if the subtraction equals **0**. If it doesn't, it just gives the result of the subtraction. If it does, it returns a `NULL`. Dividing by 0 is illegal, but dividing by `NULL` will just give `NULL` – in this way, we can at least prevent our database from producing an error.

### Exercise 1

Today, the customers at Highland Furniture get a special offer: the `price` of each product is decreased by **1.99**! This means that some products may even be free!

Our customer has **$1,000.00** and would like to know how many products of each kind they could buy.

Show the `name` of each product and a second column named `quantity`: Divide the sum of **1000.00** by the **new price** of each product. Watch out for division by **0** and return a `NULL` instead.

Most quantities will have a decimal part. That's okay for this exercise.

```sql
SELECT
  name,
  1000.00 / NULLIF(price - 1.99, 0) AS quantity
FROM product;
```

### Exercise 2

Show the `name` of each product and the column `ratio` calculated in the following way: the `price` of each product in relation to its `shipping_cost` in **percent**, **rounded** to an integer value (e.g. **31**).

If the `shipping_cost` is **0.00**, show `NULL` instead.

```sql
SELECT 
  name, 
  ROUND(
    (
      price / NULLIF(shipping_cost, 0)
    ) * 100
  ) AS ratio 
FROM product;
```

### Exercise 3

Mr Amund wants to offer a new promotion.

The promotion is as follows: every customer who orders a product and picks it up on their own (i.e., no shipping required) can buy it at a special price: the initial `price` **MINUS** the `shipping_cost`! If the `shipping_cost` is greater than the price itself, then the customer still pays the difference (i.e. the **absolute value** of `price - shipping_cost`).

Our customer has **$1,000.00** again and wants to know how many products of each kind they could buy. Show each product `name` with the column `quantity` which calculates the number of products. Drop the decimal part. If you get a price of **0.00**, show `NULL` instead.

```sql
SELECT
  name,
  FLOOR(
    1000.00 / NULLIF(
      ABS(price - shipping_cost), 0
    )
  ) AS quantity
FROM product;
```

## Summary

Very nice. It's time to review what we've learned about `NULL`s so far:

- Rule number one: Never trust a `NULL`. Keep your eyes open.
- Use the operator `IS NULL` to check if the column is `NULL`.
- Use the operator `IS NOT NULL` to check if the column is not `NULL`.
- The equality and non-equality conditions (`price = 7`, `price = NULL`, `price > 15`) are **never true** when the argument is `NULL`.
- Arithmetical operations (e.g. `a + b`) and most functions (e.g. `a || b`, `length(a)`) will return a `NULL` if any of the values is a `NULL`.
- `COALESCE(x, y, ...)` returns the first **non-NULL** argument.
- `NULLIF(x, y)` returns `x` when `x != y` or `NULL` when `x = y`.

## Quiz

Are you ready to practice?

### Exercise 1

Select the `name` and `launch_date` of all products for which the launch date **is not** February 25, 2015.

```sql
SELECT name, launch_date
FROM product
WHERE launch_date != '2015-02-25'
  OR launch_date IS NULL;
```

### Exercise 2

Show the `name` of all products together with their `price`. If the `price` is equal to **19.99** change it to `NULL`. However, make sure there aren't any `NULL`s in the `price` column, show **'unknown'** instead of them. Make sure the latter column is named `price`.

```sql
-- Option 1
SELECT
  name,
  COALESCE(NULLIF(price, 19.99)::varchar, 'unknown') AS price
FROM product;

-- Option 2
SELECT
  NAME,
  COALESCE(CAST(NULLIF(price, 19.99) AS varchar), 'unknown') AS price
FROM product;
```

### Exercise 3

Show the `id`, `name` and `category` of all products in the **descending** order of names.

```sql
SELECT id, name, category
FROM product
ORDER BY name DESC;
```

### Exercise 4

Goood! Things are getting serious now: let's add another table. You will work with the table `product` and the table `advertisement` in the next three exercises.

The table `advertisement` tells us which products have been advertised so far. It also informs us where and when this happened.

For each advertisement, show its `id`, `country`, `start_date` and `end_date` together with the `name` of the product advertised.

If there is no `start_date` or no `end_date`, show **'n/a'** instead. If there is no `name` of the product, show **'no name'**. Order the results by the `start_date`, with the **oldest dates shown first**. The column names should be: `id`, `country`, `start_date`, `end_date`, and `name`.

```sql
SELECT
  a.id,
  a.country,
  COALESCE(a.start_date::varchar, 'n/a') AS start_date,
  COALESCE(a.end_date::varchar, 'n/a') AS end_date,
  COALESCE(p.name, 'no name') AS name
FROM advertisement a
LEFT JOIN product p ON a.product_id = p.id
ORDER BY start_date;
```

### Exercise 5

For each product with a **non-NULL** `name`, show its `id` and the **number of advertisements** associated with it. Sort the results by the `id` in **descending** order.

```sql
SELECT
  p.id,
  COUNT(a.id)
FROM product p
LEFT JOIN advertisement a ON p.id = a.product_id
WHERE p.name IS NOT NULL
GROUP BY p.id
ORDER BY p.id DESC;
```

### Exercise 6

For each advertisement, show its `id` and the following sentence (as `sentence`):

```
The advertisement with id {id} for the product {name} was started on {date}.
```

Replace **{id}**, **{name}** and **{date}** with the proper columns. If there is no `name`, show the product `id`, if the product `id` is missing too, show **'no name'**. If there is no `started_date`, show **'n/a'**. Ignore products with missing `price`.

```sql
SELECT
  a.id,
  CONCAT(
    'The advertisement with id ',
    a.id,
    ' for the product ',
    COALESCE(p.name, p.id::varchar, 'no name'),
    ' was started on ',
    COALESCE(a.start_date::varchar, 'n/a'),
    '.'
  ) AS sentence
FROM advertisement a
LEFT JOIN product p ON a.product_id = p.id
WHERE p.price IS NOT NULL;
```

## Congratulations

Wow, piece of cake for you. Congratulations!

That's all you need to know about `NULL`s in our course. We hope you enjoyed working with Mr Amund and his company. See you in the next part!
