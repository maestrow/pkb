# ADRs - Architecture Decision Records

ADRs are a way to capture architectural decisions made while developing software. They provide a historical record of why certain decisions were made, which can be useful for future reference and for new team members.

- [ADRs - Architecture Decision Records](#adrs---architecture-decision-records)
  - [Generate Random BigInt in PostgreSQL](#generate-random-bigint-in-postgresql)
    - [Option 1 - random() twice](#option-1---random-twice)
    - [Option 2 - pgcrypto and gen\_random\_bytes](#option-2---pgcrypto-and-gen_random_bytes)
    - [Selected option - gen\_random\_bytes](#selected-option---gen_random_bytes)
  - [How to interpret Composed URLs like "/help/links"?](#how-to-interpret-composed-urls-like-helplinks)
  - [File types and permissions](#file-types-and-permissions)
  - [Using Stored Procedures](#using-stored-procedures)


## Generate Random BigInt in PostgreSQL

### Option 1 - random() twice

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

### Option 2 - pgcrypto and gen_random_bytes

Enable the `pgcrypto` extension 

```sql
CREATE EXTENSION IF NOT EXISTS pgcrypto;
```

and use `gen_random_bytes`:

```sql
SELECT ('x' || encode(gen_random_bytes(8), 'hex'))::bit(64)::bigint;
```

### Selected option - gen_random_bytes

Option 2: use `gen_random_bytes`.


## How to interpret Composed URLs like "/help/links"?

In order of priority:

- Exact match
  - shortcut
  - alias
- Parent-child relation
  - For each segment, check shortcut first, then alias.


## File types and permissions

We can think of it as an access modifier (or permissions), similar to those used in file systems (refer to `chmod` command).

In our case, we have the following bits:

- content
  - the file can be used as content (i.e., embedded into other articles)
- data
  - the file can be used as a data source
- exec
  - how exactly the code is executed depends on the file extension:
    - tsx component
    - sql query
    - function
    - script
- show or hide in attachments

Data type in Postgres: bit(N).


## Using Stored Procedures

To ensure consistency, the creation and deletion of articles and their properties should be performed exclusively through stored procedures.

For example, creating a new article should involve calling a specific stored procedure. This procedure will insert a record into the pages table and create the corresponding node in the graph.

By using stored procedures, we guarantee data consistency between the relational tables and the graph structure, preventing any desynchronization.
