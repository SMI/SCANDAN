# Freesurfer

https://surfer.nmr.mgh.harvard.edu/

## Docker container

https://hub.docker.com/r/freesurfer/freesurfer

```console
$ docker pull freesurfer/freesurfer
```

Alternatively, using [neurodocker](https://www.repronim.org/neurodocker/index.html):

```console
$ docker run --rm repronim/neurodocker \
    generate docker \
    --pkg-manager apt \
    --base-image debian:bullseye-slim \
    --freesurfer version=7.4.1 \
    --yes \
    > freesurfer741.Dockerfile

$ docker build --tag freesurfer:7.4.1 --file freesurfer741.Dockerfile .
```
