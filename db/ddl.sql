-- Drop types if they exist
DROP TYPE IF EXISTS file_type CASCADE;
DROP TYPE IF EXISTS prop_type CASCADE;

-- Recreate ENUM types
CREATE TYPE file_type AS ENUM ('main', 'content', 'component', 'data', 'attachment');
CREATE TYPE prop_type AS ENUM ('str', 'int', 'ref');

-- Drop tables if they exist
DROP TABLE IF EXISTS props CASCADE;
DROP TABLE IF EXISTS files CASCADE;
DROP TABLE IF EXISTS pages CASCADE;

-- Create `pages` table
CREATE TABLE pages (
  id          BIGINT PRIMARY KEY,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  title       varchar(255),
  aliases     varchar(255)[] DEFAULT NULL,
  shortcut    varchar(100) DEFAULT NULL, -- For quick access to pages

  CONSTRAINT unique_shortcut UNIQUE (shortcut)
);

-- Create `files` table
CREATE TABLE files (
  id          BIGINT PRIMARY KEY, -- inode
  page_id     BIGINT NOT NULL REFERENCES pages(id) ON DELETE CASCADE,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  path        TEXT NOT NULL,
  type        file_type,
  alias       varchar(50),
  title       varchar(255),    -- To display attachments on page using its titles
  meta        JSONB
);

-- Create `props` table
CREATE TABLE props (
  from_id     BIGINT REFERENCES pages(id) ON DELETE CASCADE,
  prop_id     BIGINT REFERENCES pages(id) ON DELETE CASCADE,
  alias       varchar(50) NOT NULL,
  type        prop_type NOT NULL,
  value_str   TEXT,
  value_int   BIGINT,
  value_ref   BIGINT REFERENCES pages(id) ON DELETE CASCADE,
  PRIMARY KEY (from_id, alias)
);

-- Drop indexes if they exist
DROP INDEX IF EXISTS idx_pages_aliases_gin;
DROP INDEX IF EXISTS idx_props_type;
DROP INDEX IF EXISTS idx_props_value_str;
DROP INDEX IF EXISTS idx_props_value_int;
DROP INDEX IF EXISTS idx_props_value_ref;

-- Create indexes
CREATE INDEX idx_pages_aliases_gin ON pages USING GIN (aliases);
CREATE INDEX idx_props_type ON props(type);
CREATE INDEX idx_props_value_str ON props(value_str);
CREATE INDEX idx_props_value_int ON props(value_int);
CREATE INDEX idx_props_value_ref ON props(value_ref);
