CREATE OR REPLACE FUNCTION update_trigger()
RETURNS TRIGGER  as
$$
	plpy.notice("Some products changed")
$$ LANGUAGE plpython3u;

--drop trigger update_my on products;

CREATE  trigger update_my
AFTER UPDATE ON products 
FOR EACH ROW 
EXECUTE PROCEDURE update_trigger();

UPDATE products 
SET warehouse_id = 100
WHERE id = 9;
