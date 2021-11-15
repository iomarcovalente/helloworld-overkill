FROM python:alpine
LABEL MAINTAINER="io.marco.valente@gmail.com"
ENV FLASK_APP app
COPY requirements.txt ./
COPY app.py requirements.txt /app/
RUN pip3 install --no-cache --upgrade pip
RUN pip3 install -r requirements.txt

ENV LISTEN_PORT 8080

EXPOSE 8080

WORKDIR /app

CMD ["flask", "run", "--port=8080", "--host=0.0.0.0"]
