#!/bin/bash

RQ_COUNT=900
KUBE_0_FLOATING_IP="149.156.10.153"

echo "Sending GET to demo-app ($KUBE_0_FLOATING_IP) $RQ_COUNT times"
for r in $(seq 1 $RQ_COUNT); do
  echo "REQ $r/$RQ_COUNT"
  timeout 1s curl -s $KUBE_0_FLOATING_IP > /dev/null
  sleep 0.5
done