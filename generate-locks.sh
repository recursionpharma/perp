#! /usr/bin/env bash
# set -e
set -x

if [[ $# < 1 ]];
then
    echo "$0 project"
    exit -1
fi

project=$1
project_dir=projects/$project
project_lock_dir=$project_dir/lockfiles
docker_image=profile-$project

if [[ ! -d logs ]];
then
    mkdir logs
fi

if [[ ! -d $project_lock_dir ]];
then
    mkdir $project_lock_dir
fi

docker image inspect $docker_image &> /dev/null || docker build . --build-arg PROJECT_DIR=$project_dir --tag $docker_image &> logs/docker.log

docker run $docker_image -c "/test/bootstrap-conda.sh &> /dev/null && ~/miniconda/bin/conda activate test &> /dev/null && ~/miniconda/bin/conda env export" > $project_lock_dir/environment-lock.yml
docker run $docker_image -c "/test/bootstrap-pipenv.sh &> /dev/null && cat Pipfile.lock" > $project_lock_dir/Pipfile.lock
docker run $docker_image -c "/test/bootstrap-poetry.sh &> /dev/null && cat poetry.lock" > $project_lock_dir/poetry.lock
docker run $docker_image -c "/test/bootstrap-pip-compile.sh &> /dev/null && cat requirements.txt" > $project_lock_dir/requirements.txt