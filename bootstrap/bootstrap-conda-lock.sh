#! /bin/bash

cp lockfiles/* ./

sed -i"" -e '/- pip:.*/a \ \ \ \ - --extra-index-url https://pypi.rxrx.io/simple' environment-lock.yml
~/miniconda/bin/conda env create -f environment-lock.yml
