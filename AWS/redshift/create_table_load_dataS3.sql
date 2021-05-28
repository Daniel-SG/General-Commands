--Create a new database
create database testdb;

--Drop test database
drop database testdb

--Create a new user
--By default, only the master user that you created when you launched the cluster has access to the
--initial database in the cluster. 
--When you create a new user, you specify the name of the new user and a password. 
--A password is required. It must have between 8 and 64 characters, 
--and it must include at least one uppercase letter, one lowercase letter, and one numeral.
create user guest password 'ABCd4321';

--Drop a user
drop user guest;

-- Create Tables
create table users(
	userid integer not null distkey sortkey,
	venueid smallint,
	email varchar(100),
	phone char(14),
	likemusicals boolean),
	caldate date not null,
	dateid smallint not null sortkey,
	holiday boolean default('N')
	saletime timestamp);

-- Replace ARN of the IAM Role associated with Redshift Cluster

-- Copy data from a AWS s3 bucket to our users table	
copy users from 's3://awssampledbuswest2/tickit/allusers_pipe.txt' 
credentials 'aws_iam_role=arn:aws:iam::658079272131:role/LondonRedshiftRole' 
delimiter '|' timeformat 'MM/DD/YYYY HH:MI:SS' region 'us-west-2';

 
