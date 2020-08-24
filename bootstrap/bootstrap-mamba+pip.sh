#! /bin/bash

sed -i"" -e "s/- python[<>~=].*/- python=$PY_VERSION/" environment-pip.yml
/root/miniconda/condabin/mamba env create -f environment-pip.yml