# Quiz

Welcome to the very last part of our SQL Basics course. This part is a **quiz**. You can check how much you remember from the whole course.

You will be given different tables each time and asked to write various SQL queries.

Are you ready? Have you revised everything? Let's go!

## Task 1: Selecting rows from one table

Great. How superstitious are you? We're going to deal with... horoscopes! Check out the table:

`horoscope (id, year, sign, content)`

Let's describe the table a little bit. In the table, we have horoscopes for given years – they are sentences that describe what may or will happen in the specific year.

Each horoscope has an `id`, refers to a specific `year`, and refers to a specific zodiac `sign`. The column `content` contains the magical sentence.

### Exercise

Select all columns from horoscopes for Pisces and Aquarius from the years 2010 to 2014.

```sql
SELECT *
FROM horoscope
WHERE sign IN ('Pisces', 'Aquarius')
    AND year BETWEEN 2010 AND 2014;
```

## Task 2: Selecting rows from multiple tables

Wow, excellent! You remembered that very good!

Now, let's see if you can still recall how to work with more than one table.

In this task, our small database collects information about pets and their owners in two separate tables.

`pet (id, owner_id, name, type, year_born)`

Each pet has an `id`, is assigned to a specific **owner** (via `owner_id`), has a `name`, is of certain `type` (dog, cat, ...), and was born in a specific **year** (the `year_born` column).

`owner (id, name, year_born)`

Each owner has an `id`, a `name`, and, again, was born in a specific **year** (the `year_born` column).

### Exercise

Show all **pets** (show the columns `name`, `type`, `year_born`) whose name begins with an `'M'` together with their **owners** (the columns `name`, `year_born`).

Rename the column `year_born` from the table `pet` as `pet_year_born` and the column `year_born` from the table `owner` as `owner_year_born`.

```sql
SELECT 
    pet.name, 
    pet.type, 
    pet.year_born AS pet_year_born, 
    owner.name, 
    owner.year_born AS owner_year_born
FROM pet
INNER JOIN owner ON pet.owner_id = owner.id
WHERE pet.name LIKE 'M%';
```

## Task 3: Aggregation and grouping

A-ma-zing! Part 2 was no problem for you! Take a look at our third task:

`essay (id, person, topic, length, points)`

We're now going to analyze essays written by various students. Each essay has an **id**, was written by a specific **person**, has a certain **topic** and a certain **length** (expressed as the number of words). Each essay is given **points** (0-100).

There may be more than one essay written by the same person.

### Exercise

Show students' **names** (column `person`) together with

- the **number of essays** they handed in (name the column `number_of_essays`).
- their **average number of points** (name the column `avg_points`).

Show only those students whose **average number of points is more than 80**.

```sql
SELECT 
    person, 
    COUNT(*) AS number_of_essays, 
    AVG(points) AS avg_points
FROM essay
GROUP BY person
HAVING avg_points > 80;
```

## Task 4: Sophisticated JOINs

This quiz is too easy for you! OK, let's see how much you remember about various JOINs.

`player (id, name, ranking, country)`

`coach (id, player_id, name, country)`

We now have two tables with **tennis players** and their **coaches**. Each player can have one or more coaches. Each coach can train one player or can be unemployed.

The columns should be obvious for you.

### Exercise

Show all coaches together with the players they train, show all columns for coaches and players. Show unemployed coaches with `NULLs` instead of player data.

```sql
SELECT *
FROM player
RIGHT JOIN coach ON player.id = coach.player_id;
```

## Task 5: Subqueries

That's right. Keep it up! Do you still remember subqueries, then? Let's see.

`prison (id, name, country)`

`prisoner (id, prison_id, name, age)`

The tables represent some of the most dangerous **prisons** in the world and a few fictional **prisoners** who serve their sentences there.

Each prison has an `id`, its `name`, and the `country` where it's located. Each prisoner also has an `id`, the id of their `prison`, a `name`, and a specific `age`.

### Exercise

Show all columns for the prisons where there is at least one prisoner above 50 years of age.

```sql
SELECT *
FROM prison
WHERE id IN (
    SELECT prison_id
    FROM prisoner
    WHERE age > 50
);
```

## Task 6: Set operations

Unbelievable! How about set operations: unions, differences and intersections? Can you still remember them? Take a look:

`gluten_free_product (id, type, name, calories, price)`

`vegetarian_product (id, type, name, calories, price)`

As you can see, we are now inside a **dietician's office**. We have two tables with the same columns: products that are free of gluten and vegetarian products. Each product has its own `id`, its `type` (whether it's meat, dairy, etc.), `name`, number of `calories` per portion and `price`.

### Exercise

Show all columns for the products which are gluten free and vegetarian at the same time.

```sql
SELECT *
FROM gluten_free_product
INTERSECT
SELECT *
FROM vegetarian_product;
```

## Task 7: Challenge

Excellent! Looks like you've mastered all parts of the SQL Basics course. Congratulations!

Before you finish, we have one final task for you. It's a bit more complicated than the previous tasks and you should combine the knowledge from different parts of the course to solve it. Let's take a look into a database at a **florist's** shop:

`customer (id, name, country)`

`purchase (id, customer_id, year)`

`purchase_item (id, purchase_id, name, quantity)`

Here customers purchase **flowers**.

Each purchase consists of one or more `purchase_item`s. Each purchase_item belongs to one purchase (column `purchase_id`).

For example, if John Smith places an order for 2 roses and 1 lily, there will be two `purchase_item`s in this specific purchase: one identifying a rose (the column `quantity` would contain the value 2 here) and one identifying a lily (column `quantity` would contain the value 1 here).

All purchase IDs are stored **chronologically**, i.e., the last ID placed in the shop has the highest ID.

### Exercise

The owner of the shop would like to see each customer's

- id (name the column `cus_id`).
- name (name the column `cus_name`).
- id of their latest purchase (name the column `latest_purchase_id`).
- the total quantity of all flowers purchased by the customer, in all purchases, not just the last purchase (name the column `all_items_purchased`).

Remember, you need not use all columns from all the tables here – choose them carefully.

```sql
SELECT 
    customer.id AS cus_id, 
    customer.name AS cus_name, 
    MAX(purchase.id) AS latest_purchase_id, 
    SUM(purchase_item.quantity) AS all_items_purchased
FROM customer
INNER JOIN purchase ON customer.id = purchase.customer_id
INNER JOIN purchase_item ON purchase.id = purchase_item.purchase_id
GROUP BY customer.id;
```
