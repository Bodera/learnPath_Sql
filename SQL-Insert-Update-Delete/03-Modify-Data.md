# Modify data

Great! Now that you know how to add data to the database, it's time to learn how to **modify** existing data.

If you want to change the `name` of the user with **ID 7**, you can use the command:

```sql
UPDATE user 
SET name = 'Elizabeth'
WHERE id = 7;
```

Here, `user` is the modified table, `name` is the modified column, and `'Elizabeth'` is the new value of the column. The `WHERE` condition tells the database which rows should be modified, and it can be any condition you'd write in a `SELECT` clause.

After you run the query, the `name` for the `user` with `id` 7 will be set to `'Elizabeth'`. Piece of cake!

## Exercise

The owners of the restaurant complain that the item with **ID 2** sells poorly. This might be because **Spring Scrolls** don't really sound like something particularly edible.

Correct the `name` by changing it to **Spring Rolls**.

```sql
UPDATE dish
SET name = 'Spring Rolls'
WHERE id = 2;
```

## Modify multiple columns

Right! You can also modify values for **multiple columns in one go**.

When you want to modify the `name` and `age` of the user with **ID 1**, use the command:

```sql
UPDATE user 
SET name = 'Elizabeth', age = 17 
WHERE id = 1;
```

This command sets the `name` to `Elizabeth` and the `age` to `17` for the user with **ID 1**.

### Exercise

Spring Rolls now sell like crazy, and nobody's interested in Prawn Salad (**ID 1**) anymore. We need to change its name to something more exotic—let's try **Green Sea Dragon**.

Apart from that, set the `price` at **10** to encourage customers to try the dish.

```sql
UPDATE dish
SET name = 'Green Sea Dragon', price = 10
WHERE id = 1;
```

## Modify multiple rows

Excellent! When you write an `UPDATE` query, the database modifies all rows for which the `WHERE` condition is true. You can modify **many rows** with one `UPDATE` command. You can build up your `WHERE` condition with `AND`, `OR`, and `NOT`. You can also use any other condition you would use in a `SELECT` command.

To change the `age` value for all users with an `id` lower than 4, you can run the command:

```sql
UPDATE user 
SET age = 17 
WHERE id < 4; 
```

The database always tells you how many rows have actually been modified. In the previous examples, it only modified a single row each time. Always check the number of modified rows to see if your query did what you expected it to.

### Exercise

It's happy hour at our restaurant! Change the price of all **main courses** to **20**.

```sql
UPDATE dish
SET price = 20
WHERE type = 'main course';
```

## Modify data — arithmetic operations

Nice! So far, we've only used **fixed values** when updating rows. We can, however, make the database **do some math**, too. Take a look:

```sql
UPDATE user 
SET age = 10 + age 
WHERE id = 5;
```

As a result of this query, the user with the ID 5 will be **older by 10 years** compared to their current age—for whatever reason.

Let's practice modifying data once again, this time using some arithmetic!

### Exercise

The restaurant owners think the **starters** are so delicious and popular that they should be much more expensive. Try **multiplying their prices by 2**.

**Think in advance**: what will the price of Kosovo Bread be after the change (currently is `NULL`)?

```sql
UPDATE dish
SET price = price * 2
WHERE type = 'starter';
```
