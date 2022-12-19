-- Вариант 2 
-- Задача 1 
create table employee (
	id int not null primary key,
	fio varchar,
	birthdate date, 
	department varchar
);

create table record(
	id int not null primary key,
	employee_id int references employee(id) not null,
	rdate date,
	dayweek varchar,
	rtime time,
	rtype int
);

select mt, count(mt)
from (
	select  (min(rtime) - '9:00') as mt
	from record r 
	where rdate = '2019-12-21' and rtype = 1
	group by employee_id
	having min(r.rtime) > '9:00') as t1
group by mt;

insert into employee(
	id,
	fio,
	birthdate, 
	department
) values 
	(1, 'FIO1', '1995-03-09', 'IT'),
	(2, 'FIO2', '1999-03-09', 'IT'),
	(3, 'FIO3', '1990-09-25', 'Fin'),
	(4, 'FIO4', '1997-09-23', 'Ut');

insert into record(
	id,
	employee_id, 
	rdate, 
	dayweek, 
	rtime, 
	rtype
) values
	(0,1,'2022-11-15','Понедельник','09:55:00',1),
	(1,2,'2022-11-15','Понедельник','08:55:00',1),
	(2,3,'2022-11-15','Понедельник','09:05:00',1),
	(3,4,'2022-11-15','Понедельник','10:51:00',1),
	(4,1,'2022-11-15','Понедельник','16:05:00',2),
	(5,2,'2022-11-15','Понедельник','16:06:00',2),
	(6,3,'2022-11-15','Понедельник','19:09:00',2),
	(7,4,'2022-11-15','Понедельник','21:00:00',2);

CREATE OR REPLACE FUNCTION Statistic(dt DATE)
RETURNS TABLE
(
    minutes double precision,
    employee_qty int
)
AS
$$
    SELECT EXTRACT (HOURS FROM tmp.min_time - '09:00:00') * 60 + EXTRACT (MINUTES FROM tmp.min_time - '09:00:00'), COUNT(*) AS employee_qty
    FROM (select employee_id, rdate, min(rtime) as min_time from record 
			where rtype = 1
			group by employee_id, rdate) as tmp
    WHERE rdate = dt
    AND tmp.min_time > '09:00:00'
    GROUP BY tmp.min_time - '09:00:00'
$$ LANGUAGE SQL;

SELECT * FROM Statistic('2022-11-15');



