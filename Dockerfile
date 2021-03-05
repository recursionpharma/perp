FROM ubuntu:latest as base
ARG PROJECT_DIR
ARG PYTHON_VERSION
ARG PYPI_URL
ARG PYPI_USERNAME
ARG PYPI_PASSWORD
ARG CHANNEL
ARG TOKEN
ENV PY_VERSION=$PYTHON_VERSION
ENV CFLAGS -O2

# Get requirements for installing different versions of python via pyenv
RUN apt update \
    && apt install -y python3-pip python3-venv curl git time libssl-dev \
    libbz2-dev libsqlite3-dev libreadline-dev libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# Install pyenv
RUN curl https://pyenv.run | bash

# Install the specific python version requested using pyenv (multiple builds
# will use this version)
RUN /root/.pyenv/bin/pyenv install $PYTHON_VERSION

# Update pip
RUN pip3 install --upgrade pip

# Install poetry
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3

# Install pipenv
RUN pip3 install --user pipenv

# Install conda
RUN curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o ~/miniconda.sh && bash ~/miniconda.sh -b -p $HOME/miniconda
ENV PATH /root/miniconda/bin:$PATH

# Install mamba
RUN ~/miniconda/bin/conda install mamba -c conda-forge

COPY ./utils/ ./bootstrap/ ./$PROJECT_DIR/ /test/
RUN /test/cleanup.sh

# Provision an optional private pypi server
RUN if [[ ! -z "$PYPI_URL" ]]; then printf "machine $PYPI_URL\n\tlogin $PYPI_USERNAME\n\tpassword $PYPI_PASSWORD\n" >> ~/.netrc && chmod 0600 ~/.netrc ; fi

# Provision an optional private conda channel
RUN if [[ ! -z "$CONDA_CHANNEL" ]]; then printf "channels:\n  - https://conda.anaconda.org/$CHANNEL/t/$TOKEN\n" >> ~/.condarc; fi

WORKDIR /test

ENTRYPOINT ["/bin/bash"]

FROM base as locks
ARG PROJECT_DIR
ARG PYTHON_VERSION
ENV PY_VERSION=$PYTHON_VERSION

COPY ./$PROJECT_DIR/lockfiles /test/lockfiles