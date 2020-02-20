#!/bin/bash -xe

gcloud redis instances create ${REDIS_INSTANCE_NAME} --size=1 --region=${REGION} \
    --zone=${ZONE} --redis-version=redis_4_0 --network superset-network

REDIS_HOST=$(gcloud redis instances describe ${REDIS_INSTANCE_NAME} --region=${REGION} | grep host | cut -d: -f2 | cut -c2-)
export REDIS_HOST
