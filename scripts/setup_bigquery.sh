#!/bin/bash -xe

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member "serviceAccount:${PROJECT_ID}@appspot.gserviceaccount.com" \
  --role "roles/bigquery.dataViewer"

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member "serviceAccount:${PROJECT_ID}@appspot.gserviceaccount.com" \
  --role "roles/bigquery.jobUser"
