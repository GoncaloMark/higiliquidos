#!/bin/bash

cd ../repos/storefront

# build storefront docker image
docker build --build-arg NEXT_PUBLIC_SALEOR_API_URL=http://saleor-api.higiliquidos.svc.cluster.local/graphql/ --build-arg NEXT_PUBLIC_STOREFRONT_URL=http://store.higiliquidos.deti.com/ -t registry.deti/higiliquidos/saleor-storefront:0.1.0 --network=host --add-host saleor-api.higiliquidos.svc.cluster.local:193.136.82.35 .

docker push registry.deti/higiliquidos/saleor-storefront:0.1.0

