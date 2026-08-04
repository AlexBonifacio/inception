  mariadb:
    build: ./requirements/mariadb --> docker build srcs/requirements/mariadb
	image: mariadb --> docker build -t mariadb 
    container_name: mariadb
    volumes:
      - mariadb_vol:/var/lib/mysql -> docker run -d --name test_db -v test_vol:/var/lib/mysql mariadb
    env_file:
      - .env
    networks:
      - inception
	restart: on-failure


docker inspect --format '{{.Config.Env}}' mariadb -> expose the environment variables of the container