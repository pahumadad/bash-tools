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
	[--stop]	to stop a PostgreSQL Docker container DB
	[--restart]	to restart a PostgreSQL Docker container DB

DB options:
	[--user_name]	set an user name. Default is 'admin'
	[--user_pass]	set an user pass. Default is 'admin'
	[--db_name]	set a DB name. Dafult is 'example_db'.
			This name will be use as the Docker container name as well.
```
