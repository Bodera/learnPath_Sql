# Final Quiz

Time to test your knowledge!

Hello and welcome to the very last part of this course! Today, you won't learn anything new. Instead, you'll have a chance to verify your skills.

This final quiz contains 4 exercises. Each of them will give you a description and ask you to create a table with some constraints. If you get stuck at any point, use a hint to move on.

Fingers crossed!

### Exercise 1

Create a table called `person` based on the description below:

Each person has:

1. An `id` (expressed as an integer) which is the table's **primary key**.
2. An `ssn` (social security number) of precisely `11` characters; this number is unique for each person and should never be `NULL`.
3. A `first_name` (up to `255` characters) and a `last_name` (up to `255` characters) – both of these fields must have a defined value.
4. A `salary` that must always be greater than `0`. The salary can be up to `10` digits long, of which `2` digits are found behind the decimal point. If no salary is specified, then `5000.00` is inserted by default.

Some people also have a `middle_name` of up to `255` characters, but this **isn't mandatory**.

```sql
CREATE TABLE person (
    id INTEGER PRIMARY KEY,
    ssn CHAR(11) UNIQUE NOT NULL,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    middle_name VARCHAR(255),
    salary DECIMAL(10, 2) DEFAULT 5000.00 CHECK (salary > 0.00)
);
```

### Exercise 2

Create a table named `country` based on the `description` below:

Each country has:

1. A unique integer `id` column which is the **primary key**.
2. A unique `name` of up to `128` characters.
3. A column named `continent_code` that's exactly `2` characters long. Its default value should be `'NA'`, which stands for unknown.
4. A `population` column (expressed in millions) which is a decimal of up to `999.99`, with two digits after the decimal sign. Make sure its value is more than zero.

```sql
CREATE TABLE country (
    id INTEGER PRIMARY KEY,
    name VARCHAR(128) UNIQUE,
    continent_code CHAR(2) DEFAULT 'NA',
    population DECIMAL(5, 2) CHECK (population > 0.00)
);
```

### Exercise 3

Create a table based on the description below:

RPG players need a table called `character` to store some information about the fantasy characters they play. Each character has a unique `name` of up to `30` characters (which is essential and is the **primary key**) and some points given for the following abilities (as separate integer columns): `strength`, `dexterity`, and `intelligence`. Each **ability** can be given `0-10` points and the sum of all the points for all three abilities must be lower than `20`.

```sql
CREATE TABLE character (
    name VARCHAR(30) PRIMARY KEY,
    strength INTEGER CHECK (strength >= 0 AND strength <= 10),
    dexterity INTEGER CHECK (dexterity >= 0 AND dexterity <= 10),
    intelligence INTEGER CHECK (intelligence >= 0 AND intelligence <= 10),
    CHECK (strength + dexterity + intelligence < 20)
);
```

### Exercise 4

You are given a simple table named `invoice` with the following definition:

```sql
CREATE TABLE invoice (
  id integer PRIMARY KEY,
  customer_name varchar(32) NOT NULL,
  total_amount decimal(8, 2),
  item_count integer
);
```

The table needs a few changes:

1. Remove the `NOT NULL` constraint from the `customer_name` column.
2. Add a default value of `0.00` to the `total_amount` column.
3. Add a condition to the `item_count` column: it should be greater than `0`.

```sql
ALTER TABLE invoice
ALTER COLUMN customer_name DROP NOT NULL,
ALTER COLUMN total_amount SET DEFAULT 0.00,
ADD CHECK (item_count > 0);
```

## Congratulations

That's it! You've just finished the last exercise in the entire course. Congratulations!

In this course, you've learned about various constraint types:

- `PRIMARY KEY`s and `FOREIGN KEY`s
- `UNIQUE`
- `NOT NULL`
- `CHECK`
- `DEFAULT`

You are now able to define tables in a way that will help you maintain data integrity and correctness.

In the next course in the track, we'll talk about views – a concept we've not mentioned so far. See you there!
