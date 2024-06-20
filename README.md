# SCANDAN Software

This repository hosts several software packages which have been packaged into Docker images.

| Image      | Pull Command | TRE Compatible? | Notes |
| ---------- | ------------ | --------------- | ----- |
| [Freesurfer](https://surfer.nmr.mgh.harvard.edu/fswiki/FreeSurferWiki)| `docker pull ghcr.io/smi/freesurfer:latest`| 🚧 |Requires a license file|
| [FSL](https://fsl.fmrib.ox.ac.uk/fsl/docs) | `docker pull ghcr.io/smi/fsl:latest` | 🚧 ||

## Usage notes

### Running graphical applications via Docker

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
