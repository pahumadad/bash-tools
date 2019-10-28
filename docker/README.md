docker scripts
==============

postgres
--------

How to use it?

```
$ bash service.sh
container options:
        [--start]       to start a PostgreSQL Docker container DB
                        if a dump file y given with '--db-dump' argument there will be created
                        the new Docker DB image and this will be used to start the container
                        optionals: [--user-name, --user-pass, --db-name, --db-port, --db-img, --db-dump]
        [--stop]        to stop a PostgreSQL Docker container DB
                        needs: [--db-name]
        [--restart]     to restart a PostgreSQL Docker container DB
                        needs: [--db-name]
        [-s --save]     to create a DB dump. You need to specify the DB connection credentials
                        a path/to/the/file.sql could be specified with the --db-dump argument
                        needs: [--user-name, --db-name], optionals: [--db-dump]

DB options:
        [--user-name DB_USER_NAME]      set an user name. Default is 'admin'
        [--user-pass DB_USER_PASS]      set an user pass. Default is 'admin'
        [--db-name DB_NAME]             set a DB name. Dafult is 'example_db'
                                        this name will be use as the Docker container name as well
        [--db-port DB_PORT]             set the DB port. Dafult is '5432'
        [--db-img DB_IMG_NAME]          use a specific Docker PostgreSQL DB image
                                        default is 'postgres' latest
        [--db-dump PATH/TO/DUMP.SQL]    use a 'dump.sql' file to create a Docker
                                        PostgreSQL DB image with this DB dump
                                        the Docker image got will be called as the dump.sql file used
```

rabbitmq_flower
---------------

These scripts allows eassily start up two docker containers, one with RabbitMQ and another with Flower.

How to use it?

```
$ bash service.sh --start      to start up the two services
                  --stop       to stop them and destroy the containers
                  --restart    to stop them, destroy the containers and start them again
```

redis
---------------

How to use it?

```
$ bash service.sh -h
usage service.sh
        [--start]       to start a Redis Docker container DB
                        optionals: [--name, --port, --data]
        [--stop]        to stop a Redis Docker container DB
                        needs: [--name]
        [--restart]     to restart a Redis Docker container DB
                        needs: [--db-name]
        [--save]        to create a backup from a Redis Docker container DB
                        the backup will be left in the folder path given with
                        '--data' (used when the container was started) with the
                        file name given with '--dump-name'
                        needs: [--db-name, --dump-name]
container options:
        [--name NAME]           set the container name. Dafult is 'redis'
        [--port PORT]           set the DB port. Dafult is '6379'
        [--data FOLDER PATH]    folder mounted as '/data' used by Redis
        [--dump-name NAME]      set the backup file name. Default is 'dump.rdb'
```
