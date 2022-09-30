--1 
SELECT DISTINCT wc1.brand, wc1.volume FROM public.warehouse_companies wc1
JOIN public.warehouse_companies AS wc2 ON wc1.volume = wc2.volume 
WHERE wc1.brand > wc2.brand;

--2
SELECT DISTINCT id, price, delivery_date  FROM public.orders
WHERE delivery_date  BETWEEN '1977-01-01' AND '1978-01-01';

--3 
SELECT DISTINCT id, name FROM public.products
WHERE name LIKE '%work%';

--4 
SELECT DISTINCT consumer_id  FROM public.orders
WHERE id IN (SELECT id FROM public.consumers
			 WHERE first_name = 'Susan');
			 
--5
SELECT DISTINCT o.consumer_id  FROM public.orders o
WHERE EXISTS (SELECT c.id FROM public.consumers AS c
			 WHERE c.id = o.consumer_id);
			 
--6 с самым маленьким объемом
SELECT id, brand FROM public.warehouse_companies
WHERE volume <= ALL (SELECT volume FROM public.warehouse_companies);

--7
SELECT  sum(volume) AS SUM_VOLUME, 
		count(id) AS COUNT_ELEMS, 
		avg(volume) AS AVG_VOLUME,
		min(volume) AS MIN_VOLUME,
		max(volume) AS MAX_VOLUME
		FROM public.warehouse_companies;
		
--8
SELECT id, consumer_id,
	(SELECT avg(price) FROM orders 
		WHERE price > 1000) AS AVG_ORDER_PRICE,
	(SELECT min(price) FROM orders
		WHERE price > 1000) AS MIN_ORDER_PRICE
	FROM orders
WHERE consumer_id IN (SELECT id FROM public.consumers   WHERE first_name = 'Susan')

--9

SELECT id, first_name,
	CASE transport  WHEN 'Cycle' THEN 'I.m faster'
					WHEN 'On foot' THEN 'I.m Slower'
					WHEN 'Bike' THEN 'I.m faster'
					WHEN 'Car' THEN 'I.m super faster'
					END AS SPEED
FROM public.couriers 

--10
SELECT id, name, price,
	CASE WHEN price > 500000 THEN 'Dorogo'
		 WHEN price < 500000 THEN 'Deshevo'
		 WHEN price = 500000 THEN 'S kaifom'
	END 
FROM public.products

--11 количество курьеров на ноге
SELECT transport, count(first_name) INTO transport_stats  FROM public.couriers
WHERE transport = 'On foot' OR transport = 'Bike'
GROUP BY transport 

--12
SELECT c.id, cnt.COUNT_OF_ORDERS 
FROM public.consumers c JOIN (SELECT count(id) AS COUNT_OF_ORDERS FROM public.orders o
																GROUP BY consumer_id) AS cnt ON c.id = cnt.COUNT_OF_ORDERS
																
--13																
SELECT id FROM public.consumers
WHERE id = (SELECT consumer_id FROM public.orders
			WHERE id = (SELECT order_id FROM public.products_orders
						WHERE products_id = 20 LIMIT 1))

--14
SELECT products_id, count(order_id) AS count_of_order FROM public.products_orders
GROUP BY products_id

--15
SELECT products_id, count(order_id) AS count_of_order FROM public.products_orders
GROUP BY products_id HAVING count(order_id) > 4
						
--16
INSERT INTO public.products_orders (order_id, products_id) VALUES(20, 20)
		
-- 17
INSERT INTO public.products_orders (order_id, products_id)
SELECT 1, id FROM products WHERE price >= ALL(SELECT price FROM products)	

--18
UPDATE consumers  
SET last_name = 'Popov'
WHERE first_name = 'Susana' 

--19
UPDATE products  
SET price = (SELECT avg(price) FROM products)
WHERE price < 1000

--20
DELETE FROM consumers 
WHERE first_name = 'Susana'

--21
DELETE FROM deliveries CASCADE 
WHERE 'Delivered' IN (SELECT status FROM deliveries)

--22
WITH CTE(id, count_of_orders) AS (
	SELECT products_id, count(order_id) 
	FROM products_orders GROUP BY products_id)
SELECT avg(count_of_orders) AS avg_count_of_orders FROM CTE

--23
DROP TABLE IF EXISTS people;
CREATE TABLE people (
	id serial PRIMARY KEY,
	full_name VARCHAR NOT NULL,
	parent_id INT
);

INSERT INTO people (
	full_name,
	parent_id
)
VALUES
	('Michael North', NULL),
	('Megan Berry', 1),
	('Sarah Berry', 1),
	('Zoe Black', 1),
	('Tim James', 1),
	('Bella Tucker', 2),
	('Ryan Metcalfe', 2),
	('Max Mills', 2),
	('Benjamin Glover', 2),
	('Carolyn Henderson', 3),
	('Nicola Kelly', 3),
	('Alexandra Climo', 3),
	('Dominic King', 3),
	('Leonard Gray', 4),
	('Eric Rampl', 4),
	('Piers Paige', 7),
	('Ryan Henderson', 7),
	('Frank Tucker', 8),
	('Nathan Ferguson', 8),
	('Kevin Rampling', 8);

WITH RECURSIVE ancestry AS (
	SELECT
		id,
		parent_id,
		full_name
	FROM
		people
	WHERE
		id = 2
	UNION
		SELECT
			p.id,
			p.parent_id,
			p.full_name
		FROM
			people p
		INNER JOIN ancestry d ON d.id = p.parent_id
) SELECT * FROM ancestry;

--TRUNCATE people;
--TRUNCATE ancestry;

--24
SELECT brand, map_location, volume, avg(volume) OVER(PARTITION BY map_location) AS avg_volume,
									max(volume) OVER(PARTITION BY map_location) AS  max_volume, 
									min(volume) OVER(PARTITION BY map_location) AS min_volume 
									FROM warehouse_companies 

--25
DROP TABLE IF EXISTS test;
CREATE TABLE test (
	f_name VARCHAR NOT NULL,
	l_name VARCHAR NOT NULL 
);

INSERT INTO test (f_name, l_name) VALUES ('Dima', 'Neu'), ('Valera', 'Vin'), ('Dima', 'Neu'), ('Valera', 'Vin');

WITH tmp_db AS (
	SELECT f_name, l_name, ROW_NUMBER() OVER(PARTITION BY f_name, l_name) FROM test
)
SELECT * FROM tmp_db WHERE ROW_NUMBER = 1
		
		


		-- все имена курьеров, которые 12 апреля возили определенный продукт с конкретного склада