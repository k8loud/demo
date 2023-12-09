#!/bin/bash

FULL_IMAGE_NAME=k8loud/mem-hoarder

docker build -t $FULL_IMAGE_NAME .
docker login
docker push $FULL_IMAGE_NAME
