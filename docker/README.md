docker scripts
==============

rabbitmq_flower
---------------

These scripts allows eassily start up two docker containers, one with RabbitMQ and another with Flower.

How to use it?

```
$ bash service.sh --start      to start up the two services
                  --stop       to stop them and destroy the containers
                  --restart    to stop them, destroy the containers and start them again
```


postgres
--------

How to use it?

```
$ bash service.sh
container options:
	[--start]	to start a PostgreSQL Docker container DB
			if a dump file y given with '--db_dump' argument there will be created
			the new Docker DB image and this will be used to start the container
			optionals: [--user_name, --user_pass, --db_name, --db_img, --db_dump]
	[--stop]	to stop a PostgreSQL Docker container DB
			needs: [--db_name]
	[--restart]	to restart a PostgreSQL Docker container DB
			needs: [--db_name]
	[-s --save]	to create a DB dump. You need to specify the DB connection credentials
			a path/to/the/file.sql could be specified with the --db_dump argument
			needs: [--user_name, --db_name], optionals: [--db_dump]

DB options:
	[--user_name DB_USER_NAME]	set an user name. Default is 'admin'
	[--user_pass DB_USER_PASS]	set an user pass. Default is 'admin'
	[--db_name DB_NAME]		set a DB name. Dafult is 'example_db'
					this name will be use as the Docker container name as well
	[--db_img DB_IMG_NAME]		use a specific Docker PostgreSQL DB image
					default is 'postgres' latest
	[--db_dump PATH/TO/DUMP.SQL]	use a 'dump.sql' file to create a Docker
					PostgreSQL DB image with this DB dump
					the Docker image got will be called as the dump.sql file used.
```
