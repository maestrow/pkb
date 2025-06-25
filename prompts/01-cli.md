Implement a CLI using commander.js. Start by implementing only stubs, without logic.

Separately defined reusable options:

- article_id: --id base62 or bigint

Hierarchy of commands, arguments, and options:

- ln Symbolic links service
- sync
  - to_db
  - to_fs
- create
- delete
- update
  - :article_id
  - alias
    - --name string
    - add
    - remove
  - title
    - --title string
  - created_at
  - updated_at
- meta Metadata, including props
  - to_db
  - to_fs
- check Checks consistency and outputs a report.
  - :article_id
