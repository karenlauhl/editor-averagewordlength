FROM ubuntu:22.04

RUN apt-get update -y && apt-get install -y python3-pip python3
WORKDIR /app

RUN pip3 install flask

COPY ./src /app

EXPOSE 5200

ENTRYPOINT [ "python3" ]
CMD [ "app.py" ]