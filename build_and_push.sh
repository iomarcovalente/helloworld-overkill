#!/bin/bash

set -ex

if [[ -z ${1} ]];then
    IMAGE_NAME=`gh repo view --json name | jq -r .name`
else
    IMAGE_NAME=${1}
fi

if [[ -z ${2} ]];then
    TAG=$(git rev-parse --short HEAD)
else
    TAG=${2}
fi

if [[ -z ${3} ]];then
    REGISTRY="localhost:5000"
else
    REGISTRY=${3}
fi

docker build -t ${REGISTRY}/${IMAGE_NAME}:${TAG} -t ${REGISTRY}/${IMAGE_NAME}:latest .

docker push ${REGISTRY}/${IMAGE_NAME}:${TAG}
docker push ${REGISTRY}/${IMAGE_NAME}:latest
