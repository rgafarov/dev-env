.PHONY: init build

init:
	{ printf "UID="; eval "id -u $$USER"; printf "\r"; printf "GID="; eval "id -g $$USER"; } > .env

build:
	docker compose build --no-cache

clean_images:
	docker rm -v $(docker ps -a -q -f status=exited)
	docker rmi $(docker images -f "dangling=true" -q)
