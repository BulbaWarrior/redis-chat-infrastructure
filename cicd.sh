#!/bin/bash

sudo curl -sLS get.docker.com | sh
#sudo apt install -y unzip
#sudo unzip /tmp/jenkins_home.zip -d /
sudo mkdir /jenkins_home
sudo chown 1000 /jenkins_home

sudo docker network create jenkins
sudo docker run \
     --name jenkins-docker \
     --rm \
     --detach \
     --privileged \
     --network jenkins \
     --network-alias docker \
     --env DOCKER_TLS_CERTDIR=/certs \
     --volume jenkins-docker-certs:/certs/client \
     --volume /jenkins_home:/var/jenkins_home \
     --publish 2376:2376 \
     docker:dind
       
sudo docker run --name jenkins-blueocean \
     --rm -d \
     --network jenkins \
     --env DOCKER_HOST=tcp://docker:2376 \
     --env DOCKER_CERT_PATH=/certs/client \
     --env DOCKER_TLS_VERIFY=1 \
     -p 8080:8080 -p 50000:50000 \
     --volume /jenkins_home:/var/jenkins_home \
     --volume jenkins-docker-certs:/certs/client:ro \
     bulbawarrior/jenkins-blueocean:1.0

