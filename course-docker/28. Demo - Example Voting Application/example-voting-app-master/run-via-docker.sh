#!/bin/bash
docker run -d --name=redis redis
docker run -d --name=db -e POSTGRES_PASSWORD=postgres postgres
docker run -d -p 5000:80 --link redis:redis voting-app
docker run -d -p 5001:80 --link db:db result-app
docker run -d --link redis:redis --link db:db worker-app
