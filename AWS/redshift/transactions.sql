begin;

insert into movie_gross values ( 'Raiders of the Lost Ark', 23400000);

insert into movie_gross values ( 'Star Wars', 10000000 );

commit / rollback;


-- PREPARE creates a prepared statement. When the PREPARE statement is executed, the specified statement (SELECT, INSERT, UPDATE, or DELETE) is parsed, rewritten, and       -- planned. When an EXECUTE command is then issued for the prepared statement, Amazon Redshift may optionally revise the query execution plan (to improve performance based -- on the specified parameter values) before executing the prepared statement.

DROP TABLE IF EXISTS prep1;
CREATE TABLE prep1 (c1 int, c2 char(20));
PREPARE prep_insert_plan (int, char)
AS insert into prep1 values ($1, $2);
EXECUTE prep_insert_plan (1, 'one');
EXECUTE prep_insert_plan (2, 'two');
EXECUTE prep_insert_plan (3, 'three');
DEALLOCATE prep_insert_plan;

-- LOCK Restricts access to a database table. This command is only meaningful when it is run inside a transaction block.
begin;

lock event, sales;

commit;
sec

-- SET SESSION AUTHORIZATION Sets the user name for the current session.
-- You can use the SET SESSION AUTHORIZATION command, for example, to test database access by temporarily running a session or transaction as an unprivileged user.

SET SESSION AUTHORIZATION 'dwuser';
SET SESSION AUTHORIZATION DEFAULT; -- sets to the default user name