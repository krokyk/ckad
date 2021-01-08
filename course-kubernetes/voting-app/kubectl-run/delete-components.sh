#!/bin/bash

kubectl delete pod redis
kubectl delete pod db
kubectl delete pod vote
kubectl delete pod result
kubectl delete pod worker
kubectl delete service redis
kubectl delete service db
kubectl delete service vote
kubectl delete service result