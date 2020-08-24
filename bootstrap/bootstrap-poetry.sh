#! /bin/bash

export PATH="/root/.local/bin:/root/.pyenv/bin:/root/.poetry/bin:$PATH"

sed -i"" -e "s/^python = .*/python = \"$PY_VERSION\"/" pyproject.toml
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

pyenv init
pyenv shell $PY_VERSION
poetry install --no-root