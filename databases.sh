#!/bin/bash

sudo curl -sLS get.docker.com | sh

# sudo docker run -p 6379:6379 --name redis -d redis
sudo docker run -p 6379:6379 --name redis -d redis redis-server --appendonly yes

sudo docker run -p 5432:5432 --name postgres -d --env POSTGRES_DB=postgres --env POSTGRES_USER=postgres --env POSTGRES_PASSWORD=postgres postgres