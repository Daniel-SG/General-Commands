
--Insert dates that have different formats and display the output:
create table datetable (start_date date, end_date date);
insert into datetable values ('2008-06-01','2008-12-31');
insert into datetable values ('Jun 1,2008','20081231');
select * from datetable order by 1;

--If you insert a time stamp value into a DATE column, the time portion is ignored and only the date
--loaded.
--If you insert a date into a TIMESTAMP or TIMESTAMPTZ column, the time defaults to midnight. For
--example, if you insert the literal 20081231, the stored value is 2008-12-31 00:00:00.

--Insert timestamps that have different formats and display the output:
create table tstamp(timeofday timestamp, timeofdaytz timestamptz);
insert into tstamp values('Jun 1,2008 09:59:59', 'Jun 1,2008 09:59:59 EST' );
insert into tstamp values('Dec 31,2008 18:20','Dec 31,2008 18:20');
insert into tstamp values('Jun 1,2008 09:59:59 EST', 'Jun 1,2008 09:59:59');

--Examples of today and now
select getdate();
select dateadd(day,1,'today');
select dateadd(day,1,'now');

--Add 1 minute to the specified date:
select caldate + interval '1 minute' as dateplus from date
where caldate='12-31-2008';

--Add 12 hours (half a day) to the specified date:
select caldate + interval '0.5 days' as dateplus from date
where caldate='12-31-2008';


