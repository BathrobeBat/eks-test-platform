# Application Deployment Template

This directory provides a **reference template** for deploying applications
to the shared EKS **test environment**.

The template defines the **expected structure and responsibilities**
for application teams, while relying on a centrally managed platform
for ingress, DNS, and TLS.

> ⚠️ This directory itself must never be deployed.
> It exists only as a starting point for new applications.

---

# App template

This folder contains the reference Kubernetes manifests for applications.

## How to use

1. Copy this folder:

```
cp -r apps/_template apps/my-app
```

2. Update `.env`
3. Commit changes to the repository
4. Deploy via GitHub Actions workflow

**Manual `kubectl apply` is intentionally not part of the workflow.**

## Notes

🚫 cert-manager annotations and TLS configuration are blocked by policy.

All TLS, certificates, and DNS are managed by the platform.
Ingress manifests containing cert-manager configuration will be rejected by admission policy.

# File Overview

`deployment.yaml`

Defines the Kubernetes Deployment:

- container image
- exposed container port
- replica count

Application teams are responsible for:

- building and publishing container images
- updating image tags

---
`service.yaml`

Defines the Kubernetes Service:

- exposes the application inside the cluster
- connects the Deployment to the Ingress

---
`ingress.yaml`

Defines how the application is exposed publicly:

Responsibilities:

- hostname definition
- routing to the correct service

The ingress:

- uses the shared AWS Application Load Balancer
- relies on platform-managed TLS and DNS
- must not include certificate or ALB configuration

---
`Dockerfile`

The included Dockerfile is **only an example.**

It exist to:

- illustrate a possible structure
- lower the barrier for initial testing

Application teams must:

- create and maintain their own Dockerfile
- choose appropriate base images and build strategies
- ensure the correct container port is exposed

This Dockerfile is **not a platform standard.**

---
## Rules and Constraints

Application teams must **not**:

- add cert-manager annotations
- manage TLS certificates directly
- create or configure load balancers
- modify platform-owned resources

All ingress, DNS, and TLS functionality is handled 
by the platform layer.

---
## Frontend and Backend Applications

Frontend and backend services should be deployed as separate applications:

- separate Deployments
- separate Services
- separate Ingress resources
- distinct hostnames (e.g. `app.test.nightingaleheart.com`, `api.test.nightingaleheart.com`)

---
## Purpose of This Template

This template exists to ensure that:

- application onboarding is predictable
- CI/CD pipelines are simple
- platform behavior is consistent
- responsibilities are clearly separated

---
If anything in this template is unclear, refer to:

- the repository root `README.md`
- the `docs/` directory