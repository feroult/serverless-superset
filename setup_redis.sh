#!/bin/bash -xe

gcloud redis instances create ${REDIS_INSTANCE_NAME} --size=1 --region=${REGION} \
    --zone=${ZONE} --redis-version=redis_4_0 --network superset-network

gcloud redis instances describe superset --region=${REGION}

gcloud compute networks vpc-access connectors create superset-redis-connector \
   --network superset-network \
   --region ${REGION} \
   --range=10.8.0.0/28
   
REDIS_IP_ADDRESS=$(gcloud redis instances describe ${REDIS_INSTANCE_NAME} --region=${REGION} | grep host | cut -d: -f2 | cut -c2-)
export REDIS_IP_ADDRESS
