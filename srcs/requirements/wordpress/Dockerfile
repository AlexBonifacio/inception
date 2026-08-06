
FROM debian:bookworm-slim

RUN apt-get update \
	&& apt-get install -y php-fpm php-mysqli curl mariadb-client \
	&& rm -rf /var/lib/apt/lists/*

RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x /usr/local/bin/wp

RUN sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf

COPY --chmod=755 ./tools/init.sh /init.sh


EXPOSE 9000

# ENTRYPOINT ["/init.sh"]
CMD ["/init.sh"]