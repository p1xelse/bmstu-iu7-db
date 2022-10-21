COPY public.warehouse_companies(brand, map_location, phone_number, volume) FROM '/home/generate/warehouse_companies.csv' DELIMITER ';' CSV HEADER;

COPY public.products (name, price, weight, prod_year, warehouse_id) FROM '/home/generate/products.csv' DELIMITER ';' CSV HEADER;

COPY public.consumers (first_name, last_name, address, phone_number) FROM '/home/generate/consumers.csv' DELIMITER ';' CSV HEADER;

COPY public.orders (consumer_id, price, date_of_issue, delivery_date) FROM '/home/generate/orders.csv' DELIMITER ';' CSV HEADER;

COPY public.deliveries (consumer_id, order_id, courier_id, status, payment_method_) FROM '/home/generate/deliveries.csv' DELIMITER ';' CSV HEADER;

COPY public.couriers (first_name, last_name, phone_number, transport) FROM '/home/generate/couriers.csv' DELIMITER ';' CSV HEADER;

COPY public.products_orders (order_id, products_id) FROM '/home/generate/orders_product.csv' DELIMITER ';' CSV HEADER;
