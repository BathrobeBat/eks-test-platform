# FROZEN – cert-manager Bootstrap

This directory contains the original cert-manager setup
used during platform bootstrap.

Certificates are now managed centrally.
Do not modify unless explicitly working on platform evolution.

# cert-manager Configuration

cert-manager is installed via Helm and is responsible for automated
TLS certificate management using Let’s Encrypt.

## IAM Integration (IRSA)

Since cert-manager was installed via Helm, the ServiceAccount already existed.
eksctl was therefore instructed to override the existing ServiceAccount
to attach the IAM role required for DNS-01 validation.

This is the recommended and correct approach, not a workaround.

## ClusterIssuers

Two ClusterIssuers are defined:
- letsencrypt-dns-staging
- letsencrypt-dns-prod

Both use DNS-01 validation with Route53.
