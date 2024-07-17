#!/bin/bash

#Defining environmental variable
export IMAGE_NAME=$1

echo "Deploying image $IMAGE_NAME..."

#Deploying the service
kubectl apply -f service.yaml

#Deploying the image
envsubst < deployment.yaml | kubectl apply -f -