
How to test mariadb from wordpress container:
docker exec -it wordpress bash
mariadb -h mariadb -u"$MYSQL_USER" -p"$DB_PASS"

To see PID1:
docker exec -it wordpress bash
ps aux

To show PID1 maintain the container running:
watch docker ps
docker exec wordpress kill 1

php-fpm (FastCGI Process Manager): a demon waiting for requests and listening 9000, exec php code and send back the result to the web server. It is used to serve PHP applications.

WordPress: here is not a programm, just a collection of PHP files in /var/www/html. The container service is php-form. 

##Dockerfile Wordpress:

php-fpm need to run: php-fpm

PHP need a connector to MySQL -> php-mysql

wordpress/tools/init.sh dl wp-cli -> curl 

script need to communicate with mariadb -> mariadb-client


To inspect the environment variables:
docker run -it --rm debian:bookworm-slim bash
apt-get update
apt-cache search php-fpm  -> show packages related to php-fpm  
apt-cache search php | grep mysql # tous les paquets php liés à mysql
apt-cache show php-fpm


wp init.sh
exec -> docker run --rm wordpress ls /usr/sbin/ | grep fpm -> show executable php-fpm8.2 


wp config create
Generates a wp-config.php file.

wp user list --allow-root --path='/var/www/html' OR docker exec wordpress wp user list --allow-root --path='/var/www/html' -> list all users
docker exec wordpress wp option get siteurl --allow-root --path='/var/www/html' -> get the siteurl
docker exec wordpress wp option get blogname --allow-root --path='/var/www/html' -> title of the blog

docker exec mariadb mariadb -u wp_user -p"$(cat secrets/db_password.txt)" wordpress -e "SHOW TABLES; SELECT user_login FROM wp_users;" OR docker exec -it mariadb bash -> mariadb -u wp_user -p"$(cat /run/secrets/db_password)""


https://lemagweb.fr/mysql-mariadb-tuning-wordpress-multi/

docker exec wordpress ps -ef

https://www.undefined.fr/snippets-wordpress/types/wp-cli/core/

https://blog.o2switch.fr/installer-wordpress-wp-cli/