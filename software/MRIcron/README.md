# MRIcron

MRIcron is useful for older computers because it doesn't need OpenGL:
```
curl -fLO https://github.com/neurolabusc/MRIcron/releases/latest/download/MRIcron_linux.zip
```

Newer is MRIcroGL, but we won't use MRIcroGL for this demonstration:
```
https://github.com/rordenlab/MRIcroGL/releases/download/v1.2.20220720/MRIcroGL_linux.zip
```

## Build

```
docker build --progress=plain -t mricron .
```

## Push to registry

Use your github token in CR_PAT.
Replace `USERNAME` with your github username.
```
export CR_PAT=ghp_XXX
echo $CR_PAT | docker login ghcr.io -u USERNAME --password-stdin
docker tag mricron ghcr.io/USERNAME/mricron:latest
docker push ghcr.io/USERNAME/mricron:latest
```

# Run

```
./mricron_container.sh
```

Any DICOM files in the current directory will be visible inside /dicom when using dcmaudit.

## Run inside the NSH with podman

Pull the container into the NSH, where `USERNAME` is the github username where you pushed your container:
```
ces-pull <username> <token> ghcr.io/USERNAME/mricron
```

Create a script to run it:
```
#!/bin/bash
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth.$(id -u)
xauth nlist "$DISPLAY" | sed -e 's/^..../ffff/' | xauth -f "$XAUTH" nmerge -
podman run --rm -it \
 -e USER="$USER" \
 -e DISPLAY="$DISPLAY" \
 -e XAUTHORITY="$XAUTH" \
 -v $XSOCK:$XSOCK \
 -v $XAUTH:$XAUTH \
 -v $(pwd):/dicom:ro \
 ghcr.io/USERNAME/mricron "$@"
```

Any DICOM files in the current directory will be available in the /dicom directory inside the container.
You can replace the `$(pwd)` in the last line with the directory which contains your DICOM files.
That directory will be mounted read-only. You can add other lines for an output directory if you want to write files.
