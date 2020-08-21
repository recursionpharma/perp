#! /bin/bash

sed -i"" -e "s/python_version =.*/python_version = \"$PY_VERSION\"/" Pipfile
PIPENV_IGNORE_VIRTUALENVS=1 ~/.local/bin/pipenv install --skip-lock