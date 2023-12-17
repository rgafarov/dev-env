.PHONY: start stop

# https://github.com/nardeas/ssh-agent - main source of idea
# dockerized ssh agent, to avoid copy of keys to all containers

ssh-private-key=id_ed25519

start:
	# create volume, build image with ssh-agent with ssh auth socket, run it and add provided key
	docker volume create --name ssh-agent
	docker build -t docker-ssh-agent:latest -f Dockerfile .
	docker run -d -v ssh-agent:/.ssh-agent --name=ssh-agent docker-ssh-agent:latest
	docker run --rm -v ssh-agent:/.ssh-agent -v ~/.ssh:/.ssh -it docker-ssh-agent:latest ssh-add /root/.ssh/$(ssh-private-key)

stop:
	docker stop ssh-agent
	docker rm ssh-agent
	docker volume rm ssh-agent
	docker rmi docker-ssh-agent:latest
