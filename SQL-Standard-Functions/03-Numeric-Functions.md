# Numeric Functions

Master numeric functions in SQL. Learn about the caveats of mathematical operators in SQL, various rounding functions in SQL and computing proportions in SQL.

## Reviewing SQL and numbers

Welcome to the third part of our course. Today, we're going to take a close look at how numbers work in SQL. You know them already, of course – today we'll discuss the small details that sometimes make a huge difference.

## Get to know table character

Let's introduce the table we'll use in this part of the course. If you're one of those people who love **MMORPG** games, you'll love the table too.

The table name is `character` and it stores information about heroes in an online RPG game. A single user can have more than one character. Let's see what the table contains in detail.

### Exercise

Select **all** the columns for the table `character`.

Each character has its unique `id` and the `id` of the user it belongs to. The character is at a certain `level`, belongs to a certain `class` (**wizard** or **warrior**) and has a certain amount of money (`account_balance`).

There are also `hp` (**health points**) and `mp` (**mana points**), as well as the basic statistics – `strength` and `wisdom`. Due to various curses and blessings, the statistics can be affected by the `stat_modifier`, which can be positive or negative.

Finally, there is the `height` and `weight` of each character, expressed in **meters** and **kilograms** respectively.

```sql
SELECT *
FROM character;
```

## Numbers – quick review

Before we continue, let's review what we know about numbers already.

**Integer** numbers are expressed in the normal, intuitive way: `1`, `2`, `43`, `-27` etc. **Fractions** are expressed with a period (`.`): `12.45`, `-401.238`, etc. Please note that in some languages you use a comma instead of a period, but you cannot do that in **SQL** (`12,45` is **incorrect**)!

In SQL (and in most programming languages) there are three kinds of number types:

1. **Integer** type – they store integers but not fractions.
2. **Floating** point numbers – they store fractions in binary format.
3. **Decimal** numbers – they store fractions in decimal format.

In this part we'll discuss some of the differences between various numeric data types in SQL.

Of course, you can use the four basic mathematical operations: `+`, `-`, `*`, `/` with numbers in SQL. You can also use columns and constant numbers together, for instance:

```sql
SELECT hp / 100
FROM character;
```

### Exercise

For each character, display its:

- `name`
- `level`
- the **sum** of its `hp` and `mp` (name this column `sum`).

```sql
SELECT name, level, hp + mp AS sum
FROM character;
```

## Numbers – concatenation

Good. You can also join numbers and text values using the concatenation symbol `||`. Take a look:

```sql
SELECT 'Your character is at level ' || level AS sentence
FROM character;
```

Quite simple, as you can see.

### Exercise

For each character above the **first** level (`level > 1`), show the following text:

```
The account balance for {name} is {money}.
```

**{name}** is the `name` of the character and **{money}** is the current `account_balance`. Name the column `sentence`.

```sql
SELECT 'The account balance for ' || name || ' is ' || account_balance || '.' AS sentence
FROM character
WHERE level > 1;
```

## Problems with subtraction

Great! As you might expect, these simple operations can also get very tricky. Let's discuss them now.

We'll start with subtraction.

### Exercise

For a character **Mnah** (`name = 'Mnah'`), select `name`, `weight`, `height` and the result of the following calculation: `weight - height - weight + height` (name the last column `result`). It should equal `0`, right?

```sql
SELECT name, weight, height, weight - height - weight + height AS result
FROM character
WHERE name = 'Mnah';
```

Output:

| Name | Weight | Height | Result |
| --- | --- | --- | --- |
| Mnah | 80.3 | 1.93 | -3.5762787e-07 |

## Binary arithmetic is not exact

Ooops… something went wrong. Why did we get something so odd?

The type of columns `weight` and `height` is **real**, which is a floating point number. The internal representation here is **binary arithmetic**. It means that not all decimal numbers can be represented exactly. The computations are also **not performed exactly** - as we can see.

What can be done about it? Nothing :) That's the way binary arithmetic works. If you need exact computations, you have to use a decimal type.

Something to remember: When you deal with **money** values, you should **always use a decimal type**. Floating point numbers are for "scientific" computations on various measurements, like weight and height.

## Problems with division

Good job. Now you know that subtraction can be tricky. What about division?

What do you think, what is the value of `1/4`? Let's check that.

```sql
SELECT 1/4;
```

Output:

| ?column? |
| --- |
| 0 |

## Integer division

Wait ... what? We got a `0`? After all those years we've been taught it's `0.25`? Has someone deceived us?

Not really, no. What happened here is called **integer division**. Integer division in SQL takes place when both the dividend and the divisor are **integers**. Since they are **integers**, SQL wants to return an **integer** result to match the number type. In other words, it brutally cuts off the decimal part, which is `.25` in our case. Zero (`0`) is the only thing left.

What is more, the meaning of the operator `/` differs among databases. In **PostgreSQL** and **SQL Server**, it is **integer division**. In **MySQL** and **Oracle** it is **regular division** (and the result of `1/4` is `0.25`).

So, how can we make sure that the result includes the decimal part?

One thing you can do is change the type of one of the values to decimal: write `1/4.0` instead of `1/4`.

```sql
SELECT 1/4.0 AS result;
```

Output:

| ?column? |
| --- |
| 0.25000000000000000000 |

## New keyword CAST

Ha! It worked this time, didn't it? That's how you can force the desired result in SQL.

There is one 'but'. What can we do if both numbers are given as columns, e.g. `hp/level`? We need to use another trick: convert one type to another explicitly. This procedure is called **casting** and it uses the structure shown in the example below:

```sql
SELECT CAST(hp AS numeric)/level
FROM character;
```

`CAST(column AS type)` changes the column to the specified type.

In SQL standard, there are three kinds of numeric data types:

- **integer** data types. These are types with names like `INTEGER`, `INT`, `SMALLINT`, `BIGINT`, etc.
- **exact numeric** data types (decimal types). These are types with names like `NUMERIC` and `DECIMAL`.
- **inexact numeric** data types, with names like `FLOAT`, `REAL`, `DOUBLE PRECISION`.

Data types are very tricky in databases. Each database has its own names and ranges for numeric data types. To get accurate information about the data types supported in your database check its documentation!

In this course whenever we're doing division of two integers, we'll always **cast the numerator to a `NUMERIC` data type**. In your real-world application, you may need a different precision and a different casting (for example cast both numbers to `REAL`).

### Exercise

For each character, show its `name`, `level` and the `hp/mp` ratio (column name `ratio`). Use casting to get a precise result.

```sql
SELECT name, level, CAST(hp AS numeric)/mp AS ratio
FROM character;
```

## Division by zero

Okay. Let's discuss division further. As you know, there is one thing which you can never do: **divide by zero**. Let's see what happens in our database when you decide to follow the path of mathematical darkness.

## Division by zero continued

All right, now let's see what happens if you get many rows, of which only one contains **division by 0**.

### Exercise

Warriors get their first `wisdom` points at `level = 2` and we have one warrior at `level = 1` with `wisdom = 0`. Let's see what happens.

Run the template which divides the `mp` by `wisdom` for each character.

```sql
SELECT
  name,
  CAST(mp AS numeric) / wisdom AS ratio
FROM character;
```

Output:

```
ERROR: division by zero Line: 1 Position in the line: 1
```

## Getting rid of division by 0

Oops! As you can see, the error occurs even if there is a **single row** with a **0** value in the denominator. How can we deal with this? There are a few ways to solve the problem.

For now, you can use the good old `WHERE` clause to filter out those rows which contain a **0**:

```sql
...
WHERE column_name != 0;
```

You'll get to know other methods of dealing with division by zero in further parts of our course.

### Exercise

For each character, show its `name` and try to divide its `mp` by its `wisdom`. Filter out rows with **0** wisdom points. Name the second column `ratio`.

```sql
SELECT
  name,
  CAST(mp AS numeric) / wisdom AS ratio
FROM character
WHERE wisdom != 0;
```

## Function mod()

Okay. There is one more useful function related to division. This function is `mod(x,y)`, which returns the **remainder of** `x` divided by `y`.

For instance, `mod(9,7)` will return `2`, because `9/7` is `1` with `2` as the remainder.

In **SQL Server** the operator to compute the remainder is `%:` `9%7` returns `2`. This`%` operator is supported by **PostgreSQL** and **MySQL**, but not by **Oracle**.

Shall we do an exercise?

### Exercise

In our game, you can increase your `strength` by `1` if you sacrifice `7` `hp`.

For each character, show its `name` and calculate how many **health points** will be left if the player decides to sacrifice the **maximum number** of `hp`. Name the second column `health_points`.

```sql
SELECT
  name,
  mod(hp, 7) AS health_points
FROM character;
```

## Function round()

Good! Now that you know how to subtract and divide, we'll talk about other numerical functions. One of them is `round(x)`. This function will round the number within parentheses to the nearest integer number. This is standard mathematical rounding: any decimal part equal to or greater than 0.5 will be rounded up.

```sql
SELECT
  round(account_balance) AS rounded_account_balance
FROM character
WHERE id = 1;
```

The above query will take the `account_balance` of the character with `id = 1` (the `account_balance` is **899.34**) and round it to the nearest integer (**899** in this case).

### Exercise

For each character, show its `name`, its `account_balance` and its `account_balance` rounded to the nearest integer (name this column `rounded_account_balance`). Notice how mathematical rounding is applied.

```sql
SELECT
  name,
  account_balance,
  round(account_balance) AS rounded_account_balance
FROM character;
```

## Precision with round()

Good! There is also another version of `round`, which takes two arguments: `round(x, precision)`. The second argument is new and specifies the number of decimal places to be returned. For example,

```sql
SELECT round(136.123, 2);
```

will return **136.12**. Let's try it out.

### Exercise

Show each character's `name` together with its original `account_balance` and `account_balance` rounded to a single decimal place (name this column `rounded_account_balance`).

```sql
SELECT
  name,
  account_balance,
  round(account_balance, 1) AS rounded_account_balance
FROM character;
```

## Problems with round()

Nice job! Before we move on, you need to know that function `round(x, precision)` differs among the databases. In most of them (**MySQL**, **SQL Server**, **Oracle**) it works with every number type – integer, double precision, numeric, etc.

But in our database – **PostgreSQL**, if you want to round a number with precision to a specific decimal place, the number being rounded must be a `numeric` (`decimal`) type.

### Exercise

Try it out yourself. Try to round height to 2 decimal places.

```sql
SELECT round(height, 2)
FROM character;
```

Output:

```
ERROR: function round(real, integer) does not exist Hint: No function matches the given name and argument types. You might need to add explicit type casts. Line: 1 Position in the line: 8
```

## Round in Postgres – explanation

In Postgres, to round a floating point number and specify a precision at the same time, you have to first cast it as numeric. For example:

```sql
SELECT
  round(CAST(weight AS numeric), 2) AS rounded_weight
FROM character;
```

will round the weight to two decimal places.

### Exercise

Round `height` to two decimal places. Name the column `rounded_height`.

```sql
SELECT
  round(CAST(height AS numeric), 2) AS rounded_height
FROM character;
```

## Other rounding functions

That was correct again. There are other rounding functions available in each database.

- `ceil(x)` (in **SQL Server** – `ceiling()`) returns the smallest `integer` which is **not less** than `x`. In other words, it always **rounds up** (**13.7** will become **14**, and so will **13.1**).
- `floor(x)` is the opposite of `ceil(x)` – it always **rounds down**, so **13.7** will become **13**.
- `trunc(x)` (in **MySQL** – `truncate()`) is yet another function which always `rounds` towards 0. For **positive** numbers, it works like `floor(x)` (**13.7** becomes **13**). For negative ones, it works like `ceil(x)` (**-13.7** becomes **-13**).

What's more, each of the functions above can be used with a second argument to specify its precision, as in the case of `round(x, precision)`. When using the `round(x, precision)` function with two arguments, PostgreSQL requires us to pass the first argument of the numeric type. Use casting when appropriate.

### Exercise

Let's check some rounding functions in the next few exercises. Show the character's `name` together with its `weight`, followed by the `weight` rounded up (name this column `weight_rounded_up`).

```sql
SELECT
  name,
  weight,
  ceil(weight) AS weight_rounded_up
FROM character;
```

## Function floor() – practice

OK, that was `ceil(x)` which always rounds up. Next comes `floor(x)`.

### Exercise

Show each character's `name` together with its `account_balance` followed by the `account_balance` rounded down. Name the last column `floor`.

```sql
SELECT
  name,
  account_balance,
  floor(account_balance) AS floor
FROM character;
```

## Function trunc() – practice

Good. The last, but not the least, function to practice is `trunc(x)`. It always rounds towards zero.

### Exercise

Show the character's `name` together with its `stat_modifier`, followed by the `stat_modifier` rounded with the function `trunc(x,p)` to a single decimal place. Name the last column `trunc`. Observe how it behaves for positive and negative numbers.

```sql
SELECT
  name,
  stat_modifier,
  trunc(stat_modifier, 1) AS trunc
FROM character;
```

## Function abs()

Nice! Of course, SQL features numerical functions other than rounding too. Let's take a look at two of them.

The first one is `abs(x)` and it returns the **absolute value** of `x`. **Positive** numbers will be expressed as they are, but **negative** ones will be expressed **without** the minus at the beginning.

```sql
SELECT abs(3), abs(-3);
```

The above query will return `3` twice. The absolute value of `3` is `3`, just like the absolute value of `-3`. Let's give it a try.

### Exercise

For each character, show its `stat_modifier` and its **absolute** value (as `absolute_value`).

```sql
SELECT
  stat_modifier,
  abs(stat_modifier) AS absolute_value
FROM character;
```

## Function sqrt()

Perfect. The last function we want to introduce is `sqrt(x)`, which calculates the square root of `x` (√x).

```sql
SELECT sqrt(25);
```

The square root of `25` is `5` and this is the result we'll get from the above query. Let's give it a try again.

### Exercise

A nasty curse in our game changes your `strength` to its square root for a few minutes. Show each character's `name`, `strength` and calculate the **square root** of `strength` for each of them. Name the last column `square_root`.

```sql
SELECT
  name,
  strength,
  sqrt(strength) AS square_root
FROM character;
```

## Summary

Amazing! OK, let's summarize what we've learned today. We know the following principles:

Computations in floating point numbers are not always exact. Use decimal numbers for all money columns and when precision matters.
Dividing two integers is an integer division. Use CAST(column AS type) to avoid errors.
Avoid division by zero. For now ...
We've also learned some useful functions:

- `mod(x,y)` or `x%y` – returns the remainder of division of `x` by `y`.
- `round(x)` or `round(x,p)` – rounds the number to an integer or to a specified precision (`p`).
- `ceil(x)` – rounds up to the nearest integer value.
- `floor(x)` – rounds down to the nearest integer value.
- `trunc(x)` or `trunc(x,p)` – always round towards zero to an interger value or to a specified precision (`p`).
- `abs(x)` – returns the absolute value of `x`.
- `sqrt(x)` – returns the square root of `x`.

The queries we've written so far were fairly simple. Let's test your knowledge with more advanced examples.

### Exercise 1

Calculate the **BMI** for every character in the table. **BMI** is calculated in the following way:

```
BMI = weight in kilograms ÷ (height in meters)²
```

Round the result to an integer. Show the characters `name` and the calculated **BMI** (column name `bmi`).

```sql
SELECT
  name,
  round(weight / (height ^ 2)) AS bmi
FROM character;
```

## Exercise 2

A healing potion costs **50** gold coins. For each character with an account balance of at least **100**, calculate how many healing potions it can buy (column name `potion_amount`) and how much money it will have left as a result of that purchase (column `change`). Round the first column down to integers.

```sql
SELECT
  floor(account_balance / 50) AS potion_amount,
  account_balance - floor(account_balance / 50) * 50 AS change
FROM character
WHERE account_balance >= 100;
```

### Exercise 3

Each **warrior** (`class = 'warrior'`) at `level` **3 or higher** can perform a special attack whose damage is calculated as follows: its `strength` plus one fourth of its `hp`, and then multiplied by the absolute value of `stat_modifier`. Round this column to **2 decimal places**.

Show the `name` and special attack damage (column `damage`) calculated for those characters which have the attack available.

```sql
SELECT
  name,
  round((strength + (hp * 0.25)) * abs(stat_modifier), 2) AS damage
FROM character
WHERE class = 'warrior' AND level >= 3;
```

### Exercise 4

For players with IDs equal to **1** and **5**, show `firstname` and `lastname` together with the `level`, `height` rounded to two decimal places, and `account_balance` rounded down. The column names should be: `firstname`, `lastname`, `level`, `height`, and `account_balance`.

```sql
SELECT
  player.firstname,
  player.lastname,
  level,
  round(CAST(height AS DECIMAL), 2) AS height,
  floor(account_balance) AS account_balance
FROM character
JOIN player ON character.player_id = player.id
WHERE player.id IN (1, 5);
```

## Congratulations

Excellent! You've completed all the exercises correctly.

That's all for today. We hope to see you again in the next part soon!
