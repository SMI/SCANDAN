# FSL

https://fsl.fmrib.ox.ac.uk/fsl/fslwiki

## Docker container

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

