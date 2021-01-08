#!/bin/bash
docker build vote -t voting-app
docker build worker -t worker-app
docker build result -t result-app
