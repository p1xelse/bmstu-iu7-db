-- 1

CREATE OR REPLACE FUNCTION count_of_consumers_with_name(name_arg VARCHAR(32))
RETURNS int AS '
	SELECT count(*) FROM products p
	GROUP BY name
	HAVING name = name_arg
' LANGUAGE SQL;

SELECT count_of_consumers_with_name('easy');


-- 2

CREATE OR REPLACE FUNCTION count_of_product_names()
RETURNS TABLE (name varchar(32), count int) AS '
	SELECT name, count(name) FROM products p
	GROUP BY name
' LANGUAGE SQL;

SELECT * FROM count_of_product_names();

-- 3 
-- продукты с определенным весом или ценой 
CREATE OR REPLACE FUNCTION get_products_weight_price(_weight int, _price int)
RETURNS  TABLE (
	Id int, 
	Name varchar(32),
	Weight int,
	Price int
)
AS '
begin
	RETURN QUERY
	SELECT p.id, p.name, p.weight, p.price FROM products p
	WHERE p.weight = _weight;

	RETURN QUERY
	SELECT p.id, p.name, p.weight, p.price FROM products p
	WHERE p.price = _price;
end	
' LANGUAGE plpgsql;

SELECT * FROM get_products_weight_price(289, 583110);

-- 4
-- Числа Фибоначи
CREATE OR REPLACE FUNCTION fib(first INT, second INT,max INT)
RETURNS TABLE (fibonacci INT)
AS '
BEGIN
    RETURN QUERY
    SELECT first;
    IF second <= max THEN
        RETURN QUERY
        SELECT *
        FROM fib(second, first + second, max);
    END IF;
END' LANGUAGE plpgsql;

SELECT *
FROM fib(1,1, 13);


-- процедуры
-- 5 
CREATE OR REPLACE PROCEDURE set_product_price(_id int, new_price int)
AS '
BEGIN
	UPDATE products
    SET price = new_price
    WHERE id = _id;
END;
' LANGUAGE plpgsql;

CALL set_product_price(1, 500);
SELECT * FROM products p 
WHERE id = 1

-- 6 
-- рекурсивная процедура
CREATE OR REPLACE PROCEDURE fib_index
(
	res INOUT int,
	index_ int,
	start_ int DEFAULT 1, 
	end_ int DEFAULT 1
)
AS ' 
BEGIN
	IF index_ > 0 THEN
		res = start_ + end_;
		CALL fib_index(res, index_ - 1, end_, start_ + end_);
	END IF;
END; 
' LANGUAGE plpgsql;

CALL fib_index(1, 5);

--7 хранимка с курсором
DROP PROCEDURE find_products_in_order;
CREATE OR REPLACE PROCEDURE find_products_in_order(_order_id int, INOUT _result_one refcursor)
AS '
BEGIN
	open _result_one
		FOR
			SELECT products_id FROM products_orders po
			where po.order_id = _order_id;
	
END;
' LANGUAGE plpgsql;
	
BEGIN;
	call find_products_in_order(1, 'funccursor');
	FETCH ALL IN funccursor;
end;

-- 8

CREATE OR REPLACE PROCEDURE access_to_meta2(
	name_ VARCHAR(100)
)
AS ' 
DECLARE
	el RECORD;
BEGIN
	FOR el IN
		SELECT column_name, data_type
		FROM information_schema.columns
        WHERE table_name = name_
	LOOP
		RAISE NOTICE ''el = %'', el;
	END LOOP;
END;
' LANGUAGE plpgsql;

CALL access_to_meta2('products');


-- 9 

CREATE OR REPLACE FUNCTION update_trigger()
RETURNS TRIGGER 
AS '
BEGIN
	RAISE NOTICE ''New =  %'', new;
    RAISE NOTICE ''Old =  %'', old; RAISE NOTICE ''New =  %'', new;
	UPDATE products
	SET price = price + 2000
	WHERE id = old.id;
	RETURN new;
END;
' LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER update_my
AFTER UPDATE ON products 
FOR EACH ROW 
WHEN (OLD.warehouse_id IS DISTINCT FROM NEW.warehouse_id)
EXECUTE PROCEDURE update_trigger();
--
--SELECT price, warehouse_id  FROM products p 
--WHERE id = 9
--
--UPDATE products 
--SET warehouse_id = 100
--WHERE id = 9
--
--SELECT price, warehouse_id FROM products p 
--WHERE id = 9

-- 10

CREATE VIEW products_buf AS 
SELECT *
FROM products p;
SELECT * FROM products_buf;

CREATE OR REPLACE FUNCTION del_product()
RETURNS TRIGGER 
AS ' 
BEGIN
    RAISE NOTICE ''New =  %'', new;
    UPDATE products
    SET name = ''none'' 
    WHERE name = old.name;
    RETURN new;
END;
' LANGUAGE plpgsql;

CREATE TRIGGER del_packages_trigger
INSTEAD OF DELETE ON products_buf
	FOR EACH ROW 
	EXECUTE PROCEDURE del_product();

DELETE FROM products_buf  
WHERE name = 'easy';

SELECT * FROM products_buf
ORDER BY id;

-- тригер при создании заказа с несуществующим продуктом 
-- должен ошибку вывести

