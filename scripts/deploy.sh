#!/bin/bash -xe

run() {
    docker run -v "$(pwd):/transfer" -it gcr.io/${PROJECT_ID}/serverless-superset bash -c "cp /var/lib/superset/superset.tar.gz /transfer"
    tar -zxf *.tar.gz
    cd dist
    tar -zxvf apache*.tar.gz
    cd apache*
    cp ../../requirements.txt .
    cat ../../requirements-db.txt >> requirements.txt
    cp ../../../config/app.yaml .
    cp ../../../config/superset_config.py .
    # gcloud app deploy -q
}

rm -rf .staging && mkdir .staging
(cd .staging && run)