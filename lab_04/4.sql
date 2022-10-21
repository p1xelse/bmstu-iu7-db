-- Хранимая процедура

create or replace procedure update_product_price(id int, price int) as 
$$
    plan = plpy.prepare("update products set price = $1 where id = $2", ["int", "int"])
    plpy.execute(plan, [price, id])
$$ language plpython3u;

call update_product_price(23, 2000);

select *
from products p 
where id = 23;