# clearml-local-setup
Source :- https://github.com/allegroai/clearml


# ClearML on Docker Desktop / Rancher Desktop Setup

This guide walks you through setting up ClearML on Kubernetes using Docker Desktop or Rancher Desktop with Helm.

## Prerequisites

- **Docker Desktop** or **Rancher Desktop** with Kubernetes enabled.
- **Helm** and **kubectl** installed.

### Install Helm & kubectl

#### Helm (Stable Version)

```bash
brew install helm          # macOS
choco install kubernetes-helm   # Windows
curl https://get.helm.sh/helm-v3.11.1-linux-amd64.tar.gz | tar -zxvf -  # Linux

kubectl (Stable Version)

brew install kubectl       # macOS
choco install kubernetes-cli  # Windows
curl -LO "https://dl.k8s.io/release/v1.27.0/bin/linux/amd64/kubectl"  # Linux

Steps

1. Add ClearML Helm Repo

helm repo add allegroai https://allegroai.github.io/clearml-helm-charts
helm repo update

2. Install ClearML

kubectl create namespace clearml  # Create the namespace if it doesn't exist
helm install my-clearml allegroai/clearml --version 7.11.5 --namespace clearml

3. Access ClearML UI

Forward the port to access ClearML locally:

kubectl port-forward svc/my-clearml-clearml-web 8080:8080

Then open http://localhost:8080.

4. Optional: Expose ClearML with LoadBalancer (Rancher Desktop)

Create a LoadBalancer service:

apiVersion: v1
kind: Service
metadata:
  name: clearml-web
spec:
  selector:
    app: my-clearml-clearml-web
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
  type: LoadBalancer

Apply with:

kubectl apply -f clearml-service.yaml

Additional Resources

	•	ClearML Docs
	•	Helm Docs
	•	Kubernetes Docs
