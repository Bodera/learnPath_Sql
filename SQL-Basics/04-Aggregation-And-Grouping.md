# Aggregation and Grouping

You've already learned how to select data from single and multiple tables. You know how to filter rows and join columns from different tables. Now it's time to move on.

In this part, you'll learn how to compute statistics, group rows, and filter such groups. Such operations are extremely important for preparing reports and always come in handy in big tables.

The tables we'll use for exercises, here, we have **employees** with their **salaries** in specific years.

Naturally, one employee can work for more than one year, so there may be many rows for the same person, usually with different salaries each year.

The employees work in specific **departments** and have a certain **position**, which may change as the employee gets promoted.

# Table of contents

- [Sort the rows ORDER BY](#sort-the-rows-order-by)
- [ORDER BY with conditions](#order-by-with-conditions)
- [Ascending and descending orders](#ascending-and-descending-orders)
- [Sort by a few columns](#sort-by-a-few-columns)
- [Duplicate results](#duplicate-results)
- [Select distinctive values](#select-distinctive-values)
- [Select distinctive values in certain columns](#select-distinctive-values-in-certain-columns)
- [Count the rows](#count-the-rows)
- [Count the rows, ignore the NULLS](#count-the-rows-ignore-the-nulls)
- [Count distinctive values in a column](#count-distinctive-values-in-a-column)
- [Find the minimum and maximum value](#find-the-minimum-and-maximum-value)
- [Find the average value](#find-the-average-value)
- [Find the sum](#find-the-sum)
- [Group the rows and count them](#group-the-rows-and-count-them)
- [Find min and max values in groups](#find-min-and-max-values-in-groups)
- [Find the average value in groups](#find-the-average-value-in-groups)
- [Group by a few columns](#group-by-a-few-columns)
- [Filter groups](#filter-groups)
- [Filter groups continued](#filter-groups-continued)
- [Order groups](#order-groups)
- [Put your skills into practice](#put-your-skills-into-practice)

## Sort the rows ORDER BY

You're already pretty skilled when it comes to filtering rows – but have you wondered how they are sorted in the result of an SQL query? Well, the answer is simple – by default, they are not sorted at all. The sequence in which rows appear is arbitrary, and every database can behave differently. You can even perform the same SQL instruction a few times and get a different order each time – unless you ask the database to sort the rows, of course.

```sql
SELECT *
FROM orders
ORDER BY customer_id;
```

In the above example, we've added a new piece: `ORDER BY`. After this expression, you can simply specify a column on which the data will be sorted.

In this case, we give the column name `customer_id`, so all orders will be sorted in relation to customer_ids.

### Exercise

Try it yourself. Select all columns from the table `employees` and sort them according to the **salary**.

```sql
SELECT *
FROM employees
ORDER BY salary;
```

## ORDER BY with conditions

Excellent! Now you can easily examine who's got the lowest and the highest salary. It's not that hard, as you can see.

We can filter rows and sort them at the same time. Just have a look:

```sql
SELECT *
FROM orders
WHERE customer_id = 100
ORDER BY total_sum;
```

The `WHERE` clause and `ORDER BY` work well together.

In this case, we'll only see the orders made by the customer with id 100. The orders will be sorted on the total sum – the cheapest order will appear as the first result and the most expensive as the last one.

### Exercise

Select only the rows related to the year 2011 from the table `employees`. Sort them by salary.

```sql
SELECT *
FROM employees
WHERE year = 2011
ORDER BY salary;
```

## Ascending and descending orders

Good. As you can see, the lowest salary was shown first and the highest salary last. This **ascending** order of results is performed in SQL by default. If you want to be precise and make things clear, however, you can use the keyword `ASC` (short for the ascending order) after the column name:

```sql
SELECT *
FROM orders
ORDER BY total_sum ASC;
```

Adding the keyword `ASC` will change nothing, but it will show your intention in a very clear way.

We can also reverse the order and make the greatest values appear first.

```sql
SELECT *
FROM orders
ORDER BY total_sum DESC;
```

As you can see, we've added the word `DESC` after the column name, which is short for the **descending** order. As a result, the highest values in the column `total_sum` will be shown first.

### Exercise

Select all rows from the table `employees` and sort them in the **descending** order by the column `last_name`.

```sql
SELECT *
FROM employees
ORDER BY last_name DESC;
```

## Sort by a few columns

Good job. All right, one more thing before we move on: you can sort your results by **more than one column** and each of them can be sorted in a **different** order:

```sql
SELECT *
FROM order
ORDER BY customer_id ASC, total_sum DESC;
```

As you can see, the results will first be sorted by `customer_id` in the ascending order (the lowest values first) and then, for each customer_id, the orders will be sorted by the `total_sum` in the descending order (the greatest values first).

### Exercise

Select all rows from the table `employees` and sort them in the **ascending** order by the **department** and then in the **descending** order by the **salary**.

```sql
SELECT *
FROM employees
ORDER BY department ASC, salary DESC;
```

## Duplicate results

Very good! We'll now focus on another aspect. By default, the database returns **every** row which matches the given criteria. This is what we normally expect, of course, but there are cases when we might want to change this behavior.

Imagine the following situation: we want to get the ids of all customers who have ever placed an order. We might use the following code:

```sql
SELECT customer_id
FROM orders;
```

What's wrong with the code in this case? Well, try to do the exercise to find out.

### Exercise

Select the column `year` for all rows in the table `employees`. Then examine the result carefully.

```sql
SELECT year
FROM employees;
```

## Select distinctive values

Could you see the problem? There were many rows with the same year, so each year is shown many times in the results.

In our orders example, if there were many orders placed by the same customer, each customer id would be shown many times in the results. **Not good**.

Fortunately, we can easily change this.

```sql
SELECT DISTINCT customer_id
FROM orders;
```

Before the column name, we've added the word `DISTINCT`. Now the database will **remove duplicates** and only show distinct values. Each `customer_id` will appear only once.

### Exercise

Select the column `year` from the table `employees` in such a way that each year is only shown once.

```sql
SELECT DISTINCT year
FROM employees;
```

## Select distinctive values in certain columns

Excellent. You can also use `DISTINCT` on a group of columns. Take a look:

```sql
SELECT DISTINCT
  customer_id,
  order_date
FROM orders;
```

One customer may place many orders every day, but if we just want to know on what days each customer actually did place at least one order, the above query will check that.

### Exercise

Check what positions there are in every department. In order to do that, select the columns `department` and `position` from the table `employees` and **eliminate duplicates**.

```sql
SELECT DISTINCT
  department,
  position
FROM employees;
```

## Count the rows

You already know that your database can do computation because we've already added or subtracted values in our SQL instructions. The database can do much more than that. It can **compute statistics** for multiple rows. This operation is called **aggregation**.

Let's start with something simple:

```sql
SELECT COUNT(*)
FROM orders;
```

Instead of the asterisk (`*`) which basically means 'all', we've put the expression `COUNT(*)`.

`COUNT(*)` is a function. A function in SQL always has a name followed by parentheses. In the parentheses, you can put information which the function needs to work. For example, `COUNT()` calculates the number of rows specified in the parentheses.

In this case, we've used `COUNT(*)` which basically means 'count all rows'. As a result, we'll just get the number of all rows in the table orders – and not their content.

### Exercise

Count all rows in the table `employees`.

```sql
SELECT COUNT(*)
FROM employees;
```

## Count the rows, ignore the NULLS

Naturally, the asterisk (`*`) isn't the only option available in the function `COUNT()`. For example, we may ask the database to count the values in a specific column:

```sql
SELECT COUNT(customer_id)
FROM orders;
```

What's the difference between `COUNT(*)` and `COUNT(customer_id)`? Well, the first option counts all rows in the table and the second option counts all rows where the column `customer_id` has a specified value. In other words, if there is a `NULL` in the column `customer_id`, that row won't be counted.

### Exercise

Check how many non-NULL values in the column `position` there are in the table `employees`. Name the column `non_null_no`.

```sql
SELECT COUNT(position) AS non_null_no
FROM employees;
```

## Count distinctive values in a column

Great. As you probably expect, we can also add the keyword `DISTINCT` in our function `COUNT()`:

```sql
SELECT COUNT(DISTINCT customer_id) AS distinct_customers
FROM orders;
```

This time, we count all rows which have a distinctive value in the column `customer_id`. In other words, this instruction tells us **how many customers** have placed an order so far. If a customer places 5 orders, the customer will only be counted once.

### Exercise

Count how many positions there are in the table `employees`. Name the column `distinct_positions`.

```sql
SELECT COUNT(DISTINCT position) AS distinct_positions
FROM employees;
```

## Find the minimum and maximum value

Good job. Of course, `COUNT()` is not the only function out there. Let's learn some others!

```sql
SELECT MIN(total_sum)
FROM orders;
```

The function `MIN(total_sum)` returns the **smallest value** of the column `total_sum`. In this way, we can find the cheapest order in our table. Convenient, huh?

You can also use a similar function, namely `MAX()`. That's right, it returns the **biggest** value of the specified column. Check it for yourself.

### Exercise

Select the **highest salary** from the table `employees`.

```sql
SELECT MAX(salary)
FROM employees;
```

## Find the average value

OK, now that you know what the highest salary is, let's discuss another function:

```sql
SELECT AVG(total_sum)
FROM orders
WHERE customer_id = 100;
```

The function `AVG()` finds the average value of the specified column.

In our example, we'll get the average order value for the customer with id 100.

### Exercise

Find the average salary in the table `employees` for the year 2013.

```sql
SELECT AVG(salary)
FROM employees
WHERE year = 2013;
```

## Find the sum

That's right. The last function that we'll discuss is `SUM()`.

Examine the example:

```sql
SELECT SUM(total_sum)
FROM orders
WHERE customer_id = 100;
```

The above instruction will find the total sum of all orders placed by the customer with id 100.

### Exercise

Find the sum of all salaries in the Marketing department in 2014. Remember to put the department name in inverted commas!

```sql
SELECT SUM(salary)
FROM employees
WHERE department = 'Marketing' AND year = 2014;
```

## Group the rows and count them

In the previous section, we've learned how to count statistics for all rows. We'll now go on to study even more sophisticated statistics. Look at the following statement:

```sql
SELECT
  customer_id,
  COUNT(*)
FROM orders
GROUP BY customer_id;
```

The new piece here is `GROUP BY` followed by a column name (`customer_id`). `GROUP BY` will **group** together all rows having the same value in the specified column.

In our example, all orders made by the same customer will be grouped together in one row. The function `COUNT(*)` will then count all rows for the specific clients. As a result, we'll get a table where each `customer_id` will be shown together with the number of orders placed by that customer.

Take a look at the following table which illustrates the query (expand the column or scroll the table horizontally if you need to):

| order_id | customer_id | order_date | ship_date  | total_sum |   | customer_id | COUNT(*)  |
|----------|-------------|------------|------------|-----------|---|-------------|-----------|
| 1        | 1           | 2014-02-21 | 2014-02-22 | 1009.00   |   | 1           | 3         |
| 2        | 1           | 2014-02-25 | 2014-02-25 | 2100.00   |   |             |           |
| 3        | 1           | 2014-03-03 | 2014-03-03 | 315.00    |   |             |           |
| 4        | 2           | 2014-03-03 | 2014-03-04 | 401.67    |   | 2           | 2         |
| 5        | 2           | 2014-03-03 | 2014-03-07 | 329.29    |   |             |           |
| 6        | 3           | 2014-03-15 | 2014-03-15 | 25349.68  |   | 3           | 1         |
| 7        | 4           | 2014-03-19 | 2014-03-20 | 2324.32   | → | 4           | 4         |
| 8        | 4           | 2014-04-02 | 2014-04-02 | 7542.21   |   |             |           |
| 9        | 4           | 2014-04-05 | 2014-04-07 | 123.23    |   |             |           |
| 10       | 4           | 2014-04-05 | 2014-04-07 | 425.33    |   |             |           |
| 11       | 5           | 2014-04-06 | 2014-04-09 | 2134.65   |   | 5           | 5         |
| 12       | 5           | 2014-04-17 | 2014-04-19 | 23.21     |   |             |           |
| 13       | 5           | 2014-04-25 | 2014-04-26 | 5423.23   |   |             |           |
| 14       | 5           | 2014-04-29 | 2014-04-30 | 4422.11   |   |             |           |
| 15       | 5           | 2014-04-30 | 2014-04-30 | 532.54    |   |             |           |

### Exercise

Find the number of employees in each department in the year 2013. Show the department name together with the number of employees. Name the second column `employees_no`.

```sql
SELECT department, COUNT(*) AS employees_no
FROM employees
WHERE year = 2013
GROUP BY department;
```

## Find min and max values in groups

Excellent! Of course, `COUNT(*)` isn't the only option. In fact, `GROUP BY` is used together with many other functions. Take a look:

```sql
SELECT
  customer_id,
  MAX(total_sum)
FROM orders
GROUP BY customer_id;
```

We've replaced `COUNT(*)` with `MAX(total_sum)`. Can you guess what happens now?

That's right, instead of counting all the orders for specific clients, we'll find the order with the **highest** value for each customer.

### Exercise

Show all departments together with their lowest and highest salary in 2014.

```sql
SELECT
  department,
  MIN(salary),
  MAX(salary)
FROM employees
WHERE year = 2014
GROUP BY department;
```

## Find the average value in groups

That's right!

Let's study one more example of this kind:

```sql
SELECT
  customer_id,
  AVG(total_sum)
FROM orders
WHERE order_date >= '2019-01-01'
  AND order_date < '2020-01-01'
GROUP BY customer_id;
```

As you can see, we now use the function `AVG(total_sum)` which will count the **average order value** for each of our customers but only for their orders **placed in 2019**.

### Exercise

For each department find the average salary in 2015.

```sql
SELECT
  department,
  AVG(salary)
FROM employees
WHERE year = 2015
GROUP BY department;
```

## Group by a few columns

Nice work.

There's one more thing about `GROUP BY` that we want to discuss. Sometimes we want to group the rows by more than one column. Let's imagine we have a few customers who place tons of orders every day, so we would like to know the daily sum of their orders.

```sql
SELECT
  customer_id,
  order_date,
  SUM(total_sum)
FROM orders
GROUP BY customer_id, order_date;
```

As you can see, we group by two columns: `customer_id` and `order_date`. We select these columns along with the function `SUM(total_sum)`.

Remember: in such queries each column in the `SELECT` part must either **be used later for grouping** or it **must be used with one of the functions**.

To better understand the issue, take a look at the following table (expand the column or scroll the table horizontally if you need to):

| order_id | customer_id | order_date | ship_date  | total_sum |   | customer_id | order_date | SUM(total_sum)  |
|----------|-------------|------------|------------|-----------|---|-------------|------------|-----------------|
| 16       | 6           | 2015-03-28 | 2015-03-29 | 230.54    |   | 6           | 2015-03-28 | 2906.19         |
| 17       | 6           | 2015-03-28 | 2015-03-30 | 321.42    |   |             |            |                 |
| 18       | 6           | 2015-03-28 | 2015-03-30 | 2354.23   |   |             |            |                 |
| 19       | 6           | 2015-03-29 | 2015-03-30 | 4224.21   |   | 6           | 2015-03-29 | 10788.06        |
| 20       | 6           | 2015-03-29 | 2015-03-30 | 2314.32   |   |             |            |                 |
| 21       | 6           | 2015-03-29 | 2015-03-31 | 124.21    |   |             |            |                 |
| 22       | 6           | 2015-03-29 | 2015-03-31 | 4125.32   |   |             |            |                 |
| 23       | 6           | 2015-03-30 | 2015-04-03 | 645.23    | → | 6           | 2015-03-30 | 10504.42        |
| 24       | 6           | 2015-03-30 | 2015-04-05 | 7543.56   |   |             |            |                 |
| 25       | 6           | 2015-03-30 | 2015-04-05 | 2315.63   |   |             |            |                 |
| 26       | 7           | 2015-04-02 | 2015-04-05 | 523.98    |   | 7           | 2015-04-02 | 9580.42         |
| 27       | 7           | 2015-04-02 | 2015-04-06 | 523.13    |   |             |            |                 |
| 28       | 7           | 2015-04-02 | 2015-04-07 | 8533.31   |   |             |            |                 |
| 29       | 7           | 2015-04-03 | 2015-04-07 | 4245.64   |   | 7           | 2015-04-03 | 4245.64         |

**Note**: It makes no sense to select any other column. For example, each order on the very same day by the very same customer can have a different shipping date. If you wanted to select the column `ship_date` in this case, the database wouldn't know which shipping date to choose for the whole group, so it would throw an error.

### Exercise

Find the average salary for each employee. Show the **last name**, the **first name**, and the **average salary**. Group the table by the last name and the first name.

```sql
SELECT
  last_name,
  first_name,
  AVG(salary)
FROM employees
GROUP BY last_name, first_name;
```

## Filter groups

In this section, we'll have a look at how groups can be filtered. There is a special keyword `HAVING` reserved for this.

```sql
SELECT
  customer_id,
  order_date,
  SUM(total_sum)
FROM orders
GROUP BY customer_id, order_date
HAVING SUM(total_sum) > 2000;
```

The new part here comes at the end. We've used the keyword `HAVING` and then stated the condition to filter the results. In this case, we only want to show those customers who, on individuals days, ordered goods with a total daily value of more than $2,000.

By the way, this is probably a good time to point out an important thing: in SQL, the specific fragments must always be put in the right order. You can't, for example, put `WHERE` before `FROM`. Similarly, `HAVING` must always follow `GROUP BY`, not the other way around. Keep that in mind when you write your queries, especially longer ones.

### Exercise

Find such employees who (have) spent more than 2 years in the company. Select their last name and first name together with the number of years worked (name this column `years`).

```sql
SELECT
  last_name,
  first_name,
  COUNT(DISTINCT year) AS years
FROM employees
GROUP BY last_name, first_name
HAVING COUNT(DISTINCT year) > 2;
```

## Filter groups continued

You're getting superb! Now, let's do one more exercise on filtering groups. Are you ready?

### Exercise

Find such departments where the average salary in 2012 was higher than $3,000. Show the department name with the average salary.

```sql
SELECT
  department,
  AVG(salary)
FROM employees
WHERE year = 2012
GROUP BY department
HAVING AVG(salary) > 3000;
```

## Order groups

Correct! There's one more thing before you go. Groups can be sorted just like rows. Take a look:

```sql
SELECT
  customer_id,
  order_date,
  SUM(total_sum)
FROM orders
GROUP BY customer_id, order_date
ORDER BY SUM(total_sum) DESC;
```

In this case, we'll order our rows according to the total daily sum of all orders by a specific customer. The rows with the highest value will appear first.

### Exercise

Sort the employees according to their summary salaries. Highest values should appear first. Show the last name, the first name, and the sum.

```sql
SELECT
  last_name,
  first_name,
  SUM(salary)
FROM employees
GROUP BY last_name, first_name
ORDER BY SUM(salary) DESC;
```

## Put your skills into practice

Very good! You've pretty much done with this part of the course. You've learned how to group rows, count statistics, and sort them.

Let's find out how much you remember. This exercise will check your knowledge all of Part 3.

### Exercise

Show the columns `last_name` and `first_name` from the table `employees` together with each person's **average salary** and the **number of years** they (have) worked in the company.

Use the following aliases: `average_salary` for each person's average salary and `years_worked` for the number of years worked in the company. Show only such employees **who (have) spent more than 2 years in the company**. Order the results according to the **average salary** in the **descending order**.

```sql
SELECT
  last_name,
  first_name,
  AVG(salary) AS average_salary,
  COUNT(DISTINCT year) AS years_worked
FROM employees
GROUP BY last_name, first_name
HAVING COUNT(DISTINCT year) > 2
ORDER BY average_salary DESC;
```
