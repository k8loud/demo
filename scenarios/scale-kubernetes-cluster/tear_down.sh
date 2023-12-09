#!/bin/bash

echo "Cleaning up"
kubectl config set-context --current --namespace=loadtest
kubectl scale deploy/loadtest-cpu --replicas=0
kubectl scale deploy/loadtest-mem --replicas=0
