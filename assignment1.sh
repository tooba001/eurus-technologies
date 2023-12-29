#bash script to setup a single virtual machine
#!/bin/bash
sudo apt-get update
sudo apt install apache2
sudo apt install mariadb
sudo systemctl start mariadb
sudo systemctl status mariadb
sudo apt install mysql-server
sudo systemctl start mysql
sudo systemctl status mysql
sudo apt install php -y
wget https://wordpress.org//latest.zip
unzip latest.zip
sudo apt install php-mysql php-cgi php-cli php-gd -y
cd wordpress
sudo mkdir /var/www/html
cd /var/www/html
cp -r * /var/www/html
ls
cd /var/www/html
ls
sudo rm -rf index.html
ls
sudo apt install php-mysql php-cgi php-cli php-gd -y
sudo systemctl restart apache2
sudo chown -R www-data:www-data /var/www/html
ip a
sudo mysql -u root -p


