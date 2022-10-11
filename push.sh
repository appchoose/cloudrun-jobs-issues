#!/bin/bash

######## EDIT YOUR CONFIG HERE ###########

SERVICE_ACCOUNT=service-account@your-project.iam.gserviceaccount.com
REGISTRY=europe-west1-docker.pkg.dev/your-project/your-registry

##########################################

RANDOM_NUMBER=$RANDOM
NAME="execution-$RANDOM_NUMBER"

echo $NAME > version

PREVIOUS_IMAGE_BUILD=$(docker images --format="{{.Tag}} {{.ID}}" | grep local-$NAME | cut -d' ' -f2)
docker image rm -f "$PREVIOUS_IMAGE_BUILD"
PREVIOUS_IMAGE_BUILD=$(docker images --format="{{.Tag}} {{.ID}}" | grep latest | cut -d' ' -f2)
docker image rm -f "$PREVIOUS_IMAGE_BUILD"
docker system prune -f

DOCKER_BUILDKIT=1 docker buildx build --no-cache --platform linux/amd64 -t local-node-for-gcr-$NAME .
docker tag local-node-for-gcr-$NAME $REGISTRY/local-node:local-$NAME
docker push $REGISTRY/local-node:local-$NAME

#gcloud container images delete --quiet $REGISTRY/local-node-$NAME:16.17-alpine-$NAME
#gcloud beta run jobs delete --quiet remove-me-node-1-$NAME

sleep 2

gcloud beta run jobs create remove-me-node-1-$NAME \
    --image $REGISTRY/local-node:local-$NAME \
    --command npx --args=happy-birthday,-u,chris \
    --service-account $SERVICE_ACCOUNT \
    --tasks 1 --max-retries 1 --parallelism 1 \
    --region europe-west1 --memory 1024Mi \
    --execute-now --wait
