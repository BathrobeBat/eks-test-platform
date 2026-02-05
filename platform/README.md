# FROZEN – Legacy Kubernetes Manifests

This directory contains legacy Kubernetes manifests that were used
during initial platform bootstrapping.

These files are kept for:
- historical reference
- rollback if required
- understanding platform evolution

⚠️ Do not modify or use for new applications.

Replacement:
- Application ingress: `apps/*/ingress.yaml`
- Platform ingress: documented in root README
