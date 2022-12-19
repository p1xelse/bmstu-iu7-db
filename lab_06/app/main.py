from email.policy import default
from database import Database

SQL_DIR = 'app/sql/'


def print_menu():
    print("\n\n\t1. Выполнить скалярный запрос \
             \n\t2. Выполнить запрос с несколькими соединениями (JOIN) \
             \n\t3. Выполнить запрос с ОТВ(CTE) и оконными функциями \
             \n\t4. Выполнить запрос к метаданным \
             \n\t5. Вызвать скалярную функцию \
             \n\t6. Вызвать многооператорную табличную функцию \
             \n\t7. Вызвать хранимую процедуру \
             \n\t8. Вызвать системную функцию \
             \n\t9. Создать таблицу в базе данных, соответствующую тематике БД \
             \n\t10. Выполнить вставку данных в созданную таблицу с использованием инструкции INSERT \
             \n\t11. Курьер по номеру заказа \
           \n\n\t0. Выход\n\n")


def scalar_query(db: Database):
    res = db.execute_file(SQL_DIR + "1_scalar.sql")
    print("Result: ", res)


def join_query(db: Database):
    res = db.execute_file(SQL_DIR + "2_join.sql")
    print("Result: ", res)


def cte_query(db: Database):
    res = db.execute_file(SQL_DIR + "3_cte.sql")
    print("Result: ", res)


def meta_query(db: Database):
    res = db.execute_file(SQL_DIR + "4_meta.sql")
    print("Result: ", res)


def scalarf_query(db: Database):
    res = db.execute_file(SQL_DIR + "5_scalarf.sql")
    print("Result: ", res)


def window_query(db: Database):
    res = db.execute_file(SQL_DIR + "6_window.sql")
    print("Result: ", res)


def procedure_query(db: Database):
    db.execute_procedure(SQL_DIR + "7_store.sql")


def sys_call_query(db: Database):
    res = db.execute_file(SQL_DIR + "8_syscall.sql")
    print("Result: ", res)


def table_query(db: Database):
    db.execute_procedure(SQL_DIR + "9_table.sql")


def insert_query(db: Database):
    db.execute_procedure(SQL_DIR + "10_insert.sql")

def courier_query(db: Database, id):
    q = """
select d.courier_id 
from orders as o
join deliveries d on d.order_id = o.id 
where o.id = {};
""".format(id)
    res = db.execute_query(q)
    print("Courier_id:", res[0][0])

def run(db: Database):
    option = None
    while(option != 0):
        try:
            print_menu()
            option = int(input("Выберите пункт меню: "))
        except:
            print("\nПовторите ввод\n")
            continue

        match option:
            case 1:
                scalar_query(db)
            case 2:
                join_query(db)
            case 3:
                cte_query(db)
            case 4:
                meta_query(db)
            case 5:
                scalarf_query(db)
            case 6:
                window_query(db)
            case 7:
                procedure_query(db)
            case 8:
                sys_call_query(db)
            case 9:
                table_query(db)
            case 10:
                insert_query(db)
            case 11:
                id = int(input("Введите ID заказа: "))
                courier_query(db, id)
            case _:
                print("Пункт должен быть больше нуля либо меньше 11")


if __name__ == "__main__":
    db = Database()
    run(db)
