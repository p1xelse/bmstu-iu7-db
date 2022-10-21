create or replace function orders_with_price_gt(price INT)
returns table (id int, consumer_id int, price int, date_of_issue date, delivery_date date) as
$$
	plan = plpy.prepare("SELECT * FROM orders WHERE price > $1", ["int"])
	res = plpy.execute(plan, [price])
	res_table = list()
	if res is not None:
		for i in res:
			res_table.append(i)
	return res_table
$$ language plpython3u;

select * from orders_with_price_gt(2000);