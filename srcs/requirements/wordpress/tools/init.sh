#!/bin/bash

set -e
DB_PASS=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

for i in $(seq 1 30); do
	mariadb -h mariadb -u"$MYSQL_USER" -p"$DB_PASS" -e "SELECT 1" &>/dev/null && break
	echo "Waiting mariadb... ($i/30)"
	sleep 1
done

echo "MariaDB init done.";

cd /var/www/html

if wp core is-installed --allow-root; then
	echo "WordPress already installed."
else
	echo "Installing Wordpress..."
	wp core download --allow-root --force

	wp config create \
		--dbname="$MYSQL_DATABASE" \
		--dbuser="$MYSQL_USER" \
		--dbpass="$DB_PASS" \
		--dbhost="mariadb" \
		--allow-root

	wp core install --allow-root \
		--url="$DOMAIN_NAME" \
		--title="$WP_TITLE" \
		--admin_user="$WP_ADMIN_USER" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--admin_email="$WP_ADMIN_EMAIL"

	wp user create --allow-root --role=author \
		"$WP_USER" \
		"$WP_USER_EMAIL" \
		--user_pass="$WP_USER_PASSWORD"
	
	chown -R www-data:www-data /var/www/html
fi

exec php-fpm8.2 -F