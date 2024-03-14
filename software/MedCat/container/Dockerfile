# Standard initialisation:
FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y python3-dev python3-virtualenv
RUN python3 -m virtualenv /venv
RUN . /venv/bin/activate && pip install --upgrade pip
# Add any lines like this to install your packages:
RUN /venv/bin/pip install scikit-learn
RUN /venv/bin/pip install medcat
RUN /venv/bin/python -m spacy download en_core_web_md
# Copy any static files you require into the container:
COPY ./model_downloader.py /model_downloader.py
# You can run scripts now to download other files you need in the container:
RUN /venv/bin/python3 /model_downloader.py
# Copy your personal scripts into the container:
COPY ./medcat_test.py /medcat_test.py
# Tell the container to run your script when it starts:
ENTRYPOINT ["/venv/bin/python3", "/medcat_test.py"]
