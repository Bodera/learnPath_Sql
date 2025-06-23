# Advanced features of INSERT, UPDATE, and DELETE

Welcome to Part 2 of the course! Today, we'll teach you some advanced features of `INSERT`, `UPDATE`, and `DELETE` operations in SQL.

You will learn how to:

- Insert, update, and delete with `NULL`.
- Use the `IS NULL` operator in the `WHERE` condition of `INSERT`, `UPDATE`, and `DELETE` statements.
- Write `INSERT`, `UPDATE`, and `DELETE` statements with complicated conditions.
- Use expressions with mixed columns in INSERT, UPDATE, and DELETE queries.
- Insert data into a table using a `SELECT` query.

We're going to work with some data we've acquired from a **university** on its official examinations, which include written and oral exams. In the oral exam, points are often recorded immediately, while the written exam's result is recorded after the exam has been scored by the teacher.

Let's find out more.

## The student table

Select all columns from the student table. It's a pretty small table that contains only four columns:

- The student identifier (`id`).
- The first name of the student (`first_name`).
- The middle name of the student (`middle_name`).
- The last name of the student (`last_name`).

**Note**: Not every student has a middle name.

```sql
SELECT * FROM student;
```

| id | first_name | middle_name | last_name |
| --- | --- | --- | --- |
| 1  | Mark      | Johan       | Adams     |
| 2  | Angela    | null        | Smith     |
| 3  | Sophia    | null        | Williams  |
| 4  | Mary      | Linda       | Johnson   |
| 5  | Patricia  | null        | Davis     |
| 6  | James     | null        | Roger     |
| 7  | Edward    | Brian       | Barnes    |
| 8  | Kevin     | null        | Kelly     |
| 9  | Steven    | null        | null      |
| 10 | Laura     | Donna       | Ross      |

## The exam table

Select all columns from the exam table. Each exam in the table:

- Has an identifier (`id`).
- Corresponds to a student (`student_id`).
- Has a related subject (`subject`).
- Has a date (`written_exam_date` and `oral_exam_date`).
- Has a score (`written_exam_score` and `oral_exam_score`).
- Has a date when it was scored by the instructor (`written_score_date` and `oral_score_date`).

Subjects can have a written exam only, an oral exam only, or both written and oral exams.

```sql
SELECT * FROM exam;
```

| id | student_id | subject | written_exam_date | written_exam_score | written_score_date | oral_exam_date | oral_exam_score | oral_score_date |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1  | 1        | Mathematics | 2017-03-20 | 21 | 2017-03-30 | 2017-03-25 | 10 | 2017-03-25 |
| 2  | 1        | Spanish | 2017-03-22 | 10 | 2017-03-26 | 2017-03-24 | 8 | 2017-03-24 |
| 3  | 2        | Spanish | 2017-03-22 | null | null | null | null | null |
| 4  | 2        | English | 2018-07-02 | null | null | 2018-06-21 | 20 | 2018-06-22 |
| 5  | 3        | English | null | null | null | 2018-04-10 | 12 | null |
| 6  | 4        | English | 2018-04-10 | 15 | 2018-04-18 | null | 12 | null |
| 7  | 5        | Spanish | 2018-04-10 | 15 | 2018-04-18 | 2018-05-11 | 20 | 2018-05-12 |
| 8  | 6        | English | 2018-04-10 | 15 | 2018-04-18 | 2018-05-11 | null | null |
| 9  | 6        | Mathematics | 2018-05-22 | 30 | 2018-05-22 | null | null | null |
| 10 | 7        | Mathematics | null | null | null | 2018-05-11 | 20 | 2018-05-12 |
| 11 | 7        | Spanish | 2018-07-02 | null | null | 2018-06-21 | 20 | 2018-06-22 |
| 12 | 8        | English | 2018-07-02 | 21 | 2018-07-06 | 2018-06-21 | 20 | 2018-06-22 |
| 13 | 8        | Mathematics | 2017-03-20 | 17 | null | 2018-06-21 | 20 | 2018-06-22 |
| 14 | 9        | English | 2017-03-25 | 15 | 2017-03-27 | 2017-04-06 | 11 | 2018-04-10 |
| 15 | 10       | English | 2017-05-05 | 18 | 2017-05-17 | 2017-07-06 | 5 | null |
