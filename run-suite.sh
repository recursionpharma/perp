#! /usr/bin/env bash
# set -e
set -x

if [[ $# < 2 ]];
then
    echo "Usage: $0 project python-version"
    exit -1
fi

project=$1
py_version=$2
project_dir=projects/$project
project_logs_dir=$project_dir/logs
project_lock_dir=$project_dir/lockfiles
docker_image=profile-$project

if [[ ! -d logs ]];
then
    mkdir logs
fi

if [[ ! -d $project_logs_dir ]];
then
    mkdir $project_logs_dir
fi

if [[ ! -f $project_logs_dir/results.txt ]];
then
    echo "env,time" > $project_logs_dir/results.txt
fi


docker build . --build-arg PROJECT_DIR=$project_dir --tag $docker_image &> logs/docker.log

docker run -e PY_VERSION=$py_version $docker_image -c "/test/bootstrap-conda.sh &> /dev/null && ~/miniconda/bin/conda activate test &> /dev/null && ~/miniconda/bin/conda env export" > $project_lock_dir/environment-lock.yml
docker run -e PY_VERSION=$py_version $docker_image -c "/test/bootstrap-pipenv.sh &> /dev/null && cat Pipfile.lock" > $project_lock_dir/Pipfile.lock
docker run -e PY_VERSION=$py_version $docker_image -c "/test/bootstrap-poetry.sh &> /dev/null && cat poetry.lock" > $project_lock_dir/poetry.lock
docker run -e PY_VERSION=$py_version $docker_image -c "/test/bootstrap-pip-compile.sh &> /dev/null && cat requirements.txt" > $project_lock_dir/requirements.txt

for snek in conda conda-lock conda+pip mamba mamba+pip pip-compile pip-lock pip+pyenv pip+venv pipenv pipenv-lock pipenv-skip-lock poetry poetry-lock
do
    echo $snek
    docker run -e PY_VERSION=$py_version $docker_image -c "/test/bootstrap-${snek}.sh" &> $project_logs_dir/${snek}.log
    status_code=$?
    echo "return code: $status_code" >> $project_logs_dir/${snek}.log
    if [[ $status_code -eq 0]]; then
        for i in `seq 1 10`;
        do
            docker run -e PY_VERSION=$py_version $docker_image -c "/usr/bin/time --format "%e" --output=/test/time.out \
                                        /test/bootstrap-${snek}.sh &> /dev/null && \
                                        echo -n "${snek}," && cat /test/time.out" >> $project_logs_dir/results.txt
        done
    fi
done   
