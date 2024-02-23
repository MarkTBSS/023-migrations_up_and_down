curl -L https://github.com/golang-migrate/migrate/releases/download/$version/migrate.$os-$arch.tar.gz | tar xvz

docker pull postgres:alpine

docker run --name container_name_db_test -e POSTGRES_USER=username -e POSTGRES_PASSWORD=password -p 4444:5432 -d image_hash
docker run --name kawaii_db_test -e POSTGRES_USER=kawaii -e POSTGRES_PASSWORD=123456 -p 4444:5432 -d 09ac24c200ca00e1e699bd76aea3987400e6451b98171ca6d648f0c8f637c23e

docker exec -it container_name_db_test bash
docker exec -it kawaii_db_test bash

073313f29e55:/#
psql -U username
psql -U kawaii

DROP DATABASE kawaii_db_test;
CREATE DATABASE kawaii_db_test;

#another bash
migrate -source file://path/to/migrations -database postgres://localhost:5432/database up 2 -verbose up
migrate -source file://C:/RAYATO159/Go-Fiber-REST-PostgreSQL/023-migrations_up_and_down/pkg/databases/migrations -database 'postgres://kawaii:123456@localhost:4444/kawaii_db_test?sslmode=disable' -verbose up
