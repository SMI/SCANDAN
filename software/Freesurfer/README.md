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
    --freesurfer version=7.3.0 \
    --yes \
    > freesurfer730.Dockerfile

$ docker build --tag freesurfer:7.3.0 --file freesurfer730.Dockerfile .
```
