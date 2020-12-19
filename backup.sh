#!/bin/bash

# Prerequires

sudo apt update -y
sudo apt install debconf-utils -y

# Install database

sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password ${bacula_database_pass}'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password ${bacula_database_pass}'
sudo apt install mysql-server -y

# Install bacula-director-mysql

sudo debconf-set-selections <<< 'dbconfig-common dbconfig-common/mysql/admin-pass password ${bacula_database_pass}'
sudo debconf-set-selections <<< 'bacula-director-mysql bacula-director-mysql/mysql/admin-pass password ${bacula_database_pass}'
sudo debconf-set-selections <<< 'bacula-director-mysql bacula-director-mysql/password-confirm password ${bacula_database_pass}'
sudo debconf-set-selections <<< 'dbconfig-common dbconfig-common/mysql/app-pass password ${bacula_database_pass}'
sudo debconf-set-selections <<< 'bacula-director-mysql bacula-director-mysql/mysql/app-pass password ${bacula_database_pass}'
sudo debconf-set-selections <<< 'bacula-director-mysql bacula-director-mysql/app-password-confirm password ${bacula_database_pass}'
sudo debconf-set-selections <<< 'bacula-director-mysql bacula-director-mysql/dbconfig-install boolean true'
sudo apt install bacula-director-mysql -y

# Install bacula

sudo debconf-set-selections <<< 'postfix postfix/main_mailer_type select Local only'
sudo debconf-set-selections <<< 'postfix postfix/mailname string backup'
sudo debconf-set-selections <<< 'bacula-director-sqlite3 bacula-director-sqlite3/dbconfig-install boolean true'
#sudo debconf-set-selections <<< 'dbconfig-common dbconfig-common/pgsql/admin-pass password ${bacula_database_pass}'
#sudo debconf-set-selections <<< 'bacula-director-sqlite3 bacula-director-sqlite3/password-confirm password ${bacula_database_pass}'
sudo apt install bacula-server -y
sudo apt install bacula-console -y

# Apply configs

sudo mv /tmp/main.cf /etc/postfix/main.cf
sudo mv /tmp/master.cf /etc/postfix/master.cf
sudo mv /tmp/bacula-dir.conf /etc/bacula/bacula-dir.conf
sudo mv /tmp/bacula-sd.conf /etc/bacula/bacula-sd.conf
sudo mv /tmp/bconsole.conf /etc/bacula/bconsole.conf

# Configure Bacula Storage

sudo mkdir /backup
sudo chown -R bacula:bacula /backup

sudo systemctl restart bacula-sd.service
sudo systemctl restart bacula-dir
