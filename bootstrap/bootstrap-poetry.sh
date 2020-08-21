#! /bin/bash

sed -i"" -e "s/python = .*/python = \"$PY_VERSION\"/" pyproject.toml
eval "$(/root/.pyenv/bin/pyenv init -)"
/root/.pyenv/bin/pyenv shell $PY_VERSION
/root/.poetry/bin/poetry install --no-root