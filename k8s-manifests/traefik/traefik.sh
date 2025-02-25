#!/bin/bash
kubectl create ns traefik-v2

helm repo add traefik https://traefik.github.io/charts
helm repo update
helm install --namespace=traefik-v2 \
	--values traefik-values.yaml \
	traefik traefik/traefik
