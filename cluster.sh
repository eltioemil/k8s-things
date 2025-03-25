#!/bin/bash

# Check if a parameter is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <up|down>"
    exit 1
fi

LOCAL_PATH=$(pwd)

# Install reloader
install_reloader() {
    helm repo add stakater https://stakater.github.io/stakater-charts
    helm repo update
    helm install reloader stakater/reloader -n default --set reloader.watchGlobally=false
}

# Apply taint and limit resources for agent-1
apply_node_config() {
    echo "Waiting for cluster nodes to be ready..."
    until kubectl get nodes 2>/dev/null | grep -q "Ready"; do
        sleep 2
    done

    # Taint agent-0
    echo "Applying taint to node k3d-mycluster-agent-0..."
    kubectl taint nodes k3d-mycluster-agent-0 my-awesome-taint=true:NoSchedule --overwrite

    # Label agent-2
    echo "Applying label to node k3d-mycluster-agent-2..."
    kubectl label node k3d-mycluster-agent-2 my-awesome-label=true
}

# Create test ns
create_test_ns() {
    kubectl create namespace test
}

# Cluster create
cluster_create() {
    k3d cluster create mycluster \
        --agents 3 \
        --volume $LOCAL_PATH/data:/mnt/data:rw \
        --servers-memory 1000Mb \
        --agents-memory 1000Mb
}

# Define the action based on the parameter
ACTION=$1

case $ACTION in
up)
    echo "Creating k3d cluster..."
    cluster_create
    if [ $? -eq 0 ]; then
        echo "k3d cluster created successfully."
        apply_node_config
        install_reloader
        create_test_ns
    else
        echo "Failed to create k3d cluster."
        exit 1
    fi
    ;;

down)
    echo "Destroying k3d cluster..."
    k3d cluster delete mycluster
    if [ $? -eq 0 ]; then
        echo "k3d cluster destroyed successfully."
    else
        echo "Failed to destroy k3d cluster."
        exit 1
    fi
    ;;

*)
    echo "Invalid parameter. Use 'up' to create or 'down' to destroy the cluster."
    exit 1
    ;;
esac
