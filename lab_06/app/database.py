import psycopg2


DEFAULT_CONFIG = {
    "db_host": "localhost",
    "db_user": "postgres",
    "db_pswd": "postgres",
    "db_database": "postgres",
    "port": 8080
}

class Database: 
    def __init__(self, cfg=DEFAULT_CONFIG) -> None:
        try:
            self.__connection = psycopg2.connect(host = cfg["db_host"], user = cfg["db_user"], password = cfg["db_pswd"], database = cfg["db_database"],
            port=cfg["port"])

            self.__connection.autocommit = True
            self.__cursor = self.__connection.cursor()

            print("\n[INFO] PostgreSQL: Connection opened\n")

        except Exception as error:
            print("\n[ERROR] Error ocured while init. Exception: ", error)
    def __del__(self):
        if self.__connection:
            self.__cursor.close()
            self.__connection.close()

            print("\n[INFO] PostgreSQL: Connection closed\n")
    def execute_file(self, file_name: str):
        try:
            file = open(file_name, 'r')
            query = file.read()
            res = self.execute_query(query)
            return res
        except Exception as e:
            print(f"[Error] error: {e.with_traceback}")


    def execute_query(self, query: str):
        try:
            self.__cursor.execute(query)
            return self.__cursor.fetchall()
        except Exception as e:
            print(f"[Error] error: {e.with_traceback}")
            raise

    def execute_procedure(self, file_name:str):
        try:
            file = open(file_name, "r")

            offset_notice = len(self.__connection.notices) # отделить предыдущие ненужные сообщения

            self.__cursor.execute(file.read())

            print("\n")

            for notice in self.__connection.notices[offset_notice:]: # получить список сообщений
                print(notice)

            print("\n\nSuccess procedure")
        except Exception as e:
            print(f"[Error] error during execute_procedure: {e.with_traceback}")