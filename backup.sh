#!/bin/bash

# Prerequires

sudo apt update -y
sudo apt install wget -y
sudo apt install debconf-utils -y

# Install database

sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password ${database_pass}'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password ${database_pass}'
sudo apt install mysql-server -y

# Install bacula

sudo debconf-set-selections <<< 'postfix postfix/main_mailer_type select Local only'
sudo debconf-set-selections <<< 'postfix postfix/mailname string backup'
sudo debconf-set-selections <<< 'bacula-director-sqlite3 bacula-director-sqlite3/dbconfig-install boolean true'
#sudo debconf-set-selections <<< 'dbconfig-common dbconfig-common/pgsql/admin-pass password ${database_pass}'
#sudo debconf-set-selections <<< 'bacula-director-sqlite3 bacula-director-sqlite3/password-confirm password ${database_pass}'
sudo install bacula-server -y

# Configure Bacula Storage

sudo mkdir /backup
sudo chown -R bacula:bacula /backup
sudo nano /etc/bacula/bacula-sd.conf

systemctl restart bacula-sd.service
sudo systemctl restart bacula-dir
