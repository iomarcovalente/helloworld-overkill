#!/bin/bash

if [[ -z ${1} ]];then
    REGISTRY="localhost:5000"
else
    REGISTRY=${1}
fi

curl -s http://localhost:5000/v2/helloworld-overkill/tags/list | jq -r .tags[-1]
