#! /bin/bash

./creds.sh

sed -i"" -e "s/- python[<>~=].*/- python=$PY_VERSION/" environment-pip.yml
echo "$0: $(cat environment-pip.yml |  grep python=)"
/root/miniconda/bin/conda env create -f environment-pip.yml
