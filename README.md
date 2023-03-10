# MariaDB installation and optimization on Ubuntu 22.04

This guide explains how to install and optimize MariaDB on Ubuntu 22.04 for both systems with 32GB of RAM and 64GB of RAM.

Prerequisites
Before you begin, make sure you have the following:
- A server running Ubuntu 22.04
- A root user or a user with sudo privileges

# Installing MariaDB
To install MariaDB on Ubuntu 22.04, follow these steps:

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

## Important
1. Memory settings: The values for key buffer size, max allowed packet, table open cache, sort buffer size, read buffer size, and read random buffer size are set to optimize memory usage and reduce disk I/O.
2. InnoDB settings: The configuration options for the InnoDB storage engine are set to improve performance and reliability, such as using a dedicated file per table, a large buffer pool size, and a large log file size.
3. Performance tuning: The configuration options related to performance tuning aim to maximize the number of concurrent connections and reduce wait times and timeouts.
4. Logging: The slow query log, long query time, and log queries not using indexes options are set to provide better visibility into the performance of the database, making it easier to identify and resolve performance issues.

# Optimizing MariaDB on systems with 16GB of RAM
To optimize MariaDB on systems with 16GB of RAM, follow these steps:
1. Open the MariaDB configuration file by running the following command:
```
sudo nano /etc/mysql/mariadb.conf.d/50-server.cnf
```
2. Add the following lines to the end of the file:
```
[mysqld]
# Memory settings
key_buffer_size = 512M
max_allowed_packet = 256M
table_open_cache = 4096
sort_buffer_size = 2M
read_buffer_size = 2M
read_rnd_buffer_size = 8M
myisam_sort_buffer_size = 128M
thread_cache_size = 32

# InnoDB Settings
innodb_file_per_table = 1
innodb_buffer_pool_size = 7G
innodb_log_file_size = 256M
innodb_flush_log_at_trx_commit = 2
innodb_thread_concurrency = 0
innodb_write_io_threads = 8
innodb_read_io_threads = 8
innodb_flush_method = O_DIRECT
innodb_autoinc_lock_mode = 2

# Performance tuning
query_cache_type = 0
query_cache_size = 0
max_connections = 1000
max_user_connections = 200
interactive_timeout = 300
wait_timeout = 300
connect_timeout = 10
tmp_table_size = 256M
max_heap_table_size = 256M

# Logging
slow_query_log = 1
long_query_time = 1
log_queries_not_using_indexes = 1
```
3. Save the file and exit the editor.
4. Restart the MariaDB service by running the following command:
```
sudo systemctl restart mariadb
```

# Optimizing MariaDB on systems with 32GB or more of RAM
To optimize MariaDB on systems with 32GB or more of RAM, follow these steps:
1. Open the MariaDB configuration file by running the following command:
```
sudo nano /etc/mysql/my.cnf
```
2. Add the following lines to the end of the file:
```
[mysqld]
# Memory settings
key_buffer_size = 1024M
max_allowed_packet = 256M
table_open_cache = 8192
sort_buffer_size = 4M
read_buffer_size = 4M
read_rnd_buffer_size = 16M
myisam_sort_buffer_size = 256M
thread_cache_size = 64

# InnoDB Settings
innodb_file_per_table = 1
innodb_buffer_pool_size = 14G
innodb_log_file_size = 512M
innodb_flush_log_at_trx_commit = 2
innodb_thread_concurrency = 0
innodb_write_io_threads = 16
innodb_read_io_threads = 16
innodb_flush_method = O_DIRECT
innodb_autoinc_lock_mode = 2

# Performance tuning
query_cache_type = 0
query_cache_size = 0
max_connections = 2000
max_user_connections = 300
interactive_timeout = 300
wait_timeout = 300
connect_timeout = 10
tmp_table_size = 512M
max_heap_table_size = 512M

# Logging
slow_query_log = 1
long_query_time = 1
log_queries_not_using_indexes = 1
```
3. Save the file and exit the editor.
4. Restart the MariaDB service by running the following command:
```
sudo systemctl restart mariadb
```

# Verify Optimization
Verify that the optimization has taken effect by checking the status of the MariaDB service:
```
mysql> SHOW GLOBAL STATUS;
```

With these optimizations, your MariaDB installation should perform optimally on both systems with 32GB of RAM and 32GB or more of RAM.
