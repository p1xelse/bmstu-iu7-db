-- create extension plpython3u;

create or replace function is_expensive(price INT)
returns varchar as
$$
    if (price > 1000):
        return "Yes"
    else:
        return "No"
$$ language plpython3u;


select "name" , price, is_expensive(price)
from products p;