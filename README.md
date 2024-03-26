# SCANDAN

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
