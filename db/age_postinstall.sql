-- Apache AGE Post-installation Script 
-- https://github.com/apache/age

CREATE EXTENSION age;
LOAD 'age';
SET search_path = ag_catalog, "$user", public;
