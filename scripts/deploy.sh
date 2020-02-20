#!/bin/bash -xe

run() {
    docker run -v "$(pwd):/transfer" -it serverless-superset bash -c "cp /var/lib/superset/dist/* /transfer"
    docker run -v "$(pwd):/transfer" -it serverless-superset bash -c "cp /var/lib/superset/requirements.txt /transfer"
    tar -zxf *.tar.gz
    cd apache*
    cp ../requirements.txt .
    cat ../../config/requirements-db.txt >> requirements.txt
    cp ../../config/app.yaml .
    cp ../../config/superset_config.py .
    gcloud app deploy -q
}

rm -rf .staging && mkdir .staging
(cd .staging && run)