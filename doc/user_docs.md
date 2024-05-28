# SCANDAN for Research Users

## Introduction

Research users are provided with access to a virtual desktop, and can log into it
using either the desktop interface (called `RDP`) or to a command line interface
(called `SSH`).

If you have any problems logging in then please contact your Research Coordinator.

The interface has a hidden menu - press the SHIFT + CTRL + ALT keys together
for access to an on-screen keyboard and other facilities. This might be helpful
if you have odd characters in your password.

## Access to data

Your project data will be made available in `/safe_data/2223-0200`

## Access to software

You can write software in R or Python, and you have access to the software
repositories CRAN and PyPi respectively.

NOTE: for Python users - the default Python is supplied by Anaconda
(`/usr/local/bin/python`) but this is an old version 3.7. The whole
Anaconda environment has been deprecated and may be removed in future.
However if you wish to use it and create conda environments then you
can do so using the `--offline` option, e.g. `conda create -n my_conda_env --offline`

The recommended option is to ignore Anaconda and use the built-in Python,
which is a more recent version 3.10, and use it from a virtual environment.
```
# Download a copy of 'virtualenv' into your personal pip environment
pip3 install virtualenv
# Create a new virtual environment
~/.local/bin/virtualenv -p /usr/bin/python3 ~/my_venv
# Every time you want to install/run a python program:
source ~/my_venv/bin/activate
# If you wish to switch to a different one then:
deactivate
```
