#! /bin/bash

mv lockfiles/* ./

/root/.pyenv/bin/pyenv virtualenv $PY_VERSION test
/root/.pyenv/bin/pyenv deactivate
/root/.pyenv/bin/pyenv activate test
pip install --no-cache-dir -r requirements.txt
