#! /bin/bash

sed -i"" -e "s/python = .*/python = \"$PY_VERSION\"/" pyproject.toml
/root/.poetry/bin/poetry install --no-root