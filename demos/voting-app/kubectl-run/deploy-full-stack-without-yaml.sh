#!/bin/bash

echo "deploying redis"
kubectl run redis --image=redis
echo "deploying db"
kubectl run db --image=postgres --env="POSTGRES_USER=postgres" --env="POSTGRES_PASSWORD=postgres"
echo "deploying vote"
kubectl run vote --image=kodekloud/examplevotingapp_vote:v1
echo "deploying result"
kubectl run result --image=kodekloud/examplevotingapp_result:v1
echo "deploying worker"
kubectl run worker --image=kodekloud/examplevotingapp_worker:v1
echo "creating service: redis"
kubectl expose pod redis --port 6379
echo "creating service: db"
kubectl expose pod db --port 5432
echo "creating service: vote"
kubectl apply -f vote-service.yaml
echo "creating service: result"
kubectl apply -f result-service.yaml
