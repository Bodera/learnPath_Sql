# Introduction

Learn the basic SQL text functions to transform text values and make your reports look pretty.

In this part, we'll teach the basic SQL text functions to help you manipulate text values in your queries. You will learn:

- how to concatenate multiple text values into one.
- simple text conversions: how to change all text to uppercase, lowercase, etc.
- how to select substrings and replace parts of the text with another text.

We're going to work with some data we've acquired from a marketing agency. Let's find out more.

## Table item

Select all columns from the table `item`.

As you can see, it contains:

- item identifiers (column `id`).
- names (column `name`).
- a third column which tells us what it actually is (column `type`).

```sql
SELECT *
FROM item;
```

## Table copywriter

Select all columns from the table `copywriter`. It's a pretty small table and it contains only 3 columns:

- the copywriter identifier (column `id`).
- first name of the copywriter (column `first_name`).
- the last name of the copywriter (column `last_name`).

```sql
SELECT *
FROM copywriter;
```

## Table slogan

Select all columns from the table `slogan`.

Each slogan in the table:

- has its identifier (column `id`).
- corresponds to a certain item (column `item_id`).
- is designed for a specific medium (column `type`).
- has its text (column `text`).
- has the ID of the copywriter (column `copywriter_id`).

```sql
SELECT *
FROM slogan;
```

## Concatenation operator ||

Okay, let's start off. First, we'll need a new operator: `||` (you can type a single `|` by pressing `shift + '\'`). These two vertical bars are the **concatenation operator**, i.e., they join two or more text values (or strings, which is another name for text values). If you write the following:

```sql
SELECT first_name || last_name AS name
FROM copywriter;
```

the result for `first_name = 'Kate'` and `last_name = 'Gordon'` will be `KateGordon`, all of this in a single column. Quite simple, right?

Of course we want the first and the last name separated with a space. Here is how you do it:

```sql
SELECT first_name || ' ' || last_name AS name
FROM copywriter;
```

Note that you use **apostrophes** for specific constant text values (a space in our example: `' '`), but you don't use apostrophes for column names (`first_name`, `last_name`). The operator `||` can be used as many times as you need in a single query.

### Exercise

Show each copywriter's `first_name` and `last_name` in one column separated with a single space. Name the column as `name`.

```sql
SELECT first_name || ' ' || last_name AS name
FROM copywriter;
```

## Concatenation operator || continued

Good job! The concatenation operator is a very useful tool provided by the SQL standard. Mind you though, there are a few databases that don't comply with the standard in this regard. For example:

- **SQL Server** and **Microsoft Access** use the plus sign (`+`) as the concatenation operator.
- **MySQL** uses the function `CONCAT()` like this:

```sql
SELECT CONCAT(first_name,' ',last_name) AS name
FROM copywriter;
```

Now that you've been officially warned, we can go back to || and do one more exercise.

### Exercise

For each item, show the following sentence: **'ID X is Y.'**, where **X** is the `id` of the item and **Y** is its `name`. Name the column `sentence`.

```sql
SELECT 'ID ' || id || ' is ' || name || '.' AS sentence
FROM item;
```

## Concatenation operator || further practice

Good job. By the way, don't forget about tiny details such as spaces and periods when you create sentences in this way. It's easy to overlook them!

Now, get ready for the next exercise.

### Exercise

For each slogan, show the following sentence (**name the column**: `sentence`):

```
The copywriter of the slogan with ID X is Y Z.
```

In this sentence, **X** is the `id` of the `slogan`, and **Y** and **Z** are the **first** and **last** name of the copywriter, respectively.

```sql
SELECT 
  'The copywriter of the slogan with ID ' || id || ' is ' || (
    SELECT 
      first_name || ' ' || last_name 
    FROM 
      copywriter 
    WHERE 
      id = copywriter_id
  ) || '.' AS sentence 
FROM 
  slogan;
```

## Function length

Very well done! Now that we understand the concatenation operator, let's learn some string functions. Our database provides many of these. For instance, there is a function called `length()`, which shows the length of a string column. For example:

```sql
SELECT length(first_name) AS first_name_length
FROM copywriter;
```

will show **4** for the name `'Kate'`, because `'Kate'` consists of **4** letters.

In **SQL Server** this function is called `len()`.

### Exercise

For every slogan, show its `id`, its `text`, and its `length`. Name the last column `text_length`.

```sql
SELECT id, text, length(text) AS text_length
FROM slogan;
```

## Function length – practice

Okay! That was good. Remember that you don't have to use `length()` in the `SELECT` clause. You can use it after `WHERE` too! By doing so, you can filter columns that have longer or shorter values, for instance.

```sql
SELECT
  id,
  text
FROM slogan
WHERE length(text) < 20;
```

The above query will select only those slogans whose length is shorter than **20** characters.

### Exercise

Show the **IDs** of all the items with a name **longer than** 8 characters. Show the **length** as the second column, name it `name_length`.

```sql
SELECT id, length(name) AS name_length
FROM item
WHERE length(name) > 8;
```

## Function lower

Right! Let's move on, there are other functions you should learn too. One of them is `lower()`. Whatever is put inside the parentheses of `lower()` will be written in lowercase letters. For example:

```sql
SELECT lower(last_name) AS last_name_lowercase
FROM copywriter;
```

will produce `'turner'` for the last name `'Turner'`. Shall we try it in an exercise?

### Exercise

The boss of the marketing agency heard that it's now very fashionable to write magazine and newspaper ads in lowercase letters. Let's check how it would look.

For every slogan of the type `'newspaper ad'` or `'magazine ad'`, show the slogan `id` and its `text` in lowercase as `text_lowercase`.

```sql
SELECT id, lower(text) AS text_lowercase
FROM slogan
WHERE type = 'newspaper ad' OR type = 'magazine ad';
```

## Function upper

Great! If there is a function for lowercase letters, there must be a function for uppercase letters too, right? It's called `upper()` and works in a similar way:

```sql
SELECT upper(last_name) AS last_name_uppercase
FROM copywriter;
```

The above query will show `'TURNER'` for the last name `'Turner'`.

### Exercise

The lowercase fashion is now passé. Everybody started to use upper case. Show the `id` of each `'newspaper ad'` or `'magazine ad'` slogan together with its `text` in capital letters. Name the second column `text_uppercase`.

```sql
SELECT id, upper(text) AS text_uppercase
FROM slogan
WHERE type = 'newspaper ad' OR type = 'magazine ad';
```

## Function initcap

Nice! Yet another function is `initcap()`, which will change the first letter of a text value to upper case and the rest to lower case. For instance, if someone mistakenly inserted another `lastname` with caps lock as `'sMITH'`, the query:

```sql
SELECT initcap(last_name) AS last_name_initcap
FROM copywriter;
```

will show `'Smith'` for that last name. That's often a convenient way to show all names in the proper way.

The `initcap()` is only present in **PostgreSQL** and **Oracle**. It does not exist in **MySQL** and **SQL Server**.

### Exercise

The boss wants you to update the names of all the items so that they start with a capital letter, followed by lowercase. Show the `id` of each item together with its **old name** (as `old_name`) and **updated name** (as `new_name`).

```sql
SELECT id, name AS old_name, initcap(name) AS new_name
FROM item;
```

## Functions lower, upper, initcap – usage

Fine! The three functions we've just gotten to know: `lower()`, `upper()` and `initcap()` can also be used to find some data, even if we're not sure about the letters' cases. This often happens when we work with data provided by our users, which are often messy: one person will use capital letters only, another one will use lower case, yet another will provide letters in a random case. Or another problem: we've got an item called **riVer Flow** for which we want to find the `id`, but we may not remember which letters were written with lower and upper case. What to do then? Take a look:

```sql
SELECT id
FROM item
WHERE lower(name) = 'river flow';
```

Smart, isn't it? Whatever the case of the `name`, we can simply put it in lower case and then compare it with **'river flow'**. Of course, you could use `upper(name)='RIVER FLOW'` or `initcap(name)='River Flow'` just as well.

By the way, this trick could be very useful if you had a chaotic database, with some column values written in lowercase letters only, others with an initial capital letter, and so on. Data aren't always consistent across all rows, so keep these functions in mind.

### Exercise 1

Show the `id` of the item whose `name` written in upper case is **TRIPCARE**.

```sql
SELECT id
FROM item
WHERE upper(name) = 'TRIPCARE';
```

### Exercise 2

For each slogan, print the following: **'X. Y'**, where **X** is the item `name` and **Y** is the `text` of the slogan. Name the column `name_text`.

```sql
SELECT name || '. ' || text AS name_text
FROM item
JOIN slogan ON item.id = slogan.item_id;
```

## Function substring

Very well done! Okay. The functions we've learned so far operated on all the string values, but we can also manipulate certain fragments or even single letters.

We'll start off with `substring(x, y)`. Take a look:

```sql
SELECT substring(name, 2)
FROM item;
```

What does the function `substring` do? It returns part of the string starting from the character specified as **y**, which must be an integer value.

In this case, if the name is **'TripCare'** and **y = 2**, we'll get **'ripCare'** as the result, because the database will start at the second character, which is **'r'**.

If the integer **y** you provide is larger than the whole string length, then you will get an empty string `''` as a result.

In Oracle, this function is called `substr()`.

### Exercise

Show the **full name** of each item and each `name` starting from the **3rd** character. Name the second column `name_substring`.

```sql
SELECT name, substring(name, 3) AS name_substring
FROM item;
```

## Function substring continued

Perfect. There is also another, extended version of `substring`. Take a look:

```sql
SELECT substring(name, 2, 3) AS name_substring
FROM item;
```

In the above example, substring received an additional number (**3**). In this way, we can specify the **length** of the substring we want to get. For the name **'TripCare'**, we'll get **'rip'**, because we start at letter **2** (which is **'r'**) and take **3** of them(**'r'**, **'I'** and **'p'**).

Again, if you start from a number which exceeds the length of the whole string, you will get an empty string. If the second number you provide is bigger than the length to the end of the string, the database will simply return the string until its end.

However, in **Oracle** this function is called **substr()**.

### Exercise

For each slogan, show its `text` and the characters **from 3 to 8** of that `text`. Name the second column `text_substring`.

```sql
SELECT text, substring(text, 3, 6) AS text_substring
FROM slogan;
```

## Function replace

Great! You can also **replace** certain parts of your string with anything you want. This is where we can use the function `replace(x,y,z)`, which takes the string **x** and, if it finds the text **y** in the **x**, then **y** will be replaced with text **z**. Take a look:

```sql
SELECT replace('young man','young','old');
```

In the above example, the function will look for **'young'** in the string **'young man'** and will replace it with **'old'**. As a result, we'll get **'old man'**. Of course, you can provide a column name instead of **'young man'** just as well.

Please note that the SQL standard does not contain the function `replace` we've just described. However, it's so popular among the available databases that we've decided to teach you how to use it.

### Exercise 1

For slogan `id = 1`, show its original `text` and its `text` with the word `'Feel'` replaced with `'Touch'`. Name the second column `changed_text`.

```sql
SELECT
  text,
  replace(text, 'Feel', 'Touch') AS changed_text
FROM slogan
WHERE id = 1;
```

### Exercise 2

For each slogan, show the item `name` and the slogan with all the periods (`.`) replaced by exclamation marks (`!`). Name the second column `changed_text`.

```sql
SELECT
  name,
  replace(text, '.', '!') AS changed_text
FROM item
JOIN slogan ON item.id = slogan.item_id;
```

## Summary

Good, that's it! Let's review the text functions we've learned in this part:

1. `||` is the concatenation operator; it merges multiple texts into one (in **SQL Server** use `+`, in **MySQL** use `concat()`).
2. `length(x)` returns the **length** of text **x** (in **SQL Server** use `len()`).
3. `lower(x)`, `upper(x)`, `initcap(x)` will all write **x** in the appropriate case.
4. `substring(x, y, z)` will return the part of **x** starting from position **y** and with **z** characters in length (in **Oracle** use `substr()`).
5. `replace(x,y,z)` will search **x** for **y**, and if it finds any **y**, it will replace it with **z**.

## Quiz

Fine, let's do some practice now.

### Exercise 1

Show the `id` of each item together with its `name` in capital letters and its `type` with an initial capital letter. The column names should be: `id`, `name_uppercase`, and `type_initcap`.

```sql
SELECT
  id,
  upper(name) AS name_uppercase,
  initcap(type) AS type_initcap
FROM item;
```

### Exercise 2

For each slogan with a `text` **longer than 20 characters**, show the `text` fragment from **character 5 until character 20**. Name the column `text_substring`.

```sql
SELECT
  substring(text, 5, 16) AS text_substring
FROM slogan
WHERE length(text) > 20;
```

### Exercise 3

For each `'tv commercial'` slogan, show the item `name`, the item `type`, and the `text` with each period (`.`) turned into three exclamation marks (`!!!`) – name this column `changed_text`.

```sql
SELECT
  item.name,
  item.type,
  replace(slogan.text, '.', '!!!') AS changed_text
FROM item
JOIN slogan ON item.id = slogan.item_id
WHERE slogan.type = 'tv commercial';
```

## Congratulations

Excellent! You've completed all the exercises!

That's it for now. In the next part, you will learn the basic numeric functions. See you soon!
