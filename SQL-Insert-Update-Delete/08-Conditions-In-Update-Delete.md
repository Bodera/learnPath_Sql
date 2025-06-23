# Conditions in UPDATE and DELETE

## UPDATE with conditions: AND, OR

Good job! Up till now, we've written operations with only one condition in the `WHERE` clause. However, there are lots of situations where we'll need to use **more than one condition**. Here's an example:

```sql
UPDATE exam 
SET written_exam_score = 0
WHERE student_id = 1 
  AND subject = 'Spanish';
```

It updates the score of the written exam in Spanish for the student with `student_id = 1`. It checks if the student ID is 1 and then checks if the exam subject is Spanish. If both of these are true, then it assigns a zero to the written exam score. The `AND` logical operator joins these two conditions.

Of course, you can use more than two conditions. Remember that all conditions joined by an `AND` operator have to return `TRUE` for the rows to update.

Another operator for multiple conditions is `OR`. In this case, it is enough that one of the given conditions is met.

### Exercise

Assign a score of `3` points to all students who do **not** have an **oral English exam score date**.

```sql
UPDATE exam 
SET oral_exam_score = 3
WHERE oral_score_date IS NULL
  AND subject = 'English';
```

## DELETE with conditions: AND, OR

Great! You can also use more than one condition in `DELETE` statements.

The statement below removes all the English exam data for students with no date for an oral or written English exam:

```sql
DELETE FROM exam
WHERE subject = 'English' 
  AND (written_exam_date IS NULL 
    OR oral_exam_date IS NULL);
```

Notice that we used both the `AND` and `OR` operators in the `WHERE` clause.

### Exercise

Our university is not accredited to conduct exams in `Spanish` and `Mathematics`. Delete all records for these exams.

```sql
DELETE FROM exam
WHERE subject = 'Spanish' OR subject = 'Mathematics';
```

or 

```sql
DELETE FROM exam
WHERE subject IN ('Spanish', 'Mathematics');
```
