#!/bin/bash
helm repo add metallb https://metallb.github.io/metallb
helm upgrade --install \
  metallb \
  metallb/metallb \
  --version 0.14.9 \
  --namespace metallb-system
