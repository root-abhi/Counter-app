#!/bin/bash

# Function to check if the LoadBalancer IP is assigned
check_loadbalancer_ip() {
    local service_name="$1"
    local namespace="$2"
    local interval=5  # Check every 5 seconds

    echo "Waiting for the LoadBalancer IP for service $service_name to be assigned..."

    while true; do
        # Get the external IP of the service
        external_ip=$(kubectl get svc "$service_name" -n "$namespace" -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

        if [ -n "$external_ip" ]; then
            echo "Service $service_name is assigned IP: $external_ip"
            return 0
        fi

        # Wait for a bit before checking again
        sleep "$interval"
    done
}

# Your existing deployment commands
echo "Adding KEDA Helm repo and installing KEDA..."
helm repo add kedacore https://kedacore.github.io/charts
helm repo update
helm install keda kedacore/keda --namespace keda --create-namespace
if [ $? -ne 0 ]; then
    echo "Failed to install KEDA"
    exit 1
fi

echo "Deploying foxapp..."
helm install foxapp ./foxapp --namespace ltx --create-namespace
if [ $? -ne 0 ]; then
    echo "Failed to deploy foxapp"
    exit 1
fi

echo "Switching to ltx namespace and deploying charts..."
kubectl config set-context --current --namespace=ltx

echo "Deploying foxapp-exporter..."
helm install foxapp-exporter ./foxapp-exporter
if [ $? -ne 0 ]; then
    echo "Failed to deploy foxapp-exporter"
    exit 1
fi

echo "Deploying prometheus..."
helm install prometheus ./prometheus
if [ $? -ne 0 ]; then
    echo "Failed to deploy prometheus"
    exit 1
fi

echo "All deployments completed successfully!"

# Check the LoadBalancer IPs for foxapp-service and prometheus-service
check_loadbalancer_ip "foxapp-service" "ltx"
check_loadbalancer_ip "prometheus-service" "ltx"

echo "Use the assigned external IPs to access Prometheus and Foxapp."

