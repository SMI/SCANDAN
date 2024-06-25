# SPM12

https://www.fil.ion.ucl.ac.uk/spm/software/spm12/

https://www.fil.ion.ucl.ac.uk/spm/docs/

https://www.fil.ion.ucl.ac.uk/spm/software/download/

## Docker container

Official image is `ghcr.io/spm/spm-docker:docker-matlab` (see https://github.com/spm/spm-docker?tab=readme-ov-file#container-registry).

Example usage is:

```console
$ xhost +local:docker
$ docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp:/tmp -v /tmp/.X11-unix:/tmp/.X11-unix ghcr.io/spm/spm-docker:docker-matlab fmri
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

## If you have MatLab

* https://www.fil.ion.ucl.ac.uk/spm/download/restricted/eldorado/spm12.zip

## Standalone

* https://www.fil.ion.ucl.ac.uk/spm/download/restricted/utopia/MCR/glnxa64/MCRInstaller.bin
* https://www.fil.ion.ucl.ac.uk/spm/download/restricted/utopia/spm12/spm12_r7771_R2010a.zip (for use with MCRInstaller)
* https://www.fil.ion.ucl.ac.uk/spm/download/restricted/utopia/spm12/spm12_r7771_Linux_R2022b.zip (for use with MatLab 2022b, we have 2023b)
