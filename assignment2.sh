#bash script to setup a wordpress for web  server in different virtual machine
#!/bin/bash
sudo apt-get update
sudo apt install apache2
sudo systemctl start apache2
sudo systemctl status apache2
sudo apt install php -y
sudo apt install wget
wget https://wordpress.org//latest.zip
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



