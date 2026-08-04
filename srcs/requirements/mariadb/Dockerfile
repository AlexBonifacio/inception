FROM debian:bookworm-slim

RUN apt-get update \
	&& apt-get install -y mariadb-server mariadb-client \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /var/lib/mysql/*

COPY ./tools/init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 3306

ENTRYPOINT ["/init.sh"]