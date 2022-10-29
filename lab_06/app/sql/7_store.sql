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
WHERE id = 1;