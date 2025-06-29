# Primary keys

What are database constraints? A short recap of primary keys and foreign keys.

## Creating tables with single-column primary keys

You may not be aware of it, but you already know a few constraint types. Primary keys, foreign keys, and `NOT NULL` are all constraints.

Before we get to know new constraint types, let's do a recap of what we already know about primary and foreign keys.

A **primary key** uniquely identifies a given row in a table. It may consist of one or more columns. When creating a table, we can specify a single-column primary key in the following way:

```sql
CREATE TABLE swimming_pool (
  id integer PRIMARY KEY,
  address text,
  rating integer
);
```

Look at the definition of the first column. After the data type, we added the keywords `PRIMARY KEY`. This way, the `id` column becomes the single-column primary key for the `swimming_pool` table.

### Exercise

An international accounting company needs to create a simple database to keep track of their employees. For now, create a table named `employee` with the following fields:

- `id` – An integer value.
- `first_name` – Up to 32 characters.
- `last_name` – Up to 32 characters.
- `department` – Up to 32 characters.

The `id` column should be the primary key.

```sql
CREATE TABLE employee (
  id integer PRIMARY KEY,
  first_name VARCHAR(32),
  last_name VARCHAR(32),
  department VARCHAR(32)
);
```

## Creating tables with multi-column primary keys

Very well done! How about **multi-column primary keys**? How can we define them? The syntax is a bit different:

```sql
CREATE TABLE tennis_racket (
  manufacturer varchar(32),
  model varchar(32),
  rating integer,
  PRIMARY KEY (manufacturer, model)
);
```

Now instead of adding `PRIMARY KEY` after a column type, we added the phrase `PRIMARY KEY (manufacturer, model)` after the last column definition. Inside the parentheses, we provide the names of the previously-defined columns that constitute the primary key.

An example from the previous exercise would look like this:

```sql
CREATE TABLE employee (
  id integer,
  first_name varchar(32),
  last_name varchar(32),
  department varchar(32),
  PRIMARY KEY (id, department)
);
```

### Exercise

The company now needs a table to keep track of its departments. Create a table named `department` with the following columns:

- `country` – Up to 32 characters.
- `name` – Up to 32 characters.
- `address` – Up to 64 characters.

The columns `country` and `name` should form the primary key.

```sql
CREATE TABLE department (
  country VARCHAR(32),
  name VARCHAR(32),
  address VARCHAR(64),
  PRIMARY KEY (country, name)
);
```

## Adding primary keys to existing tables

Good job! Now, suppose we have a table like this:

```sql
CREATE TABLE tennis_court (
  id integer,
  address text,
  type varchar(32)
);
```

We'd like to add a primary key to the table. How can we do that? It's actually pretty simple:

```sql
ALTER TABLE tennis_court
ADD PRIMARY KEY (id);
```

After invoking this instruction, the `id` column will be treated as the primary key. However, keep in mind that **each of the existing values** in the column we want to mark as the primary key **must be unique**. Otherwise, we won't be able to add the primary key.

Adding a primary key to an existing table can be very useful when we need to change the table's definition without completely removing that table. This option is also frequently used by database modelling tools that auto-generate SQL scripts.

### Exercise

The company has created the following table:

```sql
CREATE TABLE project (
  id integer,
  name varchar(64),
  description text,
  manager_id integer
);
```

They now need you to add a primary key to the `id` column.

```sql
ALTER TABLE project
ADD PRIMARY KEY (id);
```

## Adding primary keys with custom names to existing tables

Perfect! When we add a primary key to a table, the database engine internally stores the primary key in a constraint object. By default, this object gets an auto-generated name, which we'll explain in a second. However, you can also specify **your own name** for a constraint. For instance, we have the following table:

```sql
CREATE TABLE tennis_court (
  id integer,
  address text,
  type varchar(32)
);
```

We can add a primary key with a custom name in the following way:

```sql
ALTER TABLE tennis_court
ADD CONSTRAINT court_pk PRIMARY KEY (id);
```

The code above will add a primary key constraint with the custom name `court_pk`.

### Exercise

Let's try to add the primary key to the project table again:

```sql
CREATE TABLE project (
  id integer,
  name varchar(64),
  description text,
  manager_id integer
);
```

Add a primary key constraint on the `id` column and give the constraint the name `project_pk`.

```sql
ALTER TABLE project
ADD CONSTRAINT project_pk PRIMARY KEY (id);
```

## Deleting primary keys

Excellent! Now, how can we remove a primary key from a table? We have this table definition:

```sql
CREATE TABLE tennis_court (
  id integer PRIMARY KEY,
  address text,
  type varchar(32)
);
```

We can use the following instruction:

```sql
ALTER TABLE tennis_court
DROP CONSTRAINT tennis_court_pkey;
```

As we said before, primary keys are a kind of constraint; that's why we use the syntax the `DROP CONSTRAINT`. You may be wondering where `tennis_court_pkey` name came from. Internally, database engines store primary keys as uniquely-named constraint objects. By default, PostgreSQL uses the naming convention `table_name` + `_pkey`. That's why the primary key in table `tennis_court` was named `tennis_court_pkey`. Naturally, **if you provide your own constraint name when adding a primary key, you'll have to use the same custom name to delete the constraint**.

Remember that other databases may use different naming conventions. Always check the documentation of your database for more details.

### Exercise

The company size increased; there are so many departments now that the company wants to introduce a unique `id` column to the `department` table. Before it's marked as the `primary key`, we need to get rid of the existing primary key. The table has the following definition:

```sql
CREATE TABLE department (
  country varchar(32),
  name varchar(32),
  address varchar(64),
  PRIMARY KEY (country, name)
);
```

Remove the primary key from the table.

```sql
ALTER TABLE department
DROP CONSTRAINT department_pkey;
```

# Foreign keys

## Creating tables with foreign keys

Now that we remember what primary keys are, let's do a quick recap of foreign keys.

A **foreign key** is a field or a group of fields that refers to the primary key of another table. Foreign keys are used to link two tables together.

Let's say we have a table with tennis coaches:

```sql
CREATE TABLE coach (
  id integer PRIMARY KEY,
  first_name varchar(32),
  last_name varchar(32)
);
```

Now, we would like to create a table with tennis players. One of the fields will be named `coach_id` and will refer to the `coach` table:

```sql
CREATE TABLE player (
  id integer PRIMARY KEY,
  first_name varchar(32),
  last_name varchar(32),
  country varchar(32),
  coach_id integer,
  FOREIGN KEY (coach_id) REFERENCES coach (id)
);
```

As you can see, we've added

```sql
FOREIGN KEY (coach_id) REFERENCES coach (id)
```

at the end. This indicates that the `coach_id` column is a foreign key which references the `id` column in the `coach` table.

### Exercise

The company already has the `employee` table, which was created in the following way:

```sql
CREATE TABLE employee (
  id integer PRIMARY KEY,
  first_name varchar(32),
  last_name varchar(32),
  department varchar(32)
);
```

They now want to recreate the `project` table so that it uses a foreign key to link to the `employee` table.

Create the `project` table with the following columns:

- `id` – An integer and the primary key.
- `name` – Up to 64 characters.
- `description` – A longer text.
- `manager_id` – An integer.

The `manager_id` column is a foreign key, referencing the `id` column in the `employee` table.

```sql
CREATE TABLE project (
  id integer PRIMARY KEY,
  name varchar(64),
  description text,
  manager_id integer,
  FOREIGN KEY (manager_id) REFERENCES employee (id)
);
```

## Adding foreign keys to existing tables

Great! We can also add foreign keys to existing tables. We use a very similar syntax to the one we use for primary keys. We have these two tables:

```sql
CREATE TABLE soccer_team (
  id integer PRIMARY KEY,
  name varchar(32),
  city varchar(32)
);

CREATE TABLE soccer_player (
  id integer PRIMARY KEY,
  first_name varchar(32),
  last_name varchar(32),
  team_id integer
);
```

We now want the `team_id` column in `soccer_player` to reference `soccer_team.id`:

```sql
ALTER TABLE soccer_player
ADD FOREIGN KEY (team_id) REFERENCES soccer_team (id);
```

As you can see, the syntax is very similar. The column `team_id` in `soccer_player` table will become a foreign key referencing the `id` column (the **primary key**) in the `soccer_team` table.

Just as with primary keys, you can specify your own constraint name for foreign keys:

```sql
ALTER TABLE soccer_player
ADD CONSTRAINT soccer_player_fk FOREIGN KEY (team_id) REFERENCES soccer_team (id);
```

The code above will store the foreign key with the `soccer_player_fk` name.

### Exercise

We have modified the `employee` and `department` tables:

```sql
CREATE TABLE employee (
  id integer PRIMARY KEY,
  first_name varchar(32),
  last_name varchar(32),
  department_id integer,
  position_id varchar
);

CREATE TABLE department (
  id integer PRIMARY KEY,
  country varchar(32),
  name varchar(32),
  address varchar(64)
);
```

Your task is to **add a foreign key constraint** – the `department_id` column in the `employee` table should point to the `id` column in the `department` table.

```sql
ALTER TABLE employee
ADD CONSTRAINT employee_department_fk FOREIGN KEY (department_id) REFERENCES department (id);
```

## Deleting foreign keys

Nicely done! Now, we have the following table:

```sql
CREATE TABLE soccer_player (
  id integer PRIMARY KEY,
  first_name varchar(32),
  last_name varchar(32),
  team_id integer,
  FOREIGN KEY (team_id) REFERENCES soccer_team (id)
);
```

We want to get rid of the foreign key. We can use the following syntax:

```sql
ALTER TABLE soccer_player
DROP CONSTRAINT soccer_player_team_id_fkey;
```

The syntax for dropping foreign and primary keys is identical. The only thing you should keep in mind is PostgreSQL's default naming convention. For foreign keys, it's: the `table_name` + `_` + `column_name` + `_fkey`. That's why the column named `team_id` in the `soccer_player` table (which is a foreign key) has a constraint named `soccer_player_team_id_fkey`.

### Exercise

The table `employee` is currently created like this:

```sql
CREATE TABLE employee (
  id integer PRIMARY KEY,
  first_name varchar(32),
  last_name varchar(32),
  department_id integer,
  position_id varchar,
  FOREIGN KEY (department_id) REFERENCES department (id)
);
```

However, our company decided to create a new business model in which there are no fixed departments – each employee can work for multiple divisions. Your task is to **get rid of the foreign key** `department_id`.

```sql
ALTER TABLE employee
DROP CONSTRAINT employee_department_id_fkey;
```

# Updating and deleting with foreign keys

## Inserting rows with foreign key constraints

Remember that once we create a `FOREIGN KEY`, the database will keep track of the connection between those two tables. This means that we won't be able to add a row with a foreign key value that doesn't exist in the other table.

### Exercise

We've created the tables `employee` and `project` for you. The table `project` now has the following definition:

```sql
CREATE TABLE project (
  id integer PRIMARY KEY,
  name varchar(64),
  description text,
  manager_id integer,
  FOREIGN KEY (manager_id) REFERENCES employee(id)
);
```

Try to run the template query, which inserts a row into the `project` table.

```sql
INSERT INTO project (id, name, description, manager_id)
VALUES (1, 'Project X', 'Secret project', 4);
```

Output:

```
ERROR: insert or update on table "project" violates foreign key constraint "project_manager_id_fkey" Detail: Key (manager_id)=(4) is not present in table "employee". Line: 1 Position in the line: 1
```

As you can see, the query failed – there's no one with id = 4 in the employee table.

## Updating rows with foreign keys

Good. We now know that we can't add a row with a foreign key value that's not in the other table.

Now, what happens if we change the data in the main table while there are some foreign keys involved?

### Exercise

In the employee table, change the employee `id = 1` to `id = 107`.

```sql
UPDATE employee
SET id = 107
WHERE id = 1;
```

Output:

```
ERROR: update or delete on table "employee" violates foreign key constraint "project_manager_id_fkey" on table "project" Detail: Key (id)=(1) is still referenced from table "project". Line: 1 Position in the line: 1
```

## REFERENCES explained

Just as we expected – we failed. Why is that so? Because when we write `REFERENCES...` after `FOREIGN KEY (...)`:

```sql
FOREIGN KEY (...) REFERENCES ...
```

we actually mean:

```sql
REFERENCES ... ON UPDATE RESTRICT ON DELETE RESTRICT
```

In other words, the **database won't allow us to update or delete a primary key** that's linked to another table via a foreign key.

There are, however, other options we can use instead of `RESTRICT`:

1. `CASCADE` – When the referenced row is deleted or updated, the respective rows of the referencing table will be deleted or updated.
2. `NO ACTION` – Means "Do nothing to the referenced row". (In our database, this is the same as `RESTRICT`; in some databases, `NO ACTION` is slightly different from `RESTRICT`).
3. `SET NULL` – The values of the affected rows are set to `NULL`.
4. `SET DEFAULT` – The values of the affected rows are set to their default values.

### Exercise

Run the template code, which creates a new version of the `project` table – this time with `CASCADE`. Take a close look at how it's done.

```sql
CREATE TABLE project (
  id integer PRIMARY KEY,
  name varchar(1000) NOT NULL,
  description varchar(255) NOT NULL,
  manager_id integer NOT NULL,
  FOREIGN KEY (manager_id) REFERENCES employee (id) ON DELETE CASCADE ON UPDATE CASCADE
);
```

## Database behavior with CASCADE – Updating rows

Now that we've got the `CASCADE` option set, let's see how it works!

### Exercise

Let's see what happens in project when we update an ID in `employee`. Take the employee with `id = 1` and change the ID to `20`.

Observe how the `manager_id` changes when updating the `employee` table.

```sql
UPDATE employee
SET id = 20
WHERE id = 1;
```

## Database behavior with CASCADE – Deleting rows

Nice! As you can see, we were able to update the row. And the respective value in project changed as well. What about deleting rows?

### Exercise

What happens if we delete an employee? We've returned the good old ID `1` to **Amelia Foster** because she wasn't really happy about ID `20`. Now, try to delete her (`id = 1`) from the `employee` table.

Observe how the row for `manager_id = 1` in the `project` is removed.

```sql
DELETE FROM employee
WHERE id = 1;
```

## Database behavior with various kinds of foreign keys

Superb! As you could see, the project led by Amelia Foster, whose `id = 1`, was deleted too.

So now we know how `CASCADE` works. How about other options? Let's find out!

### Exercise

Experiment again! Using the template code we provided, choose the type of foreign key you want by deleting the double hyphen (`--`) from the line of the option you want to try. You can use the update/delete we provided in the Hint or make up your own.

```sql
CREATE TABLE project (
  id integer PRIMARY KEY,
  name varchar(1000) NOT NULL,
  description varchar(255) NOT NULL,
  manager_id integer NOT NULL,
  --FOREIGN KEY (manager_id) REFERENCES employee (id) ON DELETE SET NULL ON UPDATE SET NULL,
  --FOREIGN KEY (manager_id) REFERENCES employee (id) ON DELETE SET DEFAULT ON UPDATE SET DEFAULT,
  --FOREIGN KEY (manager_id) REFERENCES employee (id) ON DELETE NO ACTION ON UPDATE NO ACTION
);

INSERT INTO project VALUES (1, 'LKJ', 'To be added', 1);
INSERT INTO project VALUES (2, 'XX', 'To be added', 3);

SELECT
  *
FROM project;
```

Example update:

```sql
UPDATE employee
SET id = 15
WHERE id = 1;
```

Example delete:

```sql
DELETE FROM employee
WHERE id = 1;
```

# Summary

Perfect! Time to wrap things up. First, a quick review:

1. To define a primary key when creating a table:

```sql
CREATE TABLE swimming_pool (
  id integer PRIMARY KEY,
  address text
);
```

2. To add a primary key to an existing table:

```sql
ALTER TABLE swimming_pool
ADD [CONSTRAINT swimming_pool_pk] PRIMARY KEY (id);
```

3. To delete a primary key:

```sql
ALTER TABLE swimming_pool
DROP CONSTRAINT swimming_pool_pkey;
```

4. To add a foreign key when creating a table:

```sql
CREATE TABLE player (
  id integer PRIMARY KEY,
  first_name varchar(32),
  last_name varchar(32),
  coach_id integer,
  FOREIGN KEY (coach_id) REFERENCES coach (id)
);
```

5. To add a foreign key to an existing table:

```sql
ALTER TABLE player
ADD [CONSTRAINT player_fk] FOREIGN KEY (coach_id) REFERENCES coach (id);
```

6. To delete a foreign key:

```sql
ALTER TABLE player
DROP CONSTRAINT player_coach_id_fkey;
```

We can specify the exact behavior of foreign keys when data changes in the referenced table. The possible options are `CASCADE`, `NO ACTION`, `SET NULL`, `SET DEFAULT` and `RESTRICT` (**default option**).

How about a short quiz now?

## Exercise 1

A publishing house created a table named `textbook` in the following way:

```sql
CREATE TABLE textbook (
  id integer PRIMARY KEY,
  title varchar(128),
  subject varchar(64)
);
```

**Get rid of the primary key**.

```sql
ALTER TABLE textbook
DROP CONSTRAINT textbook_pkey;
```

## Exercise 2

The publishing house now needs a review system for their textbooks. Create a table named `review` with the following columns:

1. `id` – An integer and the primary key.
2. `textbook_id` – An integer and a foreign key referencing the `id` column in the `textbook` table.
3. `content` – A text value of any length.

The foreign key should be constructed so that whenever a corresponding row in the `textbook` table is updated or deleted, the changes are reflected in the `review` table.

```sql
CREATE TABLE review (
  id integer PRIMARY KEY,
  textbook_id integer NOT NULL,
  content text,
  FOREIGN KEY (textbook_id) REFERENCES textbook (id) ON DELETE CASCADE ON UPDATE CASCADE
);
```

## Congratulations

You've made it to the end of Part 1. Congratulations!

In the next part, we'll talk about a new constraint type, `UNIQUE`. See you there!
