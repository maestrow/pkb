
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

# 250626 Workflow

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

