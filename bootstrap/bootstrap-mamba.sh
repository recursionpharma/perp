#! /bin/bash

./creds.sh

sed -i"" -e "s/- python[<>~=].*/- python=$PY_VERSION/" environment-conda.yml
echo "$0: $(cat environment-conda.yml |  grep python=)"
/root/miniconda/condabin/mamba env create -f environment-conda.yml