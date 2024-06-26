# Freesurfer

https://surfer.nmr.mgh.harvard.edu/

Requires a `license.txt` file which can be obtained from [here](https://surfer.nmr.mgh.harvard.edu/registration.html).

## Docker containers

Official image is https://hub.docker.com/r/freesurfer/freesurfer, with the latest version being 7.4.1 (released June 2023).

```console
$ docker pull freesurfer/freesurfer:7.4.1
```

An alternative image can be build from the included `Dockerfile`.

Version 7.4.1 can be pulled from https://github.com/smi/SCANDAN/pkgs/container/freesurfer

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
