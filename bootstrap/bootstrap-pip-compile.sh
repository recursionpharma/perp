#! /bin/bash

/root/.pyenv/bin/pyenv virtualenv $PY_VERSION test
/root/.pyenv/bin/pyenv deactivate
/root/.pyenv/bin/pyenv activate test
pip install pip-tools
pip-compile --generate-hashes requirements.in
