#!/bin/bash
set -e

# Initialize MySQL if needed
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MySQL database..."
    mysqld --initialize-insecure --user=mysql --datadir=/var/lib/mysql
fi

# Start MySQL temporarily for setup
mysqld_safe --user=mysql &
MYSQL_PID=$!

# Wait for MySQL to start
echo "Waiting for MySQL to start..."
while ! mysqladmin ping -h localhost --silent; do
    sleep 1
done

# Create databases
mysql -u root -e "CREATE DATABASE IF NOT EXISTS acore_auth;"
mysql -u root -e "CREATE DATABASE IF NOT EXISTS acore_characters;"
mysql -u root -e "CREATE DATABASE IF NOT EXISTS acore_world;"
mysql -u root -e "CREATE DATABASE IF NOT EXISTS acore_playerbots;"

# Set root password
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
mysql -u root -e "FLUSH PRIVILEGES;"

# Stop temporary MySQL
kill $MYSQL_PID
wait $MYSQL_PID

# Update realmlist with server IP
if [ ! -z "$AC_REALM_ADDRESS" ]; then
    echo "Setting realm address to: $AC_REALM_ADDRESS"
    # This will be done after database import
fi

# Copy configuration files with correct settings
cp -r /azerothcore/etc/* /azerothcore/env/dist/etc/ 2>/dev/null || true

echo "Starting AzerothCore with Playerbots..."
exec "$@"
