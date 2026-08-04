FROM debian:bookworm-slim

RUN apt-get update \
	&& apt-get install -y mariadb-server mariadb-client \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /var/lib/mysql/*

COPY ./tools/init.sh /init.sh
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
RUN chmod +x /init.sh

EXPOSE 3306

ENTRYPOINT ["/init.sh"]