#!/bin/bash -xe

gcloud beta sql instances create ${SQL_INSTANCE_NAME} --database-version=POSTGRES_11 \
        --tier=db-g1-small \
        --region ${REGION} \
        --network ${VPC_NETWORK} \
        --no-assign-ip
    
gcloud sql databases create ${SQL_DATABASE} -i ${SQL_INSTANCE_NAME}

gcloud sql users create ${SQL_USER} --password ${SQL_PASSWORD} -i  ${SQL_INSTANCE_NAME}

SQL_IP_ADDRESS=$(gcloud sql instances describe superset-config | grep "\- ipAddress" | cut -d: -f2 | cut -c2-)
export SQL_IP_ADDRESS