#!/bin/bash
cd "$(dirname "$0")"

CPU_REPLICAS=(
  18
  12
  24
  16
  0    # reset
  0
  0
  0
  0
  0    # reset
  18
  10
  24
)
MEM_REPLICAS=(
  0
  0
  0
  0
  0    # reset
  35
  45
  15
  35
  0    # reset
  35
  45
  15
)
STAGE_DURATIONS_S=(
  360
  240
  420
  180
  600  # reset
  360
  240
  420
  180
  600  # reset
  360
  360
  360
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
