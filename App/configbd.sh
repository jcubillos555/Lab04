#!/usr/bin/env bash
#Set the user password
#sudo mysql -e "CREATE USER 'jcubillos555'@'localhost' IDENTIFIED BY 'jcubillos';FLUSH PRIVILEGES;"
#sudo mysql -e "GRANT ALL PRIVILEGES ON * . * TO 'jcubillos555'@'localhost';FLUSH PRIVILEGES;"
sudo mysql -e "CREATE DATABASE crud_app2@localhost;"
sudo mysql -u root -e "crud_app < users.sql;" 
#removes anonymous users
#sudo mysql -e "DELETE FROM mysql.user WHERE User='';"
#removes root remote access
#sudo mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"