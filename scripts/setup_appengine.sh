#!/bin/bash -xe

(cd config && eval "echo \"$(<app-template.yaml)\"" > app.yaml)

gcloud app create --region ${SHORT_REGION} -q || echo "App already created."