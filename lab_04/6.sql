create type product_base_info as
(
    id int,
    price int,
    weight int
);

create or replace function product_base_info(id INT)
returns setof product_base_info as
$$
	plan = plpy.prepare("SELECT id, price, weight FROM products WHERE id = $1", ["int"])
	res = plpy.execute(plan, [id])
	if res is not None:
		return res
$$ language plpython3u;

select * from product_base_info(1);
--setof для множества параметров




