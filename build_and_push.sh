#!/bin/bash

set -ex

if [[ -z ${1} ]];then
    REGISTRY="localhost:5000"
else
    REGISTRY=${1}
fi

if [[ -z ${2} ]];then
    IMAGE_NAME=`gh repo view --json name | jq -r .name`
else
    IMAGE_NAME=${2}
fi

if [[ -z ${3} ]];then
    test_tag=`git rev-parse --short HEAD`

    if [[ `git describe --tags --exact-match $test_tag` ]]; then
        TAG=`git describe --tags --exact-match $test_tag`
    else
        echo "Setting tag to latest commig short hash:"
        TAG=`git rev-parse --short HEAD`
    fi
else
    TAG=${3}
fi


docker build -t ${REGISTRY}/${IMAGE_NAME}:${TAG} -t ${REGISTRY}/${IMAGE_NAME}:latest .

docker push ${REGISTRY}/${IMAGE_NAME}:${TAG}
docker push ${REGISTRY}/${IMAGE_NAME}:latest
