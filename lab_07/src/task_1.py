from py_linq import Enumerable
from consumer_orders import *


def request_1(consumers: Enumerable):
    result = consumers.where(
        lambda x: x['id'] > 5).order_by(
        lambda x: x['first_name']).select(
        lambda x: {x['id'], x['first_name'],
                   x['last_name']})
    
    return result

def request_2(consumers: Enumerable):
    result = consumers.count(lambda x: x['id'])
    return result

def request_3(consumers: Enumerable):
	# Минимальное и максимальное имя 
	f_name = Enumerable([{consumers.min(lambda x: x['first_name']), consumers.max(lambda x: x['first_name'])}])
	print(f_name)
    # Минимальное и максимальное фамилия 
	l_name = Enumerable([{consumers.min(lambda x: x['last_name']), consumers.max(lambda x: x['last_name'])}])
	result = Enumerable(f_name).union(Enumerable(l_name), lambda x: x)
	return result


def request_4(orders):
    result = orders.group_by(key_names = ['consumer_id'], key = lambda x: x['consumer_id']).select(lambda g: {'key': g.key.consumer_id, 'count': g.count()})
    return result

def request_5(consumers, orders):
    # тут получается тапл
	result = orders.join(consumers, lambda o_k : o_k['consumer_id'], lambda i_k: i_k['id'])
	return result


def main():
    consumers = Enumerable(create_consumers('consumers.csv'))
    orders = Enumerable(create_orders('orders.csv'))
    print("1) Количество покупателей id > 5 + order_by:")
    print(request_1(consumers), end='\n\n')
    print("2) Количество покупателей:")
    print(request_2(consumers), end='\n\n')
    print("3) Минимальные и максимальные имена + фамилии:")
    print(request_3(consumers), end='\n\n')
    print("4) Группировка заказов по заказчику:")
    print(request_4(orders), end='\n\n')
    print("5) Join заказов и заказчиков:")
    print(request_5(consumers, orders), end='\n\n')

main()