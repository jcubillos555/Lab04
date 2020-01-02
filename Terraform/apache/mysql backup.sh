#!/bin/bash
sudo apt-get -y update && sudo apt-get -y upgrade
sudo apt-get -y install mysql-server
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';FLUSH PRIVILEGES;";
sudo mysql -e "CREATE USER 'admin'@'%' IDENTIFIED BY 'admin';FLUSH PRIVILEGES;";
sudo mysql -e "GRANT ALL PRIVILEGES ON * . * TO 'admin'@'%';FLUSH PRIVILEGES;";
sudo mysql -e alter user "'admin'@'%' identified with mysql_native_password by 'semba00';FLUSH PRIVILEGES;";
sudo mysql -e "CREATE DATABASE crud_app";
sudo mysql -e "USE crud_app";