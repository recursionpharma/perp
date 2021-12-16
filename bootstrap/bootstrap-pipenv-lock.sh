#! /bin/bash

./creds.sh

cp lockfiles/* ./

sed -i"" -e "s/python_version =.*/python_version = \"$PY_VERSION\"/" Pipfile
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
export PIPENV_NOSPIN=1
export PIPENV_IGNORE_VIRTUALENVS=1
export PIPENV_TIMEOUT=900
export PIPENV_INSTALL_TIMEOUT=1800

/root/.local/bin/pipenv install --ignore-pipfile
