FROM debian:10-slim

RUN : \
    && apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install \
           -qq -y --no-install-recommends \
           ca-certificates \
           gnupg2 \
           curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && :

RUN : \
    && set -eu \
    && mkdir -m 0755 -p /etc/apt/keyrings \
    && curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xA5D32F012649A5A9" | gpg --dearmor -o /etc/apt/keyrings/neurodebian.gpg \
    && echo "deb [signed-by=/etc/apt/keyrings/neurodebian.gpg] http://neurodebian.g-node.org data main contrib non-free" >> /etc/apt/sources.list.d/neurodebian.sources.list \
    && echo "deb [signed-by=/etc/apt/keyrings/neurodebian.gpg] http://neurodebian.g-node.org buster main contrib non-free" >> /etc/apt/sources.list.d/neurodebian.sources.list  \
    && apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install \
           -qq -y --no-install-recommends \
           fsl-5.0-complete \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && :
