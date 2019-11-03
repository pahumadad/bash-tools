FROM python:3.6

ARG AIRFLOW_HOME
ARG AIRFLOW_VERSION
ENV AIRFLOW_HOME=${AIRFLOW_HOME}

RUN pip install apache-airflow[celery,crypto,postgres,redis]==${AIRFLOW_VERSION} && \
    pip install psycopg2-binary

COPY airflow.cfg ${AIRFLOW_HOME}/airflow.cfg
COPY entrypoint.sh ${AIRFLOW_HOME}/entrypoint.sh
WORKDIR ${AIRFLOW_HOME}

CMD bash
