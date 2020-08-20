#! /bin/bash

PY_VERSION=3.8.5

/root/.pyenv/bin/pyenv virtualenv $PY_VERSION test
/root/.pyenv/bin/pyenv deactivate
/root/.pyenv/bin/pyenv activate test
pip install pip-tools
pip-compile --generate-hashes requirements.in
