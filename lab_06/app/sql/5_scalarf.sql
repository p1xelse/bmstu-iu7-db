CREATE OR REPLACE FUNCTION count_of_consumers_with_name(name_arg VARCHAR(32))
RETURNS int AS '
	SELECT count(*) FROM products p
	GROUP BY name
	HAVING name = name_arg
' LANGUAGE SQL;

SELECT count_of_consumers_with_name('easy');