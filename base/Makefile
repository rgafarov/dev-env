.PHONY: build-arm64

build-arm64:
	docker build . -f Dockerfile.arm64 --no-cache --build-arg UID=$$(id -u $${USER}) --build-arg GID=$$(id -g $${USER}) -t dev-base
