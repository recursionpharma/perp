#! /bin/bash

./creds.sh

/root/.pyenv/versions/$PY_VERSION/bin/python -m venv ./venv
source ./venv/bin/activate
export PYTHON_ENV_PATH=./venv/bin/
echo "$0: $($PYTHON_ENV_PATH/python --version)"
$PYTHON_ENV_PATH/pip install pip --upgrade
$PYTHON_ENV_PATH/pip install --no-cache-dir --use-feature=2020-resolver -r requirements.in