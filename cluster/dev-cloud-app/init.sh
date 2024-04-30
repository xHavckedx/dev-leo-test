#!/bin/bash

##Install flux2 in the cluster

flux bootstrap github \
  --owner=xhavckedx \
  --repository=dev-leo-test \
  --branch=main \
  --path=./cluster/dev-cloud-app/inf \
