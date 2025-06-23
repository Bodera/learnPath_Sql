# Delete data

All right! Now you will learn how to **delete** data from the database. To delete data from a database, you use — surprise, surprise — the `DELETE` command.

To delete the user with **ID 1**, type:

```sql
DELETE FROM user 
WHERE id = 1; 
```

Here, `user` is the name of the table you're deleting from. The database removes all rows for which the `WHERE` condition is true. The `WHERE` condition in the `DELETE FROM` command can be the same as the `WHERE` condition in the `SELECT` command.

As with the `UPDATE` command, the database always tells you how many rows it has deleted.

## Exercise

Oops, we've run out of sugar! Delete all desserts from our menu.

```sql
DELETE FROM dish
WHERE type = 'dessert';
```

## Delete all rows

Great! Now something a bit scary — you can delete **all** rows from a table in one command. Just run the `DELETE` command with no `WHERE` condition.

```sql
DELETE FROM user;
```

**Caution**: Be careful using this command on a real database!

### Exercise

The owners finally decided on a single cuisine. They want to serve Creole dishes, so **delete all the data** from the `dish` table to make room for new meals.

```sql
DELETE FROM dish;
```
