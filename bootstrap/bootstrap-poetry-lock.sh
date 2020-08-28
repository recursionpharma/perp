#! /bin/bash

cp lockfiles/* ./

export PATH="/root/.local/bin:/root/.pyenv/bin:/root/.poetry/bin:$PATH"

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

pyenv init
pyenv shell $PY_VERSION
poetry run pip install --upgrade pip
poetry install --no-root