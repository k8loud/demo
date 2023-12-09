# Scale Kubernetes cluster
## Requirements
### Metrics
```
cluster-memory-usage = sum(container_memory_working_set_bytes{id="/",kubernetes_io_hostname=~"kube-worker-.*"}) / sum(machine_memory_bytes{kubernetes_io_hostname=~"kube-worker-.*"}) * 100
cluster-cpu-usage = sum(rate(container_cpu_usage_seconds_total{id="/",kubernetes_io_hostname=~"kube-worker-.*"}[1m])) / sum(machine_cpu_cores{kubernetes_io_hostname=~"kube-worker-.*"}) * 100
cluster-filesystem-usage = sum(container_fs_usage_bytes{device=~"^/dev/[sv]d[a-z][1-9]$",id="/",kubernetes_io_hostname=~"kube-worker-.*"}) / sum(container_fs_limit_bytes{device=~"^/dev/[sv]d[a-z][1-9]$",id="/",kubernetes_io_hostname=~"kube-worker-.*"}) * 100
```
