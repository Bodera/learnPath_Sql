# More on Joins

Welcome to another part of our course. You're already pretty skillful in SQL, so this time we're going to go down into details.

By the end of this part, you'll know how to exercise real control over your **JOIN clauses**. Don't worry if you don't remember `JOINs` precisely – we're going to revise them anyway.

Before we start, you should get to know the data. We're going to work with three brand-new tables: `student`, `room`, and `equipment`. Are you ready?

## Table of contents

- [Get to know the table room](#get-to-know-the-table-room)
- [JOIN revised](#join-revised)
- [JOIN columns revised](#join-columns-revised)
- [INNER JOIN](#inner-join)
- [How INNER JOIN works](#how-inner-join-works)
- [LEFT JOIN explained](#left-join-explained)
- [RIGHT JOIN explained](#right-join-explained)
- [FULL JOIN explained](#full-join-explained)
- [The keyword OUTER](#the-keyword-outer)
- [NATURAL JOIN](#natural-join)
- [NATURAL JOIN explained](#natural-join-explained)
- [Table aliases](#table-aliases)
- [Aliases in self-joins](#aliases-in-self-joins)
- [Joining more tables](#joining-more-tables)

## Get to know the table room

All right! As you can see, there are four columns in the table room: `id`, `room_number`, `beds`, and `floor`.

The column:

- `id` is the identification number of the room in our table.
- `room_number` is the number of the room typically found on its door in the dormitory.
- `beds` tells you how many beds there are in the room.
- `floor` is the number of the floor where the room can be found in the dormitory.

There are only three columns in the table student: `id`, `name`, and `room_id`. The column `id` is the identification number of each student in our table, `name` is the full name of the student. `room_id` is the id of the room which the student lives in. The room id is, of course, taken from the table `room`.

If you examine the table `student` close enough, you'll find out that some students **don't have a room assigned to them**. Remember this detail – we'll make use of this information later on.

Ok, let's check the last table.

The table `equipment` is very much similar to the table `student`. It has three columns:

- `id` – the id of the equipment piece.
- `name` – which tells us what it is.
- `room_id` – the room where we can find the piece of equipment.

Note that some pieces **aren't assigned to any room** – they are simply stored in the warehouse, in case you're curious.

## JOIN revised

Good, let's get started!

Do you still remember how we joined two tables in Part 2 of our SQL course? Let's **revise** the example we gave for people and their cars:

```sql
SELECT *
FROM person
JOIN car
  ON person.id = car.owner_id;
```

That's right, we put the keyword `JOIN` between the names of two tables and then, after another keyword `ON`, we provided the condition.

In this particular example, we joined the rows where value of the column `owner_id` (table `car`) was **identical** with the value of the column `id` (table `person`). In this way, we joined cars with their owners.

### Exercise

Try it yourself. Join the two tables: `student` and `room` so that each student is shown together with the room they live in. Select all columns.

```sql
SELECT *
FROM student
JOIN room
  ON student.room_id = room.id;
```

## JOIN columns revised

Very well done!

You can select **some columns** in a `JOIN` query. Take a look at the example:

```sql
SELECT
  person.name,
  car.brand,
  car.model
FROM person
JOIN car
  ON person.id = car.owner_id;
```

Instead of all columns (selected with the asterisk `*`) here we select only three columns: `name` from table `person`, `brand` from table `car` and `model` from table `car`.

We first put the name of the **table**, then a dot (`.`), and then the name of the **column** we want to select.

### Exercise

Join the `student` and `room` tables so that each student is shown together with the room they live in.

Select the **name of the student** and **room number**.

```sql
SELECT
  student.name,
  room.room_number
FROM student
JOIN room
  ON student.room_id = room.id;
```

## INNER JOIN

Excellent! Now, you should be made aware that `JOIN` is actually just one, of a few joining methods. It's the most common one so it's always applied **by default** when you write the keyword `JOIN` in your SQL statement. Technically speaking, though, its full name is `INNER JOIN`.

The example from the previous exercise can be just as well written in the following way:

```sql
SELECT *
FROM person
INNER JOIN car
  ON person.id = car.owner_id;
```

### Exercise

Now, use the full name `INNER JOIN` to join the `room` and `equipment` tables, so that each piece of equipment is shown together with its room and other relevant columns. The result should have the following columns:

- `room_id` – ID of the room.
- `room_number`.
- `beds`.
- `floor`.
- `equipment_id` – ID of the equipment.
- `name` (of the equipment).

```sql
SELECT
  room.id AS room_id,
  room.room_number,
  room.beds,
  room.floor,
  equipment.id AS equipment_id,
  equipment.name
FROM room
INNER JOIN equipment
  ON room.id = equipment.room_id;
```

## How INNER JOIN works

If you now compare the results of `INNER JOIN` with the content of the `equipment` table, you'll notice that not all pieces of equipment are present in the resulting table. For example, a lovely kettle with the id 11 is not there. Do you know why?

`INNER JOIN` (or `JOIN`, for short) only shows those rows from the two tables where there is a **match** between the columns. In other words, you can only see those pieces of equipment which have a room assigned and vice versa. **Equipment with no room is not shown in the result**.

## LEFT JOIN explained

`LEFT JOIN` works in the following way: it returns all rows from the left table (the first table in the query) plus all matching rows from the right table (the second table in the query).

Let's see an example:

```sql
SELECT *
FROM car
LEFT JOIN person
  ON car.owner_id = person.id;
```

The `LEFT JOIN` returns all rows in the above table. The blue rows are returned by the INNER JOIN. The pink rows are added by the LEFT JOIN: there is no matching owner for the pink row cars but a LEFT JOIN returns them nevertheless.

### Exercise

Show all rows from the table `student`. If a student is assigned to a room, show the room data as well.

```sql
SELECT *
FROM student
LEFT JOIN room
  ON student.room_id = room.id;
```

### Exercise 2

Select all pieces of equipment together with the room they are assigned to. Show each piece of equipment even if it isn't assigned to a room. Select **all** available columns.

```sql
SELECT *
FROM equipment
LEFT JOIN room
  ON equipment.room_id = room.id;
```

## RIGHT JOIN explained

Great! As you may have guessed, there is also a `RIGHT JOIN`.

The `RIGHT JOIN` works in the following way: it returns **all** rows from the **right table** (the second table in the query) plus all matching rows from the **left table** (the first table in the query).

Let's see an example. Take a look at the query:

```sql
SELECT *
FROM car
RIGHT JOIN person
  ON car.owner_id = person.id;
```

The `RIGHT JOIN` returns all rows in the table above. The blue rows are returned by the INNER JOIN. The pink rows are added by the RIGHT JOIN.

Notice that the order of the tables in LEFT and RIGHT JOIN matters. In other words, `car RIGHT JOIN person` is the same as `person LEFT JOIN car`. Don't confuse the order!

### Exercise

For each student show their data with the data of the room they live in. Show also rooms with no students assigned. Use a `RIGHT JOIN`.

```sql
SELECT *
FROM student
RIGHT JOIN room
  ON student.room_id = room.id;
```

### Exercise 2

For each student show the room data the student is assigned to. Show also students who are not assigned to any room. Use a `RIGHT JOIN`.

```sql
SELECT *
FROM room
RIGHT JOIN student
  ON room.id = student.room_id;
```

## FULL JOIN explained

Excellent! Another joining method is `FULL JOIN`. This type of JOIN returns all rows from both tables and combines the rows when there is a match. In other words, FULL JOIN is a union of `LEFT JOIN` and `RIGHT JOIN`.

Let's see an example:

```sql
SELECT *
FROM car
FULL JOIN person
  ON car.owner_id = person.id;
```

The pink rows are returned by INNER JOIN.
The blue rows would be added by a LEFT JOIN.
The purple rows would be added by a RIGHT JOIN.

A FULL JOIN returns **all** rows from the table above.

Unfortunately, some databases don't support FULL JOINs and this is exactly the problem with the database we're working on in this SQL course. In other words, we'll let you off without an exercise this time!

## The keyword OUTER

OK. Remember when we told you that `JOIN` is short for `INNER JOIN`?

The three joins we mentioned just now: `LEFT JOIN`, `RIGHT JOIN`, and `FULL JOIN` are also shortcuts. They are all actually `OUTER JOINS`: `LEFT OUTER JOIN`, `RIGHT OUTER JOIN`, and `FULL OUTER JOIN`. You can add the keyword `OUTER` and the results of your queries will stay the same.

For example, for the `LEFT JOIN`, you could just as well write:

```sql
SELECT *
FROM person
LEFT OUTER JOIN car
  ON person.id = car.owner_id;
```

### Exercise

Check it out for yourself. Use the full name `RIGHT OUTER JOIN` to show all the kettles together with their room data (even if there is no room assigned).

```sql
SELECT *
FROM room
RIGHT OUTER JOIN equipment
  ON room.id = equipment.room_id
WHERE equipment.name = 'kettle';
```

## NATURAL JOIN

There's one more joining method before you go. It's called `NATURAL JOIN` and it's **slightly different** from the other methods because it doesn't require the `ON` clause with the joining condition:

```sql
SELECT *
FROM person
NATURAL JOIN car;
```

Check it yourself and try to guess how it works.

### Exercise

Use `NATURAL JOIN` on the tables `student` and `room`.

```sql
SELECT *
FROM student
NATURAL JOIN room;
```

## NATURAL JOIN explained

Great! `NATURAL JOIN` doesn't require column names because it always joins the two tables on the **columns with the same name**.

In our example, students and rooms have been joined on the column `id`, which doesn't really make much sense.

In our dormitory, the construction

```sql
SELECT *
FROM student
NATURAL JOIN room;
```

gives the same result as the following query:

```sql
SELECT *
FROM student
JOIN room
  ON student.id = room.id;
```

You can, however, construct your tables in such a way that `NATURAL JOIN` comes in handy. If you had the following tables:

- car(car_id, brand, model)
- owner(owner_id, name, car_id)

Then it would make perfect sense to use `NATURAL JOIN` because it would join the two tables on the `car_id` column. You would then need fewer keyboard strokes to join two tables.

## Table aliases

Speaking of fewer keyboard strokes, there is one more thing which may come in handy and make you write less: **aliases for tables**.

Imagine the following situation: we want to select many columns from two joined tables. You could, of course, write it like this:

```sql
SELECT
  person.id,
  person.name,
  person.year,
  car.id,
  car.name,
  car.year
FROM person
JOIN car
  ON person.id = car.owner_id;
```

Takes a lot of writing, doesn't it? All those column names together with their table names... Fortunately, there is a way to make things simpler: we can introduce new **temporary names** (called aliases) for our tables:

```sql
SELECT
  p.id,
  p.name,
  p.year,
  c.id,
  c.name,
  c.year
FROM person AS p
JOIN car AS c
  ON p.id = c.owner_id;
```

As you can see, after the table names in the `FROM` clause, we used the keyword `AS`. It indicates that whatever comes next will become the new, temporary name (alias) for the table. Thanks to this, we can save our fingers a little bit and write shorter names for our tables.

### Exercise

Use `INNER JOIN` on the tables `room` and `equipment` so that all pieces of equipment are shown with their room data. Use table aliases `r` and `e`. Select the columns `id` and `name` from the table `equipment`, as well as `room_number` and `beds` from the table `room`.

```sql
SELECT
  e.id,
  e.name,
  r.room_number,
  r.beds
FROM equipment AS e
INNER JOIN room AS r
  ON e.room_id = r.id;
```

## Aliases in self-joins

That's right! Aliases are also convenient in other situations. Let's analyze the following situation:

We want to put information about **children** and their **mothers** into a database. At some point, we would also like to show children together with their mothers using a `JOIN`.

Let's say we store both children and mothers in the same table `person`. Each row has a column named `mother_id`. This column contains the ID of another row – the mother's row.

The question is: can we join the table `person` with the table `person`? The answer is simple: yes, we can! But you can't simply write this in your SQL query:

```sql
person JOIN person
```

You need to provide two different aliases for the same table:

```sql
SELECT *
FROM person AS child
JOIN person AS mother
  ON child.mother_id = mother.id;
```

Thanks to the aliases, the database engine will use the same table person twice – the first time to look for children and the second time to look for their mothers.

### Exercise

We want to know who lives with the student **Jack Pearson** in the same room. Use self-joining to show all the columns for the student Jack Pearson together with all the columns for each student living with him in the same room.

Remember to exclude Jack Pearson himself from the result!

```sql
SELECT *
FROM student AS jack
JOIN student AS student
  ON jack.room_id = student.room_id
WHERE jack.name = 'Jack Pearson';
  AND student.name != 'Jack Pearson';
```

## Joining more tables

Excellent! You can also use more than one join in your SQL instruction. Let's say we also want to show all the room information for the students paired with Jack Pearson. Unfortunately, data like room number or floor is not stored in the table `student` – we need yet another join with the table `room`:

```sql
SELECT *
FROM student AS s1
JOIN student AS s2
  ON s1.room_id = s2.room_id
JOIN room
  ON s2.room_id = room.id
WHERE s1.name = 'Jack Pearson'
  AND s1.name != s2.name;
```

Now that you know self-joins and joining more than 2 tables, we have a tiny **challenge** for you.

### Exercise

The challenge is as follows: for each **room with 2 beds** where there actually are **2 students**, we want to show one row which contains the following columns:

- the name of the first student.
- the name of the second student.
- the room number.

Don't change any column names. **Each pair of students should only be shown once**. The student whose name comes first in the alphabet should be shown first.

A small hint: in terms of SQL, "first in the alphabet" means "smaller than" for text values.

```sql
SELECT
  s1.name,
  s2.name,
  room.room_number
FROM student AS s1
JOIN student AS s2
  ON s1.room_id = s2.room_id
JOIN room
  ON s1.room_id = room.id
WHERE room.beds = 2
  AND s1.name < s2.name;
```
