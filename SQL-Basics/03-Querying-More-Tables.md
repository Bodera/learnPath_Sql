# Data from multiple tables

Hey there! Since you've completed Part 1 of our SQL course, you already know how to get data from a single table. You've also learned how to filter rows to only get those which you really need. Superb!

Single tables might seem handy at first, but in big databases we always use **multiple tables**. This also means that we often want to get data from more than one table at a time. By the end of this part, you'll know how to join results from multiple tables.

# Table of contents

- [Get to know the tables](#get-to-know-the-tables)
- [Multiple tables in the clause FROM](#multiple-tables-in-the-clause-from)
- [Join tables on a condition](#join-tables-on-a-condition)
- [The keyword JOIN](#the-keyword-join)
- [Join tables using JOIN](#join-tables-using-join)
- [Display specific columns](#display-specific-columns)
- [Refer to columns without table names](#refer-to-columns-without-table-names)
- [Rename columns with AS](#rename-columns-with-as)
- [Filter the joined tables](#filter-the-joined-tables)
- [Filter the joined tables continued](#filter-the-joined-tables-continued)
- [Put your skills into practice](#put-your-skills-into-practice)
- [Further practice](#further-practice)


## Get to know the tables

We'll have cars (table `car`) and their owners (table `person`). We know the owner of the car because we have the column `owner_id` in the table car which contains an id from the table person. Easy, right?

Take a look at the columns the tables contain:

**person (id, name, age);**

**car (id, brand, model, price, owner_id);**

### Exercise

In case you're already fed up with the cars, we've created a new set of data for all the **exercises** in this part.

We're going to work with **movies** and their **directors**.

## Multiple tables in the clause FROM

We know who directed a specific movie because there is a column `director_id` in the table movie. If you take a look at "Midnight in Paris", its `director_id` is 3. So we can now look into the `director` table to find out that id 3 is assigned to Woody Allen. And that's how we know he is the director. Did you get that right?

There are quite a few ways of getting information from multiple tables at the same time. We're going to start with the easiest one.

```sql
SELECT *
FROM person, car;
```

You already know how `SELECT * FROM` works, don't you? Now we just name two tables instead of one, and we separate them with a comma (`,`). Piece of cake! The result, however, might be a tiny bit of a surprise to you. Let's check that out.

### Exercise

Get all the data from two tables: `movie` and `director`.

If there are 8 movies and 5 directors, how many rows will we get in our result? Exactly **40 rows**.

## Join tables on a condition

Surprised, huh? If there are 8 movies and 5 directors, most people will say that we'll get 5, 8 or 13 rows in the result. This is not true.

We've got **40 rows** altogether because SQL takes every single movie and joins it with every possible director. So we now have 8 * 5 = 40 rows!

Why did this happen? SQL doesn't know what to do with the results from the two tables, so it gave you every possible connection. How can we change it? Take a look:

```sql
SELECT *
FROM person, car
WHERE person.id = car.owner_id;
```

We've set a new condition in the `WHERE` clause. We now see only those connections where `id` from person is the same as `owner_id` from car. Makes sense, right?

Take a closer look at how we provide the information about columns in the `WHERE` condition. If you have multiple tables, you should refer to specific columns by giving the name of the table and the column, separated by a dot (`.`). As a result, the column `owner_id` from the table car becomes `car.owner_id` and so on.

### Exercise

Select all columns from tables `movie` and `director` in such a way that a movie is shown together with its director.

For the sake of this exercise, join `movie` and `director` tables in this exact order (`movie`, `director`).

```sql
SELECT *
FROM movie, director
WHERE movie.director_id = director.id
```

## The keyword JOIN

Excellent! Now the result looks much better, right?

Joining two tables is such a popular and frequent operation that SQL provides a special word for it: `JOIN`. There are many versions of `JOIN` out there. For the time being, we'll focus on the basic one.

## Join tables using JOIN

Take a look at the following example:

```sql
SELECT *
FROM person
JOIN car
  ON person.id = car.owner_id;
```

We want to join the tables `person` and `car`, so we use the keyword `JOIN` between their names.

SQL must also know how to join the tables, so there is another keyword `ON`. After it, we set our condition: join only those rows where the `id` in `person` is the same as `owner_id` in `car`.

### Exercise

Use the new construction `JOIN ... ON` to join rows from the tables `movie` and `director` in such a way that a movie is shown together with its director. Display all columns from both tables.

```sql
SELECT *
FROM movie
JOIN director
  ON movie.director_id = director.id;
```

## Display specific columns

Splendid! Now, let's say we only need a **few columns** in our result. We just want to know the model of the car and the owner's name, Take a look:

```sql
SELECT
  person.name,
  car.model
FROM person
JOIN car
  ON person.id = car.owner_id;
```

Simple, isn't it? Instead of the asterisk (`*`), we put the column names.

As we now have more than one table, we put the table name in front of the column name, and we separate them with a dot (`.`). In this way, SQL knows that the column model belongs to the table car, etc.

### Exercise

Select **director name** and **movie title** from tables `movie` and `director` in such a way that a movie is shown together with its director.

```sql
SELECT
  director.name,
  movie.title
FROM movie
JOIN director
  ON movie.director_id = director.id;
```

## Refer to columns without table names

Great. In the previous example, we provided column names together with the tables they are a part of. It's good practice, but you only **need** to do it when there **is a chance of confusing them**. If there are two different columns with the same name in two different tables, then you have to specify the tables. **If the name of the column is unique, though, you may omit the table name**.

```sql
SELECT
  name,
  model
FROM person
JOIN car
  ON person.id = owner_id;
```

There is only one column named `name` and only one column named `model` in the tables `person`, `car`, so we can provide their names without giving information about the tables they come from. Similarly, there is only one column named `owner_id` – it is only in the table `car`, so we can omit the name of the table.

When we refer to column `id` from table `person`, though, we must write the table name as well (`person.id`), because there is another column with the name `id` in table `car`.

### Exercise

Select **director name** and **movie title** from the `movie` and `director` tables in such a way that a movie is shown together with its director. Don't write table names in the `SELECT` clause.

```sql
SELECT
  name,
  title
FROM movie
JOIN director
  ON movie.director_id = director.id;
```

## Rename columns with AS

Good job! We can do one more thing with our columns: rename them. Up till now, the column named `id` was always shown as `id` in the result. Now we will change it:

```sql
SELECT
  person.id AS person_id,
  car.id AS car_id
FROM person
JOIN car
  ON person.id = car.owner_id;
```

After the column name, e.g. `person.id`, we use the new keyword `AS` and we put the new name after it (`person_id`). We can repeat this process with every column.

The new name is just an alias, which means it's temporary and doesn't change the actual column name in the database. It only influences the way the column is shown in the result of the specific query. This technique is often used when there are a few columns with the same name coming from different tables. Normally, when SQL displays columns in the result, there is no information about the table that a specific column is part of.

In our example, we had two columns `id`, so we renamed them to `person_id` and `car_id` respectively. Now, if we see the columns in the result, we will know which column comes from which table.

### Exercise

In this exercise, show the title column as movie_title. We wrote the query from the previous exercise in the template, so you just have to add a proper alias.

```sql
SELECT
  title AS movie_title,
  name
FROM movie
JOIN director
  ON director_id = director.id;
```

## Filter the joined tables

Amazing job! Now that we know how to work with columns, let's find out how to filter the results even further:

```sql
SELECT
  person.id,
  car.model
FROM person
JOIN car
  ON person.id = car.owner_id
WHERE person.age < 25;
```

The new part here is the `WHERE` clause. Now we only look for such connections of cars and their owners where the owner is below 25. Be sure to include the table name in the condition (`person.age`).

### Exercise

Select all columns from tables `movie` and `director` in such a way that a movie is shown together with its director. Select only those movies which were made after 2000. In the joining condition, let the first table be `movie` and the second table be `director`.

```sql
SELECT *
FROM movie
JOIN director
  ON movie.director_id = director.id
WHERE movie.production_year > 2000;
```

## Filter the joined tables continued

Excellent! Filtering the results is very important, so let's do another exercise on that. Do you still remember how text values work in SQL?

```sql
SELECT
  person.id,
  car.model
FROM person
JOIN car
 ON person.id = car.owner_id
WHERE car.brand = 'Fiat';
```

In the above query, we only select cars of brand `'Fiat'`. Piece of cake, right? Let's practice.

### Exercise

Select all columns from tables `movie` and `director` in such a way that a movie is shown together with its director. Select only those movies which were directed by Steven Spielberg.

```sql
SELECT *
FROM movie
JOIN director
  ON movie.director_id = director.id
WHERE director.name = 'Steven Spielberg';
```

## Put your skills into practice

Nice! Let's put into practice everything we've learned so far. Are you ready? This example is going to be slightly more complicated, so make sure you remember everything from this part of the course.

### Exercise

Select the `title` and `production_year` columns from the `movie` table, and the `name` and `birth_year` columns from the `director` table in such a way that a movie is shown together with its director.

Show the column `birth_year` as `born_in`. Select only those movies which were filmed when their director was younger than 40 (i.e. the difference between `production_year` and `birth_year` must be less than 40).

```sql
SELECT
  movie.title,
  movie.production_year,
  director.name,
  director.birth_year AS born_in
FROM movie
JOIN director
  ON movie.director_id = director.id
WHERE movie.production_year - director.birth_year < 40;
```

## Further practice

Excellent! We have one more exercise for you before the end of this part. You are going to write your longest SQL query ever, and you'll apply knowledge from both of the parts you've mastered so far. Are you ready?

### Exercise

Select the `id`, `title`, and `production_year` columns from the `movie` table, and the `name` and `birth_year` columns from the `director` table in such a way that a movie is shown together with its director. Show the column `birth_year` as `born_in` and the column `production_year` as `produced_in`. Select only those movies:

- whose title contains a letter 'a' and which were filmed after 2000,
**or**
- whose director was born between 1945 and 1995.

```sql
SELECT
  movie.id,
  movie.title,
  movie.production_year AS produced_in,
  director.name,
  director.birth_year AS born_in
FROM movie
JOIN director
  ON movie.director_id = director.id
WHERE movie.title LIKE '%a%'
  AND movie.production_year > 2000
  OR director.birth_year BETWEEN 1945 AND 1995;
```