#!/bin/bash -xe

gcloud builds submit --machine-type=n1-highcpu-8 \
  --timeout 1h \
  --tag gcr.io/${PROJECT_ID}/serverless-superset