#! /bin/bash

./creds.sh

cp lockfiles/* ./

if [[ ! -z "$PYPI_URL" ]]
then
    sed -i"" -e "/- pip:.*/a \ \ \ \ - --extra-index-url $PYPI_URL" environment-lock.yml
fi
echo "$0: $(cat environment-lock.yml |  grep python=)"
/root/miniconda/condabin/mamba env create -f environment-lock.yml
