#!/bin/bash -xe

(cd config && eval "echo \"$(<app-template.yaml)\"" > app.yaml)

