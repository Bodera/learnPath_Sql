# Inserting data from a query

## INSERT INTO ... SELECT

Very nice! You've been using this syntax to insert data: `INSERT INTO ... VALUES`. But what if you would like to **insert values from another table**? SQL provides special syntax for this:

```sql
INSERT INTO student_history(id, first_name, last_name)
SELECT id, first_name, last_name
FROM student;
```

Instead of a `VALUES` clause with a list of values, we use a `SELECT` query. In this way, the `id`, `first_name`, and `last_name` values for all students were put into the `student_history` table — in one `INSERT` query. It’s a very convenient solution for copying data from one place to another.

### Exercise

The university wants to have a list of **all oral exams in which students got more than 20 points**. They want it in a new table, `report_good_oral_exams`.

Use the `id`, `student_id`, and `subject` columns from the `exam` table to put data into `exam_id`, `student_id`, and `subject` columns in the `report_good_oral_exams` table.

```sql
INSERT INTO report_good_oral_exams (exam_id, student_id, subject)
SELECT id, student_id, subject
FROM exam
WHERE oral_exam_score > 20;
```

## INSERT INTO ... SELECT with GROUP BY

Great! Now try to insert data using `INSERT INTO ... SELECT` with `GROUP BY`.

### Exercise

This time, the university needs a list of average results of written and oral exams in each subject (from the `exam` table).

The new table, `report_average_scores` consists of the following columns: `subject`, `avg_written_exam_score`, and `avg_oral_exam_score` (which are of type `DECIMAL(4,2)`).

Help the university insert data into the `report_average_scores` table.

```sql
INSERT INTO report_average_scores (subject, avg_written_exam_score, avg_oral_exam_score)
SELECT subject, AVG(written_exam_score), AVG(oral_exam_score)
FROM exam
GROUP BY subject;
```

## Summary

Amazing! Let's summarize what we've learned.

We can:

- Insert data using `NULL`s for unknown values in a row:

```sql
INSERT INTO student 
VALUES (21, 'Tom', NULL, 'Muller');
```

- Change values using `NULL` and UPDATE:

```sql
UPDATE exam 
SET written_exam_score = NULL
WHERE id = 5;
```

- Change a value in a column or delete a row if the column contains a `NULL`:

```sql
UPDATE student
SET last_name = 'unknown' 
WHERE last_name IS NULL;
DELETE FROM student 
WHERE last_name IS NULL;
```

- Update or delete using `AND` and `OR` to meet certain conditions:

```sql
DELETE FROM exam 
WHERE subject = 'Spanish' 
  AND (written_exam_score IS NULL 
    OR oral_exam_score IS NULL)
```

- Use `INSERT INTO` to insert data from a `SELECT` query:

```sql
INSERT INTO student_history(id, first_name, last_name)
SELECT id, first_name, last_name
FROM student;
```