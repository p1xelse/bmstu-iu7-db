start:
	docker-compose up -d

stop:
	docker-compose down

delete:
	docker kill test_pg || true && docker rm test_pg || true

create_tables:
	psql postgresql://root:postgres@localhost:8080/postgres -f SQL/tables.sql
	psql postgresql://root:postgres@localhost:8080/postgres -f SQL/check.sql

generate_data:
	cd gen && python3 gen.py

fill_tables:
	psql postgresql://root:postgres@localhost:8080/postgres -f SQL/fetch_data_csv.sql

drop_tables:
	psql postgresql://root:postgres@localhost:8080/postgres -f SQL/drop_all.sql