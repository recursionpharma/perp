#! /bin/bash

./creds.sh

sed -i"" -e "s/- python[<>~=].*/- python=$PY_VERSION/" environment-pip.yml
~/miniconda/bin/conda env create -f environment-pip.yml