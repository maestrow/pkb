-- ENUM types
CREATE TYPE file_type AS ENUM ('main', 'content', 'component', 'css', 'code', 'data', 'attachment');
CREATE TYPE prop_type AS ENUM ('str', 'int', 'ref', 'url');

-- Table: pages
CREATE TABLE pages (
  id          BIGINT PRIMARY KEY DEFAULT ('x' || encode(gen_random_bytes(8), 'hex'))::bit(64)::bigint,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  title       varchar(255),
  summary     TEXT,
  aliases     varchar(255)[] DEFAULT NULL,
  shortcut    varchar(100) DEFAULT NULL, -- For quick access to pages

  CONSTRAINT unique_shortcut UNIQUE (shortcut)
);
CREATE INDEX idx_pages_aliases_gin ON pages USING GIN (aliases);
CREATE INDEX idx_pages_title ON pages(title);
CREATE INDEX idx_pages_shortcut ON pages(shortcut);

-- Table: urls
CREATE TABLE urls (
  id          BIGINT PRIMARY KEY DEFAULT ('x' || encode(gen_random_bytes(8), 'hex'))::bit(64)::bigint,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  url         TEXT NOT NULL,
  UNIQUE (url)
);
CREATE INDEX idx_urls_url ON urls(url);

-- Table: files
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
CREATE INDEX idx_files_page_id ON files(page_id);
CREATE INDEX idx_files_type ON files(type);
CREATE INDEX idx_files_path ON files(path);
CREATE INDEX idx_files_alias ON files(alias);
CREATE INDEX idx_files_title ON files(title);

-- Table: props
CREATE TABLE props (
  from_id     BIGINT REFERENCES pages(id) ON DELETE CASCADE,
  prop_id     BIGINT REFERENCES pages(id) ON DELETE CASCADE,
  alias       varchar(50) NOT NULL,
  type        prop_type NOT NULL,
  value_str   TEXT,
  value_int   BIGINT,
  value_ref   BIGINT REFERENCES pages(id) ON DELETE CASCADE,
  value_url   BIGINT REFERENCES urls(id) ON DELETE CASCADE,
  PRIMARY KEY (from_id, alias)
);
CREATE INDEX idx_props_type ON props(type);
CREATE INDEX idx_props_value_str ON props(value_str);
CREATE INDEX idx_props_value_int ON props(value_int);
CREATE INDEX idx_props_value_ref ON props(value_ref);
CREATE INDEX idx_props_value_url ON props(value_url);
