# example-fullstack – Reference Application

This example demonstrates how to deploy a simple
frontend + backend application using the platform.

## Architecture

- One shared Ingress
- Two services:
  - frontend (/)
  - backend (/api)
- Central TLS and DNS managed by the platform

## Responsibilities

Application:
- Deployments
- Services
- Routing paths

Platform:
- TLS certificates
- DNS records
- Load balancer configuration

## Deployment

This application is deployed exclusively via GitHub Actions.
Manual kubectl apply is not part of the workflow.

## Failure handling

If the backend crashes:
- Kubernetes automatically restarts the pod
- Traffic is temporarily removed via readiness probes
- Frontend remains available

This provides basic self-healing behavior without manual intervention.

## Network isolation

The backend service is protected by a NetworkPolicy:

- Only frontend pods may connect to the backend
- Other traffic inside the cluster is denied by default

This limits blast radius and enforces service boundaries.

## Autoscaling

The backend service uses a Horizontal Pod Autoscaler (HPA):

- Scales based on CPU utilization
- Minimum 1 replica, maximum 5 replicas
- Requires CPU requests to be defined

This allows the backend to handle traffic spikes automatically.

