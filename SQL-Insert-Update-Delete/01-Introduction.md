# Introduction

Welcome to our "How to INSERT, UPDATE, and DELETE Data in SQL" course, where you will learn how to manage data in SQL!

Data in any database is constantly changing. You will learn how to **add** new information to a database, **modify** database information, and **remove** information from a database.

We assume that you already know how to create SQL queries and how to work with them. If you don't, feel free to take a look at our SQL Basics course first.

We'll provide you with easy-to-understand examples based on a simple table named `user`:

`user (id, name, age)`

Each user has a unique `id`, a specific `name`, and an `age`. Easy, right?

To make things more exciting, though, you'll be working with another table, `dish`. Let's take a look at it.

`dish (id, type, name, price)`

```sql
SELECT * FROM dish;
```

| id | type | name | price |
| --- | --- | --- | --- |
| 1 | starter | Prawn Salad | 13 |
| 2 | starter | Spring Scrolls | 11 |
| 3 | main course | Asian Noodles | 25 |
| 4 | main course | Pork Roast | 32 |
| 5 | main course | Chicken Nuggets | 24 |
| 6 | main course | Pizza Italiana | 30 |
| 7 | dessert | Peach Cobbler | 10 |
| 8 | dessert | Cherry Brownies | 12 |

As you can see, the `dish` table contains information about meals in a restaurant whose owners couldn't decide on a single cuisine, so they basically put everything together.

In this digitized menu, each `dish` has a unique `id`, a specific `type` (there are starters, main courses, and desserts), a `name` that tells you what it actually is, and a certain integer `price`.

Hungry? Well, before you have something to eat, let's find out how to operate on the data.