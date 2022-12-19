CREATE TABLE IF NOT EXISTS consumers_json
(
    doc JSON
);


COPY
(
	SELECT row_to_json(c) RESULT FROM consumers  c
)
TO '/home/generate/consumers.json';

COPY consumers_json FROM '/home/generate/consumers.json';

CREATE OR REPLACE PROCEDURE set_product_price(_id int, new_price int)
AS '
BEGIN
	UPDATE products
    SET price = new_price
    WHERE id = _id;
END;
' LANGUAGE plpgsql;