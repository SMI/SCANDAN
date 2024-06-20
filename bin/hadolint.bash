#!/usr/bin/env bash

set -eo pipefail

if [ "$#" -ne "1" ]; then
    echo "Usage: $0 Dockerfile"
    exit 1
fi

set -u

dockerfile="$1"

set -x

docker run \
    --pull=always \
    --rm \
    -i \
    -v $(pwd):/repo \
    ghcr.io/hadolint/hadolint:latest \
        hadolint \
        --config /repo/configs/hadolint.yaml \
        - < "$dockerfile"
