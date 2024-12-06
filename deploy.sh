#!/bin/bash

# Define variables
PROJECT_NAME="rustapp" # Replace with your project name
DOCKER_REPO="mostfullstack/rust-app"  # Replace with your Docker Hub repo, e.g., user/repo
DEPLOYMENT_FILE="rust-app-deploy.yaml" # Replace with your Kubernetes deployment YAML file path

# Extract version from Cargo.toml
VERSION=$(grep '^version =' Cargo.toml | sed -E 's/version = "(.*)"/\1/')

# # Ensure necessary tools are installed
# if ! command -v cargo &> /dev/null; then
#     echo "Cargo is not installed. Please install Rust and Cargo first."
#     exit 1
# fi

# if ! command -v docker &> /dev/null; then
#     echo "Docker is not installed. Please install Docker first."
#     exit 1
# fi

# if ! command -v yq &> /dev/null; then
#     echo "yq is not installed. Please install yq first."
#     exit 1
# fi

# if ! command -v kubectl &> /dev/null; then
#     echo "kubectl is not installed. Please install kubectl first."
#     exit 1
# fi

# Rust build and test
echo "Running Rust checks and build..."
cargo check || { echo "Cargo check failed!"; exit 1; }
cargo test || { echo "Cargo tests failed!"; exit 1; }
cargo build --release || { echo "Cargo build failed!"; exit 1; }

# Run the built executable (optional)
# ./target/release/$PROJECT_NAME || { echo "Executable failed to run!"; exit 1; }

# Docker build and push
echo "Building Docker image..."
docker build -t $DOCKER_REPO:$VERSION . || { echo "Docker build failed!"; exit 1; }

echo "Logging into Docker Hub..."
echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin || { echo "Docker login failed!"; exit 1; }

echo "Pushing Docker image..."
# docker push $DOCKER_REPO:$VERSION || { echo "Docker push failed!"; exit 1; }
# docker tag $DOCKER_REPO:$VERSION $DOCKER_REPO:latest
docker push $DOCKER_REPO:$VERSION || { echo "Docker push failed!"; exit 1; }

# Update Kubernetes deployment
echo "Updating Kubernetes deployment... $VERSION"
yq eval '.spec.template.spec.containers[0].image = "'$DOCKER_REPO:$VERSION'"' -i $DEPLOYMENT_FILE || { echo "yq update failed!"; exit 1; }

echo "Applying Kubernetes deployment..."
kubectl apply -f $DEPLOYMENT_FILE || { echo "kubectl apply failed!"; exit 1; }

echo "Deployment completed successfully!"
