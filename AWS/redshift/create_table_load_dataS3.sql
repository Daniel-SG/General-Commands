--Create a new database
create database DDLTest
with owner awsuser;

--Drop test database
drop database testdb

--The following example creates a schema named US_SALES and gives ownership to the user AWUSER:
create schema if not exists us_sales authorization awsuser;


--Create a new user
--By default, only the master user that you created when you launched the cluster has access to the
--initial database in the cluster. 
--When you create a new user, you specify the name of the new user and a password. 
--A password is required. It must have between 8 and 64 characters, 
--and it must include at least one uppercase letter, one lowercase letter, and one numeral.
create user guest password 'ABCd4321';

--In the following example, the account password is valid until April 24, 2018.
create user dbuser with password 'abcD1234' valid until '2018-04-24';

--The following example creates a user with a case-sensitive password that contains special characters.
create user newman with password '@AbC4321!';


--Drop a user
drop user guest;

-- Create Tables
create table users(
	userid integer not null distkey sortkey,
	venueid smallint encode raw,
	address varchar(20),
	phone char(14),
	likemusicals boolean),
	caldate date not null,
	dateid smallint not null sortkey,
	holiday boolean default('N')
	saletime timestamp);

--If you specify a table name that begins with '# ', the table will be created as a temporary
--table when the session is over, the table goes away. The following is an example (must execute both statements together:
create table #newtable (id int);
select * from #newtable

insert into users(phone) values('1234556');

-- cast the value to the size of the column:
insert into address(city_name) values('City of South San Francisco'::char(20));

--Insert data based on specific column order
insert into city_new (id, amount, state, city, country)
values (2, 200.50, 'Nevada', 'Las Vegas', 'USA')

--The following two queries both delete one row from the CATEGORY table, based on a join to the EVENT
--table and an additional restriction on the CATID column:
delete from category
using event
where event.catid=category.catid and category.catid=9;

--update the CATGROUP column based on a range of values in the CATID column.
update category
set catgroup='Theatre'
where catid between 6 and 8;

-- Replace ARN of the IAM Role associated with Redshift Cluster

-- Copy data from a AWS s3 bucket to our users table	
copy users from 's3://awssampledbuswest2/tickit/allusers_pipe.txt' 
credentials 'aws_iam_role=arn:aws:iam::658079272131:role/LondonRedshiftRole' 
delimiter '|' timeformat 'MM/DD/YYYY HH:MI:SS' region 'us-west-2';


-- WITH NO SCHEMA BINDING
-- Clause that specifies that the view isn't bound to the underlying database objects, such as tables and user-defined functions. 
-- As a result, there is no dependency between the view and the objects it references. You can create a view even 
-- if the referenced objects don't exist. Because there is no dependency, you can drop or alter a referenced object 
-- without affecting the view. Amazon Redshift doesn't check for dependencies until the view is queried. 
-- To view details about late binding views, run the PG_GET_LATE_BINDING_VIEW_COLS function.
 
 -- When you include the WITH NO SCHEMA BINDING clause, tables and views referenced in the SELECT statement must be qualified with a schema name.
 -- The schema must exist when the view is created, even if the referenced table doesn't exist. For example, the following statement returns an error.

 create view myevent as select eventname from public.event
with no schema binding;


--Test whether CityData file can be loaded in both tables
--NOLOAD Data Load Operation Parameter, makes a check to know if the datatypes from the file fit in the table schema
-- if the don't fit we would get an error like Load into table 'city2' failed. Check 'stl_load_errors' system table for details
-- select * from stl_load_errors to see the error detail
--CSV Data Format Parameter

copy city (ID, Country, State, City, Amount) --Column Mapping Parameter
from 's3://df-bucket-exporter/CityData.csv'
iam_role 'arn:aws:iam::658079272131:role/LondonRedshiftRole'
--OPTIONS
csv --file format 
NOLOAD --makes a check to know if the datatypes from the file fit in the table schema. select * from stl_load_errors to see the error detail
IGNOREHEADER 1 --number of rows skiped as a header
BLANKSASNULL -- changes de blanks for nulls
manifest -- load a manifest file with all required files. format: {"entries": [{"url":"s3://df-bucket-exporter/CityData.csv", "mandatory":true},{"url":"s3://df-bucket-exporter/CityData2.csv", "mandatory":true}]}
delimiter '|'
timeformat 'YYYY-MM-DD HH:MI:SS'

--Amazon Redshift copy examples URL
--https://docs.aws.amazon.com/redshift/latest/dg/r_COPY_command_examples.html

--Download a Redshift table to S3
unload ('select * from city_new')
TO 's3://df-bucket-exporter/Unload/'
iam_role 'arn:aws:iam::658079272131:role/LondonRedshiftRole'
----OPTIONS
PARALLEL OFF -- writes only 1 file instead of 1 per each node
ALLOWOVERWRITE
MANIFEST -- writes a manifest file with all the files downloaded
DELIMITER AS '\t'
GZIP -- Download the data as GZIP format


--Unload examples link
--https://docs.aws.amazon.com/redshift/latest/dg/r_UNLOAD_command_examples.html
