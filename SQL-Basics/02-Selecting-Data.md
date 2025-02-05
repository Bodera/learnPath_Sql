# Selecting data

# Table of contents

- [Get all data](#get-all-data)
- [Select one column](#select-one-column)
- [Select many columns](#select-many-columns)
- [Select only a few rows](#select-only-a-few-rows)
- [Conditional operators](#conditional-operators)
- [The not equal sign](#the-not-equal-sign)
- [Conditional operators and selecting columns](#conditional-operators-and-selecting-columns)
- [Logical operators - OR](#logical-operators-or)
- [Logical operators - AND](#logical-operators-and)
- [The between operator](#the-between-operator)
- [Logical operators - NOT](#logical-operators-not)
- [Join even more conditions](#join-even-more-conditions)
- [Use text](#use-text)
- [The percentage sign](#the-percentage-sign)
- [The percentage sign continued](#the-percentage-sign-continued)
- [The underscore sign](#the-underscore-sign)
- [Looking for NOT NULL values](#looking-for-not-null-values)
- [Looking for NULL values](#looking-for-null-values)
- [Comparisons with NULL](#comparisons-with-null)
- [Basic mathematical operators](#basic-mathematical-operators)
- [Put your skills into practice](#put-your-skills-into-practice)

## Get all data
It's time to run your first SQL query! As you remember, the data in a database are stored in tables.

You can see all data in the `user` table with this query:

```sql
SELECT *
FROM user;
```

`SELECT` tells your database that you want to select data. `FROM user` tells the database to select data from the table user.

Finally, the asterisk (`*`) tells the database that you want to see all columns in this table.

Remember that it is a good practice to always end your SQL command with a semicolon (`;`). A semicolon is like a period at the end of the sentence. It tells the database that you're done with your command.

### Exercise

Select all data from the `car` table

```sql
SELECT *
FROM car;
```

## Select one column

What if you don't want to select all columns from a table? No problem. Just type the **column name** instead of the asterisk. If you want to get **names** of all users, type:

```sql
SELECT name
FROM user;
```

### Exercise

Select brand names from the `car` table.

```sql
SELECT brand
FROM car;
```

## Select many columns

If you want to get a couple of columns, give the names of the desired columns before `FROM`. So to get names and ages of all users, type:

```sql
SELECT
  name,
  age
FROM user;
```

Note that you separate the names of the columns with a comma (`,`).

### Exercise

Select model and price from table car.

```sql
SELECT
  model,
  price
FROM car;
```

## Select only a few rows

Our table is quite small, so if we wanted to get some information about Volkswagens, we could select all rows and just ignore the extra few which contain other brands. But what if our table consisted of thousands of rows?

```sql
SELECT *
FROM user
WHERE id = 100;
```

Look what happened. We've added `WHERE` and a **condition**. The simplest condition looks like the one in our example – we want to retrieve information about a user with a specific ID (100), so we use the appropriate condition: `id = 100`.

### Exercise

Select all columns for those cars which were produced (column production_year) in 1999.

```sql
SELECT *
FROM car
WHERE production_year = 1999;
```

## Conditional operators

Good job! Now, besides the equality sign (`=`), there are also some other conditional operators which you can use. Look at the next example.

```sql
SELECT *
FROM user
WHERE age < 20;
```

Instead of the equality sign (`=`), we used the less than sign (`<`). Now our instruction selects only those users who are below 20. We can apply several operators in the same way:

- `<` (less than),
- `>` (greater than),
- `<=` (less than or equal),
- `>=` (greater than or equal).

Easy, right? Why don't we practice a bit?

### Exercise

Select all columns for all cars with price higher than $10,000.

```sql
SELECT *
FROM car
WHERE price > 10000;
```

## The not equal sign

There is one more very important conditional operator, the inequality sign (`!=` or sometimes `<>`). Look at the example:

```sql
SELECT *
FROM user
WHERE age != 18;
```

See how easy it is? We've used the inequality sign (`!=`) to select all users who aren't 18.

### Exercise

Select all columns for those cars which weren't produced in 1999.

```sql
SELECT *
FROM car
WHERE production_year <> 1999;
```

## Conditional operators and selecting columns

You've got the hang of it already, haven't you? Let's combine what we know about conditional operators with selecting specific columns.

```sql
SELECT
  id,
  age
FROM user
WHERE age <= 21;
```

Easy, right? Instead of the asterisk (`*`), we just name the specific columns we're interested in.

### Exercise

Select brand, model and production year of all cars cheaper than or equal to $11,300.

```sql
SELECT
  brand,
  model,
  production_year
FROM car
WHERE price <= 11300;
```

## Logical operators OR

Up until now, we were able to filter the rows in the previous examples using conditional operators (`=`, `!=`, `<`, `>`, `<=`, `>=`). But what about situations when we want to be really picky and join a few conditions?

```sql
SELECT id, name
FROM user
WHERE age > 50
  OR height < 185;
```

We've added a new `OR` clause which allows us to join more conditions.

In this case, we only select those users who are above 50 years old or under 185 cm of height. In other words, a row is displayed when the first condition or the second condition is true. Note that if both conditions are true, the row is also displayed.

### Exercise

Select `vin`s of all cars which were produced before 2005 or whose price is below $10,000.

```sql
SELECT vin
FROM car
WHERE production_year < 2005
  OR price < 10000;
```

## Logical operators AND

Excellent! Of course, `OR` isn't the only logical operator out there. Take a look at the next example:

```sql
SELECT
  id,
  name
FROM user
WHERE age <= 70
  AND age >= 13;
```

`AND` is another logical operator.

In this case, only those users will be selected whose age is 13 or above **and** 70 or below. In other words, both conditions must be fulfilled to retrieve a particular row.

### Exercise

Select `vin`s of all cars which were produced after 1999 and are cheaper than $7,000.

```sql
SELECT vin
FROM car
WHERE production_year > 1999
  AND price < 7000;
```

## The BETWEEN operator

Good. Now, if you want to find users whose age is between 13 and 70, you can of course use the previous example:

```sql
SELECT id, name
FROM user
WHERE age <= 70
  AND age >= 13;
```

But there is also another way of writing the example above. Take a look:

```sql
SELECT
  id,
  name
FROM user
WHERE age BETWEEN 13 AND 70;
```

We introduced a new keyword `BETWEEN` which simply means that we look for rows with the age column set to be anything between 13 and 70, including these values.

Note, however, that some database systems can produce different results – in some of them, the values 13 and 70 are not included in the results. Always check how `BETWEEN` works in your database.

### Exercise

Select `vin`, `brand`, and `model` of all cars which were produced between 1995 and 2005.

```sql
SELECT
  vin,
  brand,
  model
FROM car
WHERE production_year BETWEEN 1995 AND 2005;
```

## Logical operators NOT

Keep up the good work! There is one more logical operator worth mentioning: `NOT`. Basically speaking, whatever is stated after `NOT` will be negated:

```sql
SELECT *
FROM user
WHERE age NOT BETWEEN 20 AND 30;
```

In the above example we placed `NOT` in front of a `BETWEEN` clause. As a result, we'll get all users except for those aged 20 to 30.

### Exercise

Select `vin`, `brand`, and `model` of all cars except for those produced between 1995 and 2005.

```sql
SELECT
  vin,
  brand,
  model
FROM car
WHERE production_year NOT BETWEEN 1995 AND 2005;
```

## Join even more conditions

We can include even more conditions by using **parentheses**, according to our needs. If we want to find only those users who are above 70 years old or below 13 and who are at least 180 cm tall, we can use the following expression:

```sql
SELECT
  id,
  name
FROM user
WHERE (age > 70 OR age < 13)
  AND (height >= 180);
```

### Exercise

Select the `vin` of all cars which were produced before 1999 or after 2005 and whose price is lower than $4,000 or greater than $10,000.

```sql
SELECT vin
FROM car
WHERE (production_year < 1999
  OR production_year > 2005)
  AND (price < 4000
  OR price > 10000);
```

## Use text

Until now, we only worked with numbers in our `WHERE` clauses. Is it possible to use letters instead? Of course it is! Just remember to put your text in single quotes like this: `'example'`.

If you wanted to know the age of all Smiths in your table, you could use the following code:

```sql
SELECT age
FROM user
WHERE name = 'Smith';
```

Note that the case of the letters matters, i.e. 'Smith' is different from 'SMITH'.

### Exercise

Select all columns of all Ford cars from the table.

```sql
SELECT *
FROM car
WHERE brand = 'Ford';
```

## The percentage sign

Great! Now, what happens if we don't know precisely what letters we're looking for? With text values, you can always use the `LIKE` operator instead of the equality sign. What change does it make? Well, take a look at the following example:

```sql
SELECT *
FROM user
WHERE name LIKE 'A%';
```

`LIKE` allows for the use of the percentage sign (`%`). The percentage sign applied in the example **matches any number (zero or more) of unknown characters**.

As a result, we'll obtain all users whose name begins with the letter `'A'`. We may not remember someone's exact name, but we know it begins with an A and that's enough. Convenient, isn't it?

### Exercise

Select `vin`, `brand`, and `model` of all cars whose brand begins with an F.

```sql
SELECT
  vin,
  brand,
  model
FROM car
WHERE brand LIKE 'F%';
```

## The percentage sign continued

That's the way to go! Of course, the percentage sign (`%`) can be put anywhere between the single quotes and as many times as it's necessary:

```sql
SELECT *
FROM user
WHERE name LIKE '%A%';
```

That's right, the example above will select any user **whose name contains at least one 'A'**.

Remember that the percentage sign (`%`) can also replace zero characters, so the name can also begin or end with the A.

### Exercise

Select vin of all cars whose model ends with an s.

```sql
SELECT vin
FROM car
WHERE model LIKE '%s';
```

## The underscore sign 

Nice! Now, sometimes we may not remember just one letter of a specific name. Imagine we want to find a girl whose name is... Catherine? Katherine?

```sql
SELECT *
FROM user
WHERE name LIKE '_atherine';
```

The underscore sign (`_`) matches exactly one character. Whether it's Catherine or Katherine – the expression will return a row.

### Exercise

Select all columns for cars which brand matches `'Volk_wagen'`.

```sql
SELECT *
FROM car
WHERE brand LIKE 'Volk_wagen';
```

## Looking for NOT NULL values

In every row, there can be `NULL` values, i.e. fields with unknown, missing values. Remember the Opel from our table with its missing price? This is exactly a `NULL` value. We simply don't know the price.

To check whether a column has a value, we use a special instruction `IS NOT NULL`.

```sql
SELECT id
FROM user
WHERE middle_name IS NOT NULL;
```

This code selects only those users who have a middle name, i.e., their column `middle_name` is known.

### Exercise

Select all columns for each car whose `price` column isn't a `NULL` value.

```sql
SELECT *
FROM car
WHERE price IS NOT NULL;
```

## Looking for NULL values

Great! Remember, `NULL` is a special value. You can't use the equal sign to check whether something is `NULL`. **It simply won't work**. The opposite of `IS NOT NULL` is `IS NULL`.

```sql
SELECT id
FROM user
WHERE middle_name IS NULL;
```

This query will return only those users who don't have a middle name, i.e. their `middle_name` is unknown.

### Exercise

Select all columns for each car whose price is unknown (`NULL`).

```sql
SELECT *
FROM car
WHERE price IS NULL;
```

## Comparisons with NULL

Good job. Remember, `NULL` is a special value. It means that some piece of information is **missing** or **unknown**.

If you set a condition on a particular column, say `AGE < 70`, the rows where age is `NULL` will always be **excluded** from the results. Let's check that in practice.

In no way does `NULL` equal zero. What's more, the expression `NULL = NULL` is never true in SQL!

### Exercise

Select all columns for cars whose `price` column is greater than or equal to zero.

Note that the Opel with an unknown price is **not** in the result.

```sql
SELECT *
FROM car
WHERE price >= 0;
```

## Basic mathematical operators

Nice! We may now move on to our next problem: **simple mathematics**. Can you add or multiply numbers in SQL? Yes, you can! Take a look at the example:

```sql
SELECT *
FROM user
WHERE (monthly_salary * 12) > 50000;
```

In the above example, we multiply the monthly salary by 12 to get the annual salary by using the asterisk (`*`). We may then do whatever we want with the new value – in this case, we compare it with $50,000.

In this way, you can add (`+`), subtract (`-`), multiply (`*`) and divide (`/`) numbers.

### Exercise

Select all columns for **cars** with a tax amount over **$2000**. The tax amount for all cars is 20% of their price. Multiply the `price` by **0.2** to get the **tax amount**.

```sql
SELECT *
FROM car
WHERE (price * 0.2) > 2000;
```

## Put your skills into practice

Very good! Now let's put together all the information we've learned so far. Let's imagine a customer who walks in and wants to know if we have any cars that meet his needs.

### Exercise

Select all columns of those cars that:

- were produced between 1999 and 2005,
- are not Volkswagens,
- have a model that begins with either `'P'` or `'F'`,
- have their price set.

```sql
SELECT *
FROM car
WHERE production_year BETWEEN 1999 AND 2005
  AND brand != 'Volkswagen'
  AND (model LIKE 'P%' OR model LIKE 'F%')
  AND price IS NOT NULL;
```