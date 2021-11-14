#!/bin/bash

set -ue

TAG=`git fetch && git tag | tail -n1`

latest_release_tag=`gh release list | cut -d 'L' -f1 | awk '{$1=$1};1' | head -n1`

if [[ $TAG == $latest_release_tag ]];then
    echo "WARN: Latest tag is matching latest release tag; nothing to do here. Quitting..."
    exit 1
fi

# Script to create release based on delta from latest tag
gh release create ${TAG} --notes-file CHANGELOG.delta.md --title ${TAG}
