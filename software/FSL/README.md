# FSL

https://fsl.fmrib.ox.ac.uk/fsl/docs/#/

Old site at https://fsl.fmrib.ox.ac.uk/fsl/fslwiki

## Docker containers

A container with a relatively old version (5.0.7) can be build from `fsl5.Dockerfile`.

Version 6.0.7.9 can be run from https://github.com/smi/SCANDAN/pkgs/container/fsl

### FSL Documentation

The new FSL site provides [these](https://fsl.fmrib.ox.ac.uk/fsl/docs/#/install/container?id=install-fsl-into-a-dockersingularity-container) instructions. This has been translated into the main `Dockerfile` in this directory.

### Neurodocker

Using [neurodocker](https://www.repronim.org/neurodocker/index.html):

```console
$ docker run --rm repronim/neurodocker \
    generate docker \
    --pkg-manager apt \
    --base-image debian:bullseye-slim \
    --fsl version=6.0.5 \
    --yes \
    > fsl605.Dockerfile

$ docker build --tag fsl:6.0.5 --file fsl605.Dockerfile .
```


