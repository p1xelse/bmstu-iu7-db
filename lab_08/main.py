from faker import Faker
from random import randint, choice
import datetime
import time
import json


class consumer():
    def __init__(self, f_name, l_name, address, phone):
        self.f_name = f_name
        self.l_name = l_name
        self.address = address
        self.phone = phone

    def get(self):
        return {'first_name': self.f_name, 'last_name': self.l_name,
                'address': self.address, 'phone_number': self.phone}

    def __str__(self):
        return f"{self.f_name:<20} {self.l_name:<20} {self.address:<5} {self.phone:<15}"



def main():
    faker = Faker()  # faker.name()
    i = 0


    while True:
        obj = consumer(faker.first_name(), faker.last_name(), faker.address().split('\n')[0], faker.phone_number())

        # print(obj)
        print(json.dumps(obj.get()))
        
        file_name = "nifi/in_file/consumer_" + str(i) + "_" + \
        	str(datetime.datetime.now().strftime("%d_%m_%Y_%H_%M_%S")) + ".json"

        print(file_name)
        
        with open(file_name, "w") as f:
            print(json.dumps(obj.get()), file=f)

        i += 1
        time.sleep(10)


if __name__ == "__main__":
	main()