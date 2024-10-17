echo "To avoid any accident, this scripe doesn't delete namesapces"

#!/bin/bash


echo "Switching to ltx namespace..."
kubectl config set-context --current --namespace=ltx

echo "Uninstalling foxapp-exporter..."
helm uninstall foxapp-exporter
if [ $? -ne 0 ]; then
    echo "Failed to uninstall foxapp-exporter"
fi

echo "Uninstalling prometheus..."
helm uninstall prometheus
if [ $? -ne 0 ]; then
    echo "Failed to uninstall prometheus"
fi

echo "Uninstalling foxapp..."
helm uninstall foxapp --namespace ltx
if [ $? -ne 0 ]; then
    echo "Failed to uninstall foxapp"
fi

echo "Uninstalling KEDA..."
helm uninstall keda --namespace keda
if [ $? -ne 0 ]; then
    echo "Failed to uninstall KEDA"
fi

echo "All resources have been deleted successfully!"

kubectl get pods -n keda; kubectl get pods -n ltx

echo "No pods should be live, all in terminating state"

