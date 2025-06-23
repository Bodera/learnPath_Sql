# Summary: CRUD

It's time to wrap things up! We have learned how to **add**, **modify**, and **remove** data from a database. In the SQL Basics course, you also learned how to **SELECT** data from a database.

This sequence of four operations is often referred to by the acronym **CRUD**:

- **C**reate
- **R**etrieve
- **U**pdate
- **D**elete

Any application handling data will be able to do these four operations.

Remember, in SQL, you:

- **Create** data with the `INSERT` command.
- **Retrieve** data with the `SELECT` command.
- **Update** data with the `UPDATE` command.
- **Delete** data with the `DELETE` command.

## Create - Exercise

The restaurant owners have already started to build up their new Creole menu. Let's help them by adding a new main course, **Rice and Gravy**, with the **ID 4** and a price of **28**.

```sql
INSERT INTO dish (id, type, name, price)
VALUES (4, 'main course', 'Rice and Gravy', 28);
```

## Update - Exercise

**Doberge Cake** (**ID 3**) in our table is too expensive, so customers don't want to buy it. Let's modify the `price` to **10**.

```sql
UPDATE dish
SET price = 10
WHERE id = 3;
```

## Delete - Exercise

**Oysters Bienville** (**ID 1**) aren't really popular. Let's remove them from the menu.

```sql
DELETE FROM dish
WHERE id = 1;
```

## Summary

Very good! Looks like you've got the hang of it already.

Now that you've mastered these four basic operations in SQL, why don't you learn about advanced features of `INSERT`, `UPDATE`, and `DELETE` in the next part of the course?
