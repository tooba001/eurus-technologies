#!/bin/bash
sudo apt install apache2
sudo systemctl status apache2
sudo apt install php -y
sudo apt install wget
wget https://wordpress.org//latest.zip
unzip latest.zip
sudo apt install php-mysql php-cgi php-cli php-gd -y
cd wordpress
sudo mkdir /var/www/html
cp -r * /var/www/html
ls
cd /var/www/html
ls
sudo rm -rf index.html
ls
sudo systemctl restart apache2
sudo chown -R www-data:www-data /var/www/html
ip a
db_name="wordpress_db"
db_user="wordpress_user"
db_password="tooba2001"
db_host="192.168.0.101"
sudo sed -i "s/database_name_here/$db_name/" /var/www/html/wp-config.php
sudo sed -i "s/username_here/$db_user/" /var/www/html/wp-config.php
sudo sed -i "s/password_here/$db_password/" /var/www/html/wp-config.php
sudo sed -i "s/localhost/$db_host/" /var/www/html/wp-config.php

