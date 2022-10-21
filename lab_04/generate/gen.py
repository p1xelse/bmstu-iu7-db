from faker import Faker
from datetime import datetime, timedelta
from random import randint 

COUNT_PRODUCTS = 1100
COUNT_CONSUMERS = 1100
COUNT_ORDERS = 1100
COUNT_WAREHOUSES = 1100
COUNT_COURIERS = 1100
COUNT_ORDER_PRODUCT_RELATION = COUNT_CONSUMERS * 2
COURIER_TRANSPORT = ['Car', 'Cycle', 'Bike', 'On foot']
PAYMENT_METHODS = ['Card', 'Cash']
DELIVERY_STATUS = ['Commit', 'On the way', 'Delivered']

def gen_products():
    product_price = dict()

    def _gen_product_string(id):
        faker = Faker()
        name = faker.word()
        price = faker.pyint(0, 1000000)
        weight = faker.pyint(0, 500)
        year = randint(1960, 2020)
        warehouse_id = randint(1, COUNT_WAREHOUSES)

        product_price[id] = price

        return f"{name};{price};{weight};{year};{warehouse_id}"

    with open("products.csv", "w") as f: 
        f.write("name;price;weight;year;warehouse_id\n")
        for i in range(COUNT_PRODUCTS):
            f.write(_gen_product_string(i + 1) + "\n")
    
    return product_price

def gen_consumers():
    def _gen_consumer_string():
        faker = Faker()
        f_name = faker.first_name()
        l_name = faker.last_name()
        address = faker.address().split('\n')[0]
        phone = faker.phone_number()
        return f"{f_name};{l_name};{address};{phone}"

    with open("consumers.csv", "w") as f: 
        f.write("f_name;l_name;address;phone\n")
        for _ in range(COUNT_CONSUMERS):
            f.write(_gen_consumer_string() + "\n")

def gen_couriers():
    def _gen_courier_string():
        faker = Faker()
        f_name = faker.first_name()
        l_name = faker.last_name()
        phone = faker.phone_number()
        transport = COURIER_TRANSPORT[randint(0, len(COURIER_TRANSPORT)) - 1]

        return f"{f_name};{l_name};{phone};{transport}"

    with open("couriers.csv", "w") as f: 
        f.write("f_name;l_name;phone;transport\n")
        for _ in range(COUNT_COURIERS):
            f.write(_gen_courier_string() + "\n")

def gen_orders_product_relation():
    product_order = []
    def _gen_order_product_string():
        order_id = randint(1, COUNT_ORDERS)
        product_id = randint(1, COUNT_PRODUCTS)
        product_order.append((product_id, order_id))

        return f"{order_id};{product_id}"

    with open("orders_product.csv", "w") as f:
        f.write("order_id;product_id\n")
        for _ in range(COUNT_ORDER_PRODUCT_RELATION):
            f.write(_gen_order_product_string() + "\n")

    return product_order

def get_price_for_order(id, product_price: dict, product_order: dict):
    price = 0

    for pair in product_order:
        product_id = pair[0]
        order_id = pair[1]

        if order_id == id:
            price += product_price[product_id]
    
    return price

def gen_orders(product_price, product_order):
    def _gen_order_string(id):
        faker = Faker()
        consumer_id = randint(1, COUNT_CONSUMERS)
        price = get_price_for_order(id, product_price, product_order)
        date_of_issue = faker.date_between(datetime(1960, 1, 1), datetime(2020, 1, 1))
        date_of_delivery = date_of_issue + timedelta(days=randint(2, 10))

        return f"{consumer_id};{price};{date_of_issue};{date_of_delivery}"

    with open("orders.csv", "w") as f: 
        f.write("consumer_id;price;date_of_issue;date_of_delivery\n")
        for i in range(COUNT_ORDERS):
            f.write(_gen_order_string(i + 1) + "\n")

def gen_deliveries():
    def _gen_delivery_string():
        consumer_id = randint(1, COUNT_CONSUMERS)
        order_id = randint(1, COUNT_ORDERS)
        courier_id = randint(1, COUNT_COURIERS)
        status = DELIVERY_STATUS[randint(0, len(DELIVERY_STATUS) - 1)]
        payment_method = PAYMENT_METHODS[randint(0, len(PAYMENT_METHODS) - 1)]


        return f"{consumer_id};{order_id};{courier_id};{status};{payment_method}"

    with open("deliveries.csv", "w") as f: 
        f.write("consumer_id;order_id;courier_id;status;payment_method\n")
        for _ in range(COUNT_ORDERS):
            f.write(_gen_delivery_string() + "\n")


def gen_warehouse_companies():
    def warehouse_companie_string():
        faker = Faker()
        name = faker.word()
        address = faker.address().split('\n')[0]
        phone = faker.phone_number()
        value = randint(1000, 100000)

        return f"{name};{address};{phone};{value}"
    with open("warehouse_companies.csv", "w") as f: 
        f.write("name;address;phone;value\n")
        for _ in range(COUNT_WAREHOUSES):
            f.write(warehouse_companie_string() + "\n")

if __name__ == '__main__':
    # gen_warehouse_companies()
    # product_price = gen_products()
    # gen_consumers()
    # gen_couriers()
    # product_order = gen_orders_product_relation()
    # gen_orders(product_price, product_order)
    gen_deliveries()
