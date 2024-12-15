#!/bin/bash

# WordPress Database Setup Script
# Usage: ./wordpress_db_setup.sh

# Prompt for database configuration
read -p "Enter MySQL root password: " ROOT_PASSWORD
read -p "Enter WordPress database name (default: wordpress): " DB_NAME
DB_NAME=${DB_NAME:-wordpress}
read -p "Enter WordPress database username (default: wpuser): " DB_USER
DB_USER=${DB_USER:-wpuser}
read -p "Enter WordPress database user password: " DB_PASS

# Check if MySQL/MariaDB is installed
if ! command -v mysql &> /dev/null
then
    echo "MySQL/MariaDB is not installed. Please install it first."
    exit 1
fi

# Function to handle errors
handle_error() {
    echo "Error: $1"
    exit 1
}

# Create database
echo "Creating WordPress database..."
mysql -u root -p"$ROOT_PASSWORD" -e "CREATE DATABASE $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" || handle_error "Failed to create database"

# Create database user
echo "Creating WordPress database user..."
mysql -u root -p"$ROOT_PASSWORD" -e "CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';" || handle_error "Failed to create database user"

# Grant privileges to the user
echo "Granting privileges to WordPress database user..."
mysql -u root -p"$ROOT_PASSWORD" -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';" || handle_error "Failed to grant privileges"

# Flush privileges to ensure immediate effect
mysql -u root -p"$ROOT_PASSWORD" -e "FLUSH PRIVILEGES;" || handle_error "Failed to flush privileges"

echo "WordPress database setup complete!"
echo "Database Name: $DB_NAME"
echo "Database User: $DB_USER"

# Provide WordPress configuration details
echo ""
echo "Use these details in your WordPress wp-config.php:"
echo "define('DB_NAME', '$DB_NAME');"
echo "define('DB_USER', '$DB_USER');"
echo "define('DB_PASSWORD', '$DB_PASS');"
echo "define('DB_HOST', 'localhost');"
