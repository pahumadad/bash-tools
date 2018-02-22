FROM postgres:9.6

ARG DUMP_FILE
ADD ${DUMP_FILE} /docker-entrypoint-initdb.d/
