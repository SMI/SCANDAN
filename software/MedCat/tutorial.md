# Package Python scripts into a container

How to package up your code and its requirements into a container
for running inside the TRE (Safe Haven).

Assumptions:
* the container will only run a single script
* the script it runs can be passed command-line parameters
* only two directories from outside the container will be made available to the script in the container:
  - `/safe_data` will be the name inside the container for input data files
  - `/safe_outputs` will be the name inside the container for output data files

Create this directory structure
```
 + container/
   - Dockerfile
   - medcat_test.py
   - model_downloader.py
   - requirements.txt
 + input/
   + docs/
     - doc1.txt
   + models/
     - mc_modelpack_snomed_int_16_mar_2022_25be3857ba34bdd5.zip
 + output/
```

```
mkdir -p container input/docs input/models output
```

Create a directory called `container` and inside there create three files:
* medcat_test.py
* model_downloader.py
* requirements.txt

The file `medcat_test.py` is
```
# usage: medcat_test.py input.txt output.json
import json, pathlib, sys
from medcat.cat import CAT
cat = CAT.load_model_pack(sys.argv[1])
text = pathlib.Path(sys.argv[2]).read_text()
entities = cat.get_entities(text)
pathlib.Path(sys.argv[3]).write_text(json.dumps(entities))
```

The file `requirements.txt` is
```
scikit-learn
medcat
```

(Actually medcat should have scikit-learn in its requirements
but it has sklearn which is an older name for the same thing
and doesn't work properly)

The file `model_downloader.py` is only run once during the creation 
of the container. It downloads models from huggingface which will be
cached inside the container. The script should contain:
```
from transformers import AutoTokenizer, AutoModel, AutoModelWithLMHead
tokenizer = AutoTokenizer.from_pretrained("emilyalsentzer/Bio_ClinicalBERT")
model = AutoModel.from_pretrained("emilyalsentzer/Bio_ClinicalBERT")
```

Inside the `container` directory create a file called `Dockerfile`

```
# Standard initialisation:
FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y python3-dev python3-virtualenv
RUN python3 -m virtualenv /venv
RUN . /venv/bin/activate && pip install --upgrade pip
# Add any lines like this to install your packages:
RUN /venv/bin/pip install scikit-learn && pip install medcat
RUN /venv/bin/python -m spacy download en_core_web_md
# Copy any static files you require into the container:
COPY ./model_downloader.py /model_downloader.py
# You can run scripts now to download other files you need in the container:
RUN /venv/bin/python3 /model_downloader.py
# Copy your personal scripts into the container:
COPY ./medcat_test.py /medcat_test.py
# Tell the container to run your script when it starts:
ENTRYPOINT ["/venv/bin/python3", "/medcat_test.py"]
```


The input file `input/docs/doc1.txt` can be anything
```
The patient with a history of diabetes was seen by Dr.Jones and found to have an occluded lung
```

Download the model files and place them in `input/models/`

Create an "image" (a non-running container)
```
cd container
sudo docker build -t abrooks/medcat .
```

The build process may take some time, but when you edit your script
during development and re-run the build command then it will complete
much quicker.

Run the container, and pass it the filename of a model.zip,
and the input and output file names.
The `-v src:dest` option makes your local directory `src` available
inside the container as the path `dest`.
As a general rule your containers should be built to expect only two
directories, `/safe_data` (for inputs) and `/safe_outputs`.
After the name of the container you can pass any arguments to the script.
```
sudo docker run --rm \
  -v $(pwd)/input:/safe_data \
  -v $(pwd)/output:/safe_outputs \
  abrooks/medcat \
  /safe_data/models/mc_modelpack_snomed_int_16_mar_2022_25be3857ba34bdd5.zip \
  /safe_data/docs/doc1.txt \
  /safe_outputs/doc1.json
```

If you need to examine the files inside the container or need a shell:
```
sudo docker run --rm -it --entrypoint /bin/bash abrooks/medcat
```

# To do

Explain how a script can be written to run outside a container
on local files and then be modified to run inside a container with the
/safe_data and /safe_outputs directories.

# Running on a GPU cluster

The procedure for running on a GPU cluster is more complex because,
for the moment anyway, the cluster does not have access to a local
filesystem, and also the container image must be pulled from a
repository and not from the docker/podman on the local computer.

We can reuse the container image built above but first we need to push
it to a container hub, for example:
```
docker login
docker push abrooks/medcat
```

The next step is to create a storage volume (called a PV or
Persistent Volume) in the cluster using a PVC (Persistent Volume Claim).
The input files, in our case the text document and a language model,
need to be copied into the storage volume.

The cluster is then told how to run the container, after which the output
files need to be copied out of the storage volume.

Unfortunately copying files into and out of a storage volume requires
a container to be running, so we use a container which is simply sleeping
to do this, as it consumes no CPU/GPU resources.

See the script [run_on_gpu_cluster.sh](run_on_gpu_cluster.sh)

Use `./run_on_gpu_cluster.sh` to run the job.

Use `./run_on_gpu_cluster.sh status` to see what is running/finished.

Use `./run_on_gpu_cluster.sh delete` to remove any running/finished jobs and remove the storage volume.

Use `kubectl -n eidf040ns logs <podname>` to get the screen output.

# OLD

```
# RUN . /venv/bin/activate && pip install https://s3-us-west-2.amazonaws.com/ai2-s2-scispacy/releases/v0.4.0/en_core_sci_md-0.4.0.tar.gz && pip install https://s3-us-west-2.amazonaws.com/ai2-s2-scispacy/releases/v0.4.0/en_core_sci_lg-0.4.0.tar.gz
```
