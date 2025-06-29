# NOT NULL constraint

Learn how to make sure that a column in a database has a value.

Hello and welcome to the third part of our course! This time, we'll tackle `NOT NULL` constraints.

You already know how to use `NOT NULL`, since we covered this constraint in our track's first course. Today we'd like to do a quick recap of what you already know and extend your knowledge a bit. Are you ready?

## NOT NULL recap – defining a column as NOT NULL

Good. As you probably remember, a `NOT NULL` constraint can be added when we define a table:

```sql
CREATE TABLE loan_application (
  id integer PRIMARY KEY,
  customer_id integer,
  amount decimal(10, 2) NOT NULL,
  loan_period_months integer
);
```

The `NOT NULL` constraint on the `amount` column means that whenever we add a new row to the table, we must provide a value for `amount`. The database won't accept a `NULL`.

Keep in mind that any column without the `NOT NULL` constraint accepts `NULL` by default. You can (but don't have to) emphasize that fact by the `NULL` keyword after the column definition. For example, we could have defined the `customer_id` column like this with the same meaning:

```sql
customer_id integer NULL
```

### Exercise

A nongovernmental organization (NGO) wants our help in managing their human rights campaigns. Create a table named `campaign` that has the following columns:

1. `id` – An `integer` and the primary key.
2. `name` – A `text` up to 32 characters.
3. the `start_date` – A `date` column that must never be `NULL`.
4. `budget` – A decimal number up to `9999.99` (two digits after the decimal point).

```sql
CREATE TABLE campaign (
  id INTEGER PRIMARY KEY,
  name VARCHAR(32),
  start_date DATE NOT NULL,
  budget DECIMAL(6, 2)
);
```

## NOT NULL recap – trying to add a NULL value

Great! Now let's make sure that our constraint works. We shouldn't be able to add a row with a `NULL` value in a `NOT NULL` column.

### Exercise

We've created the `campaign` table for you. It has the following definition:

```sql
CREATE TABLE campaign (
  id integer PRIMARY KEY,
  name varchar(32),
  start_date date NOT NULL,
  budget decimal(6, 2)
);
```

Now run the code which tries to insert a row with a `NULL` `start_date`. What do you think will happen?

```sql
INSERT INTO campaign (id, name, budget)
VALUES (1, 'Human Rights', 1000);
```

Output:

```
ERROR: null value in column "start_date" violates not-null constraint Detail: Failing row contains (1, 'Human Rights', 1000). Line: 1 Position in the line: 1
```

As you can see, the query failed. The constraint works correctly.

## Adding NOT NULL to existing tables

Good! We can already define a column as `NOT NULL`, but how about adding a `NOT NULL` constraint to existing tables? Let's say we still have the same `loan_application` table:

```sql
CREATE TABLE loan_application (
  id integer PRIMARY KEY,
  customer_id integer,
  amount decimal(10, 2) NOT NULL,
  loan_period_months integer
);
```

We need another `NOT NULL` constraint, this time on the `loan_period_months` column. Take a look:

```sql
ALTER TABLE loan_application
ALTER COLUMN loan_period_months SET NOT NULL;
```

As you can see, adding a `NOT NULL` constraint is a bit different than adding a primary key. We need to use the `ALTER COLUMN` syntax along with the `SET NOT NULL` instruction. **This operation will only succeed if all existing values in the column are not null**.

### Exercise

The NGO the campaign table looks like this now:

```sql
CREATE TABLE campaign (
  id integer PRIMARY KEY,
  name varchar(32),
  start_date date NOT NULL,
  budget decimal(10, 2)
);
```

Your task is to add a `NOT NULL` constraint to the `budget` column.

```sql
ALTER TABLE campaign
ALTER COLUMN budget SET NOT NULL;
```

## Removing NOT NULL from existing tables

Perfect! Now, what about deleting a `NOT NULL` constraint? Our table definition currently looks like this:

```sql
CREATE TABLE loan_application (
  id integer PRIMARY KEY,
  customer_id integer,
  amount decimal(10, 2) NOT NULL,
  loan_period_months integer NOT NULL
);
```

We now want to get rid of `NOT NULL` constraint on the `amount` column. To do that, we can use the following code:

```sql
ALTER TABLE loan_application
ALTER COLUMN amount DROP NOT NULL;
```

The code is very similar to the one we used to add a `NOT NULL` constraint. Instead of `SET NOT NULL`, we simply use `DROP NOT NULL`. From this moment on, new rows can have a `NULL` value in the `amount` column.

### Exercise

The NGO table looks like this now:

```sql
CREATE TABLE campaign (
  id integer PRIMARY KEY,
  name varchar(32),
  start_date date NOT NULL,
  budget decimal(10, 2) NOT NULL
);
```

The situation has changed again. The NGO wants to add future campaigns that have no start date to the table. Remove the `NOT NULL` constraint from the `start_date` column.

```sql
ALTER TABLE campaign
ALTER COLUMN start_date DROP NOT NULL;
```

## Adding and removing NOT NULL – exercise

Good job! Okay, time for an additional exercise!

### Exercise

We have a second table that keeps track of the leaflets designed and distributed by the NGO. The table looks like this:

```sql
CREATE TABLE leaflet (
  id integer PRIMARY KEY,
  circulation integer NOT NULL,
  black_and_white boolean,
  distribution_area varchar(32)
);
```

Your task is to:

1. Remove the `NOT NULL` constraint from the `circulation` column.
2. Add a `NOT NULL` constraint to the `black_and_white` column.

```sql
ALTER TABLE leaflet
ALTER COLUMN circulation DROP NOT NULL;

ALTER TABLE leaflet
ALTER COLUMN black_and_white SET NOT NULL;
```

## Summary

Okay, it's time to wrap things up! Here's what we learned:

1. To add a `NOT NULL` constraint when defining a table, use:

```sql
CREATE TABLE loan_application (
  ...
  amount decimal(10, 2) NOT NULL,
  ...
);
```

2. By default, the columns accept `NULL`s. You can emphasize this by putting the `NULL` keyword after column definition:

```sql
description varchar(255) NULL
```

Adding the `NULL` keyword does not change the column definition, it just emphasizes the default behavior.

3. To add a `NOT NULL` constraint to an existing table, use:

```sql
ALTER TABLE loan_application
ALTER COLUMN loan_period_months SET NOT NULL;
```

4. To delete a `NOT NULL` constraint from an existing table, use:

```sql
ALTER TABLE loan_application
ALTER COLUMN loan_period_months DROP NOT NULL;
```

Ready for the pop quiz?

## Quiz

Here's the quiz!

### Exercise 1

The NGO needs our help with another table – this one is used for keeping track of NGO members:

```sql
CREATE TABLE member (
  id integer PRIMARY KEY,
  full_name varchar(64),
  joined date NOT NULL,
  quit date NOT NULL
);
```

Your task is to:

1. Remove the `NOT NULL` constraint from the `quit` column.
3. Add a `NOT NULL` constraint to the `full_name` column.

```sql
ALTER TABLE member
ALTER COLUMN quit DROP NOT NULL;

ALTER TABLE member
ALTER COLUMN full_name SET NOT NULL;
```

## Congratulations

Excellent! That was the last exercise in this part. Congratulations!

In the next part, we'll talk about a new constraint type: `CHECK`. See you there!

