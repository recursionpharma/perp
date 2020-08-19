#! /bin/bash

mv lockfiles/* ./

PIPENV_IGNORE_VIRTUALENVS=1 ~/.local/bin/pipenv install --ignore-pipfile