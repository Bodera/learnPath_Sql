# UNIQUE constraint

Learn how you can make sure that all values in a column are different.

Welcome to the second part of the course! Today, we'll talk about a constraint you've not seen before: `UNIQUE`. We'll show you how you can apply it to single and to multiple columns.

Are you ready?

## UNIQUE – Introduction

All right! Let's get down to learning the `UNIQUE` constraint. Applying this constraint means that the values in a given column must be ... well, unique. In other words, each value in a `UNIQUE` column can only be used once. Here's how you specify the `UNIQUE` column when creating a table:

```sql
CREATE TABLE board_game (
  id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name varchar(32) UNIQUE,
  genre varchar(32),
  min_players integer,
  min_age integer,
  price decimal(5, 2)
);
```

As you can see, the `name` column has the `UNIQUE` constraint. It is placed after the type of the column.

### Exercise

Our users added some games to the `board_game` table. Select all the information from the table and study the `name` column.

As you will see, all the values are unique: each of them appears only once.

```sql
SELECT * FROM board_game;
```

Output:

| id | name | genre | min_players | min_age | price |
| --- | --- | --- | --- | --- | --- |
| 1 | Warhammer | fantasy | 3 | 14 | 99.76 |
| 2 | Neuroshima | post-apocalyptic | 4 | 10 | 31.99 |
| 3 | Dungeons & Dragons | fantasy | 2 | 12 | 15.87 |
| 4 | Tunnels & Trolls | fantasy | 3 | 12 | 59.98 |
| 5 | Blue Planet | science-fiction | 3 | 16 | 37.11 |

## UNIQUE – Adding new rows

As you have seen, the values in the `name` column are indeed unique. After all, no two games should share the same name, right?

### Exercise

Let's add another board game to our `board_game` table. It's called **Carcassonne**, the genre is **medieval**, the minimum number of players is `2`, the minimum age is `10`, and the price is listed at `32.99`. Don't worry about the `id` column – it's defined as `GENERATED ALWAYS AS IDENTITY` and `IDENTITY` will take care of the numbering.

```sql
INSERT INTO board_game (name, genre, min_players, min_age, price)
VALUES ('Carcassonne', 'medieval', 2, 10, 32.99);
```

## UNIQUE – Adding rows with the same value

Excellent! The new board game had a unique name, so we were able to add the new row successfully. But what would happen if we wanted to enter a row with the same name value?

### Exercise

Pretend to be an absent-minded user who didn't notice that Monopoly is already in the database.

Try to insert the game: the name is Monopoly, genre is business, `min_players` is `2`, `min_age` equals `10`, and `price` is listed at `35.20`.

```sql
INSERT INTO board_game (name, genre, min_players, min_age, price)
VALUES ('Monopoly', 'business', 2, 10, 35.20);
```

Output:

```
ERROR: duplicate key value violates unique constraint "board_game_name_key" Detail: Key (name)=(Monopoly) already exists. Line: 1 Position in the line: 1
```

## UNIQUE vs. PRIMARY KEY

Boom! The insertion failed because we already have a row with the name value 'Monopoly'. Our new constraint takes care of that.

`UNIQUE` is indeed very similar to `PRIMARY KEY`, which we learned in the previous part. We sometimes say that `UNIQUE` creates an **alternate key** for the table.

### Exercise

It's time for you to create your own `board_game` table with a `UNIQUE` column. Remember the columns we have:

- `id` is always auto-generated and is the primary key.
- `name` is a text of up to 32 characters (and it must be unique!).
- `genre` is also a text of up to 32 characters.
- `min_players` and `min_age` are integers.
- `price` is a decimal value of up to 5 digits, 2 of which are after the decimal point.

Remember that the `UNIQUE` constraint is placed after the column type!

```sql
CREATE TABLE board_game (
  id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name varchar(32) UNIQUE,
  genre varchar(32),
  min_players integer,
  min_age integer,
  price decimal(5, 2)
);
```

## UNIQUE – Playing around

Good! Now you've got your own version of the `board_game` table. Let's try it out.

### Exercise

Try to add a few rows to your brand-new table. See for yourself how the `UNIQUE` constraint works.

```sql
INSERT INTO board_game (name, genre, min_players, min_age, price)
VALUES ('Monopoly', 'business', 2, 10, 35.20),
       ('Carcassonne', 'medieval', 2, 10, 32.99),
       ('Tunnels & Trolls', 'fantasy', 3, 12, 59.98),
       ('Blue Planet', 'science-fiction', 3, 16, 37.11),
       ('Dungeons & Dragons', 'fantasy', 2, 12, 15.87),
       ('Warhammer', 'fantasy', 3, 14, 99.76),
       ('Neuroshima', 'post-apocalyptic', 4, 10, 31.99);
```

## UNIQUE on multiple columns

Okay, time to move on. Do you remember that we can include more than one column in the `PRIMARY KEY`? The same rule applies to the `UNIQUE` constraint. Take a look:

```sql
CREATE TABLE board_game (
  id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name varchar(32),
  genre varchar(32),
  min_players int,
  min_age int,
  price decimal(5, 2),
  UNIQUE (name, genre)
);
```

At the end of the instruction, we put the keyword `UNIQUE` and within parentheses we provided the column pair that must be unique.

From now on, each pair of name and genre values must be unique for each row. The individual column values, however, may be duplicated as long as the name-genre pair is unique. So, both (`name='ABC'`, `genre='horror'`) and (`name='ABC'`, `genre='fantasy'`) will be accepted, just as in the case of `PRIMARY KEY`s on multiple columns.

In other words, no two games of the same genre can have the same name, but if the genres are different, then identical names are allowed (and vice versa).

### Exercise

Run the example from our instruction to create the new table.

```sql
CREATE TABLE board_game (
  id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name varchar(32),
  genre varchar(32),
  min_players integer,
  min_age integer,
  price decimal(5, 2),
  UNIQUE (name, genre)
);
```

## UNIQUE on multiple columns – Playing around

Excellent. Now we have the right table to do a little testing. Take a look at the exercise.

### Exercise

As we mentioned previously, each pair of `name`-`genre` values must now be unique. Take your time and test that. Add a row where both values will be different, a row where one of them will be unique, and a row where both parts of the pair will be the same as in another row. See what happens each time.

```sql
-- Some suggestions you may want to try:
-- INSERT INTO board_game (name, genre, min_players, min_age, price) VALUES ('Uno', 'business', 2, 7, 23.50);
-- INSERT INTO board_game (name, genre, min_players, min_age, price) VALUES ('Scrabble', 'language', 2, 6, 32.00);
-- INSERT INTO board_game (name, genre, min_players, min_age, price) VALUES ('Monopoly', 'language', 2, 10, 35.20);
-- INSERT INTO board_game (name, genre, min_players, min_age, price) VALUES ('Uno', 'business', 3, 10, 28.50);
```

## Multiple UNIQUE constraints

Good! As you can see, `UNIQUE` with multiple columns works exactly as `PRIMARY KEY` does.

There is, however, one major difference between the two. We can only have one primary key in a given table, but we can have as many `UNIQUE` constraints as we want. For example:

```sql
CREATE TABLE board_game (
  id integer GENERATED ALWAYS AS IDENTITY UNIQUE,
  name varchar(32),
  genre varchar(32),
  studio varchar(32),
  min_players integer,
  min_age integer,
  price decimal(5, 2),
  UNIQUE (name, genre),
  UNIQUE (name, studio)
);
```

We now have one row with a `UNIQUE` constraint and a pair of separate `UNIQUE` constraints, each containing two columns. The database will check to see that each `name`-`genre` and `name`-`studio` pair are unique. It will also separately ensure that each `id` is unique.

Is there a difference between one `UNIQUE` constraint with multiple columns and separate `UNIQUE` constraints for each column? There is. A `UNIQUE` constraint with multiple columns means that the column values in the constraint must form a unique group. For example, if you had `UNIQUE (name, studio, genre)`, each name-studio-genre combination must be unique. However, the individual column values could be duplicates, just as we discussed earlier.

On the other hand, if you wrote `name ... UNIQUE`, `studio ... UNIQUE`, `genre ... UNIQUE`, each of these three column values would have to be unique. Of course, each combination of those values would also be unique, but the database wouldn't check for that.

### Exercise

We modified our table so that there are now two `UNIQUE` constraints. Try to test the table as we did previously: add rows with the same and different values and see what is allowed.

```sql
-- Some suggestions you may want to try:
-- INSERT INTO board_game (name, genre, min_players, min_age, price) VALUES ('Uno', 'business', 2, 7, 23.50);
-- INSERT INTO board_game (name, genre, min_players, min_age, price) VALUES ('Scrabble', 'language', 2, 6, 32.00);
-- INSERT INTO board_game (name, genre, min_players, min_age, price) VALUES ('Monopoly', 'language', 2, 10, 35.20);
-- INSERT INTO board_game (name, genre, min_players, min_age, price) VALUES ('Uno', 'business', 3, 10, 28.50);
```

## Adding a UNIQUE constraint

Very well done! We know how to add `UNIQUE` constraints when we define a table. How do we add a `UNIQUE` constraint to an existing table? Let's say we have the following table:

```sql
CREATE TABLE video_game (
  id integer PRIMARY KEY,
  name varchar(64),
  platform varchar(64),
  price decimal(6, 2)
);
```

We'd like to add a `UNIQUE` constraint to a group of two columns: `name` and `platform`. Take a look:

```
ALTER TABLE video_game
ADD UNIQUE (name, platform);
```

The query above will add a `UNIQUE` constraint to our table. However, keep in mind that all existing `name`-`platform` combinations must be unique. If that's not the case, we won't be able to add the constraint. What's more, once we do add it, each new `name`-`platform` combination must be unique as well.

### Exercise

We've got a table named card_game that's defined like this:

```sql
CREATE TABLE card_game (
  id integer PRIMARY KEY,
  name varchar(64) UNIQUE,
  rank integer
);
```

Your task is to add a `UNIQUE` constraint to the `rank` column.

```sql
ALTER TABLE card_game
ADD UNIQUE (rank);
```

## Adding a UNIQUE constraint with a custom name

Good job! Just like with primary and foreign key constraints, you can also add a custom name to your `UNIQUE` constraints. Check out this table:

```sql
CREATE TABLE video_game (
  id integer PRIMARY KEY,
  name varchar(64),
  platform varchar(64),
  price decimal(6, 2)
);
```

You can add a constraint like this:

```sql
ALTER TABLE video_game
ADD CONSTRAINT video_game_unique UNIQUE (name, platform);
```

The instruction above will create a new unique constraint and name it `video_game_unique`.

### Exercise

Again, we've got the table named `card_game` defined like this:

```sql
CREATE TABLE card_game (
  id integer PRIMARY KEY,
  name varchar(64) UNIQUE,
  rank integer
);
```

Add a `UNIQUE` constraint on the rank column. This time, however, provide the custom constraint name `card_game_rank_unique`.

```sql
ALTER TABLE card_game
ADD CONSTRAINT card_game_rank_unique UNIQUE (rank);
```

## Removing a UNIQUE constraint

Excellent work! Now, let's try to do the opposite: delete a constraint from an existing table. Here's the table:

```sql
CREATE TABLE group_game (
  id integer PRIMARY KEY,
  name varchar(64) UNIQUE,
  min_players integer,
  max_players integer
);
```

There's a `UNIQUE` constraint on the `name` column. To remove it, we can use this code:

```sql
ALTER TABLE group_game
DROP CONSTRAINT group_game_name_key;
```

How do we know the name of the constraint? PostgreSQL's naming convention for `UNIQUE` is `table_name` + `_` + `constraint_column(s)` + `_` + `key`. That's why our constraint was named `group_game_name_key`.

### Exercise

After the previous exercise, we've got the new `UNIQUE` constraint in our table `card_game`:

```sql
CREATE TABLE card_game (
  id integer PRIMARY KEY,
  name varchar(64) UNIQUE,
  card_game_rank integer UNIQUE
);
```

However, you now need to get rid of the `UNIQUE` constraint on the `name` column.

```sql
ALTER TABLE card_game
DROP CONSTRAINT card_game_name_key;
```

## Summary

Okay, time to wrap things up! What did we learn?

1. You can add a UNIQUE constraint to a single column, placing it after the column type:

```sql
CREATE TABLE board_game (
  id integer PRIMARY KEY,
  name varchar(32) UNIQUE
);
```

2. You can add a UNIQUE constraint to a group of columns, placing it after the column definitions:

```sql
CREATE TABLE board_game (
  id integer PRIMARY KEY,
  name varchar(32),
  genre varchar(32),
  UNIQUE (name, genre)
);
```

3. You can add a UNIQUE constraint to an existing table:

```sql
ALTER TABLE video_game
ADD CONSTRAINT video_game_unique UNIQUE (name, platform);
```

4. You can remove a UNIQUE constraint from an existing table:

```sql
ALTER TABLE group_game
DROP CONSTRAINT group_game_name_key;
```

How about a quick quiz now?

## Quiz

There's just one question in this quiz. And here it comes!

### Exercise 1

An electronics store wants us to create a table for storing information about the notebook computers they offer. They need the following columns:

1. `id` – An integer and the primary key.
2. `manufacturer` – Up to 64 characters.
3. `model` – Up to 64 characters.
4. `price` – Up to `9999.99`. (Note the two digits after the decimal point.)
5. `customer_rank` – An integer.

The `customer_rank` column and the `manufacturer` – `model` combination must be unique.

Create a table named `notebook` based on the above description.

```sql
CREATE TABLE notebook (
  id INTEGER PRIMARY KEY,
  manufacturer VARCHAR(64),
  model VARCHAR(64),
  price DESCIMAL(6, 2),
  customer_rank INTEGER UNIQUE,
  UNIQUE (manufacturer, model)
);
```

## Congratulations

Perfect! This was the last exercise in this part of the course, and you solved it. Congratulations!

In the next part, we'll review a constraint you already know – `NOT NULL`. See you there!










