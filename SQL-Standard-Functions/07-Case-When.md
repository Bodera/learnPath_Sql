# CASE WHEN

Learn how to include conditions in your SQL queries. Practice computing simple summary reports.

## Introduction

Hello for the seventh time in this course! Today, we're going to learn a powerful construction in SQL, namely `CASE WHEN ... THEN ... ELSE ... END` (in short: `CASE WHEN`). Just by looking at the keywords, you may already guess that we're going to introduce **conditional statements** to our SQL queries: if **A** happens, then do **B**.

The `CASE WHEN` statement isn't a new function in SQL, it's a completely new construction in SQL. It is very **commonly used with various aggregate functions**, so we decided to include it in this course.

But first things first. Today, we're going to help a university which is currently accepting students for five brand new degree courses. Want to find out what they are? Well, let's check that!

## Table course

Select all the information from the table `course`.

We've got an `id`, a `name` and `place_limit` which describes the number of students that can be accepted.

Then we've got a boolean column (`scholarship`) which tells us whether it is possible to get a national scholarship for that course.

The final column, `graduate_satisfaction`, shows the results of a survey among graduates with a maximum score of **100**. Some scores are `NULL` because the courses are new and there are no ratings yet.

Oh, and by the way, these are authentic degree courses offered around the world!

```sql
SELECT *
FROM course;
```

## Table candidate 

Select all the information from the table `candidate`.

Each person who is willing to enroll in a course will have:

- a unique identifier (`id`),
- first and last name (`first_name`, `last_name`),
- two scores (`score_math`, `score_language`) which are the results of two preliminary tests these students need to take: in mathematics and in language (the maximum score for each part is 100),
- finally, there is the preferred method of contact (`preferred_contact`).

```sql
SELECT *
FROM candidate;
```

## Table application

Select all the information from the table `application`.

When a candidate applies for a certain degree course, a new application is created, containing the **id** of the **candidate** and of the **course**. The values from these two columns form the **primary key**. Pretty straightforward.

Then, we've got the amount of the fee paid for the application (`fee`), the day when the payment was made (`pay_date`) and the status of application (`status`).

```sql
SELECT *
FROM application;
```

## Simple CASE WHEN

All right. The construction we've mentioned at the beginning is `CASE WHEN ... THEN ... ELSE ... END` (commonly called just `CASE WHEN`). If you've ever used any programming language, you could think of it as an **if-then-else** type of logic. If you haven't, don't worry – we'll get to that in a second.

There are two similar versions of `CASE` expressions: a **simple** `CASE WHEN` and a **searched** `CASE WHEN`. Let's start with the first one and give you an example:

```sql
SELECT
  CASE fee
    WHEN 50 THEN 'normal'
    WHEN 10 THEN 'reduced'
    WHEN 0 THEN 'free'
    ELSE 'not available'
  END
FROM application;
```

Looks complicated? Let's discuss it.

A `CASE WHEN` adds a new column to the result of the query, so that's why it usually goes into the `SELECT` clause with the other columns, before the `FROM` clause.

Generally speaking, `CASE WHEN` takes:

- a list of one or more values, each value is listed after `WHEN`,
- a list of return values, each return value is listed after `THEN` of the appropriate condition,
- an optional `ELSE` part with a default value for situations where none of the condition is met.

`CASE WHEN` always ends with `END`.

In our example, there are a few options in the column `fee` of the table `application`. The candidate may pay a full application fee (**50**), a reduced one (**10**), may not have to pay at all (**0**) or the payment information may be unavailable for some reason (`NULL`). Instead of showing these values, we change them to more descriptive ones (`normal`, `reduced` etc.).

So, after the keyword `CASE` we name the column of interest (`fee`), and then we provide a few possible value scenarios for this column (`WHEN 50 ...`, `WHEN 10 ...`, `WHEN 0 ...`), instructing our database what to print in each of these cases (`... THEN 'normal'`, `... THEN 'reduced'`, `... THEN 'free'`).

If none of the values matches the one we find in a given row, then the `ELSE` part is executed (`ELSE 'not available'`). In this way, we can control the output of our queries.

Note that you can have as many `WHEN ... THEN` statements as you need and that the `ELSE` part is always optional.

### Exercise

For each degree course, show its `name` and a second column based on the column `place_limit`:

- If it's **5**, write `'few places'`.
- if it's **10**, write `'average number of places'`.
- If it's **15** – `'numerous places'`.
- If the result is something else, show `'other'`.

```sql
SELECT
  name,
  CASE place_limit
    WHEN 5 THEN 'few places'
    WHEN 10 THEN 'average number of places'
    WHEN 15 THEN 'numerous places'
    ELSE 'other'
  END
FROM course;
```

## Simple CASE WHEN continued

Okay. In the previous example, we checked the values of a numerical column and produced string values as a result, but you can check a string column and produce numbers just as well. Check it out:

```sql
SELECT
  first_name,
  last_name,
  CASE preferred_contact
    WHEN 'mobile' THEN 5
    WHEN 'e-mail' THEN 0
    WHEN 'mail' THEN 10
    ELSE 5
  END AS contact_cost
FROM candidate;
```

In the above example, we want to calculate the cost of contacting a given candidate. Based on the values in the column `preferred_contact`, we provide some numerical values. Please note how we renamed the column in question with `AS contact_cost`, put after the `END` keyword.

### Exercise

For each application, show the candidate ID (as `candidate_id`) and the `course_id` along with the following information: if the status is accepted, show 1. Otherwise, show 0. Name the last column `accepted`.

```sql
SELECT
  candidate_id,
  course_id,
  CASE status
    WHEN 'accepted' THEN 1
    ELSE 0
  END AS accepted
FROM application;
```

## Simple CASE WHEN with NULLs

That's correct! Having gone through Part 5 about `NULL`s, you might want to ask: okay, but how do `NULL`s behave in `CASE WHEN`?

The answer is pretty straightforward: `NULL` will always go to the `ELSE` condition if you include it. Let's check this out in an exercise.

### Exercise

For table `candidate`, show each candidate's `id`, `preferred_contact` and the third column which will print:

- 'traditional' if the preferred_contact is 'mail'.
- 'modern' if it's 'mobile' or 'e-mail'.
- 'other' otherwise.

Look what is shown for `NULL` values.

```sql
SELECT
  id,
  preferred_contact,
  CASE preferred_contact
    WHEN 'mail' THEN 'traditional'
    WHEN 'mobile' THEN 'modern'
    WHEN 'e-mail' THEN 'modern'
    ELSE 'other'
  END
FROM candidate;
```

## Simple CASE WHEN – practice

All right. Let's do a more demanding exercise with `JOIN`s!

### Exercise

Show the following columns: `name` of the course, first and last name of the candidate (`first_name`, `last_name`), and a column `fee_information` which shows:

- 'high' when the fee is 50.
- 'low' in any other case.

Sort the rows by the `name` of the course in `DESC`ending order.

```sql
SELECT
  course.name,
  candidate.first_name,
  candidate.last_name,
  CASE fee
    WHEN 50 THEN 'high'
    ELSE 'low'
  END AS fee_information
FROM course
JOIN application ON course.id = application.course_id    
JOIN candidate ON application.candidate_id = candidate.id
ORDER BY course.name DESC;
```

## Searched CASE WHEN

Good job! We told you previously that there is also another type of `CASE WHEN` which is **searched** `CASE WHEN`. This is a slightly more complicated form, but don't worry – it's no rocket science. Take a look at the example:

```sql
SELECT CASE
  WHEN score_math > 80 THEN 'amazing mathematician'
  WHEN score_math > 60 THEN 'knows something about numbers indeed'
  ELSE 'not good enough'
END AS mathematical_skills
FROM candidate;
```

Let's analyze what is happening here. First of all, there is now **no column name** immediately after the keyword `CASE`. Instead, we put entire **logical conditions** with column names after each `WHEN`. Again, you can have as many `WHEN ... THEN` statements as you want and you can skip `ELSE` if you like.

A simple `CASE WHEN` took a single column and checked it against a number of values we provided. A searched `CASE WHEN` is more general – you can put different column names in each `WHEN` clause and you can use mathematical and logical operators. We'll show you that in a second.

In this case, those candidates who had a score greater than **80** will have `'amazing mathematician'` displayed, those with a score higher than **60** but lower than **80** will have `'knows something about numbers indeed'` shown instead. Those who scored **60** or less will have `'not good enough'` displayed.

### Exercise

Let's make a similar query for language skills. For each candidate, show their first and last name (`first_name`, `last_name`) along with a third column `language_skills` with the following possibilities:

- 'amazing linguist' (>80 language points).
- 'can speak a bit' (>50 language points).
- 'cannot speak a word' otherwise.

```sql
SELECT
  first_name,
  last_name,
  CASE
    WHEN score_language > 80 THEN 'amazing linguist'
    WHEN score_language > 50 THEN 'can speak a bit'
    ELSE 'cannot speak a word'
  END AS language_skills    
FROM candidate;
```

## Searched CASE WHEN with various conditions

All right. As we mentioned previously, you can use various conditions in a single `CASE WHEN` clause. As usual, here comes an example:

```sql
SELECT
  candidate_id,
  CASE
    WHEN pay_date < '2015-06-01' THEN 'database error'
    WHEN pay_date BETWEEN '2015-06-01'
      AND '2015-06-05' THEN 'accepted'
    WHEN pay_date = '2015-06-06'
      THEN 'conditionally accepted'
    ELSE 'not accepted'
  END AS payment_status
FROM application;
```

The situation is as follows: each candidate was supposed to pay an application fee between **June 1** and **June 5**. If the system provides an earlier date, this must be clearly a mistake, because the bank account was only opened on **June 1** (hence the status `'database error'`). Those who indeed paid between **June 1** and **June 5** got a status `'accepted'`. The university also agreed to accept those who paid a day later (`'conditionally accepted'`). There was, however, no mercy for those who paid even later – they did not qualify. Poor them.

Note that we could use the less than sign, the `BETWEEN` construction and the equality sign (`=`) - all in a single `CASE` clause. In other words, you can basically use all the operators and functions you've learned so far. This is the magic of searched `CASE WHEN`s.

### Exercise

For each candidate, show the `first_name` and `last_name` and a third column called `overall_result`: if the sum of `score_math` and `score_language` is **150 or more**, show `'excellent'`. If it's **between 100 and 149**, show `'good'`. Otherwise, show `'poor'`.

```sql
SELECT
  first_name,
  last_name,
  CASE
    WHEN score_math + score_language >= 150 THEN 'excellent'
    WHEN score_math + score_language >= 100 THEN 'good'
    ELSE 'poor'
  END AS overall_result
FROM candidate;
```

## Searched CASE WHEN with NULLs

Good. You can also work with `NULL`s in a `CASE WHEN` statement:

```sql
SELECT CASE
  WHEN fee IS NULL THEN 'no fee recorded'
  WHEN fee IS NOT NULL THEN 'fee recorded'
  END AS fee_information
FROM application;
```

We used the standard `IS (NOT) NULL` construction to check if the column is `NULL`. Note that we didn't have to use the `ELSE` part – a column value can be `NULL` or `NOT NULL` only. There is no other option, so we didn't need to specify it.

### Exercise

For each candidate, show the `first_name` and `last_name` along with the third column `contact_info` with the values:

- 'provided' when the column `preferred_contact` is not `NULL`.
- 'not provided' otherwise.

```sql
SELECT
  first_name,
  last_name,
  CASE
    WHEN preferred_contact IS NOT NULL THEN 'provided'
    ELSE 'not provided'
  END AS contact_info
FROM candidate;
```

## Searched CASE WHEN with NULLs – continued

Okay, and what will happen to `NULL`s if you don't include `IS NOT NULL` in your `CASE WHEN`? They will be treated as those rows for which the `ELSE` part is executed. Let's check that.

### Exercise

Show each candidate's ID, score in math and a third column which will show:

- 'above average' for candidates with math score higher than 60.
- 'below average' for candidates with math score equal to or less than 60.
- For other results, show 'not available'.

The column names should be: `id`, `score_math`, and `result`. Note what happens to the rows with a `NULL` score.

```sql
SELECT
  id,
  score_math,
  CASE
    WHEN score_math > 60 THEN 'above average'
    WHEN score_math <= 60 THEN 'below average'
    ELSE 'not available'
  END AS result
FROM candidate;
```

## Searched CASE WHEN – additional practice

Ok, let's do a more sophisticated example of `CASE WHEN`.

### Exercise

The courses have different requirements, so let's check who can actually become a student of **Ethical Hacking** (`id = 3`). Show the name of this course, the `first_name` and `last_name` of the candidate who applied for this course, and another column called `qualification`. The rules are as follows:

- If the student got above 80 in math, show 'qualified'.
- If the score in math is above 70, but the score in language is above 50, show 'qualified' as well.
- If the score in math is between 50 and 70, show 'possible'.
- Otherwise, show 'rejected'.

```sql
SELECT
  name,
  first_name,
  last_name,
  CASE
    WHEN score_math > 80 THEN 'qualified'
    WHEN score_math > 70 AND score_language > 50 THEN 'qualified'
    WHEN score_math BETWEEN 50 AND 70 THEN 'possible'
    ELSE 'rejected'
  END AS qualification
FROM course
JOIN application ON course.id = application.course_id
JOIN candidate ON application.candidate_id = candidate.id
WHERE course.id = 3;
```

## CASE WHEN with SUM

Correct, nice! Now, let's combine `CASE WHEN` with some aggregate functions.

You've learned the function `SUM()`, the constructions `CASE WHEN` and you know that `CASE WHEN` can return numbers. Now, let's combine all of this information to make a very convenient query which can count various groups of rows at the same time. Take a look:

```sql
SELECT

  SUM(CASE
    WHEN scholarship IS TRUE THEN place_limit
    ELSE 0
  END) AS scholarship_places,

  SUM(CASE
    WHEN scholarship IS FALSE THEN place_limit
    ELSE 0
  END) AS no_scholarship_places

FROM course;
```

The above query counts two `SUM`s: the number of places in all courses which offer scholarship and the number of places in those which don't.

Inside `SUM`, we put a `CASE WHEN` statement. When the value in the column `scholarship` is true, then we add the value from the column `place_limit` to the sum called `scholarship_places`. Otherwise, we add **0**. The other `SUM` is calculated in the same way.

### Exercise

Calculate the total sum from fees paid on **June 3, 2015** (column `june_3rd`) and the total sum from fees paid on **June 4, 2015** (column `june_4th`).

```sql
SELECT
  SUM(CASE
    WHEN pay_date = '2015-06-03' THEN fee
    ELSE 0
  END) AS june_3rd,

  SUM(CASE
    WHEN pay_date = '2015-06-04' THEN fee
    ELSE 0
  END) AS june_4th
FROM application;
```

## Counting rows with CASE WHEN and SUM

Correct, nice! Now, let's use `SUM` in another way. Take a look:

```sql
SELECT
  SUM(CASE WHEN pay_date BETWEEN '2015-06-01' AND
    '2015-06-05' THEN 1 ELSE 0 END)
    AS accepted_payment,
  SUM(CASE WHEN pay_date = '2015-06-06' THEN 1
    ELSE 0 END) AS conditionally_accepted_payment,
  SUM(CASE WHEN pay_date > '2015-06-06'
    THEN 1 ELSE 0 END) AS not_accepted
FROM application;
```

In the above query, we start with calculating the number of accepted payments.

Inside the function `SUM`, we use a `CASE WHEN` construction. It checks whether the `pay_date` in a given row is within the deadline specified. If it is, this row is given the number **1** (which means the sum count will go up by **1**). If this is not the case, the number is **0** and this row will not affect the sum (e.g., 10 plus 0 is still 10).

The other two `SUM` functions (`conditionally_accepted_payment`, `not_accepted`) work in the same way.

### Exercise

Count the number of applications that have:

- a full fee of 50 (full_fee_sum).
- a fee of 10 (reduced_fee_sum).
- a fee of 0 (free_sum).
- a fee of NULL (null_fee_sum).

```sql
SELECT
  SUM(CASE WHEN fee = 50 THEN 1 ELSE 0 END) AS full_fee_sum,
  SUM(CASE WHEN fee = 10 THEN 1 ELSE 0 END) AS reduced_fee_sum,
  SUM(CASE WHEN fee = 0 THEN 1 ELSE 0 END) AS free_sum,
  SUM(CASE WHEN fee IS NULL THEN 1 ELSE 0 END) AS null_fee_sum
FROM application;
```

## CASE WHEN with SUM continued

Great! The use of `CASE WHEN` together with `SUM` is actually so important that we should do one more exercise here. Are you ready?

### Exercise

Count the number of candidates with `preferred_contact` set to:

- 'mobile' (`mobile_sum`).
- 'e-mail' (`email_sum`).
- 'mail' (`mail_sum`).
- with NULL (`null_sum`).

Only count candidates whose score in math and score in language are both **greater than or equal to 30**.

```sql
SELECT
  SUM(CASE WHEN preferred_contact = 'mobile' THEN 1 ELSE 0 END) AS mobile_sum,
  SUM(CASE WHEN preferred_contact = 'e-mail' THEN 1 ELSE 0 END) AS email_sum,
  SUM(CASE WHEN preferred_contact = 'mail' THEN 1 ELSE 0 END) AS mail_sum,
  SUM(CASE WHEN preferred_contact IS NULL THEN 1 ELSE 0 END) AS null_sum
FROM candidate
WHERE score_math >= 30 AND score_language >= 30;
```

## CASE WHEN with COUNT

Okay. You can also use `CASE WHEN` with `COUNT` to count selected rows. The secret here is to omit the `ELSE` part. Let's try to rewrite the example with payment acceptance using `COUNT`:

```sql
SELECT
  COUNT(CASE
    WHEN pay_date BETWEEN '2015-06-01' AND '2015-06-05'
      THEN pay_date
  END) AS accepted_payment,

  COUNT(CASE
    WHEN pay_date = '2015-06-06'
      THEN pay_date
  END) AS conditionally_accepted_payment,

  COUNT(CASE
    WHEN pay_date > '2015-06-06'
      THEN pay_date
  END) AS not_accepted

FROM application;
```

Let's see what's changed. We don't use `SUM`, instead we use `COUNT`. The condition after `WHEN` stays the same, but now, if the condition is satisfied, we provide the column `pay_date` for that particular row so that `COUNT` can count it. The `CASE WHEN` does not have the `ELSE` part, so if the condition is not met, `CASE WHEN` returns `NULL`, which is not counted by `COUNT`.

In this way, we calculate `accepted_payment`, `conditionally_accepted_payment` and `not_accepted`.

### Exercise

Count the number of courses with possible scholarship (`scholarship_present`) and without them (`scholarship_missing`).

```sql
SELECT
  COUNT(CASE WHEN scholarship THEN 1 ELSE NULL END) AS scholarship_present,
  COUNT(CASE WHEN NOT scholarship THEN 1 ELSE NULL END) AS scholarship_missing
FROM course;
```

## CASE WHEN with COUNT – practice

Okay. Let's do one more exercise for this topic.

### Exercise

Count the number of candidates who scored:

- at least 80 in math (`good_math`).
- at least 60 and less than 80 (`average_math`).
- or less than 60 (`poor_math`).

Show only those candidates who have provided a `preferred_contact` form.

```sql
SELECT
  COUNT(CASE WHEN score_math >= 80 THEN 1 ELSE NULL END) AS good_math,
  COUNT(CASE WHEN score_math >= 60 AND score_math < 80 THEN 1 ELSE NULL END) AS average_math,
  COUNT(CASE WHEN score_math < 60 THEN 1 ELSE NULL END) AS poor_math
FROM candidate
WHERE preferred_contact IS NOT NULL;
```

## CASE WHEN with COUNT DISTINCT

Good! Now, in certain situations you may also want to include `DISTINCT` in your `CASE WHEN` statements with `COUNT`. Take a look:

```sql
SELECT
  COUNT(DISTINCT CASE
    WHEN pay_date BETWEEN '2015-06-01' AND '2015-06-05'
      THEN candidate_id
  END) AS accepted_student,

  COUNT(DISTINCT CASE
    WHEN pay_date = '2015-06-06'
      THEN candidate_id
  END) AS conditionally_accepted_student,

  COUNT(DISTINCT CASE
    WHEN pay_date > '2015-06-06'
      THEN candidate_id
  END) AS not_accepted

FROM application;
```

What changed here? Two things. First of all, we included the keyword `DISTINCT` in each `COUNT`. Second, we now count `student_ids` and not `pay_dates`. What is the meaning of these changes?

We previously counted the number of accepted payments, conditionally accepted payments and not accepted payments. Now, we count the number of candidates who were accepted for at least one degree course, the number of candidates who were conditionally accepted for at least one degree course and not accepted for at least one degree course.

We had to include the keyword `DISTINCT` because a single candidate can apply for more than one degree course, so if a candidate made two payments for two courses on time, that candidate would be counted twice (the candidate can be still counted twice in two different columns if the candidate paid for one degree course and didn't pay for another, but that's a different story).

### Exercise

Show how many students paid the full fee of 50 (`full_fee_sum`) and the reduced fee of 10 (`reduced_fee_sum`), but if a certain student paid the same amount for more than one degree course, count them only once.

```sql
SELECT
  COUNT(DISTINCT CASE WHEN fee = 50 THEN candidate_id ELSE NULL END) AS full_fee_sum,
  COUNT(DISTINCT CASE WHEN fee = 10 THEN candidate_id ELSE NULL END) AS reduced_fee_sum
FROM application;
```

## CASE WHEN with GROUP BY

Very good. Now, let's move on and analyze how we can use `CASE WHEN` and `GROUP BY` together. Take a look at the following example:

```sql
SELECT 
  course_id,
  SUM(CASE WHEN fee = 50 THEN 1 ELSE 0 END) AS full_fee,
  SUM(CASE WHEN fee = 10 THEN 1 ELSE 0 END) AS reduced_fee,
  SUM(CASE WHEN fee = 0  THEN 1 ELSE 0 END) AS no_fee
FROM application
GROUP BY course_id;
```

Look what happened in the above query: we count the number of applications with full fee, reduced fee and no fee for single courses. In other words, we know how many applications have a full fee for Baking Technology, Viking Studies, etc. We use `SUM`s as we did before, but now we also group the rows so that these sums refer to specific groups.

### Exercise

For each course, show its id (name the column `course_id`) and three more columns: `accepted`, `pending` and `rejected`, each containing the **number of** accepted, pending and rejected applications for that course, respectively. (Don't show the courses that aren't present in the application table.)

Sort the results by ID in `ASC`ending order.

```sql
SELECT
  course_id,
  SUM(CASE WHEN status = 'accepted' THEN 1 ELSE 0 END) AS accepted,
  SUM(CASE WHEN status = 'pending' THEN 1 ELSE 0 END) AS pending,
  SUM(CASE WHEN status = 'rejected' THEN 1 ELSE 0 END) AS rejected
FROM application
GROUP BY course_id
ORDER BY course_id ASC;
```

## CASE WHEN with GROUP BY – practice

Excellent! Let's do one more exercise of this kind.

### Exercise

For each candidate, with at least one application, show their `id` and three more columns called `count_accepted`, `count_rejected`, `count_pending`. Each of these columns should count the number of times the candidate has been **accepted** to courses, **rejected** or where the decision is **pending**.

Sort the rows in `ASC`ending order by the `id`.

```sql
SELECT
  candidate_id AS id,
  SUM(CASE WHEN status = 'accepted' THEN 1 ELSE 0 END) AS count_accepted,
  SUM(CASE WHEN status = 'rejected' THEN 1 ELSE 0 END) AS count_rejected,
  SUM(CASE WHEN status = 'pending' THEN 1 ELSE 0 END) AS count_pending
FROM application
GROUP BY candidate_id
ORDER BY candidate_id ASC;
```

## CASE WHEN with GROUP BY – practice 2

Fine! And yet another one so that you can become the master of `GROUP BY` with `CASE WHEN`.

### Exercise

For each degree course, show its **ID** (as `id`) and the number of distinct candidates who applied for this course and have the `preferred_contact` set to:

1. 'mobile' (column: `count_mobile`),
2. 'mail' (column: `count_mail`).

```sql
SELECT
  course_id AS id,
  COUNT(DISTINCT CASE WHEN preferred_contact = 'mobile' THEN candidate_id ELSE NULL END) AS count_mobile,   
  COUNT(DISTINCT CASE WHEN preferred_contact = 'mail' THEN candidate_id ELSE NULL END) AS count_mail
FROM application
JOIN candidate ON application.candidate_id = candidate.id
JOIN course ON application.course_id = course.id
GROUP BY course_id;
```

## Another use of CASE WHEN with GROUP BY

All right. We will now show you two other ways of using `CASE WHEN` with `GROUP BY` statements and aggregate functions. Take a look at the following example:

```sql
SELECT
  pay_date,
  COUNT(pay_date),

  CASE WHEN COUNT(pay_date) > 5
  THEN 'high' ELSE 'low' END
  AS number_of_payments

FROM application
GROUP BY pay_date;
```

The above query will group all applications according to the date where the payment was made. Then, it counts the number of payments on each date. Up to this point, it's pretty standard, right? But look what happens next: we can use `CASE WHEN` to show a comment on the values of the aggregate function. If it's **more than 5**, we'll say that the number is `'high'`. Otherwise, we'll show `'low'`.

### Exercise

Show each `preferred_contact` form with the number of candidates who provided it (as `candidates_count`). Along with that, show a column entitled `'rating'` and show:

- `'high'` if there are more than 5 candidates with this form of contact.
- `'low'` otherwise.

```sql
SELECT
  preferred_contact,
  COUNT(id) AS candidates_count,
  CASE
    WHEN COUNT(id) > 5 THEN 'high'
    ELSE 'low'
  END AS rating
FROM candidate
GROUP BY preferred_contact;
```

## CASE WHEN in GROUP BY

Fine! Lastly, we're going to show you a more advanced trick: `CASE WHEN` with `GROUP BY`. What is it about? You can actually group your rows by the values you provide yourself in the `CASE` construction. Take a look:

```sql
SELECT
  CASE
    WHEN fee = 50 THEN 'full_fee'
    WHEN fee = 10 THEN 'reduced_fee'
    ELSE 'no_fee'
  END,
  COUNT(fee)
FROM application
GROUP BY CASE
  WHEN fee = 50 THEN 'full_fee'
  WHEN fee = 10 THEN 'reduced_fee'
  ELSE 'no_fee'
END;
```

The result of this query will show groups **'full_fee'**, **'reduced_fee'** and **'no_fee'** with the number of rows containing these values. Of course, you could achieve similar results by using `COUNT` or `SUM` with `CASE WHEN`.

Here, we just want you to realize what possibilities `CASE WHEN` gives you. Note, however, that this time you'll get **'full fee'**, **'reduced fee'** and **'no fee'** as separate rows, not as possible values of a single column.

### Exercise

Use the construction we have just shown you to count the number of candidates who scored:

- at least 70 in the language test ('good score').
- at least 40 ('average score').
- and below 40 ('poor score').

The column names should be case `and` `count`.

```sql
SELECT
  CASE
    WHEN score_language >= 70 THEN 'good score'
    WHEN score_language >= 40 THEN 'average score'
    ELSE 'poor score'
  END AS case,
  COUNT(id) AS count
FROM candidate
GROUP BY CASE
  WHEN score_language >= 70 THEN 'good score'
  WHEN score_language >= 40 THEN 'average score'
  ELSE 'poor score'
END;
```

## Summary

Okay then, it's time to revise the most important aspects of CASE WHEN.

- A simple `CASE WHEN` has the following syntax:

```sql
CASE column_name
  WHEN value1 THEN text1
  WHEN value2 THEN text2
  ...
  ELSE text_else
END
```

- A searched `CASE WHEN` has the following syntax:

```sql
CASE
  WHEN condition1 THEN text1
  WHEN condition2 THEN text2
  ...
  ELSE text_else
END
```

- The `ELSE` part is optional.
- Remember to put the `END` clause at the end.
- You can use `CASE WHEN` with `SUM` to count multiple values in a single query:

```sql
SUM(CASE WHEN x THEN 1 ELSE 0 END)
```

- Similarly, you can use `CASE WHEN` with `COUNT` to count multiple values in a single query:

```sql
COUNT(CASE WHEN x THEN column END)
```

## Quiz

Are you ready for some practice? Let's find out!

### Exercise 1

For each course, show its `name` and a second column based on the column `graduate_satisfaction`:

- if it's above 80, show 'satisfied'.
- if it's above 50, show 'moderately satisfied'.
- if it's 50 or less, show 'not satisfied'.

Name the second column `satisfaction_level`.

```sql
SELECT
  name,
  CASE
    WHEN graduate_satisfaction >  80 THEN 'satisfied'
    WHEN graduate_satisfaction >  50 THEN 'moderately satisfied'
    WHEN graduate_satisfaction <= 50 THEN 'not satisfied'
  END AS satisfaction_level
FROM course;
```

### Exercise 2

Show the number of students who scored at least 60 in both math and language (as `versatile_candidates`) and the number of students who scored below 40 in both of these tests (as `poor_candidates`). Don't include students with `NULL` `preferred_contact`.

```sql
SELECT
  COUNT(CASE WHEN score_math >= 60 AND score_language >= 60 THEN 1 ELSE NULL END) AS versatile_candidates,
  COUNT(CASE WHEN score_math < 40 AND score_language < 40 THEN 1 ELSE NULL END) AS poor_candidates
FROM candidate
WHERE preferred_contact IS NOT NULL;
```

### Exercise 3

Show each degree course name and a second column called popularity. If at least 5 distinct candidates applied, show 'high', otherwise show 'low'.

```sql
SELECT
  name,
  CASE
    WHEN COUNT(DISTINCT candidate_id) >= 5 THEN 'high'
    ELSE 'low'
  END AS popularity
FROM course
JOIN application ON course.id = application.course_id
GROUP BY name;
```

### Exercise 4

For each degree course, show its `name`, the `place_limit`, the number of people who applied for that degree course (as `candidates_no`) and yet another column `popularity`: if more people applied than `place_limit`, show 'overcrowded'. Otherwise, show 'within limit'.

```sql
SELECT
  course.name,
  course.place_limit,
  COUNT(DISTINCT candidate_id) AS candidates_no,
  CASE 
  	WHEN COUNT(DISTINCT candidate_id) > place_limit
  	THEN 'overcrowded'
    ELSE 'within limit'
  END AS popularity
FROM application
JOIN course ON application.course_id = course.id
GROUP BY course.name, course.place_limit
```

## Congratulations

Wow, amazing! You are really awesome at this!

That's all for today, congratulations. Visit us again when you're ready for Part 8.
















