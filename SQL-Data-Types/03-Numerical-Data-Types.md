# Numerical data types

## Number data types: introduction

Welcome to the second part of our Understanding Data Types course. Today, we're going to deal with numerical data types.

Let's get started!

Remember your school days? You didn't learn all kinds of numbers at once. In kindergarten, you learned natural numbers (`1`, `2`, `3`). Later, you were taught fractions (`1/3`, `3/5` or `0.2`, `0.7`) and negative numbers (`-3`, `-4.5`). At some point, you may have learned real numbers (e.g., `π`, `√x`).

Why weren't you taught all the numbers at once? Because some of them are simple and some are more complex. Adding fractions, for instance, is more difficult than adding natural numbers. It's easier to add `1 + 2` than `3/2 + 4/5`.

The same applies to databases. They can make calculations faster if they know what kind of numbers they have to compute.

## integer

Let's start off with a data type you already know – `integer`. As you can expect, this data type stores **integer** or whole numbers (like `3`, `7`, or `-4`). We use it to count things like chairs, books, legs, etc. In our database, the `integer` type can store whole numbers from `-217483648` to `217483647`.

Our database has various numeric data types that can store values of different ranges. `integer` is the most popular type, but if you need a greater range, just check the documentation of your database.

## Exercise

Peter wants to have a list of users who paid to get a premium account on his dating website. Create a simple table named `premium_account` that has a single integer column called `user_id`.

```sql
CREATE TABLE premium_account (
    user_id INTEGER
);
```

## integer – inserting data

Great! Remember that numbers don't take quotation marks in SQL statements. For example:

```sql
INSERT INTO premium_account VALUES (6);
```

This will simply insert a `6` into the only column of the `premium_account` table. We did not need to place the `6` in quotes, as we did earlier with text. The same applies for any other SQL statement with numbers.

### Exercise

A user (with the `user_id` of `3`) has bought a premium account! Add that person to the table `premium_account`.

```sql
INSERT INTO premium_account VALUES (3);
```

## integer and text values

Excellent! Peter's business is starting to grow!

Now, check for yourself whether it's possible to enter a text value into a number column.

### Exercise

Try to put a text value like `'Rose'` or `'5a7'` into the table `premium_account`.

```sql
INSERT INTO premium_account VALUES ('Rose');
```

Output:

```
ERROR: invalid input syntax for type integer: "Rose" Line: 1 Position in the line: 37
```

## Numbers out of range

Nice try! As you can see, it's not possible to enter a text value into a number column. Numbers don't provide as much space as text data, so text information simply doesn't fit into number columns!

Now, how about numbers outside the data type's range?

### Exercise

Can we put a number that's bigger than the maximum or smaller than the minimum in an `integer` column? Remember, `integer` stores numbers from `-2147483648` to `2147483647`.

Try to insert a number outside of these limits into the `premium_account` table.

```sql
INSERT INTO premium_account VALUES (2147483648);
```

Output:

```
ERROR: integer out of range Line: 1 Position in the line: 1
```

## Using SELECT with numeric data types

See what's happened? You can't insert an out-of-range number for the same reason you can't insert a text value – it simply won't fit!

Now that we understand what will fit into a numeric-type column, let's see what we can do with the numbers. You can use mathematical operators (like `+` or `*`) and logical operators (like `<=`) in SQL statements with number columns. Take a look at the example below:

```sql
SELECT
  *
FROM premium_account
WHERE user_id = 5;
```

This will select all the information for the user with the ID of 5. Piece of cake!

### Exercise

Premium accounts are starting to sell like hotcakes! Given that the user with `user_id = 1` is Peter, select all information from table `premium_account` where the `user_id` is greater than 1. Let's see how many premium accounts have been purchased.

```sql
SELECT
  *
FROM premium_account
WHERE user_id > 1;
```

## Fractions: double precision and real data types

Excellent! You are now ready to move on to more complicated number types.

Apart from integer numbers, there are also fractions. In our database, we can use the `double precision` and `real` data types to store them. Just like with integer types, each database has its own types for these "floating point" numbers. Their ranges and precisions are always given in the documentation.

## Exercise

Peter wants to introduce weight into the user profiles so that people can quickly browse the site based on their size preferences.

For now, let's just create a simple table called `body` with an `integer` column called `user_id` and a `double precision` column called `weight`.

```sql
CREATE TABLE body (
    user_id INTEGER,
    weight DOUBLE PRECISION
);
```

## Floating point numbers – notation

All right! You might wonder how `double precision` and `real` numbers are stored in the database.

It's pretty straightforward; you write the numbers just as you do in English: `1.5` stands for one and a half.

If you want to store really big or really small numbers in your database, you can use scientific notation in `double precision` (15 decimal digits precision) and `real` columns (6 decimal digits precision). For instance, `1.26e4` stands for `1.26 * 10^4`, which is **12,600**.

**Good to know**: The letter "e" is the only letter allowed in number fields because it specifies the exponent for the base 10.

### Exercise

Our first daredevil is ready to specify his weight. The user with ID of `10` weighs `87.3` kg (about 192 pounds). Put this information into the `body` table.

```sql
INSERT INTO body VALUES (10, 87.3);
```

## Floating point numbers – calculations

Excellent! You can also use math and logical operators with `double precision` and `real` columns. If we only wanted to show people who weigh 80 kg or less, we could write the following:

```sql
SELECT
  *
FROM body
WHERE weight <= 80;
```

Simple, isn't it?

### Exercise

Peter got feedback from his users. They complain that weight without height tells them nothing! After all, it's not extraordinary for a man 2 meters tall (6 ft 7 in) to weigh 85 kg (187 lbs). But the same weight on a man of 1.60 meters (5ft 3 in) is quite different!

In our table `body`, we now have three columns: `user_id`, `weight`, and `height`. Select all the information about users for whom the `weight`/`height` ratio is lower than 0.5.

```sql
SELECT
  *
FROM body
WHERE weight / height < 0.5;
```

## Floating point numbers – issues with precision

Excellent! See how convenient these numbers are? Still, there is one problem with `real` and `double precision` numbers that you must take into account: **rounding errors**. Why do these happen?

Well, `double precision` and `real` numbers store information in the **binary** system. Values such as `0.2` don't have a precise binary representation. Numbers like `1/3` can't be represented with a precise decimal number at all. This is why such numbers need to be **rounded**. And when you add a rounded number to a rounded number, and the result is also rounded – well, you can guess what happens.

### Exercise

Have you noticed that we have a rather special user in our table? The one with `user_id` 6? It's **Thumbelina**. We will use the information she provided to check rounding errors.

Select her `height` and `weight` and calculate the third column called `expected_zero` in the following way: `height - weight - height + weight`. It should equal zero, right?

```sql
SELECT
  height,
  weight,
  height - weight - height + weight AS expected_zero
FROM body
WHERE user_id = 6;
```

Output:

```
 height | weight | expected_zero
--------+--------+------------------------
      1 |    0.2 |   5.551115123125783e-17
```

## decimal numbers

Good! That was a rather peculiar result, wasn't it? Let's see how we can fix it.

What numbers are the most important for every business? **Money**, of course. Because of rounding errors, **floating point numbers are not suitable for money values**. After all, we don't want the bank to think that we ALMOST or NEARLY paid our monthly payment!

Money values can be stored in another data type: `decimal`. What is unique about this data type is that it stores numbers in the decimal system.

`decimal` values are precise when they are added or divided by integer numbers. This is why they are an excellent choice for financial operations (like calculating tax).

In SQL, `decimal(p, s)` takes two numbers: `p` is the precision (that is, the total number of digits in the number) and `s` is the scale (the number of digits after the decimal point). `decimal(5, 2)` is a number which has 5 digits, two of which are after the decimal point.

### Exercise

The online dating business is going really well. Peter needs another table to store information about money transfers from his users. Create a simple table called `payment` that has two columns: `user_id` (which stores `integer` values) and `amount` (a `decimal` value with 6 digits, of which two are after the decimal point).

```sql
CREATE TABLE payment (
    user_id INTEGER,
    amount DECIMAL(6, 2)
);
```

## decimal – inserting data

Great! How do we write `decimal` numbers in SQL? The answer is simple: just as you write floating point numbers. The number `1.5` still stands for one and a half. Quite convenient, isn't it?

### Exercise

We've got a new payment from the user with `user_id = 13`. He made a payment in the amount of $`314.27`. Insert this data into the `payment` table.

```sql
INSERT INTO payment VALUES (13, 314.27);
```

## decimal – values out of range

Good job! You deserve another break. Let's play around with some decimal numbers.

### Exercise

Experiment with the values in the column `amount` and try some which are out of range. We specified two digits after the decimal point, so try to insert a value that has three.

```sql
INSERT INTO payment VALUES (13, 314.271);
```

Output:

```
1 row(s) affected
```

## decimal – calculations

Nice work! Did you try to insert a value like `314.271`? Did you see what happened? It was rounded to `314.27`. This is because we specified two digits after the decimal point when creating the column. Once you provide the precision and scale, you can't exceed it.

### Exercise

Let's check how much tax Peter is going to pay on the transactions in the `payment` table. Select `0.15` of every `amount` and name this column `tax`.

```sql
SELECT
  amount * 0.15 AS tax
FROM payment;
```

## decimal precision

As you can see, all the calculations seem correct now. That's good news for us.

### Exercise

Okay! Let's go back to our table `body` and our Thumbelina problem. We changed the columns to the `decimal` data type. Again, select the `height` and `weight` and calculate the third column `expected_zero` in the following way: `height - weight - height + weight`. The `user_id` for Thumbelina is `6`.

Will this calculation equal zero now? Let's find out!

```sql
SELECT
  height,
  weight,
  height - weight - height + weight AS expected_zero
FROM body
WHERE user_id = 6;
```

Output:

```
 height    | weight  | expected_zero
-----------+---------+---------------
      1.00 |    0.20 |          0.00
```

## Summary

Okay, let's wrap things up. We've learned the following numeric data types:

- `integer` – Used to store integer numbers, such as `32` or `-151`.
- `double precision` and `real` – Used to store fractions where high precision is not needed.
- `decimal` – Used to store decimal numbers and for precise calculations, like for money or scientific calculations.

How about a short quiz before the next part?

### Exercise

Peter is really happy with his website. He's decided to open an online store with products for people who fall in love. Heart-shaped balloons, rings, fresh flowers – anything you can imagine. Let's create a table called `product` for him. Take a look at the description below, decide on the data types, and provide a suitable SQL statement.

Each product has an `id` (an integer number) and a `name` that's 64 characters long at most. It also has a `description`, which can be of up to 256 characters. We also need the `price` for each product (all of them cost below $300.00). Last but not least, we want to store product weights in a column named `weight` and we are okay with small rounding errors.

```sql
CREATE TABLE product (
    id INTEGER,
    name VARCHAR(64),
    description VARCHAR(256),
    price DECIMAL(5, 2),
    weight DOUBLE PRECISION
);
```

## Congratulations

Perfect! That was the last exercise in this part, congratulations!

In the next part, we'll focus on identity columns and sequences. See you there!
