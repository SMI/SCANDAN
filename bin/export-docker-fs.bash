#!/usr/bin/env bash

set -eo pipefail

if [ "$#" -ne "1" ]; then
    echo "Usage: $0 image"
    exit 1
fi

set -u

image="$1"
image_sha="$(docker inspect --format='{{index .RepoDigests 0}}' "$image")"
container=$(docker create "$image_sha")
docker export "$container" \
    | tar -x --to-command='echo $TAR_FILENAME $(sha256sum $1 | cut -d" " -f1)' \
    > "$(echo $image_sha | tr /: -)-files.txt"
docker container rm --force "$container" > /dev/null
