#database setup
#!/bin/bash
sudo apt-get update
sudo apt-get install -y mysql-server mysql-client
sudo mysql_secure_installation
sudo systemctl start mysql
sudo systemctl status mysql
sudo mysql -u root -p
mysql -u root -p -e "CREATE DATABASE wordpress_db;"
mysql -u root -p -e "CREATE USER 'wordpress_user'@'%' IDENTIFIED BY 'tooba2001';"
mysql -u root -p -e "GRANT ALL PRIVILEGES ON wordpress_db.* TO 'wordpress_user'@'%';"
mysql -u root -p -e "FLUSH PRIVILEGES;"
