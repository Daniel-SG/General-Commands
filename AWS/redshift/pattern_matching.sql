

--The following example finds cities whose third and fourth characters are "ea". The command uses ILIKE
--to demonstrate case insensitivity:
select distinct city from users where city ilike '__EA%' order by city;

--The following example uses the default escape string (\\) to search for strings that include "_":
select tablename, "column" from pg_table_def
where "column" like '%start\\_%'
limit 5;

--The following example specifies '^' as the escape character, then uses the escape character to search for
--strings that include "_":
select tablename, "column" from pg_table_def
where "column" like '%start^_%' escape '^'
limit 5;

--The following example finds all cities whose names contain "E" or "H":
select distinct city from users
where city similar to '%E%|%H%' order by city;


--The following example specifies '^' as the escape string, then uses the escape string to search for strings
--that include "_":
select tablename, "column" from pg_table_def
where "column" similar to '%start^_%' escape '^'
limit 5;

--The following example finds all cities whose names contain E or H:
select distinct city from users
where city ~ '.*E.*|.*H.*' order by city;

--The following example uses the escape string ('\\') to search for strings that include a period.
select venuename from venue
where venuename ~ '.*\\..*';

--The following example counts how many transactions registered sales of either 2, 3, or 4 tickets:
select count(*) from sales
where qtysold between 2 and 4;



--This example returns all date identifiers, one time each, for each date that had a sale of any kind:
select dateid from date
where exists (
select 1 from sales
where date.dateid = sales.dateid
)
order by dateid;