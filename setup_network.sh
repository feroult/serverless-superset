#!/bin/bash -xe

gcloud services enable servicenetworking.googleapis.com --project=${PROJECT_ID}

gcloud services enable vpcaccess.googleapis.com

gcloud compute networks create ${VPC_NETWORK} \
    --subnet-mode=auto \
    --bgp-routing-mode=regional

gcloud compute addresses create google-managed-services-${VPC_NETWORK} \
    --global \
    --purpose=VPC_PEERING \
    --prefix-length=16 \
    --network=${VPC_NETWORK}

gcloud services vpc-peerings connect \
    --service=servicenetworking.googleapis.com \
    --ranges=google-managed-services-${VPC_NETWORK} \
    --network=${VPC_NETWORK} \
    --project=${PROJECT_ID}

gcloud compute networks vpc-access connectors create ${VPC_NETWORK}-connector \
   --network ${VPC_NETWORK} \
   --region ${REGION} \
   --range=10.8.0.0/28
