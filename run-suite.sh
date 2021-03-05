#! /usr/bin/env bash
# set -e
set -x

if [[ $# < 2 ]];
then
    echo "Usage: $0 benchmark-dir project python-version"
    exit -1
fi

BASEDIR=$(dirname "$0")

submodule=$1
project=$2
py_version=$3

project_dir=$submodule/$project
project_logs_dir=$project_dir/logs
project_lock_dir=$project_dir/lockfiles
docker_image=profile-$project
docker_image_lock=profile-$project-lock

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

if [[ ! -d $project_lock_dir ]];
then
    mkdir $project_lock_dir
fi


docker build $BASEDIR \
    --build-arg CONDA_CHANNEL=$CONDA_CHANNEL \
    --build-arg CONDA_TOKEN=$CONDA_TOKEN \
    --build-arg PYPI_URL=$PYPI_URL \
    --build-arg PYPI_USERNAME=$PYPI_USERNAME \
    --build-arg PYPI_PASSWORD=$PYPI_PASSWORD \
    --build-arg PROJECT_DIR=$project_dir \
    --build-arg PYTHON_VERSION=$py_version \
    --target base \
    --tag $docker_image \
    &> logs/docker.log
status_code=$?
if [[ $status_code -ne 0 ]]; then
    cat logs/docker.log
    exit $status_code
fi

# Create the lockfiles for the requisite projects and log the output for debugging
docker run --rm -e PY_VERSION=$py_version $docker_image \
    -c "/test/bootstrap-conda.sh 1>&2 && ~/miniconda/bin/conda env export -n test " \
    > $project_lock_dir/environment-lock.yml \
    2> $project_logs_dir/create-lock-conda.log
status_code=$?
echo "return code: $status_code" >> $project_logs_dir/create-lock-conda.log
if [[ $status_code -ne 0 ]]; then
    cat $project_logs_dir/create-lock-conda.log
    exit $status_code
fi

docker run --rm -e PY_VERSION=$py_version $docker_image \
    -c "/test/bootstrap-pipenv.sh 1>&2 && cat Pipfile.lock" \
    > $project_lock_dir/Pipfile.lock \
    2> $project_logs_dir/create-lock-pipenv.log
status_code=$?
echo "return code: $status_code" >> $project_logs_dir/create-lock-pipenv.log
if [[ $status_code -ne 0 ]]; then
    cat $project_logs_dir/create-lock-pipenv.log
    exit $status_code
fi

docker run --rm -e PY_VERSION=$py_version $docker_image \
    -c "/test/bootstrap-poetry.sh 1>&2 && cat poetry.lock" \
    > $project_lock_dir/poetry.lock \
    2> $project_logs_dir/create-lock-poetry.log
status_code=$?
echo "return code: $status_code" >> $project_logs_dir/create-lock-poetry.log
if [[ $status_code -ne 0 ]]; then
    cat $project_logs_dir/create-lock-poetry.log
    exit $status_code
fi

docker run --rm -e PY_VERSION=$py_version $docker_image \
    -c "/test/bootstrap-pip-compile.sh 1>&2 && cat requirements.txt" \
    > $project_lock_dir/requirements.txt \
    2> $project_logs_dir/create-lock-pip.log
status_code=$?
echo "return code: $status_code" >> $project_logs_dir/create-lock-pip.log
if [[ $status_code -ne 0 ]]; then
    cat $project_logs_dir/create-lock-pip.log
    exit $status_code
fi

docker build $BASEDIR \
    --build-arg CONDA_CHANNEL=$CONDA_CHANNEL \
    --build-arg CONDA_TOKEN=$CONDA_TOKEN \
    --build-arg PYPI_URL=$PYPI_URL \
    --build-arg PYPI_USERNAME=$PYPI_USERNAME \
    --build-arg PYPI_PASSWORD=$PYPI_PASSWORD \
    --build-arg PROJECT_DIR=$project_dir \
    --build-arg PYTHON_VERSION=$py_version \
    --target locks \
    --tag $docker_image_lock \
    &> logs/docker-lock.log
status_code=$?
if [[ $status_code -ne 0 ]]; then
    cat logs/docker-lock.log
    exit $status_code
fi

for snek in conda conda-lock conda+pip mamba mamba-lock mamba+pip pip-compile pip-lock pip+pyenv pip+venv pipenv pipenv-lock pipenv-skip-lock poetry poetry-lock
do
    echo $snek
    docker run --rm $docker_image_lock -c "/test/bootstrap-${snek}.sh" &> $project_logs_dir/${snek}.log
    status_code=$?
    echo "return code: $status_code" >> $project_logs_dir/${snek}.log
    if [[ $status_code -eq 0 ]]; then
        for i in `seq 1 10`;
        do
            docker run --rm $docker_image_lock -c "/usr/bin/time --format "%e" --output=/test/time.out \
                                        /test/bootstrap-${snek}.sh &> /dev/null && \
                                        echo -n "${snek}," && cat /test/time.out" >> $project_logs_dir/results.txt
        done
    else
        cat $project_logs_dir/${snek}.log
        exit $status_code
    fi
done   
