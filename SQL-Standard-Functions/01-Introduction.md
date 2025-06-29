# Introduction

In this course we assume that you know the basics of SQL: you know how to select information from a single table, you know how to join queries and group by query results. Take the test to find out if you know SQL well enough to follow the course.

This course introduces basic SQL functions that can be used to process different types of data. It focuses on the most used and most useful **standard SQL functions**, including:

- SQL text functions.
- SQL numeric functions.
- SQL date and time functions.
- SQL functions dealing with NULL.
- SQL aggregate functions.

In this course, we'll focus on commonly used standard SQL functions. The code we show should **work in many SQL databases**, although some minor modifications may be needed. However, not all databases comply with the SQL standard. If that's the case, we'll let you know in the exercise instructions.

Many databases offer nonstandard functions which do the same thing as the standard functions we will discuss. We don't have the scope to cover nonstandard syntax in this tutorial; your database's **documentation is a good place** to learn about any nonstandard syntax it uses.

This course is intended for intermediate users. In order to give you a general idea of what you should already know about SQL, we're going to start with a short review quiz. It will consist of **5 questions** with an increasing level of difficulty. We assume you already know how to:

- Query a single table.
- Query multiple tables with `JOIN` data from multiple tables.
- Sort and group rows.
- Use the `HAVING` statement.

So, are you ready?

## Intro Quiz

Fine, let's start with something easy. But before we do, we should get to know the tables we will be operating on.

We'll use two simple tables which come from an art gallery.

The table `artist` includes:

- the identifier (column `id`).
- first and last name (columns `first_name`, `last_name`).
- the exact dates when the artist was born and when they died (columns `born`, `died`).
- and their nationality (column `nationality`).

The table `painting` includes:

- the painting id (column `id`).
- the id of the artist (column `artist_id`).
- its title (column `title`).
- the year it was created (column `painted`).
- and the quality rating of the painting by some local experts (column `rating`).

So, are you ready for your first exercise?

### Exercise 1

For each painting created in **1800 or later**, show its `title` and the **year** it was painted (column `painted`). Include paintings for which the creation date is **unknown**.

```sql
SELECT title, painted
FROM painting
WHERE painted >= 1800 OR painted IS NULL
```

### Exercise 2

For each painting, show its `title` plus the **first** and **last name** of the painter. Only show the results for **Dutch** and **Flemish** painters.

```sql
SELECT title, first_name, last_name
FROM painting
JOIN artist ON painting.artist_id = artist.id
WHERE nationality IN ('Dutch', 'Flemish')
```

### Exercise 3

Show the **number** of paintings whose date of creation is known and which were created in **1800 or later**. Name the column `paintings_no`.

```sql
SELECT COUNT(*) AS paintings_no
FROM painting
WHERE painted >= 1800 AND painted IS NOT NULL
```

### Exercise 4

For each painter, show their **first** and **last** name together with the **number** of paintings they have painted. The names of the columns should be: `first_name`, `last_name`, and `paintings_no`.

```sql
SELECT first_name, last_name, COUNT(*) AS paintings_no
FROM painting
JOIN artist ON painting.artist_id = artist.id
GROUP BY first_name, last_name
```

### Exercise 5

For each artist, show their **first** and **last** name, the **average**, **minimum** and **maximum** ratings from all their paintings. Only show those artists who have **more than 2** paintings.

Name the columns: `first_name`, `last_name`, `avg_rating`, `min_rating`, `max_rating`.

```sql
SELECT first_name, last_name, AVG(rating) AS avg_rating, MIN(rating) AS min_rating, MAX(rating) AS max_rating
FROM painting
JOIN artist ON painting.artist_id = artist.id
GROUP BY first_name, last_name
HAVING COUNT(*) > 2
```

## Congratulations

Excellent! You've passed all the review exercises we've prepared for you. This means you're ready for our course - Standard SQL Functions.

See you in the second part where the fun begins!




