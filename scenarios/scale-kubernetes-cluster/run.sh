#!/bin/bash
cd "$(dirname "$0")"

# Assuming 4 worker nodes

CPU_REPLICAS=(
  10  # ~50%
  18  # ~80%
  0   # reset
  0   # 0%
  0   # 0%
  0   # cleanup
)
MEM_REPLICAS=(
  0   # 0%
  0   # 0%
  0   # reset
  20  # ~50%
  35  # ~80%
  0   # cleanup
)
STAGE_DURATIONS_S=(
  60  # setup CPU test
  600 # CPU test
  600 # reset
  60  # setup MEM test
  600 # MEM test
  0   # cleanup
)

kubectl apply -f loadtest.yaml -n loadtest
echo ""

stages_count="${!CPU_REPLICAS[@]}"
for i in $stages_count; do
  cpu_replicas=${CPU_REPLICAS[$i]}
  mem_replicas=${MEM_REPLICAS[$i]}
  echo "Scaling loadtest-cpu to $cpu_replicas, loadtest-mem to $mem_replicas"
  kubectl config set-context --current --namespace=loadtest
  kubectl scale deploy/loadtest-cpu --replicas=$cpu_replicas
  kubectl scale deploy/loadtest-mem --replicas=$mem_replicas

  stage_duration=${STAGE_DURATIONS_S[$i]}
  echo -e "Sleeping for $stage_duration s\n"
  sleep $stage_duration
done
