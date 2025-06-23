# Using values from another column

## Update using a value from another column

Good job! So far, we've always inserted fixed values when updating data. However, when we update, we can also refer to **values from another column**.

Suppose someone has found mistakes made in the scoring of written and oral English exams. Say that each written English exam score needs four points added to it and each oral English exam score is actually six points less than the written exam score. Here's the statement to correct this mistake:

```sql
UPDATE exam
SET
  written_exam_score = written_exam_score + 4,
  oral_exam_score = written_exam_score - 6
WHERE subject = 'English'
```

With the `SET` command, we assigned to the `written_exam_score` column its current value plus 4 points. Similarly, we updated the `oral_exam_score` column, only we subtracted six points from the written exam score (we took the value from `written_exam_score`). In the `WHERE` clause, we limited this `UPDATE` operation to exams for English.

### Exercise

The oral exams with no date assigned take place four days after the `written_exam_date`. Update the data.

```sql
UPDATE exam
SET oral_exam_date = written_exam_date + 4
WHERE oral_exam_date IS NULL;
```

## Change values between columns

Oops… The English teacher just realized that she accidentally switched `written_exam_score` and `oral_exam_score`. The last `UPDATE` introduced another mistake to the `exam` table, again with all records for English exams. How can we correct this? Look at the query below:

```sql
UPDATE exam
SET 
  written_exam_score = oral_exam_score,
  oral_exam_score = written_exam_score
WHERE subject = 'English'
```

We set new values for two columns: `written_exam_score` and `oral_exam_score`. The first column took the value from `oral_exam_score`, and the second column took the value from `written_exam_score`. SQL makes this operation easy.

### Exercise

It's time to fix another mistake in our database. Somebody mistook the first name of the student whose ID is 6 for his last name. See if you can use the example query to correct this.

```sql
UPDATE student
SET 
  first_name = last_name,
  last_name = first_name
WHERE id = 6;
```
