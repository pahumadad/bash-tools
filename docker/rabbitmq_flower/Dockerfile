FROM ubuntu:17.10

RUN apt-get update

RUN apt-get install -y python python-pip

RUN pip install flower

ARG IP
ENV IP ${IP}

CMD flower --port=5555 --broker=amqp://guest:guest@${IP}:5672//
