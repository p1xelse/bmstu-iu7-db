from consumer_orders import consumer
import json
import psycopg2

DEFAULT_CONFIG = {
    "db_host": "localhost",
    "db_user": "postgres",
    "db_pswd": "postgres",
    "db_database": "postgres",
    "port": 8080
}

def connection():
    cfg = DEFAULT_CONFIG
    try:
        con = psycopg2.connect(host = cfg["db_host"], user = cfg["db_user"], password = cfg["db_pswd"], database = cfg["db_database"], port=cfg["port"])
    except:
        print("Ошибка при подключении к Базе Данных")
        return

    print("База данных успешно открыта")
    return con

def read_table_json(cur, count = 20):
	cur.execute("select * from consumers_json")

	rows = cur.fetchmany(count)
	array = list()
	for elem in rows: 
		tmp = elem[0]
		array.append(consumer(tmp['id'], tmp['first_name'], tmp['last_name'], tmp['address'], tmp['phone_number']))

	print(f"{'id':<2} {'first_name':<20} {'last_name':<5} {'address':<20} {'phone_number':<5}")
	print(*array, sep='\n')
	
	return array

def output_json(array):
	for elem in array:
		print(json.dumps(elem.get()))

def update_consumer(consumer, ws, fs):
	for elem in consumer:
		if elem.first_name == ws:
			elem.first_name = fs
	output_json(consumer)

def add_consumer(consumers, consumer):
	consumers.append(consumer)
	output_json(consumers)

def task_2():
    con = connection()
    cur = con.cursor()

    # 1. Чтение из XML/JSON документа.
    print("1.Чтение из XML/JSON документа:")
    consumers_array = read_table_json(cur)

    # 2. Обновление XML/JSON документа.
    print("2.Обновление XML/JSON документа:")
    name = input("Введите имя: ")
    new_name = input("Введите новое имя: ")
    update_consumer(consumers_array, name, new_name)

    # 3. Запись (Добавление) в XML/JSON документ.
    print("3.Запись (Добавление) в XML/JSON документ:")
    name = input("Введите имя: ")
    lname = input("Введите фамилию: ")
    address = input("Введите адрес: ")
    phone = input("Введите номер телефона: ")
    add_consumer(consumers_array, consumer(1111, name, lname, address, phone))

    # Закрываем соединение с БД.
    cur.close()
    con.close()

task_2()