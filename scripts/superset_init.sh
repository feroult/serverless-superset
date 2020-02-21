#!/bin/bash -xe

ADMIN_INSTANCE_NAME="superset-admin"

create_admin_instance() {
    gcloud compute instances create-with-container ${ADMIN_INSTANCE_NAME} \
        --container-image gcr.io/${PROJECT_ID}/serverless-superset \
        --zone ${ZONE} \
        --machine-type n1-standard-1 \
        --network=${VPC_NETWORK} 
}

run_superset_command() {
    gcloud compute ssh --zone ${ZONE} superset@${ADMIN_INSTANCE_NAME} \
        -- docker run \
        -e "FLASK_APP=superset" \
        -e "POSTGRES_USER=${SQL_USER}" \
        -e "POSTGRES_PASSWORD=${SQL_PASSWORD}" \
        -e "POSTGRES_DB=${SQL_DATABASE}" \
        -e "POSTGRES_HOST=${SQL_HOST}" \
        -e "POSTGRES_PORT=5432" \
        --mount type=bind,source=/home/superset/superset_config.py,target=/etc/superset/superset_config.py \
        -it gcr.io/${PROJECT_ID}/serverless-superset \
        $@
}

if ! gcloud compute instances list | grep ${ADMIN_INSTANCE_NAME}; then
    create_admin_instance
fi

gcloud compute scp config/superset_config.py superset@${ADMIN_INSTANCE_NAME}:

run_superset_command flask fab create-admin
run_superset_command superset db upgrade
run_superset_command superset init
run_superset_command superset load_examples

gcloud compute instances delete ${ADMIN_INSTANCE_NAME} -q
