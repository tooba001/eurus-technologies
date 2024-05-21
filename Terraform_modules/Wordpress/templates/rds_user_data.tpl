#!/bin/bash
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
sudo yum localinstall mysql57-community-release-el7-11.noarch.rpm -y
sudo yum install mysql-community-server -y
sudo systemctl start mysqld
echo "${rds_endpoint}" >> test.txt 
cat test.txt
sudo mysql -h "$(awk -F: '{print $1}' <<< "${rds_endpoint}")" -P 3306 -u admin -ptooba2001
sudo mysql -h "$(awk -F: '{print $1}' <<< "${rds_endpoint}")" -P 3306 -u admin -ptooba2001 -e "CREATE DATABASE wordpress;"
sudo mysql -h "$(awk -F: '{print $1}' <<< "${rds_endpoint}")" -P 3306 -u admin -ptooba2001 -e "CREATE USER 'wpuser'@'%' IDENTIFIED BY 'green200#Tooba';"
sudo mysql -h "$(awk -F: '{print $1}' <<< "${rds_endpoint}")" -P 3306 -u admin -ptooba2001 -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'%';"
sudo mysql -h "$(awk -F: '{print $1}' <<< "${rds_endpoint}")" -P 3306 -u admin -ptooba2001 -e "FLUSH PRIVILEGES;"