#!/bin/bash

sudo curl -sLS get.docker.com | sh
sudo apt install -y unzip
sudo unzip /tmp/jenkins_home.zip -d /
sudo chown 1000 /jenkins_home
sudo docker run -p 80:8080 -v /jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock gustavoapolinario/jenkins-docker

