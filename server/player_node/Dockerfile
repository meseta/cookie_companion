FROM python:3.6.6-alpine

RUN apk add --update python3-dev build-base \
    && rm -rf /var/cache/apk/*
    
RUN pip install --no-cache-dir pipenv

WORKDIR /app
ADD ./Pipfile* ./.env /app/
RUN pipenv install


ADD . /app

EXPOSE 61220

CMD ["pipenv", "run", "twistd", "--nodaemon", "--python", "player.tac"]
