# IAM Policies (Platform – FROZEN)

This directory contains **IAM policies used by the EKS platform controllers**.

These policies are **platform-owned** and must not be modified by
application teams.

All policies follow the **principle of least privilege** and are attached
to Kubernetes ServiceAccounts via **IRSA**.

---

## 🔒 Status: FROZEN

The policies in this directory are considered **stable for the test environment**.

They are:
- not modified during normal application onboarding
- only changed as part of explicit platform evolution work
- validated in this test domain before reuse in production environments

---

## aws-load-balancer-controller-policy.json

Used by the **AWS Load Balancer Controller** to manage:

- Application Load Balancers (ALB)
- Target Groups
- Security Groups

This policy is required for all Kubernetes Ingress resources using
the AWS ALB Ingress Controller.

Attached via IRSA to:
- `aws-load-balancer-controller` ServiceAccount

---

## external-dns-policy.json

Used by **external-dns** to manage DNS records in Route53.

Allows:
- ChangeResourceRecordSets
- ListHostedZones
- ListResourceRecordSets

This enables automatic creation and updates of DNS records based on
Kubernetes Ingress resources.

Attached via IRSA to:
- `external-dns` ServiceAccount

---

## cert-manager-dns01-policy.json

Used by **cert-manager** to perform DNS-01 ACME challenges via Route53.

Allows:
- ChangeResourceRecordSets
- ListHostedZones
- ListResourceRecordSets

This policy is **not used by application teams** and is only relevant
when working on certificate management at the platform level.

Attached via IRSA to:
- `cert-manager` ServiceAccount

---

## Application Team Responsibilities

Application teams **must not**:

- Modify IAM policies
- Attach AWS permissions to their workloads
- Use AWS credentials directly

All AWS access required for ingress, DNS, and certificates is handled
by platform controllers.

---

## Notes for Platform Engineers

If changes to IAM policies are required:

1. Document the motivation
2. Modify policies in a dedicated branch
3. Validate changes in this test environment
4. Review IAM diff carefully before promotion

