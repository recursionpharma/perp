#! /bin/bash

./creds.sh

export PATH="/root/.local/bin:/root/.pyenv/bin:/root/.poetry/bin:$PATH"
export LC_ALL=C.UTF-8
export LANG=C.UTF-8

sed -i"" -e "s/^python = .*/python = \"$PY_VERSION\"/" pyproject.toml
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

pyenv init
pyenv shell $PY_VERSION
poetry run pip install --upgrade pip
poetry install --no-root