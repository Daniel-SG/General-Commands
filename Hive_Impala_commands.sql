https://www.cloudera.com/more/training/certification/cca-data-analyst.html


set mapreduce.map.memory.mb=4000; -- memoria maxima para mappers
set mapreduce.map.java.opts=-Xmx3200m;
set mapreduce.reduce.memory.mb=4000; -- memoria maxima para reducers
set mapreduce.reduce.java.opts=-Xmx3200m;

set hive.exec.reducers.bytes.per.reducer=256000000; -- Tamaño del reducer
set mapreduce.input.fileinputformat.split.maxsize=128000000; -- tamaño de cada mapper

set MEM_LIMIT=20g;

if [ "${v_STATUS_OUT}" = "false" ]
       then
           exit 1
fi




----otros-----
yarn.app.mapreduce.am.resource.mb=7500
yarn.app.mapreduce.am.command-opts=-Xmx6000m


msck repair table stage_prod.ccl ;
alter table xxx recover partitions --impala
hdfs fsck /ocean/hive/prod/TRANS_prod/ngtv_cdr_huawei/ | egrep -v '^\.+$' | grep -i corrupt
-------------------

-- Load data from file to table
LOAD DATA INPATH '/dualcore/ad_data1' 
INTO TABLE ads PARTITION (network=1)

--Delete partition
alter table dwh_prod.f_voip_cdr_xpbx drop if exists partition (bdate='2017-10-29');
alter table dwh_prod.f_voip_cdr_xpbx drop if exists partition (bdate in ('2017-10-29','2017-10-30'));

-- Renaming tables
ALTER TABLE nombre_viejo_tabla RENAME TO nombre_nuevo_tabla;

-- Move table to other esquema
ALTER TABLE esquema_viejo.tabla
RENAME TO esquema_nuevo.tabla;

-- Renaming columns
ALTER TABLE table_name CHANGE old_name new_name String;

-- Changing column type
ALTER TABLE table_name CHANGE field_one field_one new_Type;


--Reorder columns HIVE
ALTER TABLE jobs
CHANGE salary salary INT AFTER id;

ALTER TABLE jobs
CHANGE salary salary INT FIRST;

--Adding removing columns 
ALTER TABLE jobs ADD COLUMNS (city STRING, bonus INT);

ALTER TABLE jobs DROP COLUMN salary; -- Impala only
ALTER TABLE ads ADD PARTITION (network=1);

 -- Particion dinamica
INSERT OVERWRITE TABLE customers_by_state
PARTITION(state)
SELECT cust_id, fname, lname, address,
city, zipcode, state FROM customers;

--Particion estática
INSERT OVERWRITE TABLE customers_by_state
PARTITION(state='NY')
SELECT cust_id, fname, lname, address,
city, zipcode FROM customers WHERE state='NY';

-- Replacing columns
ALTER TABLE jobs REPLACE COLUMNS (
id INT,
title STRING,
salary INT
);

-- para ver el contenido de una vista -- show create table nombre_vista
DESCRIBE FORMATTED order_info_view;

-- Cambiar el contenido de una vista
ALTER VIEW order_info AS
SELECT order_id, order_date FROM orders;

--Renombrar la vista
ALTER VIEW order_info
RENAME TO order_information;

--impala shell
impala-shell -i myserver.example.com:21000



-- Create table as select
CREATE TABLE ny_customers
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
AS
SELECT cust_id, fname, lname
FROM customers
WHERE state = 'NY';

CREATE EXTERNAL TABLE ads ( 
    campaign_id STRING, 
    display_date STRING,
    display_time STRING, 
    keyword STRING,
    display_site STRING, 
    placement STRING,
    was_clicked TINYINT,
    cpc INT
  ) 
  PARTITIONED BY (network TINYINT)
  ROW FORMAT DELIMITED
    FIELDS TERMINATED BY '\t'
  LOCATION '/dualcore/ads';
  
  DROP DATABASE dualcore CASCADE; -- borrara las tablas y la bbdd


-- Write in HDFS

INSERT OVERWRITE DIRECTORY '/dualcore/ny/'
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
SELECT * FROM customers
WHERE state = 'NY';

--Import data from parquet file
CREATE EXTERNAL TABLE ad_data
LIKE PARQUET '/dualcore/ad_data/datafile1.parquet'
STORED AS PARQUET
LOCATION '/dualcore/ad_data/';

-- Functions (Hive)
SHOW FUNCTIONS;
DESCRIBE FUNCTIONS

-- Windowing
SELECT prod_id, brand, price,
price - MIN(price) OVER(PARTITION BY brand) AS d
FROM products;

SELECT display_date, display_site, num,
AVG(num) OVER
(PARTITION BY display_site ORDER BY display_date
ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS wavg
FROM (
	SELECT display_date, display_site, COUNT(display_date) AS num
	FROM ads GROUP BY display_date, display_site
	) ads
ORDER BY display_date, display_site;

DENSE_RANK Rank of current value within the window (with consecutive rankings)
NTILE(n) The n-tile (of n) within the window that the current value is in
PERCENT_RANK Rank of current value within the window, expressed as a percentage
CUME_DIST Cumulative distribution of current value within   the window
LEAD(column, n, default) The value in the specified column in the nth  following row
LAG(column, n, default) The value in the specified column in the nth  preceding row


mysql --user=training --password=training dualcore

  

--AVRO-- IN HIVE
CREATE TABLE order_details_avro
STORED AS AVRO
TBLPROPERTIES ('avro.schema.url'=
'hdfs://localhost/dualcore/order_details.avsc');

CREATE TABLE order_details_avro
STORED AS AVRO
TBLPROPERTIES ('avro.schema.literal'=
'{"name": "order_details",
"type": "record",
"fields": [
{"name": "order_id", "type": "int"},
{"name": "prod_id", "type": "int"}
]}');

--JOIN--CON Nulos
select a from tabla
join table2
on (a<=>b);

--SEMI JOIN--Only one instance of each row from the left-hand table is returned, regardless of how many matching rows exist in the right-hand table
select lname from customers c
left semi join orders o
on (c.cust_id=o.cust_id and o.order_id<5415700)

--functions
Rounds to specified # of decimals round(total_price, 2) 23.492 23.49
Returns nearest integer above ceil(total_price) 23.492 24
Returns nearest integer below floor(total_price) 23.492 23
Return absolute value abs(temperature) -49 49
Returns square root sqrt(area) 64 8
Returns a random number rand() 0.584977

Convert to uppercase upper(name) Bob BOB
Convert to lowercase lower(name) Bob bob
Remove whitespace at start/end trim(name) ␣Bob␣ Bob
Remove only whitespace at start ltrim(name) ␣Bob␣ Bob␣
Remove only whitespace at end rtrim(name) ␣Bob␣ ␣Bob
Extract portion of string substring('Samuel', 3, 4)  muel
Replace characters in string translate('Samuel','uel', 'my') Sammy
                              
concat_ws(' ', 'Bob', 'Smith') Bob Smith
concat_ws('/', 'Amy', 'Sam', 'Ted') Amy/Sam/Ted

SELECT names FROM people;
Amy,Sam,Ted
SELECT split(names, ',') FROM people;
["Amy","Sam","Ted"]
SELECT explode(split(names, ',')) FROM people;
Amy
Sam
Ted


http://www.example.com/click.php?A=42&Z=105#r1
parse_url(url, 'PROTOCOL') http
parse_url(url, 'HOST') www.example.com
parse_url(url, 'PATH') /click.php
parse_url(url, 'QUERY') A=42&Z=105
parse_url(url, 'QUERY', 'A') 42
parse_url(url, 'QUERY', 'Z') 105
parse_url(url, 'REF') r1

Counts all rows COUNT(*)
Counts all rows where field is not NULL COUNT(fname)
Counts all rows where field is unique and not NULL COUNT(DISTINCT fname)




-- Complex DATA

	--Array
Select phone[0], phone[1] from list_phones;

CREATE TABLE customers_phones
(cust_id STRING,
name STRING,
phones ARRAY<STRING>)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
COLLECTION ITEMS TERMINATED BY '|';

a,Alice,555-1111|555-2222|555-3333


	--Map
SELECT phone['home'] from list_phones;
	
CREATE TABLE customers_phones
(cust_id STRING,
name STRING,
phones MAP<STRING,STRING>)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
COLLECTION ITEMS TERMINATED BY '|'
MAP KEYS TERMINATED BY ':';

a,Alice,home:555-1111|work:555-2222|mobile:555-3333

	--STRUCT
Select address.street, address.zip_code from addresses;

CREATE TABLE customers_addr
(cust_id STRING,
name STRING,
address STRUCT<street:STRING,
city:STRING,
state:STRING,
zipcode:STRING>)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
COLLECTION ITEMS TERMINATED BY '|';


a,Alice,742 Evergreen Terrace|Springfield|OR|97477
--Hive
select explode(phones) lista todos los telefonos (no se puede añadir nada mas en la select)

select name from telephone_list
lateral view explode(phone) ALIAS -> (muestra el campo nombre y cada telefono asociado)

SELECT cust_id, order_ids.item
  FROM loyalty_program_parquet, loyalty_program_parquet.order_ids
  WHERE order_value.avg > 90000;

--Impala  trata los datos complejos de manera diferente
--Array
SELECT item, pos
FROM cust_phones_parquet.phones;

SELECT name, phones.item AS phone
FROM cust_phones_parquet, cust_phones_parquet.phones;

--MAP
SELECT key, value
FROM cust_phones_parquet.phones;

SELECT name, phones.value AS home
FROM cust_phones_parquet, cust_phones_parquet.phones
WHERE phones.key = 'home';

--STRUCT
-- same as hive

-- Array Struct
CREATE TABLE array_demo
(
  places_lived ARRAY < STRUCT <
    place: STRING,
    start_year: INT
  >>
)
STORED AS PARQUET;

DESCRIBE array_demo.places_lived;

SELECT places_lived.pos, places_lived.place, places_lived.start_year
  FROM array_demo, array_demo.places_lived;		   

-- Expresiones regulares

Regular Expression Description of Matching String
--------------------------------------------------
Dualcore Contains the literal string Dualcore
^Dual Starts with Dual
core$ Ends with core
^Dualcore$ Is the literal string Dualcore with no other characters
^Dual.*$ Is Dual followed by zero or more other characters
^[A-Za-z]+$ Is one or more uppercase or lowercase letters
^\\w{8}$ Is exactly eight word characters ([0-9A-Za-z_])
^\\w{5,9}$ Is between five and nine word characters (inclusive)

Dualcore I wish Dualcore had 2 stores in 90210.
\\d I wish Dualcore had 2 stores in 90210.
\\d{5} I wish Dualcore had 2 stores in 90210.
\\d\\s\\w+ I wish Dualcore had 2 stores in 90210.
\\w{5,9} I wish Dualcore had 2 stores in 90210.
.?\\. I wish Dualcore had 2 stores in 90210.
.*\\. I wish Dualcore had 2 stores in 90210.
2[^ ] I wish Dualcore had 2 stores in 90210.

\D 	A non-digit: [^0-9]
\s 	A whitespace character: [ \t\n\x0B\f\r]
\S 	A non-whitespace character: [^\s]
\w 	A word character: [a-zA-Z_0-9]
\W 	A non-word character: [^\w]
^ 	The beginning of a line
$ 	The end of a line
X? 	X, once or not at all
X* 	X, zero or more times
X+ 	X, one or more times
X{n} 	X, exactly n times
X{n,} 	X, at least n times
X{n,m} 	X, at least n but not more than m times
select case 
when birthdate regexp '(\\w{3})/(\\d{2}) (\\d{4})' then from_unixtime(unix_timestamp(birthdate,'dd-MMM yyyy'),'yyyy-MM-dd')
end from  temp3

--Variables hive
SET hivevar:mystate=CA;

SELECT * FROM customers
WHERE state = '${hivevar:mystate}';

--Variable Impala
SET var:mystate=CA;

SELECT * FROM customers
WHERE state = '${var:mystate}';

--SERDE
--separacion de campo por comas (,) a menos que el contenido del campo vaya entre comillas
  create table `trans_dsg`.`validaciones`
(
  `module` string ,
  `val_id` string ,
  `element` string ,
  `val_abreviation` string ,
  `val_description` string ,
  `query` string ,
  `val_limit_error` bigint ,
  `val_limit_warning` bigint ,
  `active` bigint ,
  `execution_order` bigint ,
  `val_type` string )  
   ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
   "separatorChar" = ",",
   "quoteChar"     = "\""
)  
tblproperties ("skip.header.line.count"="1")
STORED AS TEXTFILE;


----UDF-----

--IMPALA--
create function if not exists dsg_split3(String) 
returns String location '/tmp/test.jar' 
SYMBOL='zzprova1.provaUdf1'; 

show functions in trans_dsg
--HIVE--
add jar hdfs:///ocean/application/prod/etl-base/lib/hive-udf-15.0.1-SNAPSHOT.jar;

create temporary function getWednesdayOutOfWeekNumber as 'de.telekom.ocean.hive.GetWednesdayOutOfWeekNumberNonGeneric';

https://www.cloudera.com/more/training/certification/cca-data-analyst.html
mauro.pazienza@pue.es

-- Load data from file to table
LOAD DATA INPATH '/dualcore/ad_data1' 
INTO TABLE ads PARTITION (network=1)

--Delete partition
alter table dwh_prod.f_voip_cdr_xpbx drop if exists partition (bdate='2017-10-29');

-- Renaming tables
ALTER TABLE nombre_viejo_tabla RENAME TO nombre_nuevo_tabla;

-- Move table to other esquema
ALTER TABLE esquema_viejo.tabla
RENAME TO esquema_nuevo.tabla;

-- Renaming columns
ALTER TABLE table_name CHANGE old_name new_name String;

-- Changing column type
ALTER TABLE table_name CHANGE field_one field_one new_Type;


--Reorder columns HIVE
ALTER TABLE jobs
CHANGE salary salary INT AFTER id;

ALTER TABLE jobs
CHANGE salary salary INT FIRST;

--Adding removing columns 
ALTER TABLE jobs ADD COLUMNS (city STRING, bonus INT);

ALTER TABLE jobs DROP COLUMN salary; -- Impala only
ALTER TABLE ads ADD PARTITION (network=1);

 -- Particion dinamica
INSERT OVERWRITE TABLE customers_by_state
PARTITION(state)
SELECT cust_id, fname, lname, address,
city, zipcode, state FROM customers;

--Particion estática
INSERT OVERWRITE TABLE customers_by_state
PARTITION(state='NY')
SELECT cust_id, fname, lname, address,
city, zipcode FROM customers WHERE state='NY';

-- Replacing columns
ALTER TABLE jobs REPLACE COLUMNS (
id INT,
title STRING,
salary INT
);

-- para ver el contenido de una vista -- show create table nombre_vista
DESCRIBE FORMATTED order_info_view;

-- Cambiar el contenido de una vista
ALTER VIEW order_info AS
SELECT order_id, order_date FROM orders;

--Renombrar la vista
ALTER VIEW order_info
RENAME TO order_information;

--impala shell
impala-shell -i myserver.example.com:21000



-- Create table as select
CREATE TABLE ny_customers
ROW FORMAT DELIMITED
FIELDS TERMINATED BY '\t'
STORED AS TEXTFILE
AS
SELECT cust_id, fname, lname
FROM customers
WHERE state = 'NY';

CREATE EXTERNAL TABLE ads ( 
    campaign_id STRING, 
    display_date STRING,
    display_time STRING, 
    keyword STRING,
    display_site STRING, 
    placement STRING,
    was_clicked TINYINT,
    cpc INT
  ) 
  PARTITIONED BY (network TINYINT)
  ROW FORMAT DELIMITED
    FIELDS TERMINATED BY '\t'
  LOCATION '/dualcore/ads';
  
  CREATE EXTERNAL TABLE latlon 
  LIKE PARQUET '/dualcore/latlon/part-m-00000.parquet' 
  STORED AS PARQUET 
  LOCATION '/dualcore/latlon';

  DROP DATABASE dualcore CASCADE; -- borrara las tablas y la bbdd


-- Write in HDFS

INSERT OVERWRITE DIRECTORY '/dualcore/ny/'
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
SELECT * FROM customers
WHERE state = 'NY';

--Import data from parquet file
CREATE EXTERNAL TABLE ad_data
LIKE PARQUET '/dualcore/ad_data/datafile1.parquet'
STORED AS PARQUET
LOCATION '/dualcore/ad_data/';

-- Functions (Hive)
SHOW FUNCTIONS;
DESCRIBE FUNCTIONS

-- Windowing
SELECT prod_id, brand, price,
price - MIN(price) OVER(PARTITION BY brand) AS d
FROM products;

SELECT display_date, display_site, num,
AVG(num) OVER
(PARTITION BY display_site ORDER BY display_date
ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS wavg
FROM (
	SELECT display_date, display_site, COUNT(display_date) AS num
	FROM ads GROUP BY display_date, display_site
	) ads
ORDER BY display_date, display_site;

DENSE_RANK Rank of current value within the window (with consecutive rankings)
NTILE(n) The n-tile (of n) within the window that the current value is in
PERCENT_RANK Rank of current value within the window, expressed as a percentage
CUME_DIST Cumulative distribution of current value within   the window
LEAD(column, n, default) The value in the specified column in the nth  following row
LAG(column, n, default) The value in the specified column in the nth  preceding row


--AVRO-- IN HIVE
CREATE TABLE order_details_avro
STORED AS AVRO
TBLPROPERTIES ('avro.schema.url'=
'hdfs://localhost/dualcore/order_details.avsc');

CREATE TABLE order_details_avro
STORED AS AVRO
TBLPROPERTIES ('avro.schema.literal'=
'{"name": "order_details",
"type": "record",
"fields": [
{"name": "order_id", "type": "int"},
{"name": "prod_id", "type": "int"}
]}');

--JOIN--CON Nulos
select a from tabla
join table2
on (a<=>b);

--SEMI JOIN--Only one instance of each row from the left-hand table is returned, regardless of how many matching rows exist in the right-hand table
select lname from customers c
left semi join orders o
on (c.cust_id=o.cust_id and o.order_id<5415700)

--functions
Rounds to specified # of decimals round(total_price, 2) 23.492 23.49
Returns nearest integer above ceil(total_price) 23.492 24
Returns nearest integer below floor(total_price) 23.492 23
Return absolute value abs(temperature) -49 49
Returns square root sqrt(area) 64 8
Returns a random number rand() 0.584977

Convert to uppercase upper(name) Bob BOB
Convert to lowercase lower(name) Bob bob
Remove whitespace at start/end trim(name) ␣Bob␣ Bob
Remove only whitespace at start ltrim(name) ␣Bob␣ Bob␣
Remove only whitespace at end rtrim(name) ␣Bob␣ ␣Bob
Extract portion of string substring('Samuel', 3, 4)  muel
Replace characters in string translate('Samuel','uel', 'my') Sammy
                              
concat_ws(' ', 'Bob', 'Smith') Bob Smith
concat_ws('/', 'Amy', 'Sam', 'Ted') Amy/Sam/Ted

SELECT names FROM people;
Amy,Sam,Ted
SELECT split(names, ',') FROM people;
["Amy","Sam","Ted"]
SELECT explode(split(names, ',')) FROM people;
Amy
Sam
Ted


http://www.example.com/click.php?A=42&Z=105#r1
parse_url(url, 'PROTOCOL') http
parse_url(url, 'HOST') www.example.com
parse_url(url, 'PATH') /click.php
parse_url(url, 'QUERY') A=42&Z=105
parse_url(url, 'QUERY', 'A') 42
parse_url(url, 'QUERY', 'Z') 105
parse_url(url, 'REF') r1

Counts all rows COUNT(*)
Counts all rows where field is not NULL COUNT(fname)
Counts all rows where field is unique and not NULL COUNT(DISTINCT fname)



-- Complex DATA

	--Array
Select phone[0], phone[1] from list_phones;

CREATE TABLE customers_phones
(cust_id STRING,
name STRING,
phones ARRAY<STRING>)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
COLLECTION ITEMS TERMINATED BY '|';

a,Alice,555-1111|555-2222|555-3333


	--Map
SELECT phone['home'] from list_phones;
	
CREATE TABLE customers_phones
(cust_id STRING,
name STRING,
phones MAP<STRING,STRING>)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
COLLECTION ITEMS TERMINATED BY '|'
MAP KEYS TERMINATED BY ':';

a,Alice,home:555-1111|work:555-2222|mobile:555-3333

	--STRUCT
Select address.street, address.zip_code from addresses;

CREATE TABLE customers_addr
(cust_id STRING,
name STRING,
address STRUCT<street:STRING,
city:STRING,
state:STRING,
zipcode:STRING>)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
COLLECTION ITEMS TERMINATED BY '|';


create temporary function fpe_msn as 'com.tsystems.ocean.udf.OceanFPEMSN'
using jar 
'hdfs:///ocean/application/prod/etl-base/lib/oceanfpe1.2.46-full.jar';

