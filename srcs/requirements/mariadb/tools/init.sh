#!/bin/bash

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

DB_PASS=$(cat /run/secrets/db_password)
DB_ROOT_PASS=$(cat /run/secrets/db_root_password)

if [ ! -d /var/lib/mysql/mysql ]; then
	echo "Init database..."
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql

	mariadbd --user=mysql --bootstrap << EOF
USE mysql;
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$DB_PASS';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASS';
DELETE FROM mysql.global_priv WHERE User='';
DROP DATABASE IF EXISTS test;
FLUSH PRIVILEGES;
EOF
fi

echo "Start mariadb...";


exec mariadbd --user=mysql