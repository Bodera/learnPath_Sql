# Aggregate Functions

Deepen your understanding of SQL aggregate functions: COUNT, AVG and SUM. Practice which variant of COUNT or AVG to choose in typical use cases.

Hello and welcome to Part 6 of our course. In this part, we're going to deal with **aggregate functions**. `COUNT`, `AVG`, `MIN`, `MAX` ... You know these already, but you'll now have a chance to learn some new information.

Let's not waste any time. Today, we have managed to obtain some data from a translation agency. Let's find out what we're going to deal with.

## Table client

Select all the information from the first table: `client`.

```sql
SELECT *
FROM client;
```

Each **client** (company) has an `id` and a `name`. Not really complicated, right? Let's move on when you're done.

## Table translator

Select all the information from the second table: `translator`.

```sql
SELECT *
FROM translator;
```

As you can see, the table presents some of the translators that the agency contracts with. Each translator has: an `id`, a **first** and **last name**, and a `start_date`, which is the date on which the agreement was signed and the contract was officially started.

## Table project

The last table is a bit more complicated. It has many rows and many columns.

Select all the information from the last table: `project`. Note that you won't see all the rows present in the table – our platform displays only a limited number of rows for readability.

```sql
SELECT *
FROM project;
```

You can find the `project_id`, `client_id` and `translator_id`, of course. These columns should be clear. Then, you can also see:

- the `start` – that is, when the client commissioned the project.
- the `deadline` – when the project is due.

Afterward, we can see the `price` the client paid, the number of `words` for translation and two languages:

- the source language (`lang_from`),
- the target language (`lang_to`).

The final column (`feedback`) provides the client's feedback. Positive numbers mean that the client was very satisfied, negative ones mean that the client complained to some extent about the quality.

## Count all rows

Nice. Now that you know the tables, let's get down to work.

We'll start off with a function you already know: `COUNT(*)`, which is used to count all the rows in the result set. Just like this:

```sql
SELECT COUNT(*)
FROM translator
WHERE start_date >= '2016-01-01';
```

The above query will provide the number of translators who started contracting with the translation agency on **January 1, 2016 or later**.

### Exercise

Now's your turn. **Count** the number of all the projects for the client with `id 1`. Name the column `projects_no`.

```sql
SELECT COUNT(*) AS projects_no
FROM project
WHERE client_id = 1;
```

## COUNT with column

That's it! You may also remember that we can use `COUNT` with a column name:

```sql
SELECT COUNT(name)
FROM client;
```

What's the **difference** between `COUNT(*)` and `COUNT(name)` in this case? `COUNT(*)` will count all the rows in the table, but `COUNT(name)` will **skip** those rows where `name` is `NULL`.

### Exercise 1

Let's see how this works in practice.

Count all the rows in the table `project` (name the column `all_projects`), then count those rows where `price` is not `NULL` (name the column `projects_with_price`).

```sql
SELECT COUNT(*) AS all_projects, COUNT(price) AS projects_with_price
FROM project;
```

### Exercise 2

The agency manager gets a bonus of **5** for each project which got some `feedback`.

Show the theoretical sum the project manager could get if **all** the projects got some `feedback` (`theoretical_bonus`) and the **actual bonus** (`actual_bonus`).

```sql
SELECT 
    COUNT(*) * 5 AS theoretical_bonus,
    COUNT(feedback) * 5 AS actual_bonus
FROM project;
```

## COUNT with expression

Good job! It is less commonly known that you can use `COUNT` functions with any expression as an argument.

You can write:

```SQL
SELECT COUNT(price * 2)
FROM project
```

This query counts the doubled prices. (Yes, the result will be the same as counting single prices.) We will see a real-world usage of this construction later in this section and in the next part of the course.

### Exercise

The feedback of **0** doesn't mean anything to agency managers. They want to find out how many projects got meaningful (**non-zero**) `feedback`.

Count the number of project with non-zero feedback. Name the column `projects_no`.

```sql
SELECT COUNT(feedback) AS projects_no
FROM project
WHERE feedback != 0;
```

## COUNT DISTINCT

Correct again. When we write `COUNT(project_id)`, we actually mean `COUNT(ALL project_id)`, including all **non-NULL** values. If a value is duplicated, then each duplicate is counted separately.

We can also use the keyword `DISTINCT` to remove duplicates.

```sql
SELECT COUNT(DISTINCT client_id)
FROM project;
```

The above query will count the number of clients that have commissioned at least one project from the table `project`.

Note that we had to include the keyword `DISTINCT` – if we hadn't, we would've got the number of all projects where `client_id` was not `NULL`.

### Exercise

Count the number of translators that did translate at least **one project**. Name the column `translator_no`.

```sql
SELECT COUNT(DISTINCT translator_id) AS translator_no
FROM project;
```

## COUNT DISTINCT with expression

Well done. You can also use `COUNT(DISTINCT ...)` with an expression. Let's try it out right now.

### Exercise

Count how many distinct rates per word our translation agency uses. To obtain the rate for one word, divide the `price` by number of `words`. Name the column `rates`.

Make sure not to use integer division.

```sql
SELECT COUNT(DISTINCT price / words::decimal) AS rates
FROM project;
```

## COUNT and GROUP BY

It worked, didn't it? Good job.

Usually, `COUNT` is used together with `GROUP BY`. Do you remember how `GROUP BY` works? It groups together all the rows which share a common value in the column which we specified. We apply `GROUP BY` to obtain some statistics for entire groups of rows, like the number of items in these groups:

```sql
SELECT
  translator_id,
  COUNT(project_id)
FROM project
GROUP BY translator_id;
```

The above query will group the projects carried out by specific translators and will provide the number of projects completed by each translator.

### Exercise

Show clients IDs (`client_id`) together with the number of projects they have commissioned. Name the second column `projects_no`. Don't show clients without any project.

```sql
SELECT client_id, COUNT(project_id) AS projects_no
FROM project
GROUP BY client_id
HAVING COUNT(project_id) > 0;
```

## COUNT and GROUP BY – additional practice

Good! Of course, you can use `COUNT(*)`, `COUNT(column)`, or `COUNT(expression)` with `GROUP BY`.

### Exercise

For each project, show the `client_id` and the **number of** projects commissioned by that specific client which have some feedback (zero if there are no such projects). Name the second column `projects_no`.

```sql
SELECT client_id, COUNT(feedback) AS projects_no
FROM project
GROUP BY client_id;
```

## COUNT DISTINCT and GROUP BY

That's right! The keyword `DISTINCT` can, of course, be used in queries that apply `GROUP BY`. Take a look:

```sql
SELECT
  client_id,
  COUNT(DISTINCT translator_id)
FROM project
GROUP BY client_id;
```

The above query will show each client together with the number of translators who have ever worked on at least one project for that client.

### Exercise

Let's check the statistics the other way round. For each translator in table `project`, show their **ID** (as `translator_id`) and the **number of clients** they have worked for. Name the second column `clients_no`.

```sql
SELECT
  translator_id,
  COUNT(DISTINCT client_id) AS clients_no
FROM project
GROUP BY translator_id;
```

## COUNT DISTINCT with expression and GROUP BY

As you may already suspect, `COUNT(DISTINCT expression)` can be also used together with `GROUP BY`. Try it out in the exercise below.

### Exercise

The rate per word is the `price` divided by the number of words. For every translator, show **ID** together with **number of distinct rates per word** they used in their projects. Name the second column `rates_no`.

```sql
SELECT
  translator_id,
  COUNT(DISTINCT price / words::decimal) AS rates_no
FROM project
GROUP BY translator_id;
```

## Common mistake: COUNT(*) and LEFT JOIN

Thank you! Now we'll show you a common mistake: it's most often wrong to use `LEFT JOIN` with `COUNT(*)`.

Let's analyze the following problem: we want to show each client's `name` together with the **number** of projects they have commissioned. You may be tempted to write the following:

```sql
SELECT
  name,
  COUNT(*)
FROM client
LEFT JOIN project
  ON client.client_id = project.client_id
GROUP BY name;
```

... but this query can produce incorrect results! If a client has no projects, `COUNT(*)` will give the result of **1** (because the row with the client name itself is one row indeed) instead of **0**. In such queries, you need to use count with a **column name**:

```sql
SELECT
  name,
  COUNT(project_id)
FROM client
LEFT JOIN project
  ON client.client_id = project.client_id
GROUP BY name;
```

Now, the query will return **0** if there are no projects commissioned by a given client.

### Exercise

Show the `first` and `last name` of each translator together with the **number** of projects they have completed (**0** if there are no such projects). Name the last column `projects_no`.

```sql
SELECT
  first_name,
  last_name,
  COUNT(project_id) AS projects_no
FROM translator
LEFT JOIN project
  ON translator.translator_id = project.translator_id
GROUP BY first_name, last_name;
```

## COUNT – additional exercise 1

Perfect. Now that you know more about `COUNT`, let's do some practice.

### Exercise

For each client, show their `name`, the **number of projects** they have commissioned and the **number of translators** that have worked for that client. Do not count projects with a deadline within the **last 3 months**. The column names should be: `name`, `projects_no`, and `translators_no`.

```sql
SELECT
  name,
  COUNT(project_id) AS projects_no,
  COUNT(DISTINCT translator_id) AS translators_no
FROM client
LEFT JOIN project
  ON client.client_id = project.client_id
WHERE deadline < NOW() - INTERVAL '3 months'
GROUP BY name;
```

## COUNT – additional exercise 2

Okay. One more `COUNT` exercise, this time with some date functions.

### Exercise

For each language combination (e.g. `EN` to `ES`, `ES` to `EN`, `DE` to `PL` etc.) show `lang_from`, `lang_to` and two more columns:

1. the **number** of projects completed in this combination (as `projects_no`).
2. the **number** of translators that have completed at least one project in that language combination (as `translators_no`).

All completed projects are present in the `project` table.

```sql
SELECT
  lang_from,
  lang_to,
  COUNT(project_id) AS projects_no,
  COUNT(DISTINCT translator_id) AS translators_no
FROM project
GROUP BY lang_from, lang_to;
```

## Function AVG

Ok, time to move on. Another function we're going to take a closer look at is `AVG`, which computes the average value. Let's start with `AVG(column)`:

```sql
SELECT AVG(price)
FROM project;
```

The above query will find the average price for all projects.

### Exercise

Find the **average number of words** from all projects with Spanish (`ES`) as the target language. Name the column `average`.

```sql
SELECT AVG(words) AS average
FROM project
WHERE lang_to = 'ES';
```

## AVG and GROUP BY

Correct! Of course, we can use `AVG` with `GROUP BY`, just as we used `COUNT`:

```sql
SELECT
  client_id,
  AVG(price)
FROM project
GROUP BY client_id;
```

The above query will find the average price each customer paid for their projects.

### Exercise

Show each translator's **ID** together with the average number of words they had to translate in all their projects (as `average`). Exclude **project with ID 6** – it was cancelled.

```sql
SELECT
  translator_id,
  AVG(words) AS average
FROM project
WHERE project_id != 6
GROUP BY translator_id;
```

## AVG and NULLs

Excellent. An important thing you should know about `AVG` is that it **ignores** `NULL` values. Let's say you want to find `AVG(price)` and you have the following three price values:

- price = 100
- price = 300
- price = NULL

Some people could think that `NULL` is counted as **zero**, so the average of these three values would be `(100+300+0)/3`, which is `400/3`. That's **not true**.

`NULL`s are **not taken into account** at all, so you'll get `(100+300)/2 = 200` here.

### Exercise

Take a look at the three projects of **Adriana Fuentes**, translator with `ID 5`. Two of them have a `NULL` number of words.

Find the average number of words for all the projects of this translator. Name the column `average`. What do you think the average will be?

```sql
SELECT
  AVG(words) AS average
FROM project
WHERE translator_id = 5
GROUP BY translator_id;
```

## AVG and NULLs only

As you can see, `NULL` was not counted at all. Okay then, if `NULL` values are ignored when calculating the average, what would happen when **ALL** of the values were `NULL`s? Let's find out.

### Exercise

Let's calculate the **average number of words** in all the projects done by translator with `id = 5` again.

This time, though, exclude `project_id = 13` from the rows so that the only two projects left are the ones with a `NULL` value. Name column `average`.

```sql
SELECT
  AVG(words) AS average
FROM project
WHERE translator_id = 5 AND project_id != 13
GROUP BY translator_id;
```

## AVG with COALESCE

Good. Remember: if all arguments are `NULL`, you will get `NULL` as the average. Makes sense.

Of course, you can count `NULL`s as zero, too. Here is how. Remember, the function `COALESCE(x,y)`? We can use it to replace **x** with **y** if **x** is `NULL`:

```sql
SELECT AVG(COALESCE(price,0))
FROM project;
```

The above query will find the average price for all projects. If a project has a `NULL` price, it will indeed be treated as a project with the price **0**.

### Exercise

Find the average **number of words** per project translated so far by Adriana Fuentes (`translator_id = 5`). Assume that `NULL` in column words means that nothing has been translated yet (treat it as `words = 0`). Name the result `average`.

```sql
SELECT
  AVG(COALESCE(words,0)) AS average
FROM project
WHERE translator_id = 5;
```

## COALESCE with AVG

Okay! That was `AVG(COALESCE(x,0))`. Now, you may wonder what happens when we swap the functions:

```sql
SELECT COALESCE(AVG(price),0)
FROM project;

-- 1500.0000000000000000
```

Will the result be the same? No, it won't.

This query will compute the average for all the projects ignoring `NULL` values. In case all the values are `NULL` and so the average is `NULL` also, the `COALESCE` function will replace the `NULL` average with a zero.

### Exercise

Let's check that in practice. Change the query from the previous exercise. Swap the functions `AVG()` and `COALESCE()`. Note that the result is different now.

```sql
SELECT
  COALESCE(AVG(words), 0) AS average
FROM project
WHERE translator_id = 5;

-- 4500.0000000000000000
```

## AVG and DISTINCT

Yes, that's right. There is also another thing which many people don't know about: you can actually use `AVG` with `DISTINCT` to only calculate the average from distinct values:

```sql
SELECT AVG(DISTINCT price)
FROM project;
```

Does that really have any practical application? Well, it might. Take a look at the exercise.

### Exercise

For client with `ID 10`, find the average price (as `avg_price`) and average distinct price (as `avg_distinct_price`).

```sql
SELECT
  AVG(price) AS avg_price,
  AVG(DISTINCT price) AS avg_distinct_price
FROM project
WHERE client_id = 10;
```

## ROUND and AVG

Okay. Finally, we can use `ROUND` with `AVG` to get a nicer appearance for our results:

```sql
SELECT
  ROUND(AVG(price), 2)
FROM project;
```

The above query will round the average price to two decimal places. Of course, you can also use `AVG` without the second argument: `ROUND(AVG(price))` to get rounding to integer values.

### Exercise

For each client in the `project` table, show the **client ID** and find the **average price** for all their projects **rounded to integer values**. Column names should be `client_id` and `rounded_average`.

```sql
SELECT
  client_id,
  ROUND(AVG(price)) AS rounded_average
FROM project
GROUP BY client_id;
```

## AVG – additional exercise

Good job! Let's do one more AVG exercise.

### Exercise

For each translator, show their first and last name together with the average price of all the projects they have completed (as `rounded_average`). **Round** the price to two decimal places. Count only the projects with the number of words **greater than 500**. Exclude translators who have completed **fewer than 2** projects (all completed projects are present in the `project` table).

```sql
SELECT
  first_name,
  last_name,
  ROUND(AVG(price), 2) AS rounded_average
FROM translator
LEFT JOIN project
  ON translator.translator_id = project.translator_id
WHERE words > 500
GROUP BY first_name, last_name
HAVING COUNT(project_id) > 2;
```

## Function SUM

Amazing. Another function we'll take a look at is `SUM`. As you know, `SUM` finds the sum from all the values. `NULL` values are ignored: they are not added to the sum.

```sql
SELECT SUM(price)
FROM project;
```

The above query will find the total revenue of the translation agency.

### Exercise

Find the total number of words translated in all the projects. Name the column `sum`.

```sql
SELECT SUM(words) AS sum
FROM project;
```

## SUM with NULLs only

Good! Just like with `AVG`, `SUM` will return a `NULL` when all the values are `NULL`. Let's check it out.

### Exercise

Remember the translator with `translator_id = 5` **Adriana Fuentes**? Let's go back there again. Sum all the words from all her projects except for `project_id = 13` so that you only sum `NULL`s. Name the column `sum`.

```sql
SELECT SUM(words) AS sum
FROM project
WHERE translator_id = 5 AND project_id != 13;

-- NULL
```

## SUM and COALESCE

Fine. Again, if we don't like to get `NULL` as a result, we can use `COALESCE` to replace it with any value of our choice:

```sql
SELECT COALESCE(SUM(price), 0)
FROM project;
```

If all prices happen to be `NULL`s, the above query will return **0** and not a `NULL`. Note that this time you can also write:

```sql
SELECT SUM(COALESCE(price, 0))
FROM project;
```

and the result will stay the same.

### Exercise

Show translator **ids** with the sum of the **prices** of all the projects they have completed (as `sum`). Exclude `project_id = 13` so that one of the translators has `NULL` prices only. Instead of that `NULL` sum, show **0**.

```sql
SELECT
  translator_id,
  SUM(COALESCE(price, 0)) AS sum
FROM project
WHERE project_id != 13
GROUP BY translator_id;
```

## SUM and DISTINCT
Perfect. Again, you can also sum distinct values only:

```sql
SELECT
  SUM(DISTINCT price)
FROM project;
```

### Exercise

For client with `id = 10`, find the sum of the number of words in their projects, and the sum of the distinct number of words in their project. Name the columns `sum` and `distinct_sum`. Note that the results differ.

```sql
SELECT
  SUM(words) AS sum,
  SUM(DISTINCT words) AS distinct_sum
FROM project
WHERE client_id = 10;
```

## MAX and MIN

Great. Okay, one final piece of information: you can also use `DISTINCT` with `MIN` or `MAX` to find the minimum or maximum value, respectively.

```sql
SELECT MAX(DISTINCT price)
FROM project;
```

What is the difference between `MAX(price)` and `MAX(DISTINCT price)`? Well, we hate to disappoint you, but there is none. :)

It's just an interesting fact about SQL that you can use `DISTINCT` with `MIN` or `MAX` but it won't change anything.

### Exercise

Check it out for yourself. Show four columns:

- the maximum number of words in a project (as `max`),
- the maximum distinct number of words (as `max_distinct`),
- the minimum number of words (as `min`),
- and the minimum distinct number of words (as `min_distinct`).

```sql
SELECT
  MAX(words) AS max,
  MAX(DISTINCT words) AS max_distinct,
  MIN(words) AS min,
  MIN(DISTINCT words) AS min_distinct
FROM project;
```

Output:

| max | max_distinct | min | min_distinct |
| --- | ----------- | --- | ----------- |
135000 | 135000 | 250 | 250 |

## SUM, MAX and MIN – exercise

Okay. Let's do one more exercise and practice `SUM`, `MAX` and `MIN` together.

### Exercise

For each translator, show their first and last name, followed by:

- the sum of the prices for all the projects they have completed (as `sum`).
- the maximum price (as `max`).
- the minimum price (as `min`).

Make sure that all translators are shown, and if any of these values turns out to be `NULL`, show **0** instead.

```sql
SELECT
  first_name,
  last_name,
  COALESCE(SUM(price), 0) AS sum,
  COALESCE(MAX(price), 0) AS max,
  COALESCE(MIN(price), 0) AS min
FROM translator
LEFT JOIN project
  ON project.translator_id = translator.translator_id
GROUP BY first_name, last_name;
```

## Summary

OK, it's time to review what we've learned in this part.

- `COUNT(*)` counts the number of all rows.
- `COUNT(column1)` counts the number of rows where `column1` is not `NULL`.
- `COUNT` can be used to count non-`NULL` expressions.
- Avoid `COUNT(*)` with `LEFT JOIN`s.
- `DISTINCT` only takes into account distinct values.
- `AVG`, `SUM`, MA`X and `MIN` ignore `NULL`s, but `COUNT` takes them into account when counting the number of rows.
- You can use `COALESCE(x,y)` to replace **x** with **y** when **x** is `NULL`. For example, you can replace `NULL`s with **0**.
- You can use `AVG`, `SUM`, `MIN` or `MAX` with `DISTINCT`.
- You can use `ROUND` to round the score obtained with `AVG`.

## Quiz 

All right! Are you ready for some practice?

### Exercise 1

Count the number of all projects, the number of clients that have commissioned at least one project (that is, count them once even if they commissioned more than one project) and the average price for all the projects. Name the columns: `projects_no`, `clients_no`, and `average_price`.

```sql
SELECT
  COUNT(project_id) AS projects_no,
  COUNT(DISTINCT client_id) AS clients_no,
  AVG(price) AS average_price
FROM project;
```

### Exercise 2

For each translator, show:

- their first and last name.
- the number of projects they have completed (as `projects_no`).
- the highest number of words among their projects (as `max_words`).
- the average price among their projects rounded to integer values (as `rounded_avg_price`).

```sql
SELECT
  first_name,
  last_name,
  COUNT(project_id) AS projects_no,
  MAX(words) AS max_words,
  ROUND(AVG(price), 0) AS rounded_avg_price
FROM translator
LEFT JOIN project
  ON translator.translator_id = project.translator_id
GROUP BY first_name, last_name;
```

### Exercise 3

For each language combination in table project (e.g. `EN` to `ES`, `ES` to `EN`, `DE` to `PL` etc.) show `lang_from`, `lang_to` and the average price in this combination (as `avg_price`). When calculating the average, treat `NULL` values as **0**.

```sql
SELECT
  lang_from,
  lang_to,
  AVG(COALESCE(price, 0)) AS avg_price
FROM project
GROUP BY lang_from, lang_to;
```

### Exercise 4

Show each client's `name` together with the number of projects they have completed (name this column `projects_no`). Show only those clients who have commissioned more than 1 project.

```sql
SELECT
  name,
  COUNT(project_id) AS projects_no
FROM client
LEFT JOIN project
  ON client.client_id = project.client_id
GROUP BY name
HAVING COUNT(project_id) > 1;
```

## Congratulations

As usual, you showed amazing skills. Congratulations, that's it!
