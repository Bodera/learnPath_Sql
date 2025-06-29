# Boolean, Date, and Time data types

## Welcome

Welcome for the fourth time in this course! Today, we're going to take a look at some other data types available in SQL: the `boolean`, `date`, and `time` types. With these, you'll be able to model and create sophisticated tables.

Are you ready?

## Boolean

Good. We'll start by talking about `boolean` columns.

The `boolean` data type stores logical values, i.e., `true` or `false`. This data type usually records the answer to a yes/no question like: "Does the user have pets?"

`boolean` columns are convenient because they require very little space. However, some databases don't have a separate `boolean` data type; they simulate it using other types.

### Exercise

Once Peter released the beta version of his dating website, he noticed there were fake accounts. So Peter wants to introduce a new feature – user verification. For now, let's create a simple table called `verification` with two columns: `user_id` (`integer`) and `is_verified` (`boolean`).

```sql
CREATE TABLE verification (
    user_id INTEGER,
    is_verified BOOLEAN
);
```

## Boolean – inserting data

Great!

`boolean` values are really simple when it comes to their representation: they are either `true` or `false`. It's as easy as ABC.

### Exercise

The user with `user_id` of **13** has just been verified (column `is_verified`). Put this information into the `verification` table.

```sql
INSERT INTO verification (user_id, is_verified)
VALUES (13, true);
```

## Boolean – querying the table

Excellent! You may, of course, use the `boolean` type in your `SELECT` statements:

```sql
SELECT
  *
FROM verification
WHERE is_verified = false;
```

The above query will select all users that have not been verified.

### Exercise

Let's see which users are verified. Select all `user_id` values where the users have been verified (column `is_verified`).

```sql
SELECT
  user_id
FROM verification
WHERE is_verified;
```

## Date

The last group of data types we're going to learn are types used to store time.

Let's start with the data type called `date`. You should already know it, so this will just be a recap.

### Exercise

We've got a very simple table called `holiday`, which stores information about national holidays in a given year. It has two columns: `name` and `day`. Let's select the columns `name` and `day` for all rows to see how dates are stored in SQL.

```sql
SELECT
  name,
  day
FROM holiday;
```

Output:

|   name   |     day    |
|:--------:|----------:|
| New Year | 2019-01-01 |
| Memorial Day | 2019-05-27 |
| Labor Day | 2019-09-02 |

## Date – inserting data

As you can see, dates are stored in the format `YYYY-MM-DD`. Not very complicated, huh? Just keep in mind that you need to put apostrophes (single quotes) around each date!

### Exercise

For Peter, Valentine's Day is an important holiday. Let's put the date Feb 14, 2019 into the table `holiday`. To escape the apostrophe in Valentine's Day, write:

```
'Valentine''s Day'
```

```sql
INSERT INTO holiday (name, day)
VALUES ('Valentine''s Day', '2019-02-14');
```

## Date – comparing dates

Excellent! Now, as you may expect, logical operators can be used to compare dates. For example:

```sql
SELECT
  *
FROM holiday
WHERE day < '2010-01-01';
```

The above query will select all holidays before 2010.

### Exercise

In the table `holiday`, select all the information for all the holidays after Jan 1, 2018.

```sql
SELECT
  *
FROM holiday
WHERE day > '2018-01-01';
```

## Date – create the column

Good! Now, try to create your own `date` column into a table.

### Exercise

Peter needs a precise payment information system. Let's create a table called `payment` with the following columns: `user_id` (integer), `amount` (decimal with 4 digits before the decimal and 2 after it), and `day` (date).

```sql
CREATE TABLE payment (
    user_id INTEGER,
    amount DECIMAL(6, 2),
    day DATE
);
```

## Time

Very good! The next data type we're going to learn is `time`. The format for this type is `hh:mm:ss`, where `hh` stands for hour (using a 24-hour clock), `mm` for minutes, and `ss` for seconds. It's used to store time data (e.g., in timetables).

**Important**: A `time` column also requires you to enclose data in apostrophes.

Please note that this data type is absent from many databases.

### Exercise

When Peter found out about the new data type, he immediately added another column called `precise_time` to his table. The table is now created like this:

```sql
CREATE TABLE payment (
  user_id int,
  amount decimal(6, 2),
  day date,
  precise_time time
);
```

Insert a row into the new table. The `user_id` is 14, the `amount` is $23.45, the `day` is August 2, 2019, and the `precise_time` is 2:00 pm exactly. (That's 14:00 in SQL time!)

```sql
INSERT INTO payment (user_id, amount, day, precise_time)
VALUES (14, 23.45, '2019-08-02', '14:00:00');
```

## Datetime

Finally, we're going to learn a mixture of the `date` and `time` data types – `datetime`, which is also called `timestamp`. Its format is `YYYY-MM-DD hh:mm:ss`. As you can see, it includes both the date and the time.

This type goes by various names in various databases: `timestamp`, `datetime`, `smalldatetime`. In our database, all of these names work.

### Exercise

Peter wants to create yet another version of his table `payment`, this time with the following columns: `user_id` (integer), `amount` (decimal(4,2)) and `date_time` (timestamp).

Create the new table.

```sql
CREATE TABLE payment (
    user_id INTEGER,
    amount DECIMAL(4, 2),
    date_time TIMESTAMP
);
```

## Date and time – inserting data

That's it! You did a good job!

### Exercise

We prepared the latest version of the `payment` table for you:

```sql
CREATE TABLE payment (
  user_id int,
  amount decimal(4, 2),
  date_time timestamp
);
```

Your task is to add the following row: the user's id is `19`, the amount is `$19.23` and the timestamp is **3:00 on May 1, 2019**.

```sql
INSERT INTO payment (user_id, amount, date_time)
VALUES (19, 19.23, '2019-05-01 03:00:00');
```

## Summary

Perfect! Time to wrap things up. In this part, we learned that:

1. `boolean` columns are used to store logical values: `true` or `false`.
2. `date` columns store dates in the following format: `YYYY-MM-DD`.
3. `time` columns store time in the following format: `hh:mm:ss`.
4. `datetime` (or `timestamp`) columns store date and time in the following format: `YYYY-MM-DD hh:mm:ss`.

How about a review question before we tackle the next part?

### Exercise 1

A theater needs a table to keep track of its performances. Create a table named performance with the following columns:

1. `id` – An `integer` identifier for each performance and the primary key.
2. `title` – Up to 64 characters.
3. `performance_start` – The date and time when that performance started.
4. `base_ticket_price` – A decimal value with 2 digits after the comma; its upper limit is` 999.99`.
5. `is_private` – A yes/no column.

```sql
CREATE TABLE performance (
    id INTEGER PRIMARY KEY,
    title VARCHAR(64),
    performance_start TIMESTAMP,
    base_ticket_price DECIMAL(5, 2),
    is_private BOOLEAN
);
```

## Congratulations

Very well done! This was the last exercise in this part of the course. `boolean` and `date`/`time` columns are no longer a mystery to you!

In the next part, we're going to show you how to modify the data type of an existing column. See you there!
