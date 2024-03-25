# FSL

https://fsl.fmrib.ox.ac.uk/fsl/fslwiki

## Docker containers

A container with a relatively old version (5.0.7) can be build from `fsl5.Dockerfile`.

To run with the correct display options, use:

```console
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
xauth nlist "$DISPLAY" | sed -e 's/^..../ffff/' | xauth -f "$XAUTH" nmerge -

docker run --rm -it \
    -e USER="$USER" \
    -e DISPLAY="$DISPLAY" \
    -e XAUTHORITY="$XAUTH" \
    -v $XSOCK:$XSOCK \
    -v $XAUTH:$XAUTH \
    <image-name>
```

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


