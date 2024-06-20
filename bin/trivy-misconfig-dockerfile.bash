#!/usr/bin/env bash

set -eo pipefail

if [ "$#" -ne "1" ]; then
    echo "Usage: $0 Dockerfile"
    exit 1
fi

set -u

dockerfile="$1"
config="trivy-misconfig-dockerfile.yaml"

if [ ! -f "./configs/${config}" ]; then
    echo "Error: Missing ./configs/${config}"
    exit 1
fi

set -x

docker run \
    --pull=always \
    --rm \
    -v $HOME/.cache/trivy:/root/.cache \
    -v $(pwd):/repo \
    ghcr.io/aquasecurity/trivy:latest \
        config \
        --config "/repo/configs/${config}" \
        "/repo/${dockerfile}"

