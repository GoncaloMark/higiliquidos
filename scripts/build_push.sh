#!/bin/bash
set -e

PROD_REG=registry.deti/higiliquidos

for dockerfile in ../dockerfiles/Dockerfile.*; do
    from_tag=$(grep '^FROM' "$dockerfile" | head -n1 | awk '{print $2}' | sed 's|.*/||')
    full_tag="${PROD_REG}/$from_tag"
    echo "Building $dockerfile as $full_tag..."
    docker build -f "$dockerfile" -t "$full_tag" .
    echo "Pushing $full_tag..."
    docker push "$full_tag"
done

cd repos/saleor && \
docker build -t "${PROD_REG}/saleor:3.20.80" . && \
docker push "${PROD_REG}/saleor:3.20.80"

cd repos/saleor-dashboard && \
docker build -t "${PROD_REG}/saleor-dashboard:3.20.34" . && \
docker push "${PROD_REG}/saleor-dashboard:3.20.34"

cd repos/storefront && \
docker build -t "${PROD_REG}/storefront:0.1.0" . && \
docker push "${PROD_REG}/storefront:0.1.0"
