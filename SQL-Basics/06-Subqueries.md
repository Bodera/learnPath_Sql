# Subqueries

So far you've learned to build simple queries with lots of additional clauses.

You will now get to know subqueries. They are a powerful tool which will help you build complex instructions. Ready, steady – go!

## Table of contents

- [Get to know the table country](#get-to-know-the-table-country)
- [Get to know the tables city and mountain](#get-to-know-the-tables-city-and-mountain)
- [Get to know the tables trip and hiking_trip](#get-to-know-the-tables-trip-and-hiking_trip)
- [Get to know subqueries](#get-to-know-subqueries)
- [Subqueries with various logical operators](#subqueries-with-various-logical-operators)
- [Subqueries with functions](#subqueries-with-functions)
- [The operator IN](#the-operator-in)
- [The operator IN with subqueries](#the-operator-in-with-subqueries)
- [The operator ALL](#the-operator-all)
- [The operator ANY](#the-operator-any)
- [Get to know correlated queries](#get-to-know-correlated-queries)
- [Aliases for tables](#aliases-for-tables)
- [The operator IN with correlated subqueries](#the-operator-in-with-correlated-subqueries)
- [The operator EXISTS](#the-operator-exists)
- [The operator EXISTS with NOT](#the-operator-exists-with-not)
- [The operator ALL in correlated subqueries](#the-operator-all-in-correlated-subqueries)
- [The operator ANY in correlated subqueries](#the-operator-any-in-correlated-subqueries)
- [Subqueries in the FROM clause](#subqueries-in-the-from-clause)
- [Subqueries in the SELECT clause](#subqueries-in-the-select-clause)

## Get to know the table country

Okay! Complex instructions require complex examples. Let's imagine a **travel agency** and its database. We're going to work with as many as 5 tables this time: `country`, `city`, `mountain`, `trip`, and `hiking_trip`. Let's analyze them. Use the Database button on the right to see the contents of each table discussed.

Let's start with the table `country`.

As you can see, there are different countries listed in the table country. The travel agency operates in all of them, so we need some basic info in the table: the id of the country, the name of the country, its population, and the area in square kilometers.

## Get to know the tables city and mountain

All right, let's move on and check out the `city` table. There are different cities in each country, so the table lists information about them. It gives you the **ID** of the city and its **name**, the **ID** of the **country** where it can be found, the city **population**, the **area** in square kilometers and its **rating**, where 5 means "no better place to visit on earth" and 1 means "boring as hell".

How about the table `mountain`? In each country there are some mountains, so the travel agency lists information about them too. The table stores columns with the **ID**, the **name** of the mountain, its **height** in meters and the ID of the **country** where it is located.

Not much happening here. Why don't we move on?

## Get to know the tables trip and hiking_trip

All right, now the best part: the trip `table`. Of course trips are the essence of every travel agency! In this table, we store information about the trip **ID**, the ID of the **city** where the trip takes place, the duration of the trip in **days**, and the total **price**.

Apart from trips to cities, in the table `hiking_trip` there are also hiking trips on mountains! Each hiking trip has its own **ID**, the ID of the specific **mountain**, the number of **days** it takes, its **price**, the trip **length** in kilometers and the **difficulty** where 1 means 'piece of cake' and 5 stands for 'you're not coming back from there'.

So much for the tables. Let's get down to work and learn something new.

## Get to know subqueries

All right, to give you an idea of what **subqueries** are, consider the following problem: we want to find cities which have the same rating as Paris.

With the knowledge you have now, you would first need to check the rating for Paris:

```sql
SELECT rating
FROM city
WHERE NAME = 'Paris';
```

Then you would need to write down the result of the above query somewhere in your notebook (the rating is 5, by the way) and then construct a new query:

```sql
SELECT name
FROM city
WHERE rating = 5;
```

Subqueries have been introduced to help you with such examples. They are **'queries inside queries'** and they are always put in parentheses. Take a look:

```sql
SELECT name
FROM city
WHERE rating = (
  SELECT
    rating
  FROM city
  WHERE name = 'Paris'
);
```

The database will first check the subquery (in the parentheses), then return the result of the query (in this case, the number 5) in place of the subquery and then check the final query.

In this particular example, you must write the subquery in such a way that it returns **precisely one value** (one column of one row) so that it matches the equation 'rating = X'. It wouldn't make much sense to put a whole table there, would it?

### Exercise

Show all information about all cities which have the same area as Paris.

```sql
SELECT *
FROM city
WHERE area = (
  SELECT
    area
  FROM city
  WHERE name = 'Paris'
);
```

## Subqueries with various logical operators

Excellent! Subqueries can also be used with other logical operators. Take a look at the following example:

```sql
SELECT *
FROM mountain
WHERE height > (
  SELECT height
  FROM mountain
  WHERE name = 'Zugspitze'
);
```

The above query will return **all mountains which are higher than Zugspitze**. As you can see, we've used the 'greater than' sign (`>`) together with a subquery.

### Exercise

Find the names of all cities which have a population lower than Madrid.

```sql
SELECT name
FROM city
WHERE population < (
  SELECT population
  FROM city
  WHERE name = 'Madrid'
);
```

## Subqueries with functions

Nice! Next thing, our subqueries can become more complicated if we include some functions in them. Take a look:

```sql
SELECT *
FROM hiking_trip
WHERE length < (
  SELECT AVG(length)
  FROM hiking_trip
);
```

Now our query looks for **all hiking trips with a distance less than the average**. As you can see, we used the function `AVG()` in the subquery which, as you might remember, gives us the average value from a column.

### Exercise

Find all information about trips whose price is higher than the average.

```sql
SELECT *
FROM trip
WHERE price > (
  SELECT AVG(price)
  FROM trip
);
```

## The operator IN

Excellent! These examples are getting too easy for you! Let's try something more complicated.

So far, our subqueries only returned **single values** (like 5 or 15.28 for example). Let's change that.

First, we need to learn a new operator. Take a look at the example:

```sql
SELECT *
FROM city
WHERE rating IN (3, 4, 5);
```

Can you guess what `IN` means? That's right, it allows you to specify a few values in the `WHERE` clause instead of just one.

In our example, we only want to show interesting cities, but we're not very picky – any city with a rating 3 `OR` 4 `OR` 5 will do. That's what `IN (3,4,5)` means.

### Exercise

Find all information about hiking trips with difficulty 1, 2, or 3.

```sql
SELECT *
FROM hiking_trip
WHERE difficulty IN (1, 2, 3);
```

## The operator IN with subqueries

Okay! Now, you probably wonder how to use the new operator `IN` with **subqueries**. Consider the following example:

```sql
SELECT price
FROM trip
WHERE city_id IN (
  SELECT id
  FROM city
  WHERE population < 2000000
);
```

In the subquery, we look for IDs of all cities with a population below 2 million. Next, we use these IDs as the values in the `IN` operator.

In this way, we can find prices of trips to cities with a population lower than 2 million.

### Exercise

Find all information about all trips in cities whose area is greater than 100.

```sql
SELECT *
FROM trip
WHERE city_id IN (
  SELECT id
  FROM city
  WHERE area > 100
);
```

## The operator ALL

Outstanding! Since you're doing so well, you should be ready for another operator. See the example:

```sql
SELECT *
FROM country
WHERE area > ALL (
  SELECT area
  FROM city
);
```

As you can see, we've got a new operator `ALL` on the right side of the logical operator `>`. In this case, `> ALL` means "greater than every other value from the parentheses".

As a result, we'll get all the countries whose area is bigger than every other area of all cities. **Liechtenstein**, for instance, is a very small country. It is bigger than some cities (like Lyon, for example), but it is **not bigger than every other city** (Berlin is bigger, for example) so Liechtenstein won't be shown in the result.

You can also use `ALL` with other logical operators: `= ALL`, `!= ALL`, `< ALL`, `<= ALL`, `>= ALL`.

### Exercise

Find all information about the cities which are less populated than all countries in the database.

```sql
SELECT *
FROM city
WHERE population < ALL (
  SELECT population
  FROM country
);
```

## The operator ANY

Good. To conclude this section, let's find out about one more operator: `ANY`. Take a look:

```sql
SELECT *
FROM trip
WHERE price < ANY (
  SELECT price
  FROM hiking_trip
  WHERE mountain_id = 1
);
```

In the above example, we want to find trips to the cities which are cheaper than any hiking trip to the mountain with id 1 (Mont Blanc, just to let you know). There are two hiking trips to Mont Blanc: one which costs 1000 and one which costs 300. If we find a city trip which is cheaper than any of these values, we show it in the result.

Again, other logical operators are possible: `= ANY`, `!= ANY`, `< ANY`, `<= ANY`, `>= ANY`.

### Exercise

Find all information about all the city trips which have the same price as any hiking trip.

```sql
SELECT *
FROM trip
WHERE price = ANY (
  SELECT price
  FROM hiking_trip
);
```

## Get to know correlated queries

Very good. So far, we've only used subqueries which were **independent** of the main query – you could first run the subquery alone and then put its result in the main query.

We are now going to learn subqueries which are dependent on the main query. They are called **correlated subqueries**.

Study the example:

```sql
SELECT *
FROM country
WHERE area <= (
  SELECT MIN(area)
  FROM city
  WHERE city.country_id = country.id
);
```

We want to find all countries whose area is equal to or smaller than the minimum city area in that particular country. In other words, if there is a country smaller than its smallest city, it will be shown. Why would we use such a query? It can be very convenient if we want to check whether there any are errors in our database. If this query returned anything other than nothing, we would know that something fishy is going on in our records.

What's the new piece here? Take a look at the `WHERE` clause in the subquery. That's right, it uses country.id. Which country does it refer to? The country from the **main clause** of course. This is the secret behind correlated subqueries – if you ran the subquery alone, your database would say:
'Hey, you want me to compare `city.country_id` to `country.id`, but there are tons of ids in the table `country`, so I don't know which one to choose'.
But if you run the instruction as a subquery and the main clause browses the table `country`, then the database will each time compare `country.id` from the subquery with the current `country.id` from the main clause.

Just remember the golden rule: **subqueries can use tables from the main query, but the main query can't use tables from the subquery**!

### Exercise

Let's check if the database contains any errors in a sample exercise.

Find all information about each country whose population is equal to or smaller than the population of the least populated city in that specific country.

```sql
SELECT *
FROM country
WHERE population <= (
  SELECT MIN(population)
  FROM city
  WHERE city.country_id = country.id
);
```

## Aliases for tables

Wow! That wasn't easy, so congratulations! Now, there may be examples where the same table is used in the main query as well as in the correlated subquery. Try to find out what the following example returns:

```sql
SELECT *
FROM city main_city
WHERE population > (
  SELECT AVG(population)
  FROM city average_city
  WHERE average_city.country_id = main_city.country_id
);
```

In this example, we want to find cities with a population greater than the average population in all cities of the specific country. The problem is that we look for cities in the main clause and check the average population value for cities in the subquery. The same table appears twice – no good.

This is why we must use aliases for tables. Take a look: in the subquery we put `... FROM city average_city ...` and in the main query `... FROM city main_city`. As you can see, we gave **new temporary names** for the table `city`, different for the main query and for the subquery. The temporary name (the so-called **alias**) is put after the table name, separated by a space. No commas here, remember!

### Exercise

Find **all** information about cities with a rating higher than the average rating for all cities in that specific country.

```sql
SELECT c1.*
FROM city AS c1
WHERE rating > (
  SELECT AVG(rating)
  FROM city AS c2
  WHERE c1.country_id = c2.country_id
);
```

## The operator IN with correlated subqueries

Wow, cool! Now, remember the operator `IN`? It allowed us to specify a few values in the `WHERE` clause, so it worked a bit like the `OR` operator. Now, take a look:

```sql
SELECT *
FROM city
WHERE country_id IN (
  SELECT id 
  FROM country
  WHERE country.population - 40000 < city.population 
);
```

Can you predict what the above instruction does? It lists all cities from countries where the country's population exceeds the city's population by 40,000 or less.

### Exercise

Show all information about all trips to cities where the ratio of city area to trip duration (in days) is greater than 700.

```sql
SELECT *
FROM trip
WHERE city_id IN (
  SELECT id
  FROM city
  WHERE area / days > 700
);
```

## The operator EXISTS

Awesome! Let's learn another new operator, then. Consider the following:

```sql
SELECT *
FROM city
WHERE EXISTS (
  SELECT *
  FROM trip
  WHERE city_id = city.id
);
```

`EXISTS` is a new operator. It checks **if there are any rows that meet the condition**.

In our case, the whole query will show only information for cities where there is at least one trip (where there exists a trip) organized by our travel agency. Cities with no trips will not be shown.

### Exercise

Select all countries where there is at least one mountain.

```sql
SELECT *
FROM country
WHERE EXISTS (
  SELECT *
  FROM mountain
  WHERE mountain.country_id = country.id
);
```

## The operator EXISTS with NOT

Good! Remember the operator `NOT`? We can use it together with `EXISTS`. Take a look:

```sql
SELECT *
FROM city
WHERE NOT EXISTS (
  SELECT *
  FROM trip
  WHERE city_id = city.id
);
```

As you probably expect, this query will find all cities that don't have a trip organized to them.

### Exercise

Select all mountains with no hiking trips to them.

```sql
SELECT *
FROM mountain
WHERE NOT EXISTS (
  SELECT *
  FROM hiking_trip
  WHERE mountain_id = mountain.id
);
```

## The operator ALL in correlated subqueries

Good. Still remember the operator `ALL`? Let's use it in a correlated subquery.

```sql
SELECT *
FROM trip main_trip
WHERE price >= ALL (
  SELECT price
  FROM trip sub_trip
  WHERE main_trip.city_id = sub_trip.city_id
);
```

The above query looks for all trips which are the most expensive of all trips to that specific city. The instructions only choose trips with their price equal to or greater than all trip prices in the specific city.

### Exercise

Select the hiking trip with the longest distance (column `length`) for every mountain.

```sql
SELECT h1.*
FROM hiking_trip AS h1
WHERE h1.length >= ALL (
  SELECT h2.length
  FROM hiking_trip AS h2
  WHERE h2.mountain_id = h1.mountain_id
);
```

## The operator ANY in correlated subqueries

Okay! One more thing – you can also use the operator `ANY` in your correlated subqueries. Just take a look:

```sql
SELECT *
FROM hiking_trip
WHERE price < ANY (
  SELECT price FROM trip
  WHERE trip.days = hiking_trip.days
);
```

The above query compares city trips and hiking trips which last the same number of days. It then returns all hiking trips which are cheaper than any city trip of the same duration.

### Exercise

Select those trips which last shorter than any `hiking_trip` with the same price.

```sql
SELECT *
FROM trip
WHERE days < ANY (
  SELECT days
  FROM hiking_trip
  WHERE price = trip.price
);
```

## Subqueries in the FROM clause

Good job! Now, queries can also be used in other places. We can, for example, use a subquery instead of a table in the `FROM` clause.

```sql
SELECT *
FROM city, (
    SELECT *
    FROM country
    WHERE area < 1000
) AS small_country
WHERE small_country.id = city.country_id;
```

The above query finds cities from small countries. Of course, there is no table `small_country` in our database, so... we create it 'on the fly' with a subquery in the `FROM` clause. Of course, we need a name for it, so we use an alias with the keyword `AS`. In the end, the query shows cities together with their countries, provided that the country has an area below 1,000. Remember how selecting from two tables works? We need the condition in the `WHERE` clause, because otherwise each city would be shown together with every possible country.

### Exercise

Show mountains together with their countries. The countries must have at least 50,000 residents.

```sql
SELECT *
FROM mountain, (
    SELECT *
    FROM country
    WHERE population > 50000
) AS country_with_50k_residents
WHERE country_with_50k_residents.id = mountain.country_id;
```

Great! Of course, you can pick just a few columns in those queries. Study the following example:

```sql
SELECT
  name,
  days,
  price
FROM trip, (
  SELECT *
  FROM city
  WHERE rating = 5
) AS nice_city
WHERE nice_city.id = trip.city_id;
```

The above query finds trips and their respective cities for such cities which are rated 5. It then shows the columns `name`, `days`, `price` for these tables. When the tables have all columns with different names, then you may drop the table names (i.e. you can write `price` instead of `trip.price` because there is just one column `price` anyway).

### Exercise

Show hiking trips together with their mountains. The mountains must be at least 3,000 high. Select only the columns length and height.

```sql
SELECT length, height
FROM hiking_trip, (
  SELECT *
  FROM mountain
  WHERE height > 3000
) AS big_mountain
WHERE big_mountain.id = hiking_trip.mountain_id;
```

## Subqueries in the SELECT clause

Awesome! Subqueries can also be used within the column list in a `SELECT` clause. Here it's important that the subquery returns exactly **one row and column**.

Take a look:

```sql
SELECT
  name,
  (
    SELECT COUNT(*)
    FROM trip
    WHERE city_id = city.id
  ) AS trip_count
FROM city;
```

In the above query, we provide the name of each city together with the number of trips to that city. Notice that we use the function `COUNT()` to count the number of trips for each city.

### Exercise

Show each mountain name together with the number of hiking trips to that mountain (name the column `count`).

```sql
SELECT
  name,
  (
    SELECT COUNT(*)
    FROM hiking_trip
    WHERE mountain_id = mountain.id
  ) AS count
FROM mountain;
```














