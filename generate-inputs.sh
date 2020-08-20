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

pushd $project_dir
dephell deps convert --from=requirements.in --to=Pipfile &> logs/generate_pipenv.log
dephell deps convert --from=requirements.in --to=pyproject.toml &> logs/generate_poetry.log
popd 