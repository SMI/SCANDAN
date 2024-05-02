# test
FROM ubuntu:20.04

ARG FSL_VERSION="6.0.7.9"

ENV FSLDIR="/usr/local/fsl"

RUN : \
    && apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install \
        -qq -y --no-install-recommends \
        ca-certificates \
        curl \
        libgomp1 \
        libgtk2.0-0 \
        libquadmath0 \
        mesa-utils \
        python3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && :

RUN : \
    && set -eu \
    && curl -sLo fslinstaller.py https://fsl.fmrib.ox.ac.uk/fsldownloads/fslconda/releases/fslinstaller.py \
    && python3 fslinstaller.py -d /usr/local/fsl --skip_registration --fslversion "${FSL_VERSION}" \
    && rm fslinstaller.py \
    && :

ENTRYPOINT [ "sh", "-c", ". /usr/local/fsl/etc/fslconf/fsl.sh && /bin/bash" ]
