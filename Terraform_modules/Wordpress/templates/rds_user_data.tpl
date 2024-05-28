#!/bin/bash
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
sudo yum localinstall mysql57-community-release-el7-11.noarch.rpm -y
sudo yum install mysql-community-server -y
sudo systemctl start mysqld
echo "${rds_endpoint}" >> test.txt 
cat test.txt
sudo mysql -h "$(awk -F: '{print $1}' <<< "${rds_endpoint}")" -P 3306 -u admin -p${db_password}
sudo mysql -h "$(awk -F: '{print $1}' <<< "${rds_endpoint}")" -P 3306 -u admin -p${db_password} -e "CREATE DATABASE wordpress;"
sudo mysql -h "$(awk -F: '{print $1}' <<< "${rds_endpoint}")" -P 3306 -u admin -p${db_password} -e "CREATE USER 'wpuser'@'%' IDENTIFIED BY '${wp_db_password}';"
sudo mysql -h "$(awk -F: '{print $1}' <<< "${rds_endpoint}")" -P 3306 -u admin -p${db_password} -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'%';"
sudo mysql -h "$(awk -F: '{print $1}' <<< "${rds_endpoint}")" -P 3306 -u admin -p${db_password} -e "FLUSH PRIVILEGES;"