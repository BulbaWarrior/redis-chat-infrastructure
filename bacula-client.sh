#!/bin/bash

sudo apt update
sudo apt install bacula-client -y
sudo cp /home/${user}/bacula-fd.conf /etc/bacula/bacula-fd.conf
sudo systemctl enable bacula-fd
sudo systemctl restart bacula-fd
