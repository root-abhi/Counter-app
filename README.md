KEDA Scaling POC with Prometheus Monitoring
Description and Goals
This project is a Proof of Concept (POC) for KEDA scaling in a Kubernetes environment, featuring Prometheus monitoring, an exporter, and a counter application. The primary goal is to verify that the scaling of the Fox app operates correctly using GET requests to the counter service endpoints.

Assumptions
The charts are downloaded and executed on a local machine connected to a Kubernetes cluster.
Prerequisites
An active Kubernetes cluster.
Limitations
The only limitation is with Prometheus, which will be accessible at <Load-Balancer>:9090 since it is not managed by a proxy.
Instead of using http_foxes_count, the metric name is foxes_count_total, so please search for "foxes_count_total" in Prometheus.
Pods cannot scale down below 1 or exceed 10; these are the set limits.
Directory Structure
This repository contains the following components:

HELM Charts (ltx-charts): Helm charts for deploying the Fox app counter application, Prometheus, and log exporter.
Other Files (additional_files): This directory contains Dockerfiles and other scripts, with each application organized in its respective folder.
How to Deploy and Test
There are two scripts to deploy and destroy the entire setup:

one-click-deployment.sh
one-click-delete.sh
Deployment Instructions:

Run the following command to deploy all charts:

bash
Copy code
sh one-click-deployment.sh
This will deploy all the charts and print the external IPs for Prometheus and the Fox app.

Use curl to test the scaling:

bash
Copy code
curl <External-IP>/plusone
The first request will not add a pod, but as soon as the count increases to 2, the pods will start to scale.

After testing is complete, run the following command to delete all resources (excluding namespaces for safety):

bash
Copy code
sh one-click-delete.sh
To Build Docker File
To build the Docker image for both architectures, use the following commands:

bash
Copy code
docker buildx create --use     
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker buildx build --no-cache --platform linux/amd64,linux/arm64 -t rootasch/foxapp:0.1.1 --push .
Note
When configuring Prometheus with the Fox app directly, the configuration of the scaledObject must be changed as follows:

For target http://foxapp-service.ltx.svc/metrics, use http_foxes_count_total.
For target http://foxapp-exporter.ltx.svc.cluster.local:8001, use http_foxes_count.
This distinction is due to the different metric names in the exporter.

Questions
For any inquiries, please feel free to reach out via email at abhi107070@gmail.com.
