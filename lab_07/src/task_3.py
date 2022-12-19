# 3. LINQ to SQL. Создать классы сущностей, которые моделируют таблицы
# Вашей базы данных. Создать запросы четырех типов:
# 1. Однотабличный запрос на выборку.
# 2. Многотабличный запрос на выборку.
# 3. Три запроса на добавление, изменение и удаление данных в базе
# данных.
# 4. Получение доступа к данным, выполняя только хранимую
# процедуру.

from peewee import *

con = PostgresqlDatabase(
    database="postgres",
    user="postgres",
    password="postgres",
    host="localhost",
    port=8080
)


class BaseModel(Model):
    class Meta:
        database = con


class Consumers(BaseModel):
    id = IntegerField(column_name='id')
    first_name = CharField(column_name='first_name')
    last_name = CharField(column_name='last_name')
    address = CharField(column_name='address')
    phone_number = CharField(column_name='phone_number')

    class Meta:
        table_name = 'consumers'


class Orders(BaseModel):
    id = IntegerField(column_name='id')
    consumer_id = ForeignKeyField(column_name='consumer_id', model=Consumers)
    price = IntegerField(column_name='price')
    date_of_issue = DateField(column_name='date_of_issue')
    delivery_date = DateField(column_name='delivery_date')

    class Meta:
        table_name = 'orders'

def query_1():
    # 1. Однотабличный запрос на выборку.
    consumer = Consumers.get(Consumers.id == 2) # get - одна запись
    print("1. Однотабличный запрос на выборку:")
    print(consumer.id, consumer.first_name, consumer.last_name, consumer.address, consumer.phone_number)

    # Получаем набор записей.
    query = Consumers.select().where(Consumers.id == 2).limit(10).order_by(Consumers.id)

    print("Запрос:", query, '\n')

    consumers_selected = query.dicts().execute()

    print("Результат:\n")
    for elem in consumers_selected:
        print(elem)


def query_2():
    # 2. Многотабличный запрос на выборку.
    global con
    print("\n2. Многотабличный запрос на выборку:")

    print("Заказчики и из заказы:")

    # Изер и цвет его шлема.
    query = Consumers.select(Consumers.first_name, Orders.id.alias("order_id")).join(
        Orders, on=(Consumers.id == Orders.consumer_id)).limit(5)
    
    print(query)

    u_d = query.dicts().execute()

    for elem in u_d:
        print(elem)


def print_last_five_consumers():
    # Вывод последних 5-ти записей.
    print("Последние 5 заказчиков:")
    query = Consumers.select().limit(5).order_by(Consumers.id.desc())
    for elem in query.dicts().execute():
        print(elem)
    print()

def get_last_cons_id():
    # Вывод последних 5-ти записей.
    query = Consumers.select().limit(1).order_by(Consumers.id.desc())
    elem = query.dicts().execute()[0]
    return elem["id"]



def add_consumer(new_name, new_lname, new_address, new_phone):
    global con

    try:
        with con.atomic() as txn:
            h = Consumers(first_name=new_name, last_name=new_lname, address=new_address, phone_number= new_phone)
            h.save()
            print("Заказчик успешно добавлен!")
    except:
        print("Заказчик уже существует!")
        txn.rollback()


def update_name(consumer_id, new_name):
    consumer = Consumers(id=consumer_id)
    consumer.first_name = new_name
    consumer.save()
    print("First name успешно обновлен!")


def del_consumer(consumer_id):
    consumer = Consumers.get(Consumers.id == consumer_id)
    consumer.delete_instance()
    print("Пользователь успешно удален!")


def query_3():
    # 3. Три запроса на добавление, изменение и удаление данных в базе данных.
    print("3. Три запроса на добавление, изменение и удаление данных в базе данных:")

    print_last_five_consumers()

    add_consumer("Dimaaa", "Neeew", "kon", "9021")
    print_last_five_consumers()

    update_name(get_last_cons_id(), 'Valera')
    print_last_five_consumers()

    del_consumer(get_last_cons_id())
    print_last_five_consumers()


def query_4():
    # 4. Получение доступа к данным, выполняя только хранимую процедуру.
    global con
    # Можно выполнять простые запросы.
    cursor = con.cursor()

    print("4. Получение доступа к данным, выполняя только хранимую процедуру:")


    print_last_five_consumers()

    consumer = Consumers.get(Consumers.id == 1)
    cursor.execute("call set_consumer_name(%s, %s);", (get_last_cons_id(), "Valera"))
    # # Фиксируем изменения.
    # # Т.е. посылаем команду в бд.
    # # Метод commit() помогает нам применить изменения,
    # # которые мы внесли в базу данных,
    # # и эти изменения не могут быть отменены,
    # # если commit() выполнится успешно.
    con.commit()

    print_last_five_consumers()

    cursor.execute("call set_consumer_name(%s, %s);", (get_last_cons_id(), consumer.first_name))
    con.commit()

    cursor.close()


def task_3():
    global con

    query_1()
    query_2()
    query_3()
    query_4()

    con.close()

task_3()