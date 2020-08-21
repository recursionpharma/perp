#! /bin/bash

sed -i"" -e "s/python[<>~=].*/python=$PY_VERSION/" environment-conda.yml
/root/miniconda/condabin/mamba env create -f environment-conda.yml