# Inserting data

## Insert data

All right, we'll start off with **inserting** data into our database. To add data to a table, you use the `INSERT` command. Let's add a 50-year-old Alice as a user with an ID of 5:

```sql
INSERT INTO user 
VALUES (5, 'Alice', 50); 
```

See what happened? After `INSERT INTO`, we put the name of the table (`user`) that we're adding information to. Next, we add the keyword `VALUES` followed by the actual values `(5, 'Alice', 50)` for each column of the table. As you can see, the values must be surrounded by **parentheses** and are separated with **commas**.

The first number is the value for the `id` column. The `id` column is a numeric column, so we just type the number.

The text `'Alice'` is the value for the second column, `name`. It is a text column, meaning it contains short text information. In SQL, you surround text information with single quotes (`'example'`).

The number **50** is the value for the third column, `age`. It is a numeric column, just like `id`, so we just type the number.

Remember, in this case, you need to put the values in the **exact same order** in which the columns appear in the database.

### Exercise

The restaurant owners decided to introduce some Balkan cuisine, so we need to refresh the menu a bit.

Add a dish called **Cevapcici** with an **ID of 9** and a **price of 27**. It's a **main course**.

```sql
INSERT INTO dish 
VALUES (9, 'main course', 'Cevapcici', 27); 
```

## Insert partial data

You learn quickly, great!

Sometimes you don't know all the data when you insert information into a database. SQL allows you to insert data with values for some columns and omit data for other columns at the same time.

To insert **'Chris'** of unknown age as a user with an **ID of 6**, use the command:

```sql
INSERT INTO user (id, name) 
VALUES (6, 'Chris');
```

The new part after the table user, `(id, name)`, is the list of **column names** you will give values to. The expression `(6, 'Chris')`, in turn, is the list of __values__ for these columns. The number __6__ is the value of the first specified column, `id`. The text `'Chris'` is the value of the second specified column, `name`. The value for unknown in SQL is `NULL`. A database inserts `NULL` values for each column you omit in an `INSERT` statement.

**Warning**: Sometimes, the database will not allow you to add incomplete data

### Exercise

Balkan cuisine is getting popular, so we need another Balkan item on the menu.

Add **Kosovo Bread** with **ID of 10**; it's a **starter**. We have yet to decide on the price, so omit it for now.

```sql
INSERT INTO dish (id, type, name) 
VALUES (10, 'starter', 'Kosovo Bread'); 
```

## Insert NULL values

Well done! You can use the `NULL` value explicitly in an `INSERT` statement. To insert Chris of **unknown** age as a user with an ID of 6, you can use the command:

```sql
INSERT INTO user (id, name, Age) 
VALUES (6, 'Chris', NULL);
```

Or, since the command defines values for all columns in the `user` table, you can simply use this command:

```sql
INSERT INTO user 
VALUES (6, 'Chris', NULL);
```

Which way should you choose: the one presented in the previous exercise or one of the ways shown here? It's entirely up to you! If you want to emphasize that you insert a `NULL` value, insert it explicitly. If you want to save some typing, omit the column name.

### Exercise

Add the starter **Kosovo Bread** with **ID 10** again to the dish table. This time, explicitly insert a `NULL` value into the `price` column.

```sql
INSERT INTO dish (id, type, name, price) 
VALUES (10, 'starter', 'Kosovo Bread', NULL);
```

## Insert multiple rows

Magnificent! Now, if you need to fill up your database quickly, you may be wondering how to add **a lot of data** without much effort. Of course, you could write an `INSERT INTO` statement for each separate row, but there is also a quicker way. Have a look:

```sql
INSERT INTO user (id, name)
VALUES
  (6, 'Chris'),
  (7, 'Barbara');
```

That's right, after the closing parenthesis with the values, you can put a comma and continue adding more rows in the same way. This allows you to add multiple values quickly.

### Exercise

Lots of Czech tourists are now coming to the restaurant, and they would like to try some of their national dishes. Let's give them:

- A main course named **Gulas s knedlikem** (`id` **11**, `price` **29**).
- A dessert named **Vosi Hnizda** (`id` **12**, `price` **14**).

```sql
INSERT INTO dish (id, type, name, price) 
VALUES
  (11, 'main course', 'Gulas s knedlikem', 29),
  (12, 'dessert', 'Vosi Hnizda', 14);
```

## Insert data—exercise

Okay, before we move on, let's do a quick exercise to practice adding data to tables.

### Exercise

Add your favorite dish to the menu! It can be anything you like. Just be reasonable with the price (which must be an integer) and set the `id` to 13.

```sql
INSERT INTO dish (id, type, name, price) 
VALUES
  (13, 'starter', 'Falafel', 14);
```
