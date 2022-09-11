# Eureka Discovery Server
[![build](https://github.com/schambeck/srv-discovery/actions/workflows/maven.yml/badge.svg)](https://github.com/schambeck/srv-discovery/actions/workflows/maven.yml)

## Server Deployment

### Build artifact

    ./mvnw clean package

Executable file generated: target/srv-discovery-1.0.0.jar

### Build docker image

    make docker-build

### Start-up Server

    make docker-run

### Eureka Web UI

    http://localhost:8761
