#! /bin/bash

/root/.pyenv/bin/pyenv virtualenv 3.8.5 test
/root/.pyenv/bin/pyenv deactivate
/root/.pyenv/bin/pyenv activate test
pip install --no-cache-dir --use-feature=2020-resolver -r requirements.txt
