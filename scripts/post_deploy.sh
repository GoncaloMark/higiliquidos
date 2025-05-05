#!/bin/bash
set -e

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"

PROD_REG=registry.deti/higiliquidos

cd "$BASE_DIR/repos/storefront"

docker build \
  --build-arg NEXT_PUBLIC_SALEOR_API_URL=http://saleor-api.higiliquidos.svc.cluster.local/graphql/ \
  --build-arg NEXT_PUBLIC_STOREFRONT_URL=http://store.higiliquidos.deti.com/ \
  -t "${PROD_REG}/saleor-storefront:0.1.0" \
  --network=host \
  --add-host saleor-api.higiliquidos.svc.cluster.local:193.136.82.35 \
  .

docker push "${PROD_REG}/saleor-storefront:0.1.0"

kubectl delete deployment storefront -n higiliquidos

kustomize build "$BASE_DIR/kube/overlays/prod" | kubectl apply -n higiliquidos -f -
