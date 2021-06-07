#! /bin/bash

./creds.sh

export PATH="/root/.local/bin:/root/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
# export LC_ALL='en_US.UTF-8'
# export LANG='en_US.UTF-8'

pyenv virtualenv $PY_VERSION test
pyenv deactivate
pyenv activate test
echo "$0: $(python --version)"
pip install pip-tools
pip-compile --generate-hashes requirements.in
