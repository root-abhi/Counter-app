To Build Docker file: 
docker buildx create --use     
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker buildx build --no-cache  --platform linux/amd64,linux/arm64 -t rootasch/foxapp:0.1.1 --push .


Note: 
when configuring prometheus with foxapp directly, the config of scaledObject has to be changed to "http_foxes_count_total" 
for target: http://foxapp-service.ltx.svc/metrics = http_foxes_count_total
for target http://foxapp-exporter.ltx.svc.cluster.local:8001 = http_foxes_count
(this is due to different metric name in exporter) 
