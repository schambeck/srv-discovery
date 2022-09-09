APP = srv-discovery
VERSION = 1.0.0
JAR = ${APP}-${VERSION}.jar
TARGET_JAR = target/${JAR}
#JAVA_OPTS = -Dserver.port=8761

DOCKER_IMAGE = ${APP}:latest
DOCKER_FOLDER = src/main/docker
DOCKER_CONF = ${DOCKER_FOLDER}/Dockerfile
COMPOSE_CONF = ${DOCKER_FOLDER}/docker-compose.yml
STACK_CONF = ${DOCKER_FOLDER}/docker-stack.yml
REPLICAS = 1

# Maven

clean:
	./mvnw clean

all: clean
	./mvnw compile

install: clean
	./mvnw install

check: clean
	./mvnw verify

check-unit: clean
	./mvnw test

check-integration: clean
	./mvnw integration-test

dist: clean
	./mvnw package -Dmaven.test.skip=true

dist-run: dist run

run:
	java ${JAVA_OPTS} -jar ${TARGET_JAR}

# Docker

dist-docker-build: dist docker-build

dist-docker-build-deploy: dist docker-build stack-deploy

dist-docker-build-push: dist docker-build docker-push

docker-build-push: docker-build docker-push

docker-build:
	DOCKER_BUILDKIT=1 docker build -f ${DOCKER_CONF} -t ${DOCKER_IMAGE} --build-arg=JAR_FILE=${JAR} target

docker-run:
	docker run -d \
		--restart=always \
		--net schambeck-bridge \
		--name ${APP} \
		--publish 8761:8761 \
		${DOCKER_IMAGE}

--rm-docker-image:
	docker rmi ${DOCKER_IMAGE}

docker-bash:
	docker exec -it docker_web_1 /bin/bash

docker-tag:
	docker tag ${APP} ${DOCKER_IMAGE}

docker-push:
	docker push ${DOCKER_IMAGE}

docker-pull:
	docker pull ${DOCKER_IMAGE}

docker-logs:
	docker logs ${APP} -f

# Docker Compose

dist-compose-up: dist compose-up

compose-up:
	docker-compose -p ${APP} -f ${COMPOSE_CONF} up -d --build

compose-down: --compose-down

compose-down-rmi: --compose-down --rm-docker-image

--compose-down:
	docker-compose -f ${COMPOSE_CONF} down

compose-logs:
	docker-compose -f ${COMPOSE_CONF} logs -f \web

# Docker Swarm

stack-deploy:
	docker stack deploy -c ${STACK_CONF} --with-registry-auth ${APP}

stack-rm:
	docker stack rm ${APP}

service-logs:
	docker service logs ${APP}_web -f
