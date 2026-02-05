## Architecture Overview

The diagram below illustrates the logical request flow and responsibility
boundaries within the test environment.

It highlights:
- The separation between platform-managed (FROZEN) components and application workloads
- How traffic flows from the public internet to application pods
- Where security controls such as NetworkPolicies and admission policies are enforced

```
Client (Browser / CI / Load Test)
        |
        v
Route 53 (test.nightingaleheart.com)
        |
        v
AWS Application Load Balancer (ALB)
(shared, internet-facing)
        |
        v
-------------------------------------------------
|               Amazon EKS Cluster              |
|                                               |
|  Platform-managed components (FROZEN):        |
|  -------------------------------------------- |
|  - AWS Load Balancer Controller               |
|  - cert-manager (DNS-01 via Route 53)         |
|  - external-dns                               |
|  - Admission policies                         |
|  - NetworkPolicies (default-deny)             |
|                                               |
|  apps namespace                               |
|  -------------------------------------------- |
|  Frontend Deployment                          |
|    - exposed via ALB ingress                  |
|                                               |
|        | (allowed by NetworkPolicy)           |
|        v                                      |
|  Backend Deployment (HPA enabled)             |
|                                               |
-------------------------------------------------
```