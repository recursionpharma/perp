#! /bin/bash

./creds.sh

export PATH="/root/.local/bin:/root/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

pyenv virtualenv $PY_VERSION test
pyenv deactivate
pyenv activate test
pip install pip --upgrade
pip install --no-cache-dir --use-feature=2020-resolver -r requirements.in
