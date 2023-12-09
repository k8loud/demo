# Scale Kubernetes cluster
## Requirements
### Metrics
```
cluster-memory-usage = sum(container_memory_working_set_bytes{id="/",kubernetes_io_hostname=~"kube-worker-.*"}) / sum(machine_memory_bytes{kubernetes_io_hostname=~"kube-worker-.*"}) * 100
cluster-cpu-usage = sum(rate(container_cpu_usage_seconds_total{id="/",kubernetes_io_hostname=~"kube-worker-.*"}[1m])) / sum(machine_cpu_cores{kubernetes_io_hostname=~"kube-worker-.*"}) * 100
cluster-filesystem-usage = sum(container_fs_usage_bytes{device=~"^/dev/[sv]d[a-z][1-9]$",id="/",kubernetes_io_hostname=~"kube-worker-.*"}) / sum(container_fs_limit_bytes{device=~"^/dev/[sv]d[a-z][1-9]$",id="/",kubernetes_io_hostname=~"kube-worker-.*"}) * 100
```

### mem-hoarder
mem-hoarder is used for memory stress testing. 
It should be available on [DockerHub](https://hub.docker.com/r/k8loud/mem-hoarder) but if that's not the case run 
```
mem_hoarder\build_and_push.sh
```

## Description
Kubernetes cluster's load may differ depending on various factors.
Keeping additional resources just in case a spike occurs puts them to waste while it's not happening.
It would be beneficial if the resources pool could dynamically adjust to the current state.
This scenario presents scaling based on CPU and RAM usage of the Kubernetes worker nodes.
Triggers of the rules include filesystem usage too, but it hasn't been tested.

## Results
![screenshot_2023-12-09_01-02-18](https://github.com/k8loud/demo/assets/29145519/8763432b-a985-436d-bc94-ebe3d2272ee2)
