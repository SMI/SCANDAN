# SPM12

https://www.fil.ion.ucl.ac.uk/spm/software/spm12/

https://www.fil.ion.ucl.ac.uk/spm/docs/

## Docker container

"Official" image is `spmcentral/spm`, last updated 3 years ago. See https://www.fil.ion.ucl.ac.uk/spm/docs/installation/containers/#spm-containers

```console
$ xhost +local:docker
$ docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp:/tmp -v /tmp/.X11-unix:/tmp/.X11-unix spmcentral/spm fmri
```

Alternatively, using [neurodocker](https://www.repronim.org/neurodocker/index.html):

```console
$ docker run --rm repronim/neurodocker \
    generate docker \
    --pkg-manager yum \
    --base-image centos:7 \
    --spm12 version=r7771 \
    > spm12-r7771.Dockerfile

$ docker build --tag spm12:r7771 --file spm12-r7771.Dockerfile .
```

