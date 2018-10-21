FROM python:3

WORKDIR /app
ADD . /app

RUN pip install --no-cache-dir pipenv

RUN pipenv install --system --deploy --ignore-pipfile

EXPOSE 61220

CMD ["twistd", "--nodaemon", "--python", "player.tac"]
