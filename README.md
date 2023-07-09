# MariaDB installation and optimization on Ubuntu
This guide outlines the steps for installing and optimizing MariaDB on Ubuntu 22.04 or newer.

## Prerequisites
Before starting the installation process, ensure you have the following:
- A server running Ubuntu 22.04 or newer
- A root user or a user with sudo privileges
- Git installed. If not, install it with `sudo apt-get install git -y`

## MariaDB Installation and Optimization Script
We provide a Bash script that optimizes your MariaDB installation based on the total RAM and CPU resources available on your server. It calculates optimal configuration settings according to the hardware and selected optimization level.

Here are the steps to use this script:
1. Clone the script from GitHub:
```
git clone https://github.com/tranceuser/optimize_mariadb.git
```
2. Grant the script executable permissions:
```
chmod +x optimize_mariadb.sh
```
3. Execute the script as a root user:
```
sudo ./optimize_mariadb.sh
```
4. If MariaDB was not previously installed, after the optimization is finished, execute the following command to secure your installation:
```
sudo mysql_secure_installation
```
Follow the on-screen instructions to set the root password, remove anonymous users, and secure the installation.

5. Start the MariaDB service by executing the following command:
```
sudo systemctl start mariadb
```
6. Set the MariaDB service to start automatically at boot by running the following command:
```
sudo systemctl enable mariadb
```
The script will guide you through the remaining process. When prompted, select an optimization level:
1) Optimizes MariaDB to utilize up to 50% of total RAM and CPU.
2) Optimizes MariaDB to utilize up to 100% of total RAM and CPU.

Note: Use option 2 only if MariaDB is the primary service running on your server.