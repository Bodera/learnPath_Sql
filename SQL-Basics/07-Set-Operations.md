# Set Operations

Wow! You're pretty skilled right now, but there are still some things left which you should know before you finish the course.

You will now learn how to operate on entire SQL query results. By the end, you'll be able to build unions, intersections and differences of two queries. Sounds vague? Don't worry, we'll explain everything for you.

Are you ready for another lecture? Good. Let's go!

## Table of contents

- [Get to know the tables](#get-to-know-the-tables)
- [How UNION works](#how-union-works)
- [Conditions for UNION](#conditions-for-union)
- [The keyword UNION ALL](#the-keyword-union-all)
- [How INTERSECT works](#how-intersect-works)
- [How EXCEPT works](#how-except-works)
- [MINUS instead of EXCEPT](#minus-instead-of-except)
- [Summary](#summary)

## Get to know the tables

Okay, let's introduce the tables we'll have as our guests today. Fortunately, just two of them this time.

Do you do play sport? Even if not, we're going to deal with sportsmen and sportswomen this time. We're going to analyze two tables which contain information about `medals` that various people won in two Olympic disciplines. Let's check them out.

### Cycling medalists

```sql
SELECT *
FROM cycling;
```

As you can see, the table contains the following columns:

- `id` which is the identification number for each medal.
- `person` which is the first and last name of the person who won the medal.
- `country` which the person represented.
- `year` when the medal was won.
- `place` which indicates the kind of medal (1 – gold, 2 – silver, 3 – bronze).

There are, of course, various categories of cycling, but to make things easier, we don't care about them here. We've just picked some sportsmen and sportswomen and put their medals in the table, not too many, so that you can get the hang of the table quickly.

### Skating medalists

```sql
SELECT *
FROM skating;
```

All right, let's see what we've got here. Oh wait – deja vu? Nope, the rows are different, it's just that the **column names are the same**. After all, no matter the discipline, this kind of information stays the same, isn't that right?

Actually, it's going to be important that both of our tables have the same number of columns. You'll understand why later.

## How UNION works

Let's start off with a new keyword `UNION`. What is a union? Well, to make a long story short, it combines results of two or more queries. Let's analyze the example:

```sql
SELECT *
FROM cycling
WHERE country = 'Germany'
UNION
SELECT *
FROM skating
WHERE country = 'Germany';
```

As you can see, we first selected all medals for Germany from the table `cycling`, then we used the keyword `UNION` and finally we selected all medals for Germany from the table `skating`.

You may be tempted to ask: Could we split this instruction into two separate queries? Of course we could. But using a `UNION`, we get all results for the first table PLUS the results of the second table shown together. Remember to only put the semicolon (`;`) at the very end of the whole instruction!

### Exercise

Show all the medals for the period between 2010 and 2014 for skating and cycling. Use the `UNION` keyword.

```sql
SELECT *
FROM skating
WHERE year BETWEEN 2010 AND 2014
UNION
SELECT *
FROM cycling
WHERE year BETWEEN 2010 AND 2014;
```

## Conditions for UNION

Okay, how does the magic work? How can we show two tables as one?

As you probably expect, both tables must have the **same number of columns** so that the results can be merged into one table. Makes sense, right? You should also remember that the respective columns must have the **same kind of information**: number or text.

If one of your tables puts numbers in the column `place` (1, 2, 3) and the other puts texts ('first', 'second', 'third'), the trick won't work.

## The keyword UNION ALL

Good. By default, `UNION` removes duplicate rows. Luckily, we can change this. Just put `UNION ALL` instead of `UNION` in your query

```sql
SELECT *
FROM cycling
WHERE country = 'Germany'
UNION ALL
SELECT *
FROM skating
WHERE country = 'Germany';
```

... and you'll get all rows, even when they are the same.

### Exercise

Show all countries which have medals in cycling or skating. Use a union. Don't remove duplicates.

```sql
SELECT country
FROM skating
UNION ALL
SELECT country
FROM cycling;
```

## How INTERSECT works

Excellent. Here is another keyword: `INTERSECT`. Let's change our example a little bit:

```sql
SELECT year
FROM cycling
WHERE country = 'Germany'
INTERSECT
SELECT year
FROM skating
WHERE country = 'Germany';
```

Instead of `UNION` (or `UNION ALL`), we've put `INTERSECT` in there. What's the difference?

Well, `UNION` gave you all the results from the first query PLUS the results from the second query. `INTERSECT`, on the other hand, only shows the rows which belong to **BOTH** tables.

In this case, we would get the years when Germany got a medal in cycling AND speed skating at the same time.

The conditions here stay the same: the **number of columns** in both tables must be the same and the **number or text** values must match.

### Exercise

Find names of each person who has medals both in cycling and in skating.

```sql
SELECT person
FROM cycling
INTERSECT
SELECT person
FROM skating;
```

## How EXCEPT works

Good job. Amazing people, aren't they?

The next keyword is: `EXCEPT`. Let's change our example one more time:

```sql
SELECT person
FROM cycling
WHERE country = 'Germany'
EXCEPT
SELECT person
FROM skating
WHERE country = 'Germany';
```

So what does `EXCEPT` do? It shows all the results from the first (left) table with the **exception** of those that also appeared in the second (right) table.

In our example, we will see all people from Germany who won a medal in cycling **MINUS** the people from Germany who also won a medal in skating.

### Exercise

Find all the countries which have a medal in cycling but not in skating.

```sql
SELECT country
FROM cycling
EXCEPT
SELECT country
FROM skating;
```

## MINUS instead of EXCEPT

Nice! Remember how we explained `EXCEPT` and we said that it returns the rows from the first table **MINUS** the rows from the second table? The choice of words was no coincidence: some databases use the keyword `MINUS` instead of `EXCEPT`.

You should therefore always check your database documentation before writing such queries.

There are also some databases which support both words, just like our database – so why not try an exercise?

### Exercise

Find all the years when there was at least one medal in skating but no medals in cycling. Use the keyword `MINUS`.

```sql
SELECT year
FROM skating
MINUS
SELECT year
FROM cycling;
```

## Summary

You nailed it, wonderful!

Looks like we're done and you've learned all there was to learn in this SQL basics course. By now, you should know pretty much: how to deal with single and multiple tables, how to filter results, how to compute statistics, and how to JOIN tables and results – you can now write amazing queries all by yourself!

Or can you? We've prepared a revision part for you where you can check your combined skills and knowledge from all the parts of the course. Revise everything and give it a shot!
