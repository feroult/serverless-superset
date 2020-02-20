#!/bin/bash -xe

gcloud builds submit --machine-type=n1-highcpu-8 --tag gcr.io/${PROJECT_ID}/serverless-superset
