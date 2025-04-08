#!/bin/bash
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth.$(id -u)
xauth nlist "$DISPLAY" | sed -e 's/^..../ffff/' | xauth -f "$XAUTH" nmerge -
docker run --rm -it \
 -e USER="$USER" \
 -e DISPLAY="$DISPLAY" \
 -e XAUTHORITY="$XAUTH" \
 -v $XSOCK:$XSOCK \
 -v $XAUTH:$XAUTH \
 -v $(pwd):/dicom:ro \
 mricrogl MRIcroGL/MRIcroGL_QT "$@"
