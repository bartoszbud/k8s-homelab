#!/bin/bash

# Post-deployment script for Kubernetes Homelab setup
echo -e "Post deploy procedure start...\n"

echo -e "Set KUBECONFIG $(cp -v kubespray/inventory/homelab-cluster/artifacts/admin.conf ~/.kube/config)"

echo -e "Disabling cloud-init... $(for i in m1 m2 m3 w1 w2 w3; do ssh admin@kube-$i "sudo touch /etc/cloud/cloud-init.disabled"; done)\n"

echo -e "Applying MetalLB $(kubectl apply -f ./load-balancer/metal-lb.yml)\n"
echo -e "Applying NGINX Ingress $(kubectl apply -f ./ingress/ingress.yml)\n"
echo -e "Applying ArgoCD ingress $(kubectl apply -f ./ingress/argocd-ingress.yml)\n"
echo -e "Applying NFS CSI $(kubectl apply -f ./csi/nfs-csi.yml)\n"

echo -e "Applying Observability stack...\n"
echo -e "Applying Prometheus $(kubectl apply -f ./observability/prometheus.yml)\n"
echo -e "Applying Loki $(kubectl apply -f ./observability/loki.yml)\n"
echo -e "Applying Grafana $(kubectl apply -f ./observability/grafana.yml)\n"
echo -e "Applying Promtail $(kubectl apply -f ./observability/promtail.yml)\n"

echo -e "Applying DevOps stack...\n"
echo -e "Applying Gitea $(kubectl apply -f ./devops/gitea/gitea.yml)\n"
echo -e "Applying Nexus $(kubectl apply -f ./devops/nexus/nexus.yml)\n"
echo -e "Applying Jenkins $(kubectl apply -f ./devops/jenkins/jenkins.yml)\n"

echo -e "Creating secrets\n"
kubectl create secret tls keycloak-tls --cert=lab.pl.crt --key=lab.pl.crt.key -n iam
kubectl create secret tls argocd-tls --cert=lab.pl.crt --key=lab.pl.crt.key -n argocd