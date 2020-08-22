#! /bin/bash

mv lockfiles/* ./

sed -i"" -e '/- pip:.*/a \ \ \ \ - --extra-index-url https://pypi.rxrx.io/simple' environment-lock.yml
/root/miniconda/condabin/mamba env create -f environment-lock.yml
