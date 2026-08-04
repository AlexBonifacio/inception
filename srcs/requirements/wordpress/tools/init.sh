#!/bin/bash

until ... ; do
	echo "Waiting mariadb..."
	sleep 1
done
exec php-fpm8.2 -F