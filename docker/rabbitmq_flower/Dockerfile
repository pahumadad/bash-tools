FROM python:3.6-alpine3.7

RUN pip install flower

ARG IP
ENV IP ${IP}

CMD flower --port=5555 --broker=amqp://guest:guest@${IP}:5672//
