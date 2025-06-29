# Final Quiz

Check the knowledge of SQL functions in the quiz.

## Introduction 

And... finally! You've made it to the last part of our course. It's time for our ultimate quiz! Do you remember string functions? Numerical functions? Dates? Aggregates? It's time to check up on all of that! We've prepared nine questions for you!

As always, we'll start with the introduction of our tables. Today, we'll work with **Mensa**, the oldest IQ society in the world! Of course, don't take it too seriously – these data are purely fictional.

## Table branch

Select all the information from the table `branch`.

```sql
SELECT *
FROM branch;
```

Nothing extraordinary: `id`, `country` and `city` of the branch.

## Table person

Select all the information from the table `person`.

```sql
SELECT *
FROM person;
```

Each person has an `id`, `first_name`, `middle_name`, `last_name` and `registration_date`.

Then, there is the `iq`.

Finally, you have the `branch_id` the person belongs to (only one is possible), precise `weight` in kilograms and the `height` in centimeters.

### Exercise 1

Show the *first*, middle and last name of each person together, as one column, in the following way:

```
Firstname Middlename LASTNAME
```

Firstname is the first name and Middlename is the middle name - first letter in uppercase, rest in lowercase. LASTNAME is the last name in uppercase. Name the column `full_name`

Show this information only for those people whose `last_name` is at least 7 characters long. Make sure to handle properly the people who have no middle name. Show an empty string instead of a `NULL` middle name.

```sql
SELECT
    CONCAT(
        first_name,
        ' ',
        SUBSTRING(middle_name, 1, 1),
        LOWER(SUBSTRING(middle_name, 2)),
        ' ',
        UPPER(last_name)
    ) AS full_name
FROM person
WHERE LENGTH(last_name) >= 7;
```

### Exercise 2

Mensa created a dating website for its members. We need to anonymize the user data before they go on their first date.

For each person, show the following sentence:

```
XYZ lives in A and weighs B kilograms.
```

**XYZ** are the initials, *A* is the `city` and *B* is the `weight` rounded to integer numbers. If a given person doesn't have a middle name, replace it with nothing (`''`). Name the column `sentence`.

Don't forget about the period at the end of the sentence!

```sql
SELECT
    CONCAT(
        SUBSTRING(first_name, 1, 1),
        SUBSTRING(middle_name, 1, 1),
        SUBSTRING(last_name, 1, 1),
        ' lives in ',
        city,
        ' and weighs ',
        ROUND(weight),
        ' kilograms.'
    ) AS sentence
FROM person
JOIN branch ON branch_id = branch.id;  
```

### Exercise 3

For each person, show the first and last name along with the precise weight, weight rounded down to the next integer (name the column `weight_down`) and weight rounded up to the next integer (name the column `weight_up`).

```sql
SELECT
    first_name,
    last_name,
    weight,
    FLOOR(weight) AS weight_down,
    CEIL(weight) AS weight_up
FROM person;
```

### Exercise 4

For each branch, show its `id`, `country`, `city` and the **average iq** of members of this branch, rounded to 2 decimal places (name the column `average_iq`). Treat `NULL` values as **152**.

```sql
SELECT
    b.id,
    b.country,
    b.city,
    ROUND(AVG(COALESCE(iq, 152)), 2) AS average_iq
FROM branch b
JOIN person p ON p.branch_id = b.id
GROUP BY b.id, b.country, b.city;
```

### Exercise 5

For each person who registered earlier than 3 months ago, show their `first_name`, `last_name` and the **interval** showing how long they've been a member (subtract the `registration_date` from `current_date`). Name the last column `days`.

```sql
SELECT
    first_name,
    last_name,
    CURRENT_DATE - registration_date AS days
FROM person
WHERE registration_date < CURRENT_DATE - INTERVAL '3' MONTH;
```

### Exercise 6

Count the number of people who registered in each month of 2015. Name the columns `month` and `people_no`. The month should be expressed as a number, e.g. 3 (you don't need to cast it to some other type). Don't show months where no registrations took place.

```sql
SELECT
    EXTRACT(MONTH FROM registration_date) AS month,
    COUNT(*) AS people_no
FROM person
WHERE EXTRACT(YEAR FROM registration_date) = 2015
GROUP BY month
ORDER BY month;
```

### Exercise 7

For each person, show the first and last name along with a third column named iq_rating. When the iq is below 149, show 'high', when it's between 149 and 152, show 'very high', when it is above 152, show 'highest', and when it's NULL, show 'missing'.

```sql
SELECT
    first_name,
    last_name,
    CASE
        WHEN iq < 149 THEN 'high'
        WHEN iq BETWEEN 149 AND 152 THEN 'very high'
        WHEN iq > 152 THEN 'highest'
        ELSE 'missing'
    END AS iq_rating
FROM person;
```

### Exercise 8

For each branch, show the id, country, city and count the number of people with the highest IQ (156) in these branches (name the column num_of_highest). 

```sql
SELECT
    b.id,
    b.country,
    b.city,
    SUM(CASE WHEN p.iq = 156 THEN 1 ELSE 0 END) AS num_of_highest
FROM branch b
JOIN person p ON p.branch_id = b.id
GROUP BY b.id, b.country, b.city;
```

### Exercise 9

For each branch, show its `id`, `country`, `city` and three more columns:

- `count_high` (iq below 149),
- `count_very_high` (iq 149-152),
- `count_highest` (iq above 152),

each of them showing the number of people with the respective `iq` in specific branches.

```sql
SELECT
    b.id,
    b.country,
    b.city,
    SUM(CASE WHEN p.iq < 149 THEN 1 ELSE 0 END) AS count_high,
    SUM(CASE WHEN p.iq BETWEEN 149 AND 152 THEN 1 ELSE 0 END) AS count_very_high,
    SUM(CASE WHEN p.iq > 152 THEN 1 ELSE 0 END) AS count_highest
FROM branch b
JOIN person p ON p.branch_id = b.id
GROUP BY b.id, b.country, b.city;
```

## Congratulations

That was yet another correct answer. Do you know what that means?

You've completed the ENTIRE course! Congratulations, you've officially become the master of SQL functions.

We hope you enjoyed your time with us! Check out our other courses to learn more about SQL. We especially recommend the Recursive Queries course, where you can learn how to write very useful common table expressions (CTEs), and the Window Functions course, where you can learn how to compute running totals and averages, build rankings, investigate trends over time, and much more.


