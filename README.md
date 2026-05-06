## Repository Visibility

This repository is a public, sanitized version of a platform implementation
used for academic and portfolio purposes.

A separate private repository is maintained within the organization to manage
the actual test environment and ongoing platform ownership.


## Overview

This project implements a reproducible test environment in AWS using Amazon EKS.
The platform allows developers to deploy and test applications on a separate
test domain before exposing them on the production domain.

The solution includes:
- Kubernetes (EKS)
- Automated DNS management via Route53
- HTTPS using Let’s Encrypt with cert-manager
- Secure AWS access using IAM Roles for Service Accounts (IRSA)

🚫 cert-manager annotations and TLS configuration are blocked by policy.

All TLS, certificates, and DNS are managed by the platform.
Ingress resources containing cert-manager configuration will be rejected by admission policy.

The platform follows cloud and Kubernetes best practices and is suitable
both for real-world usage and as a foundation for an academic thesis.

## Purpose of this Repository

This repository defines a **reproducible Kubernetes application platform on AWS (EKS)**. It is designed to:

- Provide a **clear contract** between platform engineering and application teams
- Enable **self-service application deployments** via CI/CD
- Separate **stable (frozen) platform infrastructure** from **application-owned configuration**

The repository is intentionally structured so that a future DevOps engineer can take over with minimal context.

## Scope & Intentional Limitations

This repository intentionally focuses on a **test environment** architecture.

The following areas are **explicitly out of scope** and intentionally not implemented:

- Production environments
- Secrets management (e.g. AWS Secrets Manager, Vault)
- Multi-cluster or multi-region setups
- Blue/green or canary deployments
- GitOps controllers (e.g. Argo CD, Flux)
- Centralized logging or monitoring stacks

These omissions are deliberate in order to:
- Keep the architecture understandable and auditable
- Focus on platform fundamentals rather than operational scale
- Serve as a reproducible reference for learning and testing

## Operational Lifecycle

This repository defines a **controlled application lifecycle** for the shared
EKS test environment.

Applications are expected to follow the lifecycle below.

---

### 1. Develop & Containerize

Application teams:

- Develop frontend and/or backend services
- Build container images locally or via CI
- Push images to Amazon ECR

The repository provides:
- Example `Dockerfile` templates
- Reference Kubernetes manifests under `apps/_template`

---

### 2. Deploy to Test Environment

Deployment to the test cluster is performed via a **manual GitHub Actions workflow**.

- Applications are deployed under the `apps/` namespace
- Traffic is routed through a **shared Application Load Balancer**
- DNS and TLS are managed centrally by the platform

This stage allows teams to:
- Validate functionality
- Perform load testing
- Verify integration between frontend and backend services

---

### 3. Test & Validate

While running in the test environment, teams may:

- Access the application via the test domain
- Perform functional and load testing
- Observe scaling behavior (HPA)
- Validate network and security policies

The test cluster is intentionally **isolated from production**.

---

### 4. Cleanup Test Resources

Once testing is complete, applications **must be removed** from the test cluster.

Cleanup is performed via a dedicated GitHub Actions workflow:

- Requires explicit confirmation 
- Removes all Kubernetes resources and repository folders for the application
- Prevents unused workloads from consuming cluster resources

**No cleanup is performed automatically.**

---

### 5. Promote to Production (Out of Scope)

Promotion to a production environment is **intentionally out of scope** for this repository.

The test environment exists solely to:
- Validate deployments
- Reduce risk before production
- Provide a controlled and cost-aware testing platform

---

### Lifecycle Summary

```
Develop → Build Image → Deploy to Test → Validate → Cleanup
```

This lifecycle ensures:

- Predictable resource usage
- Clear ownership boundaries
- Safe experimentation without production impact

## Architecture at a Glance

At a high level, the platform is structured around a clear separation of responsibilities:

- **Platform layer**  
  Owns ingress, DNS, TLS, IAM, and cluster-wide policies  
  Managed by the platform / DevOps team

- **Application layer**  
  Owns application code, container images, and Kubernetes manifests  
  Managed by application teams

Applications are deployed into a shared Amazon EKS cluster and exposed via a centrally managed
Application Load Balancer (ALB) using a dedicated test domain.

All security-sensitive infrastructure components are frozen and protected by policy.

## High-Level Architecture

```
Internet
   |
Route53 (public hosted zone)
   |
AWS Application Load Balancer (ALB)
   |
EKS Ingress (AWS Load Balancer Controller)
   |
Kubernetes Services
   |
Application Pods
```

Key integrations:
- **external-dns**: automatically manages Route53 records
- **cert-manager**: manages TLS certificates
- **AWS ACM**: provides certificates used by ALB
- **IRSA**: secure AWS access for controllers

---

## Repository Structure

```
repo/
├── .github/
│   └── workflows/
│       ├── deploy-app.yml              # CI/CD pipeline (build → ECR → deploy)
|       ├── deploy-fullstack-app.yml    # CI/CD pipeline (build → ECR → deploy)
│       ├── cleanup-app.yml             # CI/CD cleanup (explicit app removal from test cluster)
|       └── README.md                   # CI/CD usage documentation
│
├── platform/                           # owned by platform team (FROZEN)
│   ├── ingress.yaml                    # shared ALB ingress
│   ├── README.md
│   │
│   ├── cert-manager/                   # TLS infrastructure (FROZEN)
│   │   ├── cluster-issuer.yaml
│   │   ├── cluster-issuer-staging.yaml
│   │   ├── cluster-issuer-dns01-prod.yaml
│   │   └── README.md
│   │
│   ├── network-policies/               # cluster-level security (FROZEN)
│   │   ├── default-deny-apps.yml
│   │   ├── default-deny-egress-apps.yml
│   │   ├── allow-frontend-to-backend.yml
│   │   ├── allow-dns-egress.yml
│   │   ├── backend-egress-internet.yml
│   │   └── README.md
│   │
│   └── policies/                       # admission policies (FROZEN)
│       ├── block-cert-manager-ingress.yml
│       └── README.md
│
├── apps/                               # owned by application teams
│   ├── _template/                      # reference template (never deployed)
│   │   ├── deployment.yml
│   │   ├── service.yml
│   │   ├── ingress.yml
│   │   ├── Dockerfile.example.dockerfile
│   │   ├── .env.example.yml
│   │   └── README.md
│   │
│   ├── hello/                          # example single-service app
│   │   ├── deployment.yml
│   │   ├── service.yml
│   │   ├── ingress.yml
│   │   ├── Dockerfile.example.dockerfile
│   │   ├── .env.example.yml
│   │   └── README.md
│   │
│   └── example-fullstack/              # frontend + backend reference app
│       ├── .env.example.md
│       ├── ingress.yml
│       ├── network-policy.yml
│       ├── README.md
│       │
│       ├── frontend/
│       │   ├── deployment.yml
│       │   ├── service.yml
│       │   └── Dockerfile.example.dockerfile
│       │
│       └── backend/
│           ├── deployment.yml
│           ├── service.yml
│           ├── hpa.yml
│           └── Dockerfile.example.dockerfile
│
├── iam/                                # AWS IAM policies (IRSA)
│   ├── aws-load-balancer-controller-policy.json
│   ├── cert-manager-dns01-policy.json
│   ├── external-dns-policy.json
│   └── README.md
│
├── docs/
│   ├── architecture.md                 # ASCII architecture diagram
│   ├── eks.md
│   ├── ingress.md
│   ├── security.md
│   └── troubleshooting.md
│
└── README.md                           # main documentation (this file)

```

---

## 🔒 Frozen Components (DO NOT MODIFY)

The following components are considered **platform-level infrastructure**. They are versioned, stable, and must not be modified by application teams.

### 1. Shared ALB Configuration

**Location:** Kubernetes Ingress resources using shared ALB annotations

This functionality:
- Uses a shared, internet-facing AWS Application Load Balancer
- Is managed by the AWS Load Balancer Controller
- Relies on standardized annotations for listeners, target type, and grouping
- Acts as the common entry point for all applications in the test environment

Why frozen:
- Changing this affects **all applications**
- Must be coordinated with DNS, certificates, and AWS networking

---

### 2. ClusterIssuers (cert-manager)

**Location:** `platform/cert-manager/`

Defines:
- Let’s Encrypt staging issuer
- Let’s Encrypt production issuer

Why frozen:
- Central trust configuration
- Incorrect changes may break certificate issuance cluster-wide

---

### 3. IAM Policies (IRSA)

**Location:** `platform/iam/`

Used by:
- AWS Load Balancer Controller
- external-dns
- cert-manager

Why frozen:
- Security-critical
- Changes require AWS review and testing

---

### 4. Network Policies

**Location:** `platform/network-policies/`

Defines:
- Default-deny ingress and egress policies
- Explicit service-to-service communication rules

Why frozen:
- Enforces cluster-wide zero-trust networking
- Prevents accidental exposure between applications
- Must remain consistent across all deployments

The `apps` namespace uses a default-deny NetworkPolicy.

All pod-to-pod traffic is denied unless explicitly allowed.
Each application must define its required communication paths.

This reduces attack surface and enforces service isolation by default.

---

## 🔓 Application-Owned Configuration

Application teams are expected to manage everything under `apps/<app-name>/`.

### Required Files Per Application

#### `deployment.yaml`
- Defines pods, containers, images, resources

#### `service.yaml`
- Exposes the application internally in the cluster

#### `ingress.yaml`
- Defines the public hostname
- Connects the app to the shared ALB
- References the TLS certificate via annotation

Example responsibilities:
- Hostname (`app.test.example.com`)
- Path routing
- Backend service mapping

Application teams **must not**:
- Create ALBs
- Manage certificates directly
- Modify Route53 records manually

---

## DNS & TLS Flow (DNS-01 Validation)

1. Application ingress is applied
2. AWS Load Balancer Controller updates ALB
3. external-dns creates/updates Route53 record
4. ACM certificate is attached to ALB listener
5. HTTPS traffic is terminated at ALB

---

## CI/CD Expectations

A typical pipeline for an application should:

1. Build container image
2. Push image to registry
3. Apply manifests from `apps/<app-name>/`

The platform layer is deployed separately and infrequently.

CI/CD pipelines are intentionally limited to application-owned resources.

Platform-level components are not modified through application pipelines.

---

## Design Principles

- **Separation of concerns**: platform vs application
- **Least privilege**: IRSA everywhere
- **Minimal YAML per app**
- **Explicit ownership** via directory structure

---

## Status

- Platform components: **FROZEN**
- Application onboarding: **ACTIVE**
- Documentation: **IN PROGRESS**

---

## Notes for Future Maintainers

This environment represents a **shared test / pre-production domain**.

Frozen components are considered stable **within the scope of this test environment**, but *may still evolve* as part of controlled platform work.

If changes are required to frozen components:

1. Document the motivation (what problem is being solved)
2. Apply changes in a dedicated feature branch
3. Validate changes in this test domain before promoting patterns to production

The intent of freezing is to prevent **uncoordinated or accidental changes**, not to block deliberate platform evolution.

---

## Developer Workflow (Frontend & Backend)

Application teams are expected to build and own their container images.

A typical workflow:

### 1. Build Docker Images

Each application (frontend or backend) should provide its own `Dockerfile`.

Example:

```bash
docker build -t <registry>/<app-name>:<tag> .
docker push <registry>/<app-name>:<tag>
```

Images should:
- be immutable (tagged via commit SHA or version)
- expose the correct container port
- not contain environment-specific configuration

---

### 2. Deploy to the Test Domain

Once an image is published:

1. Update `deployment.yaml` with the new image tag
2. Apply manifests under `apps/<app-name>/`

```bash
kubectl apply -f apps/<app-name>/
```

Frontend and backend services should:
- use **separate Deployments and Services**
- use **distinct hostnames** or paths as agreed (e.g. `api.test.example.com` and `app.test.example.com`)

---

### 3. Validate

After deployment:
- verify DNS resolution
- verify HTTPS access
- validate service-to-service communication if applicable

---

## Application Lifecycle and Cleanup

Applications deployed to the test environment are **temporary by design**.

The test domain is used exclusively to validate application behavior before
promotion to the production domain.

Once an application has been verified:

- All Kubernetes resources for the application **must be removed**
- No pods or services should remain running in the test cluster
- This prevents unnecessary cloud costs and resource sprawl

### Cleanup process

Applications are removed using a dedicated CI/CD cleanup workflow.

This workflow:
- Deletes all application-owned Kubernetes manifests
- Removes Kubernetes Ingress resources (ALB rules and DNS records are cleaned up automatically by controllers)
- Ensures the test cluster returns to an idle state
- Deletes the application folder in this repository (ensure any required changes are merged or promoted before running cleanup)

The test environment is therefore treated as **ephemeral infrastructure**,
not a long-lived staging platform.

Cleanup is mandatory before deploying a new iteration of the same application name.

---

**This workflow enables teams to independently iterate on applications while relying on a stable shared platform.**

---

## Intended Audience

This repository is intended for:

- Platform and DevOps engineers maintaining shared Kubernetes infrastructure
- Application developers deploying services into a managed test environment
- Future maintainers taking over the platform after initial development

The repository prioritizes clarity, documentation, and explicit boundaries over feature completeness.
