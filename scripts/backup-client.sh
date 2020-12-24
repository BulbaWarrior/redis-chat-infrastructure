#!/bin/bash

sudo apt update
sudo apt install bacula-client -y

sudo rm /etc/bacula/bacula-fd.conf
sudo mv /tmp/bacula-fd.conf /etc/bacula/bacula-fd.conf

sudo mkdir /opt/restore
sudo chown -R bacula:bacula /opt/restore

sudo systemctl enable bacula-fd
sudo systemctl restart bacula-fd
