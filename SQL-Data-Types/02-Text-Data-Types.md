# Text data types

## Text information – introduction

Great! In this part, we'll show you what data types are used for **text information**.

Text information is a data type that can store words and expressions like `'barbecue'`, `'Hannah Smith'` or `'Maroon5'`.

In SQL, text information is always stored between two single quotation marks (i.e., `'`, also called 'single quotes' or 'apostrophes'). They are important because they tell our database 'Hey, this is text information!'.

### Exercise

Do you still remember Peter from the previous course and his childhood museum? Well, his idea didn't really work out. He now has a new idea in mind – an online dating website! In this course, we're going to help him develop this new, brilliant idea.

He hasn't done much so far. There is only a single table, `user_account`, in his database. It contains a single column named `nickname`. Let's practice working with text information by putting his first user (**Kangaroo19**) into the table. Remember about the quotation marks!

```sql
INSERT INTO user_account (nickname)
VALUES ('Kangaroo19');
```

## Sorting text information

That's right! One of the reasons for data types is that we can sort information quite easily. Let's check that.

```sql
SELECT
  *
FROM user_account 
ORDER BY nickname;
```

As you can see, we can sort the results of our `SELECT` statement by writing `ORDER BY`, followed by the **name** of the column (or **several columns**, separated with commas). The default order is ascending (that is, A comes before B). If you want to reverse the order, just put `DESC` after the column name(s):

```sql
SELECT
  *
FROM user_account 
ORDER BY nickname DESC;
```

### Exercise

Peter started working on his database. He now has an impressive two columns in his table `user_account`: `first_name` and `nickname`.

Let's retrieve all the information from the table and sort it according to the values in the column `first_name`. Sort it in **ascending** order.

```sql
SELECT
  *
FROM user_account 
ORDER BY first_name;
```

## Comparing text information

Excellent! As you can see, the database sorted the results in the order we asked for. Convenient, isn't it?

We can also compare text information using the logical operators (`<`, `>`, `<=`, `>=`, `=`, `!=`) that you learned in the SQL Basics course.

It's quite easy to use `=` (equals) and `!=` (not equals), and the result is pretty much predictable. The following statement ...

```sql
SELECT
  *
FROM user_account
WHERE first_name = 'Mark';
```

... will select all the Marks in the database. But how about the following statement?

```sql
SELECT
  *
FROM user_account
WHERE nickname >= 'D';
```

The above query will select all users whose nickname starts with D, E, F, etc. Since A, B, and C come earlier in the alphabet (they are "lower", so to speak), nicknames starting with those letters will be skipped.

### Exercise

Peter hasn't done anything since the last exercise, so we're still working with the table `user_account` and the columns `first_name` and `nickname`.

Select all the users whose first names start with A, B, C, or D. Use a single logical operator.

```sql
SELECT
  *
FROM user_account
WHERE first_name < 'E';
```

## The varchar data type

Well done! Now that you know a bit about text information, let's discuss the data types that represent text.

The basic data type for text information is `varchar`. This data type always requires an explicit **length**, in characters, of the text which it's going to store. We put the length in brackets, i.e., `varchar(length)`. For instance, the following statement ...

```sql
CREATE TABLE user_account (
  first_name varchar(32)
);
```

... will create a table with a single column `first_name` where the data type is `varchar(32)`. This means that any value in this column must be **32 characters or less**.

Please note that if you use Oracle as your database, this data type is called `varchar2` instead of `varchar`.

### Exercise

Now that you know the `varchar` data type, try to create Peter's table on your own. The table name is `user_account` and it has two columns: `nickname` and `first_name`. Both of them are `varchar` types, and both are 32 characters long.

```sql
CREATE TABLE user_account (
  nickname varchar(32),
  first_name varchar(32)
);
```

## varchar – explore the limit 1

Excellent! As you can see, Peter didn't really need much time writing the statement!

Let's focus on the `varchar` limit we used for both columns: `varchar(32)`. What will happen if a nickname is **shorter** than that? Let's find out.

### Exercise

Try to add a person named **Anna** with the nickname **crazygirl** to the table `user_account`.

```sql
INSERT INTO user_account (nickname, first_name)
VALUES ('crazygirl', 'Anna');
```

Output:

```
1 row(s) affected
| first_name | nickname    |
|------------|-------------|
| Anna       | crazygirl   |
```

## varchar – explore the limit 2

As you can see, nothing unexpected happened – the row was added successfully. This is because the limit set for `varchar` defines the **maximum** number of characters, but it will accept anything shorter than that!

How about longer values? Let's find out.

### Exercise

The longest last name in history is probably that of a German typesetter: `'Wolfeschlegelsteinhausenbergerdorff'`. Someone on the website, named Adam, thought it would make a perfect nickname. Will the 35-character-long nickname work? Try to add Adam and his nickname to the table `user_account`.

```sql
INSERT INTO user_account (nickname, first_name)
VALUES ('Wolfeschlegelsteinhausenbergerdorff', 'Adam');
```

Output:
```
ERROR: value too long for type character varying(32) Line: 1 Position in the line: 1
```

## The char data type

So, the database didn't let you enter a value that's longer than the limit defined for that field. Quite understandable, isn't it? The type `varchar(x)` lets you provide any value which is shorter than or equal to `x`.

There is also another text type called `char`. The difference is that `char` stores **fixed-size** information. For instance, `varchar(10)` lets you add any value of up to 10 characters, whereas `char(10)` expects you to have exactly 10 characters every time.

When do we use the `char` type? Consider the vehicle identification number (VIN). Its length is fixed – it is always 17 characters long. That makes it a perfect candidate for the `char(17)` data type.

### Exercise

Peter decided to experiment with the nicknames a little. He now wants every user to have a nickname which is **exactly 10 characters long**.

Create the table `user_account` from scratch. This time, have one column named `first_name` (up to 32 characters) and another column named `nickname` (exactly 10 characters).

```sql
CREATE TABLE user_account (
  first_name varchar(32),
  nickname char(10)
);
```

## char – explore the limit 1

Good job! Now, let's experiment a bit.

We told you that `char(10)` always takes 10 characters. This is unlike `varchar(10)`, which can store 10 characters or less. Let's see what happens if we provide a shorter value to a `char` type.

### Exercise

Peter wants to know what happens when a new user doesn't comply with the rule about 10-character-long nicknames. Try to add a new user, **Adrian**, whose nickname is **soap27**.

```sql
INSERT INTO user_account (nickname, first_name)
VALUES ('soap27', 'Adrian');
```

Output:

```
1 row(s) affected
| first_name | nickname    |
|------------|-------------|
| Adrian     | soap27      |
```

## char – explore the limit 2

Success! But wait! We told you that `char(10)` must get exactly 10 characters, and yet you succeeded in entering a shorter value. Did we lie to you?

Not exactly. Various databases may behave differently, but in most of them the information will still contain 10 characters. What do databases do with the remaining characters we didn't use? Some of them will fill the missing characters with spaces, others with empty characters. This is not the best option, so our advice is to always insert as many characters as required.

### Exercise

Peter also wants to check what happens if the nickname is longer than 10 characters. Let's find out: Add a new user with the first name **Mark** and the nickname **datemeifyoulikeme**.

```sql
INSERT INTO user_account (nickname, first_name)
VALUES ('datemeifyoulikeme', 'Mark');
```

Output:

```
ERROR: value too long for type character(10) Line: 1 Position in the line: 1
```

## text/clob

Good. Just as you'd expect, we can't enter a value that's longer than the defined limit into a `char(x)` column.

We're now going to introduce another text data type. Depending on the database, it's called `text` or `clob`. However, both names refer to the same data type. This data type is used to store text information of any length. You can store one word or 1,000 words in such a field.

In this course, we're using a PostgreSQL database, which supports `text` but not `clob`. We'll use `text` throughout this course. Remember to always check your database documentation to find out what data types it supports.

### Exercise

Peter decided that the old table `user_account` was not enough and that the 10-character-long nicknames didn't really work. What's more, he wants users to describe themselves!

Let's create a new `user_account` table with the following columns:

- `first_name` of the type `varchar(32)`.
- `nickname` of the type `varchar(32)`.
- `description` of the type `text`.

```sql
CREATE TABLE user_account (
  first_name varchar(32),
  nickname varchar(32),
  description text
);
```

## text/clob – Playground

Excellent! Now the users can provide some information about themselves.

You deserve a short break. Here's something a little different.

### Exercise

Try playing around with the table `user_account`. Add new rows and see how they work with various data types.

```sql
INSERT INTO user_account (nickname, first_name, description)
VALUES ('soap27', 'Adrian', 'I like soap'),
       ('datemeifyoulikeme', 'Mark', 'I like you'),
       ('TheBest', 'Peter', 'I like Peter');
```

## Summary

Good job! Time to wrap things up.

In this part, we got to know three data types for storing text information:

- `varchar(x)`, which stores up to `x` characters.
- `char(x)`, which stores exactly `x` characters.
- `text` or `clob`, which stores **any** number of characters.

Let's test your skills with a quick quiz.

## Quiz

Let's see if you remember how ERDs work.

Peter developed a slightly more sophisticated version of the table `user_account` and provided us with a simple ERD. Based on the diagram below, create the proper table.

![User account table ERD](./img/user_account_erd.png)

```sql
CREATE TABLE user_account (
  first_name varchar(32),
  last_name varchar(32),
  nickname varchar(24),
  color_eyes varchar(10),
  color_hair varchar(10),
  description text
);
```

## Congratulations

Perfect! That was the last exercise in this part, and you nailed it. Congratulations!

In the next part, we'll focus on numerical data types. See you there!
