#! /bin/bash

./creds.sh

cp lockfiles/* ./

if [[ ! -z "$PYPI_URL" ]]
then
    sed -i"" -e "/- pip:.*/a \ \ \ \ - --extra-index-url $PYPI_URL" environment-lock.yml
fi
~/miniconda/bin/conda env create -f environment-lock.yml
