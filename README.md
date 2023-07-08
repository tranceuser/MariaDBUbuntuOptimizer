# MariaDB installation and optimization on Ubuntu

This guide explains how to install and optimize MariaDB on Ubuntu 22.04 or newer.

Prerequisites
Before you begin, make sure you have the following:
- A server running Ubuntu 22.04 or newer
- A root user or a user with sudo privileges

# Installing MariaDB
To install MariaDB on Ubuntu 22.04 or newer, follow these steps:

1. Update the package list by running the following command:
```
sudo apt-get update -y
```
2. Install MariaDB by running the following command:
```
sudo apt-get install mariadb-server -y
```
3. Once the installation is complete, run the following command to secure the installation:
```
sudo mysql_secure_installation
```
Follow the on-screen instructions to set the root password, remove anonymous users, and secure the installation.
4. Start the MariaDB service by running the following command:
```
sudo systemctl start mariadb
```
5. Enable the MariaDB service to start at boot by running the following command:
```
sudo systemctl enable mariadb
```

## MariaDB Backup
Before any changes are made, the script creates a backup of your original MariaDB configuration file, located at `/etc/mysql/mariadb.conf.d/50-server.cnf`. The backup file is appended with the current timestamp to prevent overwriting of previous backups.

## MariaDB Restoring Configuration
To restore the original configuration, copy the backup file over the current configuration file, like so:
```
sudo cp /etc/mysql/mariadb.conf.d/50-server.cnf.bak /etc/mysql/mariadb.conf.d/50-server.cnf
```
Replace 50-server.cnf.bak with the actual name of your backup file.

## MariaDB Optimization Script

This is a Bash script that optimizes your MariaDB installation based on the total RAM and CPU resources available on your machine.
It calculates optimal configuration settings based on the hardware and chosen optimization level.

1. Give the script executable permissions:
```
chmod +x optimize_mariadb.sh
```
2. Run the script as root:
```
sudo ./optimize_mariadb.sh
```
3. Restart the MariaDB service by running the following command:
```
sudo systemctl restart mariadb
```

The script will guide you through the rest. When prompted, choose an optimization level:
1: Optimizes MariaDB to use up to 50% of total RAM and CPU.
2: Optimizes MariaDB to use up to 100% of total RAM and CPU.
Use option 2 only if MariaDB is the sole service running on your server.

## Remote Access
On Ubuntu 22.04, the configuration file for MariaDB is usually located in /etc/mysql/mariadb.conf.d/50-server.cnf.
To edit the file, you can use a text editor such as nano:
```
sudo nano /etc/mysql/mariadb.conf.d/50-server.cnf
```
Then, add the following line under the [mysqld] section:
```
bind-address = 0.0.0.0
```
Save the file and exit the editor.
After making this change, you will need to restart MariaDB for the changes to take effect:
```
sudo systemctl restart mariadb
```
## Check the max connections
1. Log in to the MariaDB shell as the root user:
```
mysql -u root -p
```
Enter the root user password when prompted.
2. Run the following command to check the current maximum connections setting:
```
SHOW VARIABLES LIKE "max_connections";
```
This will display the current value of the max_connections variable.
Exit the MariaDB shell:
```
exit;
```