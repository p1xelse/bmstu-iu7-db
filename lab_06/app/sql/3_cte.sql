DROP TABLE IF EXISTS test;
CREATE TABLE test (
	f_name VARCHAR NOT NULL,
	l_name VARCHAR NOT NULL 
);

INSERT INTO test (f_name, l_name) VALUES ('Dima', 'Neu'), ('Valera', 'Vin'), ('Dima', 'Neu'), ('Valera', 'Vin');

WITH tmp_db AS (
	SELECT f_name, l_name, ROW_NUMBER() OVER(PARTITION BY f_name, l_name) FROM test
)
SELECT * FROM tmp_db WHERE ROW_NUMBER = 1;