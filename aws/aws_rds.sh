#question 3
#setup HA architecture for wordpress.
#Create an Autoscaling group with launch configuration & relevant resources for wordpress web part.
#Create a load balancer for wordpress web
#Database should be on EC2 instance. It doesn't need to be HA for now
#database setup in rds
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
