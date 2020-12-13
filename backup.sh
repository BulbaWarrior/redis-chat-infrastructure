#!/bin/bash

# Prerequires

sudo apt install wget -y

# Install bacula

sudo apt update -y
sudo apt install bacula -y

# Configure postfix

sudo wget -P /etc/postfix -O main.cf https://raw.githubusercontent.com/BulbaWarrior/redis-chat-infrastructure/master/backups/postfix/main.cf
sudo wget -P /etc/postfix -O master.cf https://raw.githubusercontent.com/BulbaWarrior/redis-chat-infrastructure/master/backups/postfix/master.cf

# Configure Bacula Storage

sudo mkdir /backup
sudo chown -R bacula:bacula /backup
sudo nano /etc/bacula/bacula-sd.conf

sudo wget -P /etc/bacula -O bacula-sd.conf https://raw.githubusercontent.com/BulbaWarrior/redis-chat-infrastructure/master/backups/bacula/bacula-sd.conf
sudo wget -P /etc/bacula -O bacula-dir.conf https://raw.githubusercontent.com/BulbaWarrior/redis-chat-infrastructure/master/backups/bacula/bacula-dir.conf
