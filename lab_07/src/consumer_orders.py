from datetime import datetime
from dateutil import parser

class consumer():
    id = int()
    first_name = str()
    last_name = str()
    address = str()
    phone_number = str()

    def __init__(self, id, first_name, last_name, address, phone_number) -> None:
        self.id = id
        self.first_name = first_name
        self.last_name = last_name
        self.address = address
        self.phone_number = phone_number

    def get(self):
        return {'id': self.id, 'first_name': self.first_name, 'last_name': self.last_name,
                'address': self.address, 'phone_number': self.phone_number}

    def __str__(self) -> str:
        return f"{self.id, self.first_name, self.last_name, self.address, self.phone_number}"

class order():
    id = int()
    consumer_id = int()
    price = int()
    date_of_issue = datetime.now()
    delivery_date = datetime.now()

    def __init__(self, id, consumer_id, price, date_of_issue, delivery_date) -> None:
        self.id = id
        self.consumer_id = consumer_id
        self.price = price
        self.date_of_issue = date_of_issue
        self.delivery_date = delivery_date

    def get(self):
        return {'id': self.id, 'consumer_id': self.consumer_id, 'price': self.price,
                'date_of_issue': self.date_of_issue, 'delivery_date': self.delivery_date}

    def __str__(self) -> str:
        return f"{self.id, self.consumer_id, self.price, self.date_of_issue, self.delivery_date}"

def create_consumers(file_name):
    file = open(file_name, 'r')
    consumers = list()

    for line in file:
        arr = line.split(';')
        arr[0] = int(arr[0])
        consumers.append(consumer(*arr).get())

    return consumers

def create_orders(file_name):
    file = open(file_name, 'r')
    orders = list()

    for line in file:
        arr = line.split(';')
        arr[0], arr[1], arr[2] = int(arr[0]), int(arr[1]), int(arr[2]) 
        arr[3] = datetime.strptime(arr[3].strip(" \n"), "%Y-%m-%d")
        arr[4] = datetime.strptime(arr[4].strip(" \n"), "%Y-%m-%d")
        orders.append(order(*arr).get())

    return orders


