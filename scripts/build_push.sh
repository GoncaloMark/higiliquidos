#!/bin/bash
set -e

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"

PROD_REG=registry.deti/higiliquidos

for dockerfile in "$BASE_DIR/dockerfiles"/Dockerfile.*; do
    from_tag=$(grep '^FROM' "$dockerfile" | head -n1 | awk '{print $2}' | sed 's|.*/||')
    full_tag="${PROD_REG}/$from_tag"
    echo "Building $dockerfile as $full_tag..."
    docker build -f "$dockerfile" -t "$full_tag" "$BASE_DIR"
    echo "Pushing $full_tag..."
    docker push "$full_tag"
done

cd "$BASE_DIR/repos/saleor"
docker build -t "${PROD_REG}/saleor:3.20.80" .
docker push "${PROD_REG}/saleor:3.20.80"

cd "$BASE_DIR/repos/saleor-dashboard"
docker build -t "${PROD_REG}/saleor-dashboard:3.20.34" .
docker push "${PROD_REG}/saleor-dashboard:3.20.34"

cd "$BASE_DIR/repos/dummy-payment-app"
docker build -f Dockerfile.dev -t "${PROD_REG}/dummy-payment-app:0.1.0" .
docker push "${PROD_REG}/dummy-payment-app:0.1.0"

cd "$BASE_DIR"
docker build -t "${PROD_REG}/register-payments:0.1.0" .
docker push "${PROD_REG}/register-payments:0.1.0"

