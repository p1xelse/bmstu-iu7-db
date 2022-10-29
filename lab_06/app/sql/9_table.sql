CREATE TABLE IF NOT EXISTS public.favorite_product(
	product_id INT NOT NULL REFERENCES products(id),
    consumer_id INT NOT NULL REFERENCES consumers(id)
);