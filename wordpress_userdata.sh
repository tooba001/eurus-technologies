#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo yum install -y httpd php php-common php-gd php-mysqli
sudo systemctl restart httpd
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
sudo yum localinstall mysql57-community-release-el7-11.noarch.rpm -y
sudo yum install mysql-community-server -y
sudo systemctl start mysqld
password=$(sudo grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
password2='green200#Tooba'
sudo mysqladmin -u root --password="$password" password "$password2"
mysql -u root -p"$password2"
echo "$password" >> aa.txt
cat aa.txt
sudo mysql -u root -p"$password2" -e "CREATE DATABASE wordpress;"
sudo mysql -u root -p"$password2" -e "CREATE USER 'wpuser'@'%' IDENTIFIED BY 'green200#Tooba';"
sudo mysql -u root -p"$password2" -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'%';"
sudo mysql -u root -p"$password2" -e "FLUSH PRIVILEGES;"
sudo wget https://wordpress.org/latest.zip
sudo unzip latest.zip
sudo cp -r wordpress/* /var/www/html
sudo chown apache:apache -R /var/www/html
sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sudo sed -i 's/database_name_here/wordpress/' /var/www/html/wp-config.php
sudo sed -i 's/username_here/wpuser/' /var/www/html/wp-config.php
sudo sed -i 's/password_here/green200#Tooba/' /var/www/html/wp-config.php
sed -i 's/localhost/localhost/' /var/www/html/wp-config.php
sudo systemctl restart httpd 
cat aa.txt
