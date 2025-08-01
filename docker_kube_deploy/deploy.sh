#!/bin/bash

# === Config ===
IMAGE_NAME="larryman77/simple-web"
TAG="latest"
DEPLOYMENT_NAME="simple-web"
NAMESPACE="default"

# === Build Docker Image ===

echo "Building Docker Image..."
docker build -t $IMAGE_NAME:$TAG .

if [ $? -ne 0 ]; then
	echo "Docker Build Failed"
	exit 1
fi

# === Push Docker Image ===

echo "Pushing image to Docker Hub..."
docker push $IMAGE_NAME:$TAG

if [ $? -ne 0 ]; then
	echo "Docker push failed, are you logged in to Docker?"
	exit 1
fi

# === Restart Kubernetes Deployment

echo "Restarting Kubernetes Deployment."
kubectl rollout restart deployment $DEPLOYMENT_NAME

if [ $? -ne 0 ]; then
	echo "Kubernetes Restart Failed."
	exit 1
fi

echo -e "Deployment updated successfully.\n"


