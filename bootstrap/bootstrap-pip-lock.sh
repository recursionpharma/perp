#! /bin/bash

cp lockfiles/* ./

export PATH="/root/.local/bin:/root/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

pyenv virtualenv $PY_VERSION test
pyenv deactivate
pyenv activate test
pip install --no-cache-dir -r requirements.txt
