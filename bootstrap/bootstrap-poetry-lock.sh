#! /bin/bash

./creds.sh

cp lockfiles/* ./

export PATH="/root/.pyenv/versions/$PY_VERSION/bin/:/root/.local/bin:/root/.pyenv/bin:/root/.poetry/bin:$PATH"
export LC_ALL=C.UTF-8
export LANG=C.UTF-8

# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

# pyenv init
# pyenv shell $PY_VERSION
pyenv global $PY_VERSION
echo "$0: $(python --version)"
poetry run pip install --upgrade pip
poetry install --no-root