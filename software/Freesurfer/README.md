# Freesurfer

https://surfer.nmr.mgh.harvard.edu/

Requires a `license.txt` file which can be obtained from [here](https://surfer.nmr.mgh.harvard.edu/registration.html).

## Docker container

Official image is https://hub.docker.com/r/freesurfer/freesurfer, however latest image is 7.2.0 (released July 2021), and latest release is 7.4.1 (released June 2023).

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
