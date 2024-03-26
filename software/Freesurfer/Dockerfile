FROM ubuntu:22.04

ARG FREESURFER_VERSION="7.4.1"
ARG FREESURFER_DEB_MD5="bfe85dd76677cfb7ca2b247b9ac6148e"

ENV \
    LANG="en_GB.UTF-8" \
    LC_ALL="en_GB.UTF-8"

RUN : \
    && apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install \
           -qq -y --no-install-recommends \
           ca-certificates \
           curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && :

RUN : \
    && set -eu \
    && deb="freesurfer_ubuntu22-${FREESURFER_VERSION}_amd64.deb" \
    && curl -sfLo "${deb}" "https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/${FREESURFER_VERSION}/${deb}" \
    && echo "${FREESURFER_DEB_MD5} ${deb}" | md5sum -c \
    && apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install \
           -y --no-install-recommends \
           "./${deb}" \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && rm "${deb}" \
    && :
