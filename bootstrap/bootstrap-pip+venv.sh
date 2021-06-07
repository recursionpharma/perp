#! /bin/bash

./creds.sh

/root/.pyenv/versions/$PY_VERSION/bin/python -m venv ./venv
source ./venv/bin/activate
echo "$0: $(python --version)"
pip install pip --upgrade
pip install --no-cache-dir --use-feature=2020-resolver -r requirements.in