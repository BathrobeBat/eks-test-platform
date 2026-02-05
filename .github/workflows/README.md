# GitHub Workflows – Test Environment (EKS)

This directory contains the GitHub Actions workflows used to deploy and clean up
applications in the shared **EKS test environment**.

All workflows are **manually triggered** and are designed to be safe, explicit,
and easy to understand for both developers and future maintainers.

---

## Deploy App to Test (EKS)

**Workflow:** `deploy-app.yml`

Deploys an application from the `apps/` directory to the shared test cluster.

### How it works

The workflow will:

- Build a Docker image
- Push the image to Amazon ECR
- Deploy the application to the EKS test cluster
- Expose the application via the shared ALB and test domain

### Required input

| Input | Description |
|------|------------|
| `app` | Name of the application folder under `apps/` |

### Example

```
app:hello
```

### Notes

- TLS, DNS, and ALB configuration are managed by the platform
- Applications **must not** include cert-manager annotations
- Manual `kubectl apply` is intentionally **not part of the workflow**

---

## Cleanup App from Test (EKS)

**Workflow:** `cleanup-app.yml`

Removes an application and all associated Kubernetes resources from the test cluster.

This workflow exists to ensure that:
- No unused pods or services remain after testing
- Test cluster costs stay low
- The environment remains clean for other teams

---

### ⚠️ Destructive Operation

This workflow **permanently deletes resources** from the test cluster.

For safety, it requires **explicit confirmation**.

---

### Required inputs

| Input | Description |
|------|------------|
| `app` | Name of the application folder under `apps/` to remove |
| `confirm` | Must be exactly `DELETE` to proceed |

### Example

```
app: hello
confirm: DELETE
```

If the confirmation value is anything other than `DELETE`, the workflow will stop
immediately and no resources will be removed.

---

### What is removed

The workflow deletes Kubernetes resources belonging to the application, including:

- Deployment
- Service
- Ingress
- Associated pods

Container images in ECR are **not** deleted automatically.

---

## Design Principles

These workflows follow a few key principles:

- **Explicit over implicit** – no automatic deploys or deletes
- **Safe by default** – destructive actions require confirmation
- **Platform-owned infrastructure** – apps only manage app-level resources
- **Clear separation of responsibility** between platform and application teams

---

## When to use cleanup

Cleanup should be triggered when:

- An application has been validated in the test domain
- The application is ready to be promoted to a production environment
- Test resources are no longer needed

---

## Summary

- Deploy → test → cleanup is the expected lifecycle
- Nothing is deleted automatically
- All actions are intentional and auditable via GitHub Actions history
