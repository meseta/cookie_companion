FROM python:3.6

WORKDIR /app
ADD . /app

RUN pip install --no-cache-dir pipenv

RUN pipenv install

EXPOSE 61220

CMD ["pipenv", "run", "twistd", "--nodaemon", "--python", "player.tac"]
