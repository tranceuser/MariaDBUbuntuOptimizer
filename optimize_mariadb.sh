#!/bin/bash

# Function to display error messages
error() {
  echo "Error: $1"
  exit 1
}

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  error "Please run this script as root or using sudo."
fi

# Check if a flag file exists
if [ -f /var/run/script_flag ]; then
  echo "This script has already been run before. Exiting."
  exit 0
fi

# Create the flag file to indicate that the script has been run
touch /var/run/script_flag

# Update package lists and upgrade packages
echo "Updating package lists and upgrading packages..."
apt-get update && apt-get upgrade -y || error "Failed to update and upgrade packages."

# Check if MariaDB is installed
if ! command -v mysql >/dev/null 2>&1; then
  echo "MariaDB is not installed. Installing MariaDB server..."
  
  # Install MariaDB
  apt-get install -y mariadb-server || error "Failed to install MariaDB server."
else
  echo "MariaDB server is already installed."
fi

# Choose optimization level
echo "Choose optimization level:"
echo "1. Optimize to use up to 50% of total RAM and CPU"
echo "2. Optimize to use up to 100% of total RAM and CPU"
echo "Note: Use option 2 to utilize all available resources only if MariaDB is the sole service running on the server."
read -p "Enter your choice (1 or 2): " OPTIMIZATION_LEVEL

if [[ "$OPTIMIZATION_LEVEL" != "1" ]] && [[ "$OPTIMIZATION_LEVEL" != "2" ]]; then
  error "Invalid choice. Please enter 1 or 2."
fi

# Configuration changes for improving performance
CONFIG_FILE="/etc/mysql/mariadb.conf.d/50-server.cnf"
echo "Backing up the original MariaDB configuration file..."
cp "$CONFIG_FILE" "${CONFIG_FILE}.bak$(date +%Y%m%d%H%M%S)"

# Restore backup
# sudo cp /etc/mysql/mariadb.conf.d/50-server.cnf.bak /etc/mysql/mariadb.conf.d/50-server.cnf

# Calculate hardware-based settings
echo "Calculating hardware-based settings..."
TOTAL_MEMORY_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')
TOTAL_MEMORY_GB=$((TOTAL_MEMORY_KB / 1024 / 1024))
TOTAL_CPU_CORES=$(nproc)

# Calculate settings based on hardware and optimization level
if [ "$OPTIMIZATION_LEVEL" == "1" ]; then
  INNODB_BUFFER_POOL_SIZE="$((TOTAL_MEMORY_GB / 2 * 1024 / 2))M"
  QUERY_CACHE_SIZE="$((TOTAL_MEMORY_GB * 64 / 2))M"
  THREAD_CACHE_SIZE=$((TOTAL_CPU_CORES * 5))
  INNODB_READ_IO_THREADS=$((TOTAL_CPU_CORES / 2))
  INNODB_WRITE_IO_THREADS=$((TOTAL_CPU_CORES / 2))
else
  INNODB_BUFFER_POOL_SIZE="$((TOTAL_MEMORY_GB * 1024 / 2))M"
  QUERY_CACHE_SIZE="$((TOTAL_MEMORY_GB * 64))M"
  THREAD_CACHE_SIZE=$((TOTAL_CPU_CORES * 10))
  INNODB_READ_IO_THREADS=$TOTAL_CPU_CORES
  INNODB_WRITE_IO_THREADS=$TOTAL_CPU_CORES
fi

INNODB_BUFFER_POOL_INSTANCES=$((TOTAL_MEMORY_GB / 2))

# Apply custom performance tuning settings
echo "Applying custom performance tuning settings based on hardware and optimization level..."
cat >>$CONFIG_FILE <<EOL

# Custom performance tuning based on hardware and optimization level
[mysqld]
innodb_buffer_pool_size = $INNODB_BUFFER_POOL_SIZE
innodb_buffer_pool_instances = $INNODB_BUFFER_POOL_INSTANCES
innodb_log_file_size = 256M
innodb_flush_log_at_trx_commit = 2
innodb_flush_method = O_DIRECT
innodb_read_io_threads = $INNODB_READ_IO_THREADS
innodb_write_io_threads = $INNODB_WRITE_IO_THREADS
innodb_io_capacity = 2000
query_cache_size = $QUERY_CACHE_SIZE
query_cache_type = 1
query_cache_limit = 2M
thread_cache_size = $THREAD_CACHE_SIZE
max_connections = 1000
key_buffer_size = 128M
table_open_cache = 2000
wait_timeout = 1800
connect_timeout = 10
interactive_timeout = 1800
EOL

echo "Restarting MariaDB service..."
read -p "Do you want to restart mariadb now? (y/n) " answer
if [[ "$answer" == [Yy]* ]]; then
  sudo systemctl restart mariadb || error "Failed to restart MariaDB service."
else
  echo "Done."
fi

echo "MariaDB optimization complete."