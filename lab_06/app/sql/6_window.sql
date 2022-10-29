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