#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo yum install -y httpd php php-common php-gd php-mysqli
sudo systemctl restart httpd
sudo wget https://wordpress.org/latest.zip
sudo unzip latest.zip
sudo cp -r wordpress/* /var/www/html
sudo chown apache:apache -R /var/www/html
sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sudo sed -i "s/database_name_here/wordpress/" /var/www/html/wp-config.php
sudo sed -i "s/username_here/wpuser/" /var/www/html/wp-config.php
sudo sed -i "s/password_here/green200#Tooba/" /var/www/html/wp-config.php
sed -i "s/localhost/$(awk -F: '{print $1}' <<< "${rds_endpoint}")/" /var/www/html/wp-config.php
sudo systemctl restart httpd  