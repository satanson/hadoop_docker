create schema if NOT EXISTS foobar;
CREATE TABLE IF NOT EXISTS foobar.emp (
     id INTEGER NOT NULL PRIMARY KEY,
     name VARCHAR,
     age INTEGER,
     gender VARCHAR,
     boss VARCHAR,
     email VARCHAR
     );

CREATE SEQUENCE emp_id;
UPSERT INTO foobar.EMP VALUES( NEXT VALUE FOR emp_id, 'alice', 31, 'M', 'dave', 'alice@gmail.com');
UPSERT INTO foobar.EMP VALUES( NEXT VALUE FOR emp_id, 'bob', 28, 'M', 'dave', 'bob@gmail.com');
UPSERT INTO foobar.EMP VALUES( NEXT VALUE FOR emp_id, 'candy', 31, 'M', 'dave', 'candy@gmail.com');
UPSERT INTO foobar.EMP VALUES( NEXT VALUE FOR emp_id, 'dave', 31, 'M', 'george', 'dave@gmail.com');

CREATE INDEX emp_idx0 ON foobar.emp(age DESC) include (name,boss) async;
CREATE INDEX emp_idx1 ON foobar.emp(name DESC) include (gender,boss) async;
CREATE INDEX emp_idx2 ON foobar.emp(name DESC, email) include (age,boss) async;

UPSERT INTO foobar.EMP VALUES( NEXT VALUE FOR emp_id, 'edword', 0, 'M', 'dave', 'edword@gmail.com');
UPSERT INTO foobar.EMP VALUES( NEXT VALUE FOR emp_id, 'ford', 1, 'M', 'dave', 'ford@gmail.com');
UPSERT INTO foobar.EMP VALUES( NEXT VALUE FOR emp_id, 'george', 255, 'M', 'dave', 'george@gmail.com');
SELECT * FROM foobar.EMP;
