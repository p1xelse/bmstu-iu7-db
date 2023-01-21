--CREATE DATABASE SHOP;

CREATE TABLE IF NOT EXISTS public.warehouse_companies(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	brand VARCHAR(32) NOT NULL,
	map_location TEXT NOT NULL,
	phone_number VARCHAR(32) NOT NULL,
	volume INT NOT NULL
);

CREATE TABLE IF NOT EXISTS public.products(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	name VARCHAR(32) NOT NULL,
	price INT NOT NULL,
	weight INT NOT NULL,
	prod_year INT,
	warehouse_id INT NOT NULL REFERENCES warehouse_companies(id)
);


CREATE TABLE IF NOT EXISTS public.consumers(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	first_name VARCHAR(32) NOT NULL,
	last_name VARCHAR(32) NOT NULL,
	address text NOT NULL,
	phone_number VARCHAR(32) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.consumer_copy(
	consumerid INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	first_name VARCHAR(32) NOT NULL,
	last_name VARCHAR(32) NOT NULL,
	address text NOT NULL,
	phone_number VARCHAR(32) NOT NULL
);


CREATE TABLE IF NOT EXISTS public.orders(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	consumer_id INT NOT NULL REFERENCES consumers(id),
	price INT NOT NULL,
	date_of_issue DATE NOT NULL,
	delivery_date DATE NOT NULL
);

DROP TYPE IF EXISTS status_type;
CREATE TYPE status_type AS ENUM ('Commit', 'On the way', 'Delivered');

DROP TYPE IF EXISTS payment_method_type;
CREATE TYPE payment_method_type AS ENUM ('Card', 'Cash');

DROP TYPE IF EXISTS transport_type;
CREATE TYPE transport_type AS ENUM ('Car', 'Cycle', 'Bike', 'On foot');

CREATE TABLE IF NOT EXISTS public.couriers(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	first_name VARCHAR(32) NOT NULL,
	last_name VARCHAR(32) NOT NULL,
	phone_number VARCHAR(32) NOT NULL,
	transport transport_type NOT NULL
	
);

CREATE TABLE IF NOT EXISTS public.deliveries(
	id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	consumer_id INT NOT NULL REFERENCES public.consumers(id),
	order_id INT NOT NULL REFERENCES public.orders(id),
	courier_id INT NOT NULL REFERENCES public.couriers(id),
	status status_type NOT NULL,
	payment_method_ payment_method_type NOT NULL
);


CREATE TABLE IF NOT EXISTS public.products_orders(
	order_id INT NOT NULL REFERENCES public.orders(id),
	products_id INT NOT NULL REFERENCES public.products(id)
);

--DROP SCHEMA public CASCADE;
--CREATE SCHEMA public;

-- функция Номер заказа, возвращаем курьера который его доставлял
