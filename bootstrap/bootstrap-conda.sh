#! /bin/bash

sed -i"" -e "s/- python[<>~=].*/- python=$PY_VERSION/" environment-conda.yml
~/miniconda/bin/conda env create -f environment-conda.yml