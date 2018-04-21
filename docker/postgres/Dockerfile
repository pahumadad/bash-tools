FROM postgres

ARG DUMP
ENV DUMP ${DUMP}
ADD ${DUMP} /docker-entrypoint-initdb.d/
