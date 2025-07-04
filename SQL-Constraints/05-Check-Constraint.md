# CHECK constraint

Price below zero? Customer over 200 years old? Learn how CHECK constraints can ensure that information in a database is correct.

Hello and welcome once again to our course! In this part, we're going to get to know a new constraint type: `CHECK`. Thanks to `CHECK`, we can specify logical conditions that need to be met by a given column or group of columns.

So, without further ado, let's get started!

## Introduction

Let's get started. Take a look at the following example:

```sql
CREATE TABLE video_game (
  id GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  name varchar(32) UNIQUE NOT NULL,
  genre varchar(32) NOT NULL,
  studio varchar(32),
  multiplayer boolean,
  hours integer CHECK (hours > 0),
  price decimal(5, 2) CHECK (price > 0)
);
```

As you can see, we added the keyword `CHECK` to two columns, followed by a logical condition inside parentheses. For example, the `price` column value cannot be `0` or less because of the condition we set (`price > 0`). The database will ensure that this condition is always met.

### Exercise

Run the template code to create the `video_game` table with the new constraint `CHECK`. The new columns which may require some explanation are:

1. `multiplayer` – This column tells us whether a specific game has a multiplayer mode.
2. `hours` – This column stores the estimated number of hours necessary to complete the game.

```sql
CREATE TABLE video_game (
  id integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  name varchar(32) UNIQUE NOT NULL,
  genre varchar(32) NOT NULL,
  studio varchar(32),
  multiplayer boolean,
  hours integer CHECK (hours > 0),
  price decimal(5, 2) CHECK (price > 0)
);
```

## CHECK – adding new values

Okay. First of all, let's check whether we can still insert correct values into our table.

### Exercise

Add a new game to the `video_game` table. The `name` is `'Grand Theft Auto V'`, `genre` is `'Criminal'`, `studio` is `'Rockstar'`, `multiplayer` is `TRUE`, `hours` are `500` and `price` is `89.99`.

```sql
INSERT INTO video_game (name, genre, studio, multiplayer, hours, price)
VALUES ('Grand Theft Auto V', 'Criminal', 'Rockstar', TRUE, 500, 89.99);
```

## CHECK – updating rows

Superb! As you can see, all the values were in accordance with our `CHECK` constraints, so we inserted the row successfully. But what if we change some values?

### Exercise

Try to update a row in the `video_game` table. Pick the row with the `name` `'Grand Theft Auto V'` and change the `price` to `-2`. What do you think will happen?

```sql
UPDATE video_game
SET price = -2
WHERE name = 'Grand Theft Auto V';
```

Output:

```
ERROR: new row for relation "video_game" violates check constraint "video_game_price_check" Detail: Failing row contains (4, Grand Theft Auto V, Criminal, Rockstar, t, 500, -2.00). Line: 1 Position in the line: 1
```

## CHECK – practice

As you can see, the database protects the columns from any invalid values, even when updating the row. The `price` must be greater than 0, so when you try to update a row and provide a price lower than 0, the database will not allow it.

Good news, isn't it? But before we move on, how about creating your own `CHECK` constraints?

### Exercise

It's your turn to create the table with `CHECK`s! Use the template we provided and make sure the `hours` and `price` values are both greater than zero.

Remember to put the `CHECK` keyword after the data type for each column, followed by the logical condition in parenthesis.

```sql
CREATE TABLE video_game (
  id INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  name VARCHAR(32) UNIQUE NOT NULL,
  genre VARCHAR(32) NOT NULL,
  studio VARCHAR(32),
  multiplayer BOOLEAN,
  hours INTEGER CHECK (hours > 0),
  price DECIMAL(5, 2) CHECK (price > 0)
);
```

## CHECK – complex conditions

Great! Now it's good to understand that the logical conditions after `CHECK` can be complex. Take a look at the example below:

```sql
price decimal(5, 2) CHECK (price > 0.00 AND price < 800.00)
```

As you can see, we can join more than one condition to create precise logical statements.

### Exercise

Fill the template we prepared for you so that the `hours` column has a constraint: greater than `0` and lower than `999`.

```sql
CREATE TABLE video_game (
  id INTEGER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  name VARCHAR(32) UNIQUE NOT NULL,
  genre VARCHAR(32) NOT NULL,
  studio VARCHAR(32),
  multiplayer BOOLEAN,
  hours INTEGER CHECK (hours > 0 AND hours < 999),
  price DECIMAL(5, 2) CHECK (price > 0.00 AND price < 800.00)
);
```

## Complex conditions with multiple columns

Nice! You should also know that we can use other columns in the `CHECK` constraint as well. Take a look at the example below:

```sql
CREATE TABLE video_game (
  id integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  name varchar(32) UNIQUE NOT NULL,
  genre varchar(32) NOT NULL,
  studio varchar(32),
  multiplayer boolean,
  hours integer,
  price decimal(5, 2),
  CHECK (price/hours < 1.00)
);
```

In the example above, the database will only allow you to enter relatively cheap video games, where the result of the game's cost divided by the hours of playing is low.

### Exercise

We put the constraint from our example into the database. Let's try to insert a new game that meets the criteria. Insert a game called `'Disciples II'` into the `video_game` table:

1. `genre` is `'Strategy'`.
2. `studio` is `'Dat'`.
3. `multiplayer` is `TRUE`.
4. `hours` are `150`.
5. `price` is `29.99`.

```sql
INSERT INTO video_game (name, genre, studio, multiplayer, hours, price)
VALUES ('Disciples II', 'Strategy', 'Dat', TRUE, 150, 29.99);
```

## Updating rows with complex constraints

Perfect! As you can see, the insertion succeeded because the condition in the `CHECK` constraint was met. What happens when we try to change it a little bit?

### Exercise

In the `video_game` table, try to update the `price` for the game `'Disciples II'`. Set price to `250.00`.

```sql
UPDATE video_game
SET price = 250.00
WHERE name = 'Disciples II';
```

Output:

```
ERROR: new row for relation "video_game" violates check constraint "video_game_check" Detail: Failing row contains (3, Disciples II, Strategy, Dat, t, 150, 250.00). Line: 1 Position in the line: 1
```

## CHECK – practice

Just as we expected! The update failed because the new value for the `price` column didn't meet the criterion.

How about trying something on your own?

### Exercise

Let's leave the gaming community for now. Create a table called `salary` with the following columns:

1. `employee_id` – A unique integer number.
2. `monthly` – A decimal of up to 10 digits, with 2 digits after the decimal point.
3. `annual` – A decimal of up to 10 digits, with 2 digits after the decimal point.

Add the following `CHECK` constraint: The `annual` field must equal the `monthly` field times `12`.

```sql
CREATE TABLE salary (
  employee_id INTEGER,
  monthly DECIMAL(10, 2),
  annual DECIMAL(10, 2) CHECK (annual = monthly * 12),
  UNIQUE (employee_id)
);
```

## Adding CHECK constraints to existing tables

Great! We already know a lot about creating `CHECK` constraints when defining tables, but what about adding them to existing tables? Let's say we have the following table:

```sql
CREATE TABLE video_game_ranking (
  game_id integer,
  user_rating decimal(4, 1) ,
  expert_rating decimal(4, 1),
  rank integer,
  award_count integer CHECK (award_count > 0)
);
```

We want to add the following the `CHECK` constraint: the `rank` column must be greater than `0`:

```sql
ALTER TABLE video_game_ranking
ADD CHECK (rank > 0);
```

The code above resembles the one we wrote to add a `UNIQUE` constraint. You can also modify it and provide your own name for a constraint:

```sql
ALTER TABLE video_game_ranking
ADD CONSTRAINT rank_check CHECK (rank > 0);
```

**Note**: The syntax for adding a `CHECK` constraint is actually standard SQL syntax.

### Exercise

The following table was created by a train company:

```sql
CREATE TABLE train_connection (
  id integer PRIMARY KEY,
  city_from varchar(32),
  city_to varchar(32),
  distance_miles integer,
  basic_price decimal(5, 2) CHECK (basic_price > 0.0)
);
```

Your task is to add a constraint on the `distance_miles` column: it should always be greater than `0`.

```sql
ALTER TABLE train_connection
ADD CHECK (distance_miles > 0);
```

## Removing CHECK constraints from existing tables

Great! What about deleting a constraint? Let's go back to the `video_game_ranking` table:

```sql
CREATE TABLE video_game_ranking (
  game_id integer,
  user_rating decimal(4, 1),
  expert_rating decimal(4, 1),
  rank integer,
  award_count integer CHECK (award_count > 0)
);
```

Let's say we want to delete the constraint from the `award_count` column. Here's how we'd do it:

```sql
ALTER TABLE video_game_ranking
DROP CONSTRAINT video_game_ranking_award_count_check;
```

Again, we're using code which should be familiar to you – you can delete primary/foreign keys and the `UNIQUE` constraints in the same way. The default naming convention for a `CHECK` constraint in PostgreSQL is `table_name` + `_` + `column_name`(s) + `_` + `check`. In our example, the check was made on the `award_count` column, so the constraint was named `video_game_ranking_award_count_check`.

### Exercise

You are again given the `train_connection` table:

```sql
CREATE TABLE train_connection (
  id integer PRIMARY KEY,
  city_from varchar(32),
  city_to varchar(32),
  distance_miles integer,
  basic_price decimal(5, 2) CHECK (basic_price > 0.0)
);
```

It turns out that some train connections are completely free of charge. Your task is to remove the constraint on the `basic_price` column.

```sql
ALTER TABLE train_connection
DROP CONSTRAINT train_connection_basic_price_check;
```

## Summary

Perfect! Time to wrap up this part with a quick summary:

1. When creating a table, add a `CHECK` constraint on a single column with:

```sql
CREATE TABLE video_game (
  id integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  ...
  hours integer CHECK (hours > 0),
  ...
);
```

2. To add a `CHECK` constraint on multiple columns, use:

```sql
CREATE TABLE video_game (
  id integer GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  ...
  hours integer,
  price decimal(5, 2),
  CHECK (price/hours < 1.00)
);
```

3. To add a `CHECK` constraint to an existing table, use:

```sql
-- Option 1: by providing the name of the constraint
ALTER TABLE video_game_ranking
ADD CONSTRAINT video_game_rank_constraint CHECK (rank > 0);

-- Option 2: by not providing the name of the constraint
ALTER TABLE video_game_ranking
ADD CHECK (rank > 0);
```

4. To remove a `CHECK` constraint from an existing table, use:

```sql
ALTER TABLE video_game_ranking
DROP CONSTRAINT video_game_ranking_award_count_check;
```

How about a short quiz now?

## Quiz

Here's the exercise for you!

### Exercise 1

A traveler asked us to help him modify the table where he keeps basic information about all his trips. The table has the following definition:

```sql
CREATE TABLE trip (
  id integer PRIMARY KEY,
  destination varchar(64),
  total_budget decimal(6, 2),
  budget_souvenirs decimal(6, 2),
  nights integer CHECK (nights > 0)
);
```

Your task is to:

1. Add a constraint to ensure that `budget_souvenirs` is less than `total_budget`.
2. Remove the constraint from the `nights` column. (He could take a day trip somewhere, with no overnight stays.)

```sql
ALTER TABLE trip
ADD CHECK (budget_souvenirs < total_budget);

ALTER TABLE trip
DROP CONSTRAINT trip_nights_check;
```

## Congratulations

Very well done – you've answered the question correctly. Congratulations!

That's it for this part. In the next part, we'll get to know `DEFAULT` – yet another type of constraint. See you there!
