## Network isolation

The `apps` namespace uses a default-deny NetworkPolicy.

All pod-to-pod traffic is denied unless explicitly allowed.
Each application must define its required communication paths.

This reduces attack surface and enforces service isolation by default.

## Redacted Values in Public Repository

This repository is published publicly for academic and portfolio purposes.

Certain AWS-specific identifiers have been intentionally redacted, including:
- Route53 Hosted Zone IDs
- ACM Certificate ARNs
- AWS Account IDs

These values are environment-specific and replaced with placeholders to avoid
leaking production or personal AWS account details.

The structure, intent, and integration points remain fully representative
of a real-world deployment.
