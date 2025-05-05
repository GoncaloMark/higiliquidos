#!/bin/bash
set -e

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"

kustomize build "$BASE_DIR/kube/overlays/prod" | kubectl apply -n higiliquidos -f -