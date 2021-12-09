#! /bin/bash

./creds.sh

cp lockfiles/* ./

export PATH="/root/.local/bin:/root/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

pyenv virtualenv $PY_VERSION test
pyenv deactivate
pyenv activate test
export PYTHON_ENV_PATH=/root/.pyenv/versions/$PY_VERSION/envs/test/bin/
echo "$0: $($PYTHON_ENV_PATH/python --version)"
$PYTHON_ENV_PATH/pip install --upgrade pip
$PYTHON_ENV_PATH/pip install --no-cache-dir -r requirements.txt
