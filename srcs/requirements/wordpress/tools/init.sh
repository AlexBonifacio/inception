#!/bin/bash

set -e
DB_PASS=$(cat /run/secrets/db_password)

for i in $(seq 1 30); do
	mariadb -h mariadb -u"$MYSQL_USER" -p"$DB_PASS" -e "SELECT 1" &>/dev/null && break
	echo "Waiting mariadb... ($i/30)"
	sleep 1
done

exec php-fpm8.2 -F