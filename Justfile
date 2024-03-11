set shell := ["zsh", "-cu"]
LOCATION_PYTHON := `python -c "import sys;print(sys.executable)"`

# just manual: https://github.com/casey/just/#readme

# Ignore the .env file that is only used by the web service
set dotenv-load := false


VERSION := `cat VERSION | tr -d '\n'`
username := "index.docker.io/bossjones"
container_name := "dnsmasq"
IMAGE := username / container_name


_default:
    @just --list

info:
    @print "Dnsmasq Version: {{VERSION}}"
    @print "OS: {{os()}}"
    @print "username: {{username}}"
    @print "container_name: {{container_name}}"
    @print "IMAGE: {{IMAGE}}"

# verify python is running under pyenv
which-python:
    python -c "import sys;print(sys.executable)"

## Builds the local Docker container for development
build:
	DOCKER_BUILDKIT=1 docker buildx build --push --rm --platform linux/arm64 --progress=plain -t {{IMAGE}}:latest -t  {{IMAGE}}:{{VERSION}} .

## Push the ethos-core-tools image to the internal docker registry
push:
	@docker push {{IMAGE}}:{{VERSION}}
	@docker push {{IMAGE}}:latest

## Perform both build of the ethos-core-tools image and push it to the registry
build-and-push: build push
