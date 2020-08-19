#! /bin/bash

source $HOME/.poetry/env

export PATH="/root/.local/bin:/root/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

~/miniconda/bin/conda shell.bash hook
~/miniconda/bin/conda init
~/miniconda/bin/conda config --set auto_activate_base false

