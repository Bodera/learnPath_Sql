# Date and time functions

Study date and time functions and learn how to select events from a period of time.

Welcome to Part 4. Today, we're going to get you familiarized with **date and time in SQL**. You might have taken our course – **Creating Tables in SQL** – and if you have, then you will already know some of the things discussed here. But don't worry, both beginners and more advanced users will find something useful.

## Table route

Good. Let's introduce the tables we're going to work with. A European airline called **PerfectAir** provided some of its data to us. Let's see what we have received from them.

### Exercise

Select **all** the information for the table `route`.

```sql
SELECT * FROM route;
```

The table `route` keeps track of the destinations offered by **PerfectAir**. Each **route** has:

- an ID `code` used for identification.
- the international code of the **departure airport** (`from_airport`).
- the international code of the **arrival airport** (`to_airport`).
- total distance of the route (`distance`) expressed in **kilometers**.
- `departure` which stores the scheduled **time** of **departure**.
- `arrival` containing information about planned **time** of **arrival**.

Keep in mind that both of the time values are shown in **Central European Time**.

## Table aircraft

Select **all** the information for the table `aircraft`.

```sql
SELECT * FROM aircraft;
```

**PerfectAir** has its own fleet and each aircraft is listed in the table. An **aircraft** has an `ID` and `model`. The table also stores columns:

- `produced` – when the production of the aircraft was officially completed and the aircraft was sold.
- `launched` – when the aircraft took its first flight for PerfectAir.

These two dates may differ significantly when, e.g., PerfectAir bought a used aircraft. You may have noticed that `launched` is a more accurate column (it shows the time too). This is because PerfectAir wants to note the exact point in time when the aircraft took off the ground for the first time.

The last column is `withdrawn` – an exact point in time where the aircraft landed for the last time before it was retired.

## Table flight

Select **all** the information for the table `flight`.

```sql
SELECT * FROM flight;
```

This table lists specific **flights** (`id`) on a specific **route** (`route_code`) with a specific **aircraft** (`aircraft_id`) on a specific **date** (`date`).

The `delay` column is expressed in **minutes**. A positive value in this column means that the arrival was indeed delayed. A negative value indicates that the plane landed ahead of schedule.

## Dates in SQL

Okay! Let's get down to work. As you may or may not remember, our database can store **dates**. Let's see how they're represented.

### Exercise

Select the column `produced` from the table `aircraft` and take a look at the **date** format.

```sql
SELECT produced
FROM aircraft;

-- 2021-02-12
```

## Date format explained

Good. As you can see, **dates** are shown in the following format: **YYYY-MM-DD**. First we provide the **year**, then the **month**, finally the **day**. Be aware, though, that some databases may use other formats, depending on the database configuration. If we want to use dates in our queries, then we need to provide them within apostrophes:

```sql
SELECT
  id,
  model
FROM aircraft
WHERE produced = '2012-04-05';
```

The above query will select the `id` and `model` of all the **aircraft** produced on **April 5, 2012**.

### Exercise

Select the columns `id`, `model` and `produced` for those aircraft which were produced on **April 6, 2008** or **March 1, 2010**.

```sql
SELECT
  id,
  model,
  produced
FROM aircraft
WHERE produced = '2008-04-06' OR produced = '2010-03-01';
```

## Dates with logical operators

Good. It is also quite easy to use **dates** with logical operators other than the equality sign. Take a look at the following example:

```SQL
SELECT
  id,
  model,
  produced
FROM aircraft
WHERE produced > '2010-12-31';
```

In SQL, a date which is "**greater than**" **2010-12-31** means that you will get all the production dates after that date (i.e., from **2011-01-01 until today**). Similarly, putting the "**less than**" sign instead (`<`) will show older dates.

### Exercise

Select the columns `id`, `model`, `produced` for all the aircraft which were produced after **December 31, 2012**.

```sql
SELECT
  id,
  model,
  produced
FROM aircraft
WHERE produced > '2012-12-31';
```

## Dates with BETWEEN

That's it. Of course, you can also use dates with `BETWEEN`. In this way, you can for instance find production dates in a specific year:

```sql
SELECT
  id,
  model,
  produced
FROM aircraft
WHERE produced BETWEEN '2010-01-01' AND '2010-12-31';
```

The above query will find all the aircraft produced **between** January 1, 2010 and December 31, 2010, **including** these dates.

### Exercise

Select the `id` and `date` of all flights which did **NOT** take place in **2015**.

```sql
SELECT
  id,
  date
FROM flight
WHERE date NOT BETWEEN '2015-01-01' AND '2015-12-31';
```

## Dates with ORDER BY

Nice job. You can also sort your rows by date using `ORDER BY`:

```sql
SELECT
  id,
  model,
  produced
FROM aircraft
WHERE produced BETWEEN '2010-01-01' AND '2010-12-31'
ORDER BY produced;
```

As usual, you can add `ASC` or `DESC` after the `ORDER BY` clause to set the sorting order.

### Exercise 1

Select the `id` and `date` of all flights in **2015** and sort them with the newest dates coming first.

```sql
SELECT
  id,
  date
FROM flight
WHERE date BETWEEN '2015-01-01' AND '2015-12-31'
ORDER BY date DESC;
```

### Exercise 2

For each aircraft produced in **2010**, show its `id`, **production date** and the **distinctive codes of routes** they operate on (rename the column to `route_code`).

```sql
SELECT DISTINCT
  a.id,
  a.produced,
  f.route_code
FROM aircraft a
JOIN flight f ON a.id = f.aircraft_id
WHERE produced BETWEEN '2010-01-01' AND '2010-12-31';
```

## Time in SQL

Good! Apart from dates, our database can also store time. At PerfectAir, time columns are used in the table `route` to indicate the estimated time of **departure** and **arrival** in **Central European Time**. Let's see how time is represented there.

### Exercise

Select the column `departure` from the table `route`.

```sql
SELECT
  departure
FROM route;

-- 14:25:00
```

## Time with logical operators

As you can see, the format for this type of data is **hh:mm:ss**, where **hh** stands for **hours**, **mm** for **minutes** and **ss** for **seconds**. This type of column requires apostrophes, just like dates.

```sql
SELECT
  code,
  departure
FROM route
WHERE arrival = '14:25:00';
```

**Time** requires the use of a **24-hour** system (i.e., you should write **14:25** instead of 2:25 PM and **03:10** instead of 3:10 AM etc.). You can also use other comparison signs: `<`, `<=`, `>`, `>=`, `!=`.

**Note**: The **Oracle** database does not support the data type **time**, even though it is in **SQL** Standard.

### Exercise

Show the `code` of the **route** with the scheduled arrival time of **9:30 AM**.

```sql
SELECT
  code
FROM route
WHERE arrival = '09:30:00';
```

## Time with BETWEEN

That's right. You can also use `BETWEEN` with time:

```sql
SELECT
  code,
  departure
FROM route
WHERE arrival BETWEEN '12:00:00' AND '15:00:00';
```

Just like with dates, remember that `BETWEEN` is **inclusive** – routes which depart at **12:00 Noon** or **3:00 PM** sharp will be included in the results.

### Exercise

Show the `code` of all the routes which depart **between** 11:00 AM and 5:00 PM.

```sql
SELECT
  code
FROM route
WHERE departure BETWEEN '11:00:00' AND '17:00:00';
```

## Time with ORDER BY

Good! And the last thing, you can also sort by time.

```sql
SELECT
  code,
  departure
FROM route
ORDER BY arrival DESC;
```

Just like with dates again.

### Exercise 1

Show the `code` and `arrival` time of all the routes with arrival **before 4:00 PM** and order them by arrival with the earliest time coming first.

```sql
SELECT
  code,
  arrival
FROM route
WHERE arrival < '16:00:00'
ORDER BY arrival;
```

### Exercise 2

Show the **average distance** of all routes which depart after **8:00 AM**. Name the column `average`.

```sql
SELECT
  AVG(distance) AS average
FROM route
WHERE departure > '08:00:00';
```

## Timestamps

Perfect! Apart from the date or time itself, our database can also store dates with exact time. We call them **timestamps**. Let's see what they look like.

### Exercise

Select the column `launched` from the table `aircraft` and note how **timestamps** are displayed.

```sql
SELECT
  launched
FROM aircraft;

-- 2014-06-10 07:55:00+00
```

## Timestamps explained

Good. Did you take a look at the format? Let's analyze it:

```sql
'2014-06-10 07:55:00+02'
```

The first part is, of course, the **date**, and the second part is **time**. The final `'+02'` refers to the timezone - in this case it means that we are two hours ahead of UTC. The timestamp format depends on database configuration.

You can compare two timestamp columns, just like this:

```sql
SELECT id
FROM aircraft
WHERE withdrawn < launched;
```

The above query could be used to check for typos in our table – this way, we can make sure there is no aircraft which was **withdrawn** from service before it was even **launched**.

### Exercise

**Run the template query** and find out for yourself whether there are erroneous entries in the table `aircraft`.

```sql
SELECT id
FROM aircraft
WHERE withdrawn < launched;
```

## Timestamps with constant values

We detected a mistake in the table, thank you for your help.

**Timestamps** are a very precise way to define a point in time. This is why using the **equality sign** (`=`) with them isn't a good idea. Two timestamps may differ by a single second and the condition on equality will not be satisfied. Still, you can use comparisons with `>`, `<`, `!=` etc. to compare two columns (just as you did) or a column compared to a constant value. Do we have to be very precise when providing the constant value? Not really. Take a look:

```sql
SELECT
  id,
  launched
FROM aircraft
WHERE launched > '2015-01-01';
```

As you can see, we compared a **timestamp** with a **date**. How is this possible? Well, our database converts the date we provided to a timestamp by adding as many zeroes as necessary. For instance:

- `'2015-01-01'` will become `'2015-01-01 00:00:00'`,
- `'2014-02-12 12:00'` will become `'2014-02-12 12:00:00'`.

Convenient, isn't it?

### Exercise

Identify the `id` and **withdrawn timestamp** for all the aircraft withdrawn on or after **October 15, 2015**. The column names should be `id` and `withdrawn`.

```sql
SELECT
  id,
  withdrawn
FROM aircraft
WHERE withdrawn >= '2015-10-15';
```

## Timestamps with BETWEEN

Nice job. As you may expect, it is also possible to use `BETWEEN` with timestamps:

```sql
SELECT id
FROM aircraft
WHERE launched
BETWEEN '2015-11-01' AND '2015-12-01';
```

Again, we can skip the time – the database will fill in the missing fields with zeroes.

This automatic addition of zeroes is very convenient, but you need to watch out when retrieving rows for the whole month, year etc. If you want the aircraft launched in **November 2015**, you must use the condition we've just shown you:

```sql
BETWEEN '2015-11-01' AND '2015-12-01'
```

The second date is **December 1** because the database will add the missing zeroes: `2015-12-01 00:00:00`. This is the exact point in time when December starts (the beginning of its first day). If you wrote the second date as the last day of November (`2015-11-30`), you would skip all the aircraft which were launched on **November 30, 2015**. Keep that in mind.

### Exercise

Find all the aircraft which were launched in **2015**. Show the columns `id` and `launched`.

```sql
SELECT
  id,
  launched
FROM aircraft
WHERE launched
BETWEEN '2015-01-01' AND '2016-01-01';
```

## Timestamps with ORDER BY

Very well done! The last thing you should know about timestamps is that you can also sort them with `ORDER BY`:

```sql
SELECT
  id,
  launched
FROM aircraft
ORDER BY launched;
```

Of course, you can use `DESC` or `ASC` after `ORDER BY`.

### Exercise 1

For all the aircraft launched in **2013** or **2014**, show their `id` and **launch date**. Sort by the column `launched` from the newest to the oldest dates.

```sql
SELECT
  id,
  launched
FROM aircraft
WHERE launched
BETWEEN '2013-01-01' AND '2015-01-01'
ORDER BY launched DESC;
```

### Exercise 2

For each aircraft, show its `id` as `aircraft_id` and calculate the **average distance** (call it `average`) covered on all its routes. Only take into account those aircrafts which were launched **before January 1, 2014** and took more than **1 flight**.

```sql
SELECT
  aircraft_id,
  AVG(distance) AS average
FROM flight
  JOIN route ON flight.route_code = route.code
WHERE aircraft_id IN (
  SELECT id
  FROM aircraft
  WHERE launched < '2014-01-01'
)
GROUP BY aircraft_id
HAVING COUNT(*) > 1;
```

## EXTRACT(field FROM column)

Correct again! Now, let's see how we can manipulate dates, times and timestamps. SQL provides a special function: `EXTRACT(field FROM column)`. Here `field` is one of the following: `DAY`, `MONTH`, `YEAR`, `HOUR`, `MINUTE`, `SECOND`.

Take a look:

```sql
SELECT EXTRACT(YEAR FROM launched) AS year
FROM aircraft
ORDER BY year;
```

The above query will extract the **year** from the column `launched` for each aircraft and will show it in ascending order.

The function `EXTRACT` is not supported by **SQL Server**. **SQL Server** has a similar function called `datepart`.

### Exercise

Extract and show the **month** of each **withdrawn date** in the table `aircraft` (name the column `month`). Show the column `withdrawn` as the second column for reference.

```sql
SELECT
  withdrawn,
  EXTRACT(MONTH FROM withdrawn) AS month
FROM aircraft;
```

## EXTRACT – example

Great. How can we use this function? For instance, we can use it to change the way dates are shown. Take a look:

```sql
SELECT
  EXTRACT(DAY FROM launched) ||
  '-' ||
  EXTRACT(MONTH FROM launched) ||
  '-' ||
  EXTRACT(YEAR FROM launched)
FROM aircraft;
```

As a result, we'll get dates like `'10-03-2012'` instead of `'2012-03-10'`. But the query itself… Ugh… this doesn't look very nice.

This is why various databases implement new functions to work with time and date. These functions make such operations easier. However, there is no universal way which would work across most databases. This is why we won't show any of them here.

### Exercise

For each **route**, show its `code` and the **departure time** in the following, changed format: **hh.mm**, where **hh** is the **hour** and **mm** the **minutes**. Name the second column `time`.

```sql
SELECT
  code,
  EXTRACT(HOUR FROM departure) ||
  '.' ||
  EXTRACT(MINUTE FROM departure) AS time
FROM route;
```

## EXTRACT with a wrong data type

All right. You may wonder what happens when you try to extract a field which is not present in the given type. Is it possible to extract a **year** from a **time** column? Let's find out.

### Exercise

For each route, try to extract the **year** from the `arrival` column and see what happens.

```sql
SELECT EXTRACT(YEAR FROM arrival) AS year
FROM route
```

Output:

```
ERROR: "time" units "year" not recognized Line: 1 Position in the line: 1
```

## EXTRACT with a wrong data type – continued

Error! That's what you got, as you could have expected. It's not possible to extract any part of date from a time column … But it's possible to extract a field of **time** from a **date** column. It will just provide a zero. Let's give it a try.

### Exercise

For each flight, show its `id`, `date`, and the **hour** extracted from the field `date` (name the column `hour`).

```sql
SELECT
  id,
  date,
  EXTRACT(HOUR FROM date) AS hour
FROM flight;
```

## AT TIME ZONE

Nice work. Another thing we want to introduce is conversion between various time zones. As you know, the table `route` provides the **departure** and **arrival** times in **Central European Time**. Let's see how we can show the arrival time in the arrival airport time zone for a flight from Madrid to Tokyo:

```sql
SELECT arrival AT TIME ZONE 'Asia/Tokyo'
FROM route
WHERE from_airport = 'MAD'
  AND to_airport = 'NRT';
```
As you can see, we need to write `AT TIME ZONE` followed by the **timezone** in apostrophes. In our database, we usually provide the time zone in the format **Continent/City**, but you need to watch out, because some databases have other conventions.

**MySQL** uses the function `convert_tz` to convert timestamps between various timezones.

### Exercise 1

For the route from **Keflavik** (`KEF`) to **Gdansk** (`GDN`), show the **departure time** from Keflavik in local time for Gdansk (**Europe/Warsaw**). Name the column `local_time`.

```sql
SELECT
  departure AT TIME ZONE 'Europe/Warsaw' AS local_time
FROM route
WHERE from_airport = 'KEF'
  AND to_airport = 'GDN';
```

### Exercise 2

For each route with a distance **greater** than **600 km**, show its `code` and its **departure** and **arrival** at the **local time for Tokyo, Japan**. Name the last two columns `local_departure` and `local_arrival`.

```sql
SELECT
  code,
  departure AT TIME ZONE 'Asia/Tokyo' AS local_departure,
  arrival AT TIME ZONE 'Asia/Tokyo' AS local_arrival
FROM route
WHERE distance > 600;
```

## Difference between timestamps

Great, let's move on. Our database can add and subtract dates. Take a look:

```sql
SELECT withdrawn - launched
FROM aircraft;
```

The above query will calculate the difference between the columns `withdrawn` and `launched`. What will the result look like? Let's find out.

### Exercise

```sql
SELECT withdrawn - launched
FROM aircraft;
```

Output:

| ?column? |
| --- |
| null |
| null |
| 2021 days 22:02:00 |
| null |
| 1673 days 23:16:00 |
| -365 days |
| null |
| 288 days 14:39:00 |
| 597 days 17:26:00 |
| null |
| null |

## INTERVAL YEAR TO MONTH

The results we got are intervals: **1307 days 23:16:00** tells us that the difference between the two timestamps is **1307 days**, **23 hours** and **16 minutes**. This is the result we got in our database (**PostgreSQL**), but be aware that other databases may return something else (like the number of milliseconds between these two dates, for instance).

The standard of SQL provides two types of intervals. One of them is `INTERVAL 'x-y' YEAR TO MONTH`, where **x** is the number of years and **y** is the number of months. You can add such an interval to a date/timestamp:

```sql
SELECT
  id,
  launched + INTERVAL '1-2' YEAR TO MONTH
FROM aircraft;
```

The above query will add **1 year** and **2 months** to each launched timestamp in the table `aircraft`.

Among popular databases, only **MySQL** does not support this syntax and has an alternative one: `INTERVAL '1-2' YEAR_MONTH`.

### Exercise

PerfectAir decided to use the withdrawn aircraft (`id = 5`). Show its `id`, its original **withdrawn date** and the **withdrawn date postponed** by 1 year and 6 months. Name the last column `changed_date`.

```sql
SELECT
  id,
  withdrawn,
  withdrawn + INTERVAL '1-6' YEAR TO MONTH AS changed_date
FROM aircraft
WHERE id = 5;
```

## INTERVAL DAY TO SECOND

Good. The second type of interval specified by the SQL standard is `INTERVAL 'd hh:mm:ss' DAY TO SECOND`, where `d` is the number of days, `hh` is the number of hours, `mm` is the number of minutes and `ss` is the number of seconds.

This interval can also be applied with a **date/timestamp** column to add/subtract a certain period of time:

```sql
SELECT
  id,
  launched + INTERVAL '1 2:05:20' DAY TO SECOND
FROM aircraft;
```

The above query will add **1 day**, **2 hours**, **5 minutes** and **20 seconds** to the timestamp in the column `launched` and return it as a result. So for example the timestamp `2010-04-01 21:58:00+02` would be turned into `2010-04-03 00:03:20+02`.

Again, **MySQL** has an alternative syntax: `INTERVAL '1 2:05:20' DAY_SECOND`.

### Exercise

Before the official launch, every plane has a **14-day** test period. However, some planes, due to complications with paperwork may be held for a few hours longer than usual, before they can officially take off.

For plane with ID of **4**, show the original launch timestamp and the timestamp of when its test period began (it lasted exactly **14** days, **8** hours, **41** minutes and **16** seconds). Name the second column `test_date`.

```sql
SELECT
  launched,
  launched - INTERVAL '14 8:41:16' DAY TO SECOND AS test_date
FROM aircraft
WHERE id = 4;
```

## INTERVAL 'x' FIELD

Okay! There is one more syntax for intervals. It is not in SQL Standard, but most databases support it. The syntax is as follows:

- INTERVAL '2' HOUR
- INTERVAL '3' DAY
- INTERVAL '5' MONTH
- INTERVAL '1' YEAR
- etc.

In **MySQL** you use the syntax without the apostrophes: `INTERVAL 2 HOUR`, `INTERVAL 3 DAY`, etc.

As usual, you can add such intervals to a timestamp/date (or subtract it):

```sql
SELECT id,
  launched + INTERVAL '3' MONTH
FROM aircraft;
```

The above query will add **3 months** to the timestamp stored in the column `launched`.

### Exercise

PerfectAir has changed its schedules. All flights which depart after **1:00 PM** have been **delayed by 1 hour**. Show the `code` of each route together with the **new departure** (as `new_departure`) and arrival times (as `new_arrival`).

```sql
SELECT
  code,
  departure + INTERVAL '1' HOUR AS new_departure,
  arrival + INTERVAL '1' HOUR AS new_arrival
FROM route
WHERE departure > '13:00:00';
```

## INTERVAL with constant values

Good! You can also use intervals with a constant value which you provide on your own. There is, however, one catch. Try to run the example we've prepared for you.

### Exercise

The query will fail. We'll explain why in the next exercise but maybe you'll guess why it failed. :)

```sql
SELECT '2015-01-01' + INTERVAL '5' DAY;
```

Output:

```
ERROR: invalid input syntax for type interval: "2015-01-01" Line: 1 Position in the line: 8
```

## INTERVAL with constant values – continued

The addition failed because our database thinks that **'2015-01-01'** is a common text value (`string`) and it's not able to add an interval to a text field. What can we do then? We can explicitly convert `'2015-01-01'` to a **date/timestamp**:

```sql
SELECT CAST('2015-01-01' AS timestamp) + INTERVAL '5' DAY;
```

Let's see if it works.

### Exercise

```sql
SELECT CAST('2015-01-01' AS timestamp) + INTERVAL '5' DAY;
```

Output:

| ?column? |
| -------- |
| 2015-01-06 00:00:00 |

## INTERVALs with comparison operators

Fine! The query worked this time.

Intervals are typically used with the comparison operators (e.g. `>`, `>=`) to select facts from a given day, month, year etc. Take a look:

```sql
SELECT id
FROM aircraft
WHERE produced >= '2010-01-01'
  AND produced < CAST('2010-01-01' AS date) + INTERVAL '1' YEAR;
```

The above query will look for aircraft produced in **2010**. Note that we needed to use `CAST` when adding an interval.

### Exercise

Show the `id` and the `model` for all the aircraft produced in **2014** and **2015**.

```sql
SELECT
  id,
  model
FROM aircraft
WHERE produced >= '2014-01-01'
  AND produced <= CAST('2014-01-01' AS date) + INTERVAL '1' YEAR;
```

## INTERVALs with comparison operators – additional practice

Good job. Comparison operators are often used with intervals when we want to find facts for a specific month. We no longer need to check whether a given month has 28, 29 (February), 30 or 31 days, the database will do that for us.

```sql
SELECT id
FROM aircraft
WHERE produced >= '2010-01-01'
  AND produced < CAST('2010-01-01' AS date) + INTERVAL '1' MONTH;
```

Check it out for yourself!

### Exercise

**Count** the number of flights performed in **August 2015**. Name the column `flight_no`.

```sql
SELECT COUNT(*) AS flight_no
FROM flight
WHERE date >= '2015-08-01'
  AND date < CAST('2015-08-01' AS date) + INTERVAL '1' MONTH;
```

## Current_date, current_time and current_timestamp

Good. Okay, let's move on – now we'll learn a practical application for intervals. But let's start from the beginning.

Our database knows the current date and time. It has three functions which can come in handy:

- `current_date` returns the current date.
- `current_time` return the current time.
- `current_timestamp` returns the current date with time and timezone.

Note that we don't use parentheses `()` after the function name, even though we indeed use a function. You can use them in the following way:

```sql
SELECT current_date, current_time, current_timestamp;
```

Shall we give it a try?

### Exercise

Run the template query and analyze the result.

The functions `current_date`, `current_time`, and `current_timestamp` return the current time for the **database server** (in our case: **UTC**). Depending on where you are, this may or may not be the same as your local time.

```sql
SELECT
  current_date,
  current_time,
  current_timestamp;
```

## Current date & time with intervals

All right. How can we use these functions in our queries? We can use them to find facts which took place in the last week, last month etc. Take a look:

```sql
SELECT id
FROM flight
WHERE date > CURRENT_DATE - INTERVAL '7' DAY;
```

The above query will find all flights which took place in the last **7 days**.

We use the structure `INTERVAL 'x' UNIT` where **x** is the number and *UNIT* is `SECOND`, `MINUTE`, `HOUR`, `DAY`, `MONTH` or `YEAR`. Our database takes the current date and puts it back **7 days**.

### Exercise 1

Find the `id` of all the aircraft which were produced **earlier** than **3 months ago**.

```sql
SELECT id
FROM aircraft
WHERE produced < CURRENT_DATE - INTERVAL '3' MONTH;
```

### Exercise 2

Find the `code` of all the routes which normally depart within **3 hours** from the **current time**.

```sql
SELECT code
FROM route
WHERE departure BETWEEN CURRENT_TIME AND CURRENT_TIME + INTERVAL '3' HOUR;
```

## Summary

Fantastic job! It's time to review what we know about date and time.

- SQL features **dates** (`'2010-01-01'`), **times** (`'13:00:00'`) and **timestamps** (`'2010-01-01 13:00:00'`).
- You can **compare** the above types, use `BETWEEN`, and `ORDER BY` with them.
- The function `EXTRACT(DAY FROM column)` extracts certain parts of date/time.
- Use `AT TIME ZONE` switches between time zones.
- `INTERVAL '7' DAY` is an interval of 7 days which you can add to or subtract from a timestamp/date.
- `INTERVAL '2-1' YEAR TO MONTH` is another type of interval, this one is an interval of 2 years and 1 month.
- For current date and time, you can use `CURRENT_DATE`, `CURRENT_TIME` or `CURRENT_TIMESTAMP`.

## Quiz

Are you ready to practice?

### Exercise 1

Show the `code`, `from_airport`, and `to_airport` for all those routes which **depart** between 9:00 AM and 3:00 PM.

```sql
SELECT
  code,
  from_airport,
  to_airport
FROM route
WHERE departure BETWEEN '09:00:00' AND '15:00:00';
```

### Exercise 2

For all the flights which took place on **July 11, 2015**, show the `from_airport`, `to_airport`, and the `model` of the aircraft.

```sql
SELECT
  from_airport,
  to_airport,
  model
FROM flight
JOIN route ON flight.route_code = route.code
JOIN aircraft ON flight.aircraft_id = aircraft.id
WHERE date = '2015-07-11'
```

### Exercise 3

Calculate the **average delay time** for all the flights which took place in **August** (any year).

```sql
SELECT
  AVG(delay)
FROM flight
WHERE date BETWEEN '2015-08-01' AND '2015-08-31';
```

### Exercise 4

For **each** route, show its `code` together with the **number of flights** on that route and the **average delay** on that route. Only take into account flights **older than 6 months**. Don't show the routes with zero flights on it or `NULL` average delay. The column names should be: `code`, `count`, and `avg`.

```sql
SELECT
  code,
  COUNT(*),
  AVG(delay)
FROM flight
JOIN route ON flight.route_code = route.code
WHERE date < CURRENT_DATE - INTERVAL '6' MONTH
GROUP BY code
HAVING COUNT(*) > 0 AND AVG(delay) IS NOT NULL;
```

### Exercise 5

**Group** all the flights by the **year**. Show the **year** (as `year`) and calculate the **average delay time** for each of those years (as `avg`).

```sql
SELECT
  EXTRACT(YEAR FROM date) AS year,
  AVG(delay)
FROM flight
GROUP BY year;
```

### Exercise 6

**Count** the **number of distinct aircraft** which were used during flights in **August 2015**. Name the column `aircraft_no`.

```sql
SELECT
  COUNT(DISTINCT aircraft_id) AS aircraft_no
FROM flight
WHERE date BETWEEN '2015-08-01' AND '2015-08-31';
```

## Congratulations

Congratulations, six correct answers! You now really know dates and time inside out!

That's the end of Part 4. See you in Part 5 devoted to `NULL`s!
