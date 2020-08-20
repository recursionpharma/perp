#! /usr/bin/env bash
set -e
set -x

if [[ $# < 1 ]];
then
    echo "$0 project"
    exit -1
fi

project=$1
project_dir=projects/$project
project_logs_dir=$project_dir/logs
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
for snek in conda conda+pip mamba mamba+pip pip+pyenv pip+venv pipenv pipenv-lock pipenv-skip-lock poetry poetry-lock
do
    echo $snek
    docker run $docker_image -c "/test/bootstrap-${snek}.sh" &> $project_logs_dir/${snek}.log
    echo "return code: $?" >> $project_logs_dir/${snek}.log
    for i in `seq 1 10`;
    do
        docker run $docker_image -c "/usr/bin/time --format "%e" --output=/test/time.out \
                                    /test/bootstrap-${snek}.sh &> /dev/null && \
                                    echo -n "${snek}," && cat /test/time.out" >> $project_logs_dir/results.txt
    done
done   
