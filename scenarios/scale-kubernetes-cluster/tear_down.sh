#!/bin/bash

echo "Cleaning up"
kubectl scale deploy/loadtest-cpu --replicas=0
kubectl scale deploy/loadtest-mem --replicas=0
