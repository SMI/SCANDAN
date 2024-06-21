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

reports_dir="${reports_dir-./reports}"
TRIVY_IMG="ghcr.io/aquasecurity/trivy:latest"

set -x

# Put the full image reference in a file
docker inspect --format="{{index .Id}}" "${image}" > "${reports_dir}/image-id.txt"

docker pull "${TRIVY_IMG}"

# Generate CVE table
docker run \
    --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $HOME/.cache/trivy:/root/.cache \
    -v "${reports_dir}":/reports \
    -v $(pwd):/repo \
    "${TRIVY_IMG}" \
        image \
        --config "/repo/configs/${config}" \
        --format table \
        --output /reports/trivy-cve.txt \
        "${image}"

# Generate SBOM
docker run \
    --rm \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $HOME/.cache/trivy:/root/.cache \
    -v "${reports_dir}":/reports \
    -v $(pwd):/repo \
    "${TRIVY_IMG}" \
        image \
        --config "/repo/configs/${config}" \
        --format cyclonedx \
        --output /reports/trivy-sbom.json \
        "${image}"
