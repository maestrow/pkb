# 250626 Generate Random BigInt in PostgreSQL

## Option 1 - random() twice

source: https://www.postgresql.org/message-id/20231221121412.ksgegfafhv2q5blm%40hjp.at

> Postgres's random() function generates a random double. That can be converted
> to a random int for smaller integers, but a double can't represent all of the
> values in a bigint. Is there a recommended way to generate a random bigint in
> Postgres?

Call random() twice and add the results like this:

```sql
select (random() * 2147483648)::int8 * 4294967296
     + (random() * 4294967296)::int8;
```

## Option 2

Enable the `pgcrypto` extension 

```sql
CREATE EXTENSION IF NOT EXISTS pgcrypto;
```

and use `gen_random_bytes`:

```sql
SELECT ('x' || encode(gen_random_bytes(8), 'hex'))::bit(64)::bigint;
```

# 250626 Markdown reference links

[I'm an inline-style link](https://www.somewebsite.com)

[I'm an inline-style link with title](https://www.somewebsite.com "somewebsite's Homepage")

[I'm a reference-style link][Arbitrary case-insensitive reference text]

[You can use numbers for reference-style link definitions][1]

Or leave it empty and use the [link text itself]

Some text to show that the reference links can follow later.

[arbitrary case-insensitive reference text]: https://www.somewebsite.org
[1]: http://somewebsite.org
[2]: http://www.somewebsite.com "somewebsite's Homepage"
[link text itself]: http://www.somewebsite.com

# 250626 How to interpret Composed URLs like "/help/links"?

In order of priority:

- Exact match
  - shortcut
  - alias
- Parent-child relation
  - For each segment, check shortcut first, then alias.

# 250626 File types

- content
  - main
  - extra (inlined)
- data
- code
  - component. tsx
  - css
  - function or script. sql, js, ts, go, etc.

If file is not marked as any of the above, it is considered an attachment.

# Workflow

Create new note:

    kb new $alias

Open properties page:

    kb props      

You can edit the properties of the current note. And copy reference links to the clipboard.

    kb save

- updates `updated_at`
- performs a consistency check
- update files list in database

    kb view
