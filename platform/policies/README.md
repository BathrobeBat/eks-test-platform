# Admission Policies

This platform uses Kubernetes admission policies to enforce
a clear separation of responsibilities between application teams
and the platform.

Policies are enforced at cluster level and cannot be bypassed
by application manifests.

---

## Why admission policies exist

Admission policies are used to:

- Prevent accidental misconfiguration
- Enforce platform-wide standards
- Protect shared infrastructure
- Ensure predictable and secure deployments

They act as **guardrails**, not as application logic.

---

## Blocked configurations in application namespaces

The following configurations are **not allowed** in application namespaces (`apps`):

### ❌ cert-manager annotations

Application manifests must NOT include:

- `cert-manager.io/*`
- `acme.cert-manager.io/*`

All certificates and TLS configuration are managed centrally by the platform.

### ❌ TLS configuration in Ingress

Application Ingress resources must NOT define:

```yaml
spec:
  tls:
```
TLS termination is handled by the shared AWS ALB and AWS Certificate Manager (ACM).

## What happens if a policy is violated

If an application manifest violates a policy:

- The deployment will be rejected at admission time

- The error message will explain which rule was violated

- No resources will be created or modified

Example error:
```
admission webhook denied the request:
cert-manager annotations are not allowed.
TLS is managed by the platform.
```

## Can these policies be changed?

Yes — but only by platform maintainers.

If a change is required:

- Document the reason
- Validate the change in a test environment
- Update both policy and documentation together