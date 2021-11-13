#!/bin/bash

# Runs github-changelog-generator and generate a new changelog based on current release-summary
# With flag -d it generates a delta changelog to use with github release notes otherwise it creates a full changelog
# More info in README.md

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

while getopts "d:" opt; do
    case "$opt" in
    d)  delta="yes"
        ;;
    esac
done

shift $((OPTIND-1))

[ "${1:-}" = "--" ] && shift

if [[ $delta == "yes" ]];then
    latest_release_tag=`gh release list | cut -d 'L' -f1 | awk '{$1=$1};1'`
    docker run -it -e latest_release_tag=$latest_release_tag --rm \
        -v "$(pwd)":/usr/local/src/your-app githubchangeloggenerator/github-changelog-generator \
        -u iomarcovalente -p helloworld-overkill --no-unreleased --since-tag $latest_release_tag \
        --output CHANGELOG.delta.md
else
    docker run -it --rm \
        -v "$(pwd)":/usr/local/src/your-app githubchangeloggenerator/github-changelog-generator \
        -u iomarcovalente -p helloworld-overkill --no-unreleased
fi
