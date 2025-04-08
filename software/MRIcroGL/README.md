# MRIcroGL in a container

Build the container:
```
docker build -t mricrogl .
```

Run it:
```
./mricrogl.sh
```

## Push to registry

Use your github token in CR_PAT.
Replace `USERNAME` with your github username.
```
export CR_PAT=ghp_XXX
echo $CR_PAT | docker login ghcr.io -u USERNAME --password-stdin
docker tag mricrogl ghcr.io/USERNAME/mricrogl:latest
docker push ghcr.io/USERNAME/mricrogl:latest
```

## Run inside the NSH with podman

Pull the container into the NSH, where `USERNAME` is the github username where you pushed your container:
```
ces-pull <username> <token> ghcr.io/USERNAME/mricron
```

Run it using a script similar to `./mricrogl.sh` but replace `docker` with `podman`.


# Building from source

See https://github.com/rordenlab/MRIcroGL/blob/master/DOCKER.md

```
docker build -t mricrogl -f Dockerfile_from_source .
```

Unfortunately this gives an error:
```
/Python-for-Lazarus/python4lazarus/PythonEngine.pas(4675,46) Error: (3026) Wrong number of parameters specified for call to "LoadFromFile"
Error: (5088) Found declaration: LoadFromFile(const AnsiString);
```
