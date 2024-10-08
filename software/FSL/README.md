# FSL

https://fsl.fmrib.ox.ac.uk/fsl/docs/#/

Old site at https://fsl.fmrib.ox.ac.uk/fsl/fslwiki

## Docker containers

A container with a relatively old version (5.0.7) can be build from `fsl5.Dockerfile`.

Version 6.0.7.9 can be run from https://github.com/smi/SCANDAN/pkgs/container/fsl

To run it:
```
XSOCK=/tmp/.X11-unix
XAUTH=${HOME}/.Xauthority
podman run --rm -it \
    -e USER="$USER" \
    -e DISPLAY="$DISPLAY" \
    -e XAUTHORITY="$XAUTH" \
    -v $XSOCK:$XSOCK \
    -v $XAUTH:$XAUTH \
    --entrypoint='["/bin/sh", "-c", ". /usr/local/fsl/etc/fslconf/fsl.sh && /usr/local/fsl/bin/fsl"]' \
    ghcr.io/smi/fsl:latest
```

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


### Manual installation

See https://fsl.fmrib.ox.ac.uk/fsl/docs/#/install/index?id=information-for-advanced-users
and https://fsl.fmrib.ox.ac.uk/fsl/docs/#/install/linux

Download installer from `https://git.fmrib.ox.ac.uk/fsl/conda/installer/-/raw/main/fsl/installer/fslinstaller.py?ref_type=heads&inline=false`

Edit installer to better handle installing into a directory which already exists:
```
In overwrite_destdir
    return # XXX added
    # generate a unique name for the old
In check_need_admin
    return False # XXX added
    return not os.access(dirname, os.W_OK | os.X_OK)
```

Edit installer to call miniconda with the `-f` option if directory already exists:
```
cmd = 'bash miniconda.sh -f -b -p {}'.format(ctx.basedir)
```

Run it like this:
```
python3 ./fslinstaller.py --skip_registration --no_self_update -d /usr/local/fsl 
   [--no_env] if you don't want it to edit your bashrc/profile scripts
```

It modifies `~/.profile` and `~/Documents/MATLAB/startup.m`
