
create or replace function count_products_in_order(order_id INT)
returns int as
$$
	plan = plpy.prepare("SELECT * FROM orders o JOIN products_orders po ON o.id = po.order_id WHERE o.id = $1", ["int"])
	res = plpy.execute(plan, [order_id])
	count_products = 0
	if res is not None:
		for i in res:
			count_products += 1
	return count_products
$$ language plpython3u;


select id, count_products_in_order(id)
from orders;
