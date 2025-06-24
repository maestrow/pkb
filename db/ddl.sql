CREATE TABLE articles (
  id          BIGINT PRIMARY KEY,
  title       TEXT,
  alias       TEXT[] DEFAULT NULL,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE props (
  from_id     BIGINT REFERENCES articles(id) ON DELETE CASCADE,
  alias       TEXT NOT NULL,
  type        TEXT NOT NULL CHECK (type IN ('str', 'int', 'ref')),
  value_str   TEXT,
  value_int   BIGINT,
  value_ref   BIGINT REFERENCES articles(id) ON DELETE CASCADE,
  PRIMARY KEY (from_id, alias)
);

CREATE INDEX idx_articles_alias_gin ON articles USING GIN (alias);
CREATE INDEX idx_props_type ON props(type);
CREATE INDEX idx_props_value_str ON props(value_str);
CREATE INDEX idx_props_value_int ON props(value_int);
CREATE INDEX idx_props_value_ref ON props(value_ref);
