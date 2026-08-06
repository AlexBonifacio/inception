FROM debian:bookworm-slim

ARG DAYS_VALID=365
ARG DOMAIN_NAME=abonifac.42.fr

RUN apt-get update \
	&& apt-get install -y nginx openssl \
	&& rm -rf /var/lib/apt/lists/*

RUN echo "Creating self-signed SSL certificate..." \
	&& openssl req -x509 -nodes -days ${DAYS_VALID} \
	-newkey rsa:2048 \
	-keyout /etc/ssl/private/nginx-selfsigned.key \
	-out /etc/nginx/ssl/inception.crt \
	-subj "/C=FR/ST=RH/L=Lyon/O=42/CN=abonifac.42.fr"

COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]