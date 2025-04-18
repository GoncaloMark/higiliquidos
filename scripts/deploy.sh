#!/bin/bash
set -e

kustomize build ../kube/overlays/prod | kubectl apply -n higiliquidos -f -