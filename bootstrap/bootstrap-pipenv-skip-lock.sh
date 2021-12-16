#! /bin/bash

./creds.sh

sed -i"" -e "s/python_version =.*/python_version = \"$PY_VERSION\"/" Pipfile

export LC_ALL='en_US.UTF-8'
export LANG='en_US.UTF-8'
export PIPENV_NOSPIN=1
export PIPENV_IGNORE_VIRTUALENVS=1
export PIPENV_TIMEOUT=900
export PIPENV_INSTALL_TIMEOUT=1800

/root/.local/bin/pipenv install --skip-lock
