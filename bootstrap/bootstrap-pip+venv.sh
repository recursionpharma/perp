#! /bin/bash

/root/.pyenv/versions/$PY_VERSION/bin/python -m venv ./venv
source ./venv/bin/activate
pip install pip --upgrade
pip install --no-cache-dir --use-feature=2020-resolver -r requirements.in