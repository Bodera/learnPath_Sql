# Relational databases

## Welcome
Welcome to our SQL Basics course. In this course, you will get to know how to talk to databases.

What is a database exactly? To put it simply, it's a computer program which stores various data. There are quite a few database vendors, e.g., Oracle, MySQL, PostgreSQL, SQL Server, and many others. Chances are some of these names already sound familiar to you – after all, databases can be found literally everywhere!

There are various types of databases. In this course, we're going to focus on relational databases – they're a very frequent choice in the contemporary IT world.

Let's find out about how relational databases are organized.

## Tables

Every relational database stores information in tables. You can have many tables in one database and each of your tables will hold data which refers to similar objects. Each table has a name, so you can find out what kind of information is stored there.

For example, the database of your university would include a table named `student` with all data regarding students, another table `subject` with information on the subjects at your university, etc.

## Columns and rows

Tables in databases look exactly the way you would imagine a normal table – they have **columns** and **rows**.

Columns in every table have their **names**, and they identify the kind of information is stored in them.

Each row stores information about one object. In the `student` table below, you can see that the column names reflect the kind of data contained in them, so in the column `name` there are names of students, in the column `graduation_year` there is the year of their graduation, etc.

Each **row** corresponds to exactly one student.

| id | name           | year_born | graduation_year  |
|:---:|:--------------:|:---------:|:----------------:|
| 1  | Kyle Lawson    | 1992      | 2015             |
| 2  | Santiago Knox  | 1991      | 2015             |
| 3  | Arian Sheppard | 1990      | 2013             |
| 4  | Samuel Foster  | 1991      | 2014             |
| 5  | Hayden Smith   | 1986      | 2010             |

## SQL

So, how do we get in touch with our database? We use the so-called **Structured Query Language**. Of course, no one uses the full name, we just call it **SQL** for short.

All relational databases understand SQL, but each of them has a slightly different dialect, so to speak.

In this course, you will learn the basics of the standard SQL which will be understood by every relational database. Thanks to SQL, you'll be able to make queries in each database environment.

## Queries

The instructions that we'll learn in this course are called queries. Just as the name suggests, queries are questions that we ask to find out some information about the data stored in the database.

Databases can do amazing things – they don't only return the data you ask for, they can actually do advanced calculations on the tables. You'll see for yourself!

We'll start with very simple instructions, and we'll introduce new things one by one. By the end of this course, you'll be able to write fairly complex queries.