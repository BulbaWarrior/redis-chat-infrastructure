#!/bin/bash

sudo curl -sLS get.docker.com | sh
sudo mkdir -p /jenkinshome
sudo docker run -p 80:8080 -p 50000:50000 -v /jenkins_home:/var/jenkins_home jenkins/jenkins:lts
