#database setup
#!/bin/bash
sudo apt install mysql-server
sudo systemctl start mysql
sudo systemctl status mysql
sudo sql -u root -p
