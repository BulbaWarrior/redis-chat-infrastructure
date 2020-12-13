#!/bin/bash

sudo curl -sLS get.docker.com | sh
sudo docker build https://github.com/kezzyhko/django-redis-chat.git#main --tag django-redis-chat
sudo docker run -p 80:8000 --name django-redis-chat -d --env POSTGRES=${database_addr} --env REDIS=${database_addr} --env NODE_ID=${node_id} django-redis-chat bash -c "python3 manage.py makemigrations && python3 manage.py migrate --run-syncdb && python3 -u manage.py runserver 0.0.0.0:8000 --noreload"
