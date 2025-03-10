# MRIcron

MRIcron is useful for older computers because it doesn't need OpenGL
```
curl -fLO https://github.com/neurolabusc/MRIcron/releases/latest/download/MRIcron_linux.zip
```

Newer is MROcroGL
```
https://github.com/rordenlab/MRIcroGL/releases/download/v1.2.20220720/MRIcroGL_linux.zip
```

## Build

```
docker build --progress=plain -t mricron .
```

(CACHEDATE must change each time to prevent docker cache keeping an old copy of a repo from git pull)

## Push to registry

```
export CR_PAT=ghp_XXX
echo $CR_PAT | docker login ghcr.io -u USERNAME --password-stdin
docker tag mricron ghcr.io/howff/mricron:latest
docker push ghcr.io/howff/mricron:latest
```

# Run

```
./mricron_container.sh
```

Any DICOM files in the current directory will be visible inside /dicom when using dcmaudit.
