#!/bin/bash

sudo apt update
sudo apt install bacula-client -y
sudo rm /etc/bacula/bacula-fd.conf
sudo mv /tmp/bacula-fd.conf /etc/bacula/bacula-fd.conf
sudo systemctl enable bacula-fd
sudo systemctl restart bacula-fd
