# SCANDAN Software

This repository hosts several imaging-related software packages which have been compiled into Docker images for use in Trusted Reserach Environments (TREs).

| Software | Image | Notes |
| ---------- | ------------ | --------------- | ----- |
| [Freesurfer](https://surfer.nmr.mgh.harvard.edu/fswiki/FreeSurferWiki)| `ghcr.io/smi/freesurfer:latest`| Requires a user-provided license file|
| [FSL](https://fsl.fmrib.ox.ac.uk/fsl/docs) | `ghcr.io/smi/fsl:latest` ||
| [MRIcron](https://github.com/neurolabusc/MRIcron)| `ghcr.io/smi/mricron:latest`||
| [MRIcroGL](https://github.com/rordenlab/MRIcroGL)| `ghcr.io/smi/mricrogl:latest`||

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
