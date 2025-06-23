# Introduction
And... finally! This is the last part of this course. Let's check our knowledge of SQL `INSERT`, `UPDATE`, and `DELETE` queries.

First, we'll familiarize ourselves with the database. This one is for a zoo and stores data about animals, zoo employees, and people who 'adopt' animals to help the zoo financially.

## The animal table

Let's analyze the first table, animal, which contains data about the animals in the zoo.

### Exercise

Select all the information from the `animal` table. Each animal has the following info:

- `id` – a number that identifies each animal in the database.
- `species` – the species of the animal.
- `name` – the name of that animal.
- `city` – the city where that animal came from.
- `age` – the age of the animal.
- `arrived_date` – when that animal arrived at the zoo. The default value for this column is current date.
- `picture` – a link to the photo of the animal; if there is no photo, this field will store the string `'img/no-photo.jpg'`.

```sql
SELECT * FROM animal;
```

| id | species | name | city | age | arrived_date | picture |
| --- | --- | --- | --- | --- | --- | --- |
| 1  | lion   | Simba | Boston | 10 | 2017-01-20 | img/lion.jpg |
| 2  | parrot | Lucky | Boston | 4  | 2015-11-22 | img/parrot1.jpg |
| 3  | frog   | Sammy | Liverpool | 1 | 2018-10-02 | img/frog.jpg |
| 4  | lizard | Oreo  | Chicago | 2  | 2018-05-02 | img/lizard3.jpg |
| 5  | newt   | Princess | Liverpool | 2 | 2018-02-02 | img/newt5.jpg |

## The adoptive_person table

Now we have the last table, `adoptive_person`. It stores information about people who pay for the care of certain animals at the zoo.

### Exercise

Select all the information from the adoptive_person table. You'll find the following columns:

- `id` – uniquely identifies each adoptive person in the database.
- `first_name` – the first name of the adoptive person.
- `last_name` – the last name of the adoptive person.
- `city` – the city where this person lives.
- `animal_id` – refers to the `animal` table and shows which animal this person has donated money for.

```sql
SELECT * FROM adoptive_person;
```

| id | first_name | last_name | city | animal_id |
| --- | --- | --- | --- | --- |
| 1  | John      | Franklin | Cleveland | 2 |
| 2  | Lisa      | Allans   | Dallas    | 8 |
| 3  | Thomas    | Gary     | Annandale | 1 |
| 4  | Rayan     | Muller   | London    | 3 |
| 5  | Jonatan   | Adams    | Austin    | 3 |
| 6  | Kate      | Williams | Boston    | 8 |
| 7  | Alex      | Gary     | Detrit    | 1 |
| 8  | Marian    | Ferguson | London    | 2 |

## Exercise 1

Now that we know the data, let's get started!

Data about all the zoo's animals is stored in the animal table. Recall that this table contains these columns:

- id
- name
- species
- city
- age
- arrived_date
- picture (default value of `'img/no-photo.jpg'`)

### Exercise

Insert data into the animal table for two new mammals:

| id | species | name | age | arrived_date |
| --- | --- | --- | --- | --- |
| 6  | bear   | Max  | 2   | today |
| 7  | tiger  | Smokey | 1 | today |

At this time, we don't know any more about these animals.

```sql
INSERT INTO animal (id, species, name, age, arrived_date)
VALUES (6, 'bear', 'Max', 2, current_date),
(7, 'tiger', 'Smokey', 1, current_date);
```

## Exercise 2

Excellent! Let's move on.

### Exercise

Delete data for the adoptive person **John Franklin**.

Recall that the name of the relevant table is `adoptive_person`.

```sql
DELETE FROM adoptive_person
WHERE first_name = 'John' AND last_name = 'Franklin';
```

## Exercise 3

Cool! Just a few more!

### Exercise

A visitor discovered a mistake in the zoo database. The picture for the **frog** actually shows an elephant. Update the frog's picture (using the `picture` column) by setting it to the default value for this column.

```sql
UPDATE animal
SET picture = DEFAULT
WHERE species = 'frog';
```

## Exercise 4

Time for the next exercise!

### Exercise

Our zoo has decided to sell all animals who come from **Boston** and are **over five years old** to another zoo. Remove the data of the sold animals from our database.

```sql
DELETE FROM animal
WHERE city = 'Boston' AND age > 5;
```

## Exercise 5

Amazing! Here's the next challenge!

### Exercise

We recently sold a **frog** to another zoo. Its adoptive person(s) want to change their animal to the parrot with `animal_id = 2`. Update the records in the `adoptive_person` table to reflect this change.

```sql
UPDATE adoptive_person
SET animal_id = 2
WHERE animal_id = 3;
```

## Congratulations!

Congratulations! That was the last question in the whole course! We're sure the knowledge you acquired will help you write better SQL queries.

We hope you enjoyed your time with us. If you want to learn more, check out our other courses and follow [our blog](https://learnsql.com/blog/). We hope to see you again soon!
