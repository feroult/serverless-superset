#!/bin/bash -xe

eval "echo \"$(<app-template.yaml)\"" > app.yaml

