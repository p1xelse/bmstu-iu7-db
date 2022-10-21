-- 1 Выгрузка 
select row_to_json(p) from products p;
select row_to_json(d) from deliveries d;
select row_to_json(c) from consumers c;

-- 2 из файла прочитать
-- сначала создадим файл 
-- touch test.json
-- chmod 777 test.json
copy (select row_to_json(p) from products p) to '/home/test.json';

-- копия таблицы продуктов, потом проверим, что она заполнится
CREATE TABLE IF NOT EXISTS public.products_copy(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	name VARCHAR(32) NOT NULL,
	price INT NOT NULL,
	weight INT NOT NULL,
	prod_year INT,
	warehouse_id INT NOT NULL REFERENCES warehouse_companies(id)
);

-- создадим таблицу с одним столбцом json'ов и скопируем туда файл
create table if not exists products_import (doc json);
copy products_import(doc) from '/home/test.json';

-- get as text
insert into products_copy (name, price, weight, prod_year, warehouse_id) 
select doc->>'name', (doc->>'price')::int, (doc->>'weight')::int, (doc->>'prod_year')::int, (doc->>'warehouse_id')::int from products_import;

select * from products_copy;


-- 3 
--drop table public.student;
CREATE TABLE IF NOT EXISTS public.student(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	name varchar(20) not null,
	info jsonb
);

insert into public.student(name, info) 
	values 
	('Dima', '{"math": 5, "prog": 4}'),
	('Valera', '{"math": 4, "prog": 3}');

select * from student s;

-- 4.1. Извлечь XML/JSON фрагмент из XML/JSON документа
	
create table if not exists products_import (doc json);
copy products_import(doc) from '/home/test.json'; -- выгрузка из файла

select doc->'price' price, doc->'weight' weight from products_import; -- извлечение json


-- 4.2 Извлечь значения конкретных узлов или атрибутов XML/JSON документа
CREATE TABLE IF NOT EXISTS public.student(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	name varchar(20) not null,
	info jsonb
);

insert into public.student(name, info) 
	values 
	('Dima', '{"info": {"math": 5, "prog": 4}}'),
	('Valera', '{"info": {"math": 4, "prog": 3}}');

select info->'info'->'math' from student s;

-- 4.3 Выполнить проверку существования узла или атрибута

CREATE TABLE IF NOT EXISTS public.student(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	name varchar(20) not null,
	info jsonb
);

insert into public.student(name, info) 
	values 
	('Dima', '{"info": {"math": 5, "prog": 4}}'),
	('Valera', '{"info": {"math": 4, "prog": 3}}');

--select info#>>'{info, math}' from student s;


CREATE OR REPLACE FUNCTION is_existing_path(path text[])
RETURNS VARCHAR AS '
    SELECT CASE
               WHEN count.cnt > 0
                   THEN ''true''
               ELSE ''false''
               END AS comment
    FROM (
             SELECT COUNT(info #>> path) cnt
             FROM student
         ) AS count;
' LANGUAGE sql;

select is_existing_path('{info, mathe}'); -- false
select is_existing_path('{info, math}');  -- true

-- 4.4 Изменить json документ

select * from student s;

update student
set info = info || '{"fiz": 3}'
where name = 'Dima';

select * from student s;

--4.5. Разделить XML/JSON документ на несколько строк по узлам

insert into student (name, info) values ('spec', '[{"count": 1}, {"count": 2}, {"count": 3}, {"privet": 1}]');

select * from student s 
where name = 'spec';

select jsonb_array_elements(info::jsonb)
from student s 
where name = 'spec';


	
	
	
	
	
