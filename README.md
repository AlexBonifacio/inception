
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

https://lemagweb.fr/mysql-mariadb-tuning-wordpress-multi/

docker exec wordpress ps -ef
