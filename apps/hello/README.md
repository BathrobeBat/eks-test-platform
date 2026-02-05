# hello – Example Application

This application is a concrete implementation of the shared
application deployment template.

It is used to verify:
- CI/CD deployment via GitHub Actions
- Routing via the shared AWS ALB
- DNS via External-DNS
- TLS managed by the platform

## Access

Omitted in public repo for company privacy

## Deployment model

This application:
- Owns Deployment, Service, and app-specific Ingress
- Does NOT manage TLS, certificates, or DNS
- Is deployed exclusively via GitHub Actions

Manual `kubectl apply` is intentionally not part of the workflow.

## Notes

- cert-manager annotations are blocked by policy
- TLS is managed centrally by the platform
