DATA = /home/abonifac/data
COMPOSE = docker compose -f srcs/docker-compose.yml

all:
	mkdir -p $(DATA)/mariadb $(DATA)/wordpress
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down -v

fclean: clean
	docker run --rm -v $(DATA):/data debian:bookworm-slim rm -rf /data/mariadb /data/wordpress
	mkdir -p $(DATA)/mariadb $(DATA)/wordpress

re: fclean all

.PHONY: all down clean fclean re
