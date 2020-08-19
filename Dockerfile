FROM ubuntu:latest
ARG TOKEN
ARG PROJECT_DIR

# Get the latest
RUN apt update && apt install -y python3-pip python3-venv curl git time && rm -rf /var/lib/apt/lists/*

# Update pip
RUN pip3 install --upgrade pip

# Install poetry
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3

# Install pyenv
RUN curl https://pyenv.run | bash

# Install pipenv
RUN pip3 install --user pipenv

# Install conda
RUN curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o ~/miniconda.sh && bash ~/miniconda.sh -b -p $HOME/miniconda

# Install mamba
RUN ~/miniconda/bin/conda install mamba -c conda-forge

COPY ./utils/ ./bootstrap/ ./$PROJECT_DIR/ /test/
RUN /test/cleanup.sh

WORKDIR /test

ENTRYPOINT ["/bin/bash"]
