#!/bin/bash

helm repo add argo https://argoproj.github.io/argo-helm
kubectl create namespace argocd
helm install my-argocd argo/argo-cd --namespace argocd -f argo-values.yaml
