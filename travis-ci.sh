#!/bin/bash

image_name="xebialabsunsupported/xl-docker-demo-jboss"
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
tag=9.0.2.Final
docker build -t $image_name:$tag --build-arg wildfly_version=$tag .
docker push $image_name:$tag