# MRIcroGL in a container

Build the container:
```
docker build -t mricrogl .
```

Run it:
```
./mricrogl.sh
```

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
