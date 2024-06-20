#!/usr/bin/env bash

set -eo pipefail

if [ "$#" -ne "1" ]; then
    echo "Usage: $0 image"
    exit 1
fi

set -u

image="$1"
config="trivy-image-scan.yaml"

if [ ! -f "./configs/${config}" ]; then
    echo "Error: Missing ./configs/${config}"
    exit 1
fi

set -x

docker run \
    --pull=always \
    --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $HOME/.cache/trivy:/root/.cache \
    -v $(pwd):/repo \
    ghcr.io/aquasecurity/trivy:latest \
        image \
        --config "/repo/configs/${config}" \
        "${image}"
