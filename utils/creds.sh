#! /bin/bash

# Provision private PyPI server access
if [[ ! -z "$PYPI_URL" ]]
then
    host=$(echo $PYPI_URL | awk -F[/:] '{print $4}')
    printf "machine $host\n\tlogin $PYPI_USERNAME\n\tpassword $PYPI_PASSWORD\n" >> ~/.netrc && chmod 0600 ~/.netrc
fi

# Provision private Anaconda channel
if [[ ! -z "$CONDA_CHANNEL" ]]
then
    printf "channels:\n  - https://conda.anaconda.org/$CHANNEL/t/$TOKEN\n" >> ~/.condarc
fi