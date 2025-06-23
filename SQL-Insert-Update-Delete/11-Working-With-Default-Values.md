# Working with DEFAULT values in INSERT and UPDATE

Welcome to Part 3 of the How to INSERT, UPDATE, and DELETE Data in SQL course. Today, we're going to deal with **default values** in `INSERT` and `UPDATE` statements.

Let's get started!

## The author table

In this part, we'll be working on data from a **popular news website**. Authors create posts on the website; to do this, they first have to register and supply some information about themselves. This information is stored in the `author` table. Let's look at that table.

### Exercise

Select all columns from the `author` table. It contains the following columns:

- `id` – identifies each author.
- `first_name` – the first name of the author.
- `last_name` – the last name of the author.
- `photo` – a path to a photo of the author; if there is no author photo, it will store the string `'imgs/no-photo.jpg'`.
- `create_timestamp` – when this author registered on the website.
- `is_active` – a boolean value denoting whether the author has an active account and can write posts (`true`) or an inactive account (`false`).

```sql
SELECT * FROM author;
```

| id | first_name | last_name | photo | create_timestamp | is_active |
| --- | --- | --- | --- | --- | --- |
| 10 | Marian | Williams | imgs/MW.jpg | 2018-09-20 21:13:02.3 | t |
| 11 | Anne | Kowalsky | imgs/anne.jpg | 2018-09-04 07:00:15.6 | f |
| 12 | Olivier | Malley | imgs/no-photo.jpg | 2018-10-04 17:40:45.8 | t |

## The post table

The other table is named `post`, which stores information about authors' published blog posts. Let's look at it as well.

### Exercise

Select all columns from the `post` table. It contains the following columns:

- `id` – identifies each post.
- `author_id` – identifies the author of the post.
- `title` – the post's title/headline.
- `text` – the content of the post.
- `modified_timestamp` – when the post was created or modified.

```sql
SELECT * FROM post;
```

| id | author_id | title | text | modified_timestamp |
| --- | --- | --- | --- | --- |
| 10 | 10 | Incredible history | Archaeologists in Egypt found skeletons of 10 women and 20 men. An international team of university experts are carrying out their research on the subject. | 2018-10-12 12:15:30.2 |
| 11 | 12 | Pictures for charity | Alan is a realist artist from Alaska. He decided to sell all his pictures to help people. Thanks to his generous contributions, the local children's hospital was able to buy the equipment it needed. | 2019-01-02 20:10: |

## DEFAULT — explanation

Okay, let's explain `DEFAULT`.

The `DEFAULT` clause allows us to assign a **default value to a column**. `DEFAULT` is defined for a column **during table creation**, and the database architect decides whether a given column has a default value. The user only needs to know that a default value is defined for a particular column.

Technically, the default value is a constraint that says that if there is no value added to this column during an `INSERT` or `UPDATE` operation, the specified default value will be used.

In our database, the `author` table has default values for the following columns:

- `photo` (default value of `'imgs/no-photo.jpg'`)
- `create_timestamp`
- `is_active` (default value of `false`)

The `post` table has a default value for `modified_timestamp`.

## Inserting a DEFAULT value into one column

Great! Let's see how `DEFAULT` works in practice.

In the `author` table, the `photo` column stores either a path to the image if one exists or the string `'imgs/no-photo.jpg'` (the default value). The default value will be put into the column if no other value is inserted into this field.

```sql
INSERT INTO author (id, first_name, last_name, photo, create_timestamp, is_active) 
VALUES (1, 'Gregory', 'Smith', DEFAULT, '2018-08-25', 1);
```

`DEFAULT` occupies the fourth position in the `VALUES` list, which corresponds to the photo column. When this record is inserted, the string `'imgs/no-photo.jpg'` will go into the `photo` column. Here's what the result looks like:

| id | first_name | last_name | photo | create_timestamp | is_active |
| --- | --- | --- | --- | --- | --- |
| 1 | Gregory | Smith | imgs/no-photo.jpg | 2018-08-25 00:00:00.0 | 1 |

### Exercise

Let's add the data for **Cindy Barry** into the `author` table. She should have an **ID** of `2`, a photo path set to `'imgs/cindy.jpg'`, and a registration date of `'2018-08-27'`.

We don't know if Cindy wants to have an active account yet, so we'll leave this as a `DEFAULT` value.

```sql
INSERT INTO author (id, first_name, last_name, photo, create_timestamp, is_active) 
VALUES (2, 'Cindy', 'Barry', 'imgs/cindy.jpg', '2018-08-27', DEFAULT);
```

## Inserting DEFAULT values by omitting columns

Very nice! Now, what if you need to add a default value **to more than one column**? Here's how you can do it:

```sql
INSERT INTO author (id, first_name, last_name, photo, create_timestamp, is_active)
VALUES (3, 'Alan', 'Hillary', DEFAULT, DEFAULT, DEFAULT);
```

Wherever we want the database to insert the default value, we put `DEFAULT`.

Since we used more than one `DEFAULT` in this statement, it got quite long! Fortunately, SQL provides a shorter version that we can use:

```sql
INSERT INTO author (id, first_name, last_name)
VALUES (3, 'Alan', 'Hillary');
```

Notice that SQL allows you to omit `DEFAULT`s in the `VALUES` list. In the column list, you also skip any columns where you'd put a `DEFAULT` value. If you have to insert multiple `DEFAULT` values, it's easier and quicker to omit them, as we did here.

### Exercise

Martin Williams (`id = 4`) registered to join the site on `2018-09-30`. Insert his data with default values for the `photo` and `is_active` columns.

```sql
INSERT INTO author (id, first_name, last_name, create_timestamp)
VALUES (4, 'Martin', 'Williams', '2018-09-30');
```

## INSERT using DEFAULT for all columns

Amazing! What about using `DEFAULT` for all columns? You can use a statement like this:

```sql
INSERT INTO all_defaults_table VALUES (DEFAULT, DEFAULT, DEFAULT, DEFAULT, DEFAULT);
```

SQL again allows you to use a shorter query:

```sql
INSERT INTO all_defaults_table DEFAULT VALUES;
```

Using `DEFAULT` for every table column is a very rare case, so we don't need to discuss it in detail. Just remember that you can use this syntax if needed.

## Using DEFAULT for the current date and time

Great! `DEFAULT` is often used for date and time columns, and a very common situation is to use the current date and time for the default value. In SQL, you use `current_timestamp` to get the current date and time.

The `create_timestamp` column of the `author` table has a default value of `current_timestamp`. The following statement inserts a row with the `create_timestamp` column with the current date and time (i.e., the date and time of when the record was inserted):

```sql
INSERT INTO author (id, last_name, photo, create_timestamp)
VALUES (7, 'Smith', 'imgs/Smith2.jpg', DEFAULT);
```

Here is the result:

| id | first_name | last_name | photo | create_timestamp | is_active |
| --- | --- | --- | --- | --- | --- |
| 7 | NULL | Smith | imgs/Smith2.jpg | 2018-10-12 10:02:20.1237862 | true |

Notice that the first name is not given in this query. The value for `first_name` is `NULL` because there is no `DEFAULT` value for this column.

### Exercise

The author with ID of 7 wrote his first short post:

> 'Our company sold about 23 percent more magazines this year than it did 2 years ago.'

The `title` is

```
'Increased magazine sales'
```

And the post **ID** is `5`. Insert this data into the `post` table using the default date, which is the current date and time.

```sql
INSERT INTO post (id, author_id, title, text)
VALUES (5, 7, 'Increased magazine sales', 'Our company sold about 23 percent more magazines this year than it did 2 years ago.');
```

## Update a column using a DEFAULT value

Very nice! You can also use `DEFAULT` in an `UPDATE` statement.

If the column has a set default value, you can update data using the default value of this column. For example:

```sql
UPDATE author
SET photo = DEFAULT
WHERE id = 2;
```

This statement removes the picture from the account of the author whose `id = 2`. The remaining data doesn't need to change, so we update the row rather than delete it. The `photo` column has a default value, so we used it to update the row. Now the string `'imgs/no-photo.jpg'` will be the photo column value for this author.

### Exercise

The author Alan Hillary (`id = 3`) would like to set the `is_active` value to the default and change the path for his photo to `imgs/alan3.jpg`.

```sql
UPDATE author
SET is_active = DEFAULT, photo = 'imgs/alan3.jpg'
WHERE id = 3;
```

## Summary

Great! We've reached the final section for this part. Let's review what we've learned.

A database architect can define a default value for a column in a table. If that's the case, **you can use the default value**:

- In an `INSERT` statement:

```sql
INSERT INTO author (id, first_name, last_name, photo, create_timestamp, is_active) 
VALUES (120, 'Gary', 'Brown', 'imgs/gary.jpg', '2018-08-25', DEFAULT);
```

- By omitting columns in `INSERT`:

```sql
INSERT INTO author (id, first_name, last_name) 
VALUES (121, 'Mary', 'Taylor');
```

- During an `UPDATE` operation:

```sql
UPDATE author
photo = DEFAULT
WHERE id = 120;
```

### Exercise

Well done! You've completed Part 3 and learned the various ways in which SQL can automatically generate values.
