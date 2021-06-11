

--Query table definition
select * from pg_table_def where tablename = 'testtable';

--Query the PG_DATABASE_INFO catalog table to view details about databases.
select datname, datdba, datconnlimit
from pg_database_info
where datdba > 1;


--The PG_TABLE_DEF system table contains information about all the tables in the cluster.
--By default, new database objects, such as tables, are created in a schema named "public".
--To view a list of all tables in the public schema, you can query the PG_TABLE_DEF system catalog table
select distinct(tablename) from pg_table_def where schemaname = 'public';

--Query the PG_USER catalog to view a list of all database users, along with the user ID (USESYSID) and user privileges
select * from pg_user;

--Query the PG_USER_INFO catalog table to view details about a database user.
select * from pg_user_info;


--The user name rdsdb is used internally by Amazon Redshift to perform routine administrative and maintenance tasks. 
--You can filter your query to show only user-defined user names by adding where usesysid > 1 to your select statement
select * from pg_user where usesysid > 1;

--The SVL_QLOG view is a friendlier subset of information from the STL_QUERY table. 
--You can use this view to find the query ID (QUERY) or process ID (PID) for a recently run query or 
--to see how long it took a query to complete.
--SVL_QLOG includes the first 60 characters of the query string (SUBSTRING) to help you locate a specific query. 
--Use the LIMIT clause with your SELECT statement to limit the results to five rows.
select query, pid, elapsed, substring from svl_qlog
where userid = 100
order by starttime desc
limit 5;

--You will need the PID if you need to cancel a query that is taking too long to run. 
--You can query the STV_RECENTS system table to obtain a list of process IDs for running queries, 
--along with the corresponding query string. If your query returns multiple PIDs, you can look at the query text to determine 
--which PID you need.
--Copy in another window and execute immediately after running below query to find the PID of the below query
select top 10 *
from stv_recents
where status='Running';

--Execute a sample query that is a little complex for processing
--The result set will include all of the rows in the SALES table multiplied by all the rows in the USERS table (49989*3766). 
--This is called a Cartesian join, and it is not recommended. The result is over 188 million srows and takes a long time to run.
select sellerid, firstname, lastname, sum(qtysold)
from sales, users
group by sellerid, firstname, lastname
order by 4 desc;

--The CANCEL command will not abort a transaction. To abort or roll back a transaction, you must use the ABORT 
--or ROLLBACK command. To cancel a query associated with a transaction, first cancel the query then abort the transaction.

cancel <pid>

--If your current session has too many queries running concurrently, you might not be able to run the CANCEL command 
--until another query finishes. In that case, you will need to issue the CANCEL command using a different 
--workload management query queue.
--Workload management enables you to execute queries in different query queues so that you don't need to wait for another query
--to complete. The workload manager creates a separate queue, called the Superuser queue, that you can use for troubleshooting.
--To use the Superuser queue, you must be logged on a superuser and set the query group to 'superuser' using the SET command. 
--After running your commands, reset the query group using the RESET command.

set query_group to 'superuser';
cancel 18764;
reset query_group;

set statement_timeout to 1; -> makes queries timeout after 1 ms
set wlm_query_slot_count to 3; -> limits the number of concurrency queries that can be run


set timezone='Etc/GMT+1' -> change timezone
select pg_timezone_names(); -> see available timezones

--To view a list of supported time zone abbreviations, execute the following command.
select pg_timezone_abbrevs();

--Check number of nodes and slices
select * from stv_slices

--Returns information to track or troubleshoot a data load.
-- This table records the progress of each data file as it is loaded into 
--a database table.
--Check node slice that loaded the data
select * from stl_load_commits

-- Re-sorts rows (if table contains sort key columns) and reclaims space in either a specified table or all tables in the current database.
vacuum table_name;
-- https://docs.aws.amazon.com/redshift/latest/dg/r_VACUUM_command.html

-- ANALIZE Updates table statistics for use by the query planner.
analyze table_name;
-- https://docs.aws.amazon.com/redshift/latest/dg/r_ANALYZE.html

--Grant permission on all tables in myschema to guest user account 
grant all on all tables in schema myschema to guest
grant all on schema myschema to guest

--Revoke permission on test table from guest user account
revoke all on table myschema.test from guest

-- In pg_table_def you can see the type and the encoding for every column in the table
select "column", type, encoding
from pg_table_def
where tablename = 'cartesian_venue_default'

-- analyze compression tells you which encoding type you should use for each column in the table based on the datatype
analyze compression table_name

--Check the data distribution with min and max range on each node slices for date and sales table - dateid column only.
select trim(name) as table, slice, sum(num_values) as rows, min(minvalue),
max(maxvalue)
from svv_diskusage
where (name in ('date') and col =0) OR (name in ('sales') and col =5)
group by name, slice
order by slice, name;

