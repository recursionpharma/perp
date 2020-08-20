#! /bin/bash

mv lockfiles/* ./

~/miniconda/bin/conda env create -f environment-lock.yml
