#!/bin/bash
kubectl create ns traefik

helm repo add traefik https://traefik.github.io/charts
helm repo update
helm install --namespace=traefik \
	--values values.yaml \
	traefik traefik/traefik
