FROM docker.io/ubuntu@sha256:e9569c25505f33ff72e88b2990887c9dcf230f23259da296eb814fc2b41af999

ARG FREESURFER_VERSION="7.4.1"
ARG FREESURFER_IMAGE_REVISION="4"
ARG FREESURFER_DEB_MD5="bfe85dd76677cfb7ca2b247b9ac6148e"

ENV \
    LANG="en_GB.UTF-8" \
    LC_ALL="en_GB.UTF-8" \
    FREESURFER_HOME="/usr/local/freesurfer/${FREESURFER_VERSION}" \
    PATH="/usr/local/freesurfer/${FREESURFER_VERSION}/bin:${PATH}"

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN : \
    && apt-get update -qq \
    && apt-get upgrade -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install \
         -qq -y --no-install-recommends \
         bash \
         bc \
         binutils \
         ca-certificates \
         csh \
         curl \
         file \
         gettext \
         gzip \
         language-pack-en \
         libbsd0 \
         libegl1 \
         libgl1 \
         libglu1-mesa \
         libglvnd0 \
         libglx0 \
         libjpeg62 \
         libncurses5 \
         libopengl0 \
         libpcre3 \
         libquadmath0 \
         libsm6 \
         libwayland-cursor0 \
         libx11-dev \
         libxcb-icccm4 \
         libxcb-image0 \
         libxcb-keysyms1 \
         libxcb-render-util0 \
         libxcb-render0 \
         libxcb-shape0 \
         libxcb-sync1 \
         libxcb-xfixes0 \
         libxcb-xinerama0 \
         libxcb-xinput0 \
         libxcb-xkb1 \
         libxdmcp6 \
         libxext6 \
         libxi6 \
         libxkbcommon-x11-0 \
         libxkbcommon0 \
         libxrender1 \
         libxss1 \
         libxt6 \
         make \
         perl \
         tar \
         tcsh \
         x11-apps \
         xorg \
         xorg-dev \
         xserver-xorg-video-intel \
         xterm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && :

RUN : \
    && deb="freesurfer_ubuntu22-${FREESURFER_VERSION}_amd64.deb" \
    && curl -sfLo "${deb}" "https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/${FREESURFER_VERSION}/${deb}" \
    && echo "${FREESURFER_DEB_MD5} ${deb}" | md5sum -c \
    && dpkg -i "${deb}" \
    && rm "${deb}" \
    && cd "${FREESURFER_HOME}" \
    && rm -rf \
        average/mult-comp-cor \
        lib/cuda \
        lib/qt \
        subjects \
        trctrain \
    && :

RUN : \
    && mkdir /safe_data /safe_outputs /scratch \
    && useradd ces-user \
    && :

USER ces-user
