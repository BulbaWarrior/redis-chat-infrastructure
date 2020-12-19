#!/bin/bash

sudo curl -sLS get.docker.com | sh

# sudo docker run -p 6379:6379 --name redis -d redis
sudo docker run -p 6379:6379 --name redis -d redis redis-server --appendonly yes

sudo mkdir -p /data
sudo chown 1000 /data
sudo docker volume create --driver local --opt type=none --opt device=/data --opt o=bind data
sudo docker run -p 5432:5432 -v data:/var/lib/postgresql/data --name postgres -d --env POSTGRES_DB=postgres --env POSTGRES_USER=postgres --env POSTGRES_PASSWORD=postgres postgres
