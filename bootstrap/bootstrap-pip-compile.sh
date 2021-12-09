#! /bin/bash

./creds.sh

export PATH="/root/.local/bin:/root/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
# export LC_ALL='en_US.UTF-8'
# export LANG='en_US.UTF-8'

pyenv virtualenv $PY_VERSION test
pyenv deactivate
pyenv activate test
export PYTHON_ENV_PATH=/root/.pyenv/versions/$PY_VERSION/envs/test/bin/
echo "$0: $($PYTHON_ENV_PATH/python --version)"
$PYTHON_ENV_PATH/pip install pip-tools
$PYTHON_ENV_PATH/pip-compile --generate-hashes requirements.in
