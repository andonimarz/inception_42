name = inception

.SILENT:

all:
	@printf "Launching ${name}...\n"
	@bash srcs/requirements/wordpress/tools/make_dir.sh
	@docker-compose -f ./srcs/docker-compose.yml up -d

down:
	@printf "Stopping ${name}...\n"
	@docker-compose -f ./srcs/docker-compose.yml down

restart: down all
	@printf "After a system restart, restarting ${name} too...\n"

clean: down
	@printf "Cleaning ${name}...\n"
	@docker system prune -a
	@sudo rm -rf ~/data/wordpress/*
	@sudo rm -rf ~/data/mariadb/*

re: clean all

fclean:
	@printf "Total cleaning of docker\n"
	@docker stop $$(docker ps -qa)
	@docker system prune --all --force --volumes
	@docker network prune --force
	@docker volume prune --force
	@sudo rm -rf ~/data/wordpress/*
	@sudo rm -rf ~/data/mariadb/*

.PHONY	: all down restart re clean fclean
