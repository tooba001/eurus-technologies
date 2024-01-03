 #bash script to setup a wordpress in a single virtual machine
#!/bin/bash
sudo apt-get install apache2
sudo apt-get install mysql-server -y
sudo mysql_secure_installation
sudo mysql -e "CREATE DATABASE newdatabase;"
sudo mysql -e "CREATE USER 'toobaa'@'%' IDENTIFIED BY 'tooba2001@A!';"
sudo mysql -e "GRANT ALL PRIVILEGES ON newdatabase.* TO 'toobaa'@'%';"
sudo mysql -e "FLUSH PRIVILEGES;"
sudo apt install php -y
sudo apt install php-mysql php-cgi php-cli php-gd -y
sudo apt-get install php-mysqli
wget https://wordpress.org//latest.zip
unzip latest.zip
sudo apt install php-mysql php-cgi php-cli php-gd -y
unzip latest.zip
cd wordpress
sudo mkdir /var/www/html
cd /var/www/html
cp -r * /var/www/html
ls
cd /var/www/html
ls
sudo rm -rf index.html
ls
sudo systemctl restart apache2
sudo chown -R www-data:www-data /var/www/html
ip a




