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

# Create the lockfiles for the requisite projects and log the output for debugging
docker run -e PY_VERSION=$py_version $docker_image -c "/test/bootstrap-conda.sh 1>&2 && ~/miniconda/bin/conda env export -n test " > $project_lock_dir/environment-lock.yml 2> logs/create-lock-conda.log
echo "return code: $?" >> $project_logs_dir/create-lock-conda.log

docker run -e PY_VERSION=$py_version $docker_image -c "/test/bootstrap-pipenv.sh 1>&2 && cat Pipfile.lock" > $project_lock_dir/Pipfile.lock 2> logs/create-lock-pipenv.log
echo "return code: $?" >> $project_logs_dir/create-lock-pipenv.log

docker run -e PY_VERSION=$py_version $docker_image -c "/test/bootstrap-poetry.sh 1>&2 && cat poetry.lock" > $project_lock_dir/poetry.lock 2> logs/create-lock-poetry.log
echo "return code: $?" >> $project_logs_dir/create-lock-poetry.log

docker run -e PY_VERSION=$py_version $docker_image -c "/test/bootstrap-pip-compile.sh 1>&2 && cat requirements.txt" > $project_lock_dir/requirements.txt 2> logs/create-lock-pip.log
echo "return code: $?" >> $project_logs_dir/create-lock-pip.log

for snek in conda conda-lock conda+pip mamba mamba-lock mamba+pip pip-compile pip-lock pip+pyenv pip+venv pipenv pipenv-lock pipenv-skip-lock poetry poetry-lock
do
    echo $snek
    docker run -e PY_VERSION=$py_version $docker_image -c "/test/bootstrap-${snek}.sh" &> $project_logs_dir/${snek}.log
    status_code=$?
    echo "return code: $status_code" >> $project_logs_dir/${snek}.log
    if [[ $status_code -eq 0 ]]; then
        for i in `seq 1 1`;
        do
            docker run -e PY_VERSION=$py_version $docker_image -c "/usr/bin/time --format "%e" --output=/test/time.out \
                                        /test/bootstrap-${snek}.sh &> /dev/null && \
                                        echo -n "${snek}," && cat /test/time.out" >> $project_logs_dir/results.txt
        done
    fi
done   
