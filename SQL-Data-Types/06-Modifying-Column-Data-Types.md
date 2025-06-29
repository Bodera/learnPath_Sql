# Modifying column data types

## Welcome

Welcome again! In this part, we won't introduce any new data types. Instead, we'll show you how you can **modify** the data type of an existing column. You'll also learn how to change or remove an identity or a sequence. Are you ready?

## Inserting oversized values

Suppose we work for an art gallery and we have the following table:

```sql
CREATE TABLE artwork (
  id integer PRIMARY KEY,
  title varchar(32),
  author varchar(32)
);
```

We create the table and start filling it with information. At some point, however, we notice that the field `title` is too short – there are certain works whose names are longer than 32 characters. What happens if we try to add them?

### Exercise

Try to run the template query: it attempts to add an artwork which has a very long name.

As you can see, the query failed. The work's title was too long.

```sql
INSERT INTO artwork (id, title, author) VALUES
(200, 'The importance of drinking at least 5 bottles of water a day', 'John Smith');
```

Output:

```
ERROR: value too long for type character varying(32)
```

## Changing column type – 1

The query failed because the title we tried to add was too long. Note that other databases may behave differently: they will accept longer values or they will trim the value and only accept the first x characters. Either way, we'll have a problem with longer values in most databases. Can we do anything about this? Luckily, SQL allows us to change column types. Take a look:

```sql
ALTER TABLE artwork ALTER COLUMN title SET DATA TYPE varchar(128);
```

In the query above, we make the `title` column longer by changing its type to `varchar(128)`. It will keep all existing data intact.

## Changing column type – 2

Good. Now that we changed the column type, let's see how inserting new rows works.

### Exercise

Run the template code, which tries to insert a row with a longer title.

The insertion succeeds. The owner will be able to enter longer artwork names from now on.

```sql
INSERT INTO artwork (id, title, author) VALUES
(200, 'The importance of drinking at least 5 bottles of water a day', 'John Smith');
```

## Changing column type – exercise 1

We successfully extended the type of the column.

It's your turn now.

### Exercise

The art gallery owner was so happy with our services that he recommended us to a friend who runs an artist agency.

The agency created a table named `actor` with the following columns: `id`, `first_name`, `last_name`, and `country`.

The last column can be up to 8 characters long. As it turns out, that's not enough. Change the column `country` so that it accepts up to 32 characters.

```sql
ALTER TABLE actor ALTER COLUMN country SET DATA TYPE varchar(32);
```

## Changing column type – exercise 2

Good job! Naturally, `varchar` isn't the only column type that you can extend. Let's try another.

### Exercise

The agency also has an issue with registering all their theatrical property purchases. They've created the table `purchase` in the following way:

```sql
CREATE TABLE purchase (
  id integer primary key,
  property_id integer,
  amount decimal(4, 2)
);
```

Your task is to extend the column `amount` so that it accepts 10 digits in total, with two after the decimal.

```sql
ALTER TABLE purchase ALTER COLUMN amount SET DATA TYPE decimal(10, 2);
```

## What you can and cannot change

Great! You successfully extended `varchar` and `decimal` columns. How about other column modifications? Can you change a `boolean` field to an `integer`? Can you **shorten** a column?

The SQL standard says that you can **only extend** columns to accept longer text values, larger numbers, etc. What's more, you can only change column types to matching types. In other words, you can't change a `varchar` column to an `integer` column or a `decimal` column into a `boolean` column.

In practice, databases often allow more types of modifications than the SQL standard. For instance, PostgreSQL will try to convert numerical values into text if you instruct it to convert `decimal` into `varchar`. And while most databases allow you to shorten a column, it's usually a bad idea to do so – you could accidentally (and permanently) lose some data.

On the other hand, database developers rarely change column types. If anything, they extend columns in compliance with the SQL standard, just as we showed you in the previous exercises.

## Canceling auto-generation of identities

Great! Now, we'll show you how you can cancel the auto-generation of integer values from your table. Suppose we have the following table:

```sql
CREATE TABLE country (
  id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name varchar(32),
  code char(2)
);
```

At some point, you want to stop the auto-generation of the identity in the column `id`. You can use the following code:

```sql
ALTER TABLE country ALTER COLUMN id DROP IDENTITY;
```

Once you run this code, the column `id` will not auto-generate numbers when you add further rows.

### Exercise

Let's investigate another problem the agency has. We've created a table named `costume` in the following way:

```sql
CREATE TABLE costume (
  id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name varchar(64),
  manufacturer varchar(32)
);
```

The agency wants to generate their own IDs now. Your task is to turn off auto-generation of the `identity` in the column `id`.

```sql
ALTER TABLE costume ALTER COLUMN id DROP IDENTITY;
```

## Adding auto-generation of identities

Perfect! By the same token, you can also add auto-generation to a column without auto-generation for an `identity`. First, look at the structure of the following table:

```sql
CREATE TABLE president(
  id integer PRIMARY KEY,
  full_name varchar(32),
  election_date date
);
```

Let's say we want to add auto-generation for the column `id`:

```sql
ALTER TABLE president ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY;
```

The code above will add auto-generation of an `identity` to our existing column. Note that instead of `ADD GENERATED ALWAYS` you can use `ADD GENERATED BY DEFAULT`.

### Exercise

The agency has an opposite problem with another table. They've created a table named `stage` in the following way:

```sql
CREATE TABLE stage (
  id integer PRIMARY KEY,
  name varchar(64),
  rating decimal(2, 1),
  city varchar(32)
);
```

Your task is to add auto-generation **by default** as `identity` to the `id` column.

```sql
ALTER TABLE stage ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY;
```

## Restarting sequences

Very well done! Now, how about sequences? Can they be modified or removed? It turns out that they can! Let's say we have a sequence like this:

```sql
CREATE SEQUENCE standard_seq START WITH 1 INCREMENT BY 1;
```

The sequence generates subsequent integers for us. At some point, however, we deleted all rows with auto-generated values and we'd like the sequence to start generating numbers from 1 again. We can use the following syntax:

```sql
ALTER SEQUENCE standard_seq START WITH 1 RESTART;
```

The query above first sets the new starting value for sequence `standard_seq` to 1 and then uses `RESTART` to actually **reset the current value to the starting value**. Sound complicated? You can also use the simplified syntax:

```sql
ALTER SEQUENCE standard_seq RESTART WITH 1;
```

The code above works the same – it simply sets the current sequence value to 1. You can also restart a sequence using any other value. If you want to start over from 100, you just need to use:

```sql
ALTER SEQUENCE standard_seq RESTART WITH 100;
```

### Exercise

The agency has created the sequence below:

```sql
CREATE SEQUENCE artist_numbers START WITH 1 INCREMENT BY 2;
```

Some values have already been generated. Your task is to start the sequence over from 1.

```sql
ALTER SEQUENCE artist_numbers RESTART WITH 1;
```

## Changing sequence increments

Great! You can also change the increment part of a sequence. Let's say we have the following sequence:

```sql
CREATE SEQUENCE standard_seq START WITH 1 INCREMENT BY 1;
```

Now, if we want to change the increment to 10, we can use:

```sql
ALTER SEQUENCE standard_seq INCREMENT BY 10;
```

### Exercise

The agency also wants the `artist_numbers` sequence to increment by 1, not 2. Your task is to change that.

```sql
ALTER SEQUENCE artist_numbers INCREMENT BY 1;
```

## Removing sequences

Perfect! You can also remove a sequence you no longer need. Take a look:

```sql
DROP SEQUENCE standard_seq;
```

The code above will remove the sequence named `standard_seq`.

### Exercise

The agency has generated some IDs starting from 1. Now, they no longer need the sequence `artist_numbers`. Remove it.

```sql
DROP SEQUENCE artist_numbers;
```

## Summary

It's time to wrap things up! What did we learn?

1. We only recommend modifying a column by extending the same type (e.g., varchar(32) to varchar(64)). To do so, you can use:

```sql
ALTER TABLE artwork ALTER COLUMN title SET DATA TYPE varchar(64);
```

2. To add auto-generation of an identity, use:

```sql
ALTER TABLE country ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY;
```

3. Similarly, to delete auto-generation of an identity, use:

```sql
ALTER TABLE country ALTER COLUMN id DROP IDENTITY;
```

4. To start a sequence over with a given value, use:

```sql
ALTER SEQUENCE car_sequence RESTART WITH 1;
```

5. To remove a sequence, use:

```sql
DROP SEQUENCE car_sequence;
```

How about a short quiz now?

### Exercise 1

We wanted to create a table to keep track of car rides. We used the following script:

```sql
CREATE TABLE car_ride (
  id integer PRIMARY KEY,
  start_place varchar(32),
  end_place varchar(32),
  distance decimal(4, 2)
);
```

However, we need to record longer distances now. Your task is to change the `distance` table so that it stores decimals of up to 6 digits, of which 2 are after the decimal point.

```sql
ALTER TABLE car_ride ALTER COLUMN distance SET DATA TYPE decimal(6, 2);
```

### Exercise 2

Excellent! Our car_ride table looks like this now:

```sql
CREATE TABLE car_ride (
  id integer PRIMARY KEY,
  start_place varchar(32),
  end_place varchar(32),
  distance decimal(6, 2)
);
```

So far, we've been using a sequence to generate IDs. Let's change that. First, add a `GENERATED ALWAYS` identity to the `id` column.

```sql
ALTER TABLE car_ride ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY;
```

### Exercise 3

Now that we have auto-generation of the `identity`, get rid of the `car_ride_seq` sequence that we used to auto-generate numbers.

```sql
DROP SEQUENCE car_ride_seq;
```

## Congratulations

You've solved the very last exercise in this part. Congratulations!

There's just one part left in this course: the **Final Quiz**. Take your time to rest and review everything you've learned so far. We'll see you there
