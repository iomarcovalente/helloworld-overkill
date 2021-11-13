#!/bin/bash

set -ex

if [[ -z ${3} ]];then
    REGISTRY="localhost:5000"
else
    REGISTRY=${3}
fi

set -u

IMAGE_NAME="${1}"
TAG="${2}"

docker build -t ${REGISTRY}/${IMAGE_NAME}:${TAG} -t ${REGISTRY}/${IMAGE_NAME}:latest .
docker push ${REGISTRY}/${IMAGE_NAME}
