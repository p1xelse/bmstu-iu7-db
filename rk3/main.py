from peewee import *

from datetime import *

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


class Employee(BaseModel):
    id = IntegerField(column_name='id')
    fio = CharField(column_name='fio')
    birthdate = DateField(column_name='birthdate')
    department = CharField(column_name='department')

    class Meta:
        table_name = 'employee'


class Record(BaseModel):
    id = IntegerField(column_name='id')
    employee_id = ForeignKeyField(Employee, backref='employee_id')
    e_date = DateField(column_name='rdate')
    day_of_week = CharField(column_name='dayweek')
    e_time = TimeField(column_name='rtime')
    e_type = IntegerField(column_name='rtype')

    class Meta:
        table_name = 'record'

REQ_1 = """
SELECT department
FROM employee
WHERE ((EXTRACT(year FROM CURRENT_DATE) - EXTRACT(year FROM birthdate)) > 25)
"""

REQ_2 = """
SELECT employee.id, employee.fio
FROM record
JOIN employee ON record.employee_id = employee.id
WHERE rdate = CURRENT_DATE -- для теста можно '2020-11-15'
AND rtype = 1
AND rtime IN
(
    SELECT MIN(rtime)
    FROM record
    WHERE rdate = CURRENT_DATE --для теста можно' 2020-11-15'
    AND rtype = 1
)
LIMIT 1;
"""

REQ_3 = """
SELECT e.id, e.fio, count(e.id)
FROM employee AS e 
JOIN record AS r ON r.employee_id = e.id
WHERE (r.rtime > '9:00:00') AND (r.rtype = 1) 
GROUP BY e.id, e.fio 
HAVING (Count(e.id) > 5);
"""

def output(cur):
    rows = cur.fetchall()
    for elem in rows:
        print(*elem)
    print()


def print_query(query):
    for elem in query.dicts().execute():
        print(elem)


def task_1():
    print("\n------EXECUTE------\n")
    global con

    cur = con.cursor()

    cur.execute(REQ_1)
    print("Задание 1:")
    output(cur)

    cur.execute(REQ_2)
    print("Задание 2:")

    output(cur)

    cur.execute(REQ_3)
    print("Задание 3:")
    output(cur)

    cur.close()


def task_2():
    print("\n------ORM------\n")
    print("1. Найти все отделы, в которых нет сотрудников моложе 25 лет")
    tmp = datetime.now().year - Employee.birthdate.year
    query = Employee.select(Employee.department).where(tmp > '25')
    print_query(query)

    print("2. Найти сотрудника, который пришел сегодня на работу раньше всех")
    query = Record.select(
        fn.Min(Record.e_time).alias('min_time')).where(Record.e_type == 1 and Record.e_date == date.today())
    min_time = query.dicts().execute()

    query = Record.select(Record.employee_id).where(
        Record.e_time == min_time[0]['min_time']).where(Record.e_type == 1 and Record.e_date == date.today()).limit(1)
    print_query(query)

    print("3. Найти сотрудников, опоздавших не менее 5-ти раз")

    query = Employee.select(Employee.id, Employee.fio).join(Record).where(Record.e_time > '09:00:00').where(
        Record.e_type == 1).group_by(Employee.id, Employee.fio).having(fn.Count(Employee.id) > 5)
    print_query(query)


def main():
    task_1()
    task_2()


if __name__ == "__main__":
    main()


con.close()