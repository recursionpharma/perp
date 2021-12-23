#! /bin/bash

DATE="2021-12-16"
for PY_VERSION in "3.7" "3.8" "3.9"
do
    for PROJECT in "utility" "data" "web"
    do
        python plot-results.py -p $PROJECT -v $PY_VERSION -f gs://perp-benchmarks/public/$PROJECT-$DATE/${PY_VERSION}/logs/results.txt -i images/${PROJECT}_results_${PY_VERSION//./}_${DATE}.png
    done
done