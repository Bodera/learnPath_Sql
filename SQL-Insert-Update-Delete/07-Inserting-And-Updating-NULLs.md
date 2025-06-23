# Inserting and updating NULLs

## Review: Inserting partial data

Okay, let's get started! Previously in this course, we talked about how you can insert data into a table by providing values for only some of the columns.

For example, suppose the teacher would like to insert the date (November 10, 2018) of a written history exam for the student Tom Muller, `id = 11`, and the score of his oral history exam. This is not all the data that could be inserted into the table (we could insert the date of the oral exam, for example). Let's see how to write this query:

```sql
INSERT INTO exam (id, student_id, subject, written_exam_date, oral_exam_score) 
VALUES (16, 11, 'History', '2018-11-10', 20); 
```

After the table name (`exam`), only some of the column names (`id`, `student_id`, `subject`, `written_exam_date`, `oral_exam_score`) are listed. Likewise, only the values for those columns are given.

Recall that the database inserts `NULL`s into each column you omit in an `INSERT` statement. If you have several columns with `NULL`s, it is convenient to omit them.

Warning: Sometimes, the database will not allow you to add incomplete data.

### Exercise

Add a new student with `id = 11` to the student table. The teacher knows only his last name: **Barry**.
Don't use NULL when inserting this data.

```sql
INSERT INTO student (id, last_name) 
VALUES (11, 'Barry'); 
```

## Insert NULL into a column

You learn quickly — great! In SQL, we can also insert data into a table by listing all the column names. This requires us to include all values, both known and unknown.

Let's analyze a case from the university database. The teacher completes the list of students. He has to insert Tom Muller (`id = 12`), but Tom doesn't have a middle name. Look at the statement:

```sql
INSERT INTO student (id, first_name, middle_name, last_name)
VALUES (12, 'Tom', NULL, 'Muller');
```

In this situation, `NULL` helps the teacher insert the record for the unknown value.

Since this command defines values for all columns in the table, you can simply use it this way:

```sql
INSERT INTO student 
VALUES (12, 'Tom', NULL, 'Muller');
```

Which syntax should you choose: the first one or the shorter second one? It's entirely up to you! If you want to emphasize that you inserted a `NULL` value, insert it explicitly. If you want to save on typing, omit the column name.

### Exercise

Add info about Tom Muller's written math exam to this table. You know only the exam ID (`17`), the student ID (`12`), Tom's score on the written exam (`12`), the date of the written exam (**October 14, 2018**), and when the exam was scored *(October 16, 2018*).

The other column values are unknown.

Note: Use this format for the date: `YYYY-MM-DD`. Here, `YYYY` is a year with 4 digits, `MM` is a month with 2 digits, and `DD` is a day with 2 digits. For May 12, 2017, we'd write `'2017-05-12'`.

```sql
INSERT INTO exam (id, student_id, written_exam_score, written_exam_date, written_score_date) 
VALUES (17, 12, 12, '2018-10-14', '2018-10-16');
```

## UPDATE with NULL in SET

Fantastic! You already know how to insert data with `NULL`s. You can also use `NULL` in `UPDATE` statements.

Suppose the teacher made a mistake. Tom Muller took the written exam, but the teacher hasn't checked this exam (exam ID of `17`). Nevertheless, Tom has the score of the written exam (`written_exam_score`) and the date (`written_score_date`), but he shouldn't. In this case, the only known value is the actual date of the written exam; you must move the other two values. How would you do this?

It's simple! Look at the command below:

```sql
UPDATE exam 
SET 
  written_exam_score = NULL, 
  written_score_date = NULL
WHERE id = 17;
```

After `SET`, we used two comma-separated column names to update `written_exam_score` and `written_score_date`. Each column was assigned NULL. In the WHERE condition, we update only the exam with id = 17. In this way, we correct our mistake.

### Exercise

In the database, the teacher stores the student name Laura Donna Ross (`id = 10`). However, Laura doesn't have a middle name; Donna is a mistake. Correct this mistake by updating the data.

```sql
UPDATE student 
SET 
  middle_name = NULL
WHERE id = 10;
```

## IS NULL in UPDATE

Very nice! You're familiar with using `NULL` in an `UPDATE` operation. However, sometimes we need to complete data that has some information missing. For example, say that students' written exams have been scored, but we haven't recorded the date when the exams were scored. The teacher would like to assign the date `2018-11-20` to the relevant column. Look at the command that will resolve this problem:

```sql
UPDATE exam
SET written_score_date = '2018-11-20'
WHERE written_score_date IS NULL
  AND written_exam_score IS NOT NULL;
```

In `SET`, we assign a new value to the `written_score_date` column. However, this value will be changed only when there is a `NULL` in the column and the written exam score is not `NULL`. The `IS NULL` allows us to check that.

### Exercise

Some students didn't receive any scores on a written exam—the teacher forgot to enter their scores. Correct this mistake by assigning all missing written exam values a score of `43`.

```sql
UPDATE exam 
SET written_exam_score = 43
WHERE written_exam_score IS NULL;
```

## IS NULL in DELETE

Great! You know how to use `IS NULL` in an `UPDATE` statement. Now it's time to get familiar with `IS NULL` in another statement: `DELETE`. The command below explains why it is sometimes worth using `IS NULL` with `DELETE`:

```sql
DELETE FROM student
WHERE last_name IS NULL;
```

This command removes all students without a last name from the database. A last name is a very important way to identify a student, and a record without it is not useful. Here, we use `IS NULL` to check if the `last_name` column has a `NULL` in it. The query leaves only student records with existing last names in the database.

### Exercise

A group of students weren't scored on an oral exam, so the exam was canceled. The results from this exam have to be removed. Write a query to remove these records.

```sql
DELETE FROM exam
WHERE oral_exam_score IS NULL;
```
