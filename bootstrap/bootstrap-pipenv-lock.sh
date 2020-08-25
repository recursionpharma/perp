#! /bin/bash

cp lockfiles/* ./

export LC_ALL='en_US.UTF-8'
export LANG='en_US.UTF-8'
export PIPENV_NOSPIN=1
export PIPENV_IGNORE_VIRTUALENVS=1
export PIPENV_TIMEOUT=900
export PIPENV_INSTALL_TIMEOUT=1800

~/.local/bin/pipenv install --ignore-pipfile