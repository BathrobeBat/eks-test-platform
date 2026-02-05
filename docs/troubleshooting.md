## HTTP-01 Failure Analysis

During initial testing, cert-manager challenges remained in a pending state.

Root cause analysis showed that Kubernetes pods were unable to resolve
the public test domain via Route53.

This was verified using a BusyBox DNS test pod.

The issue was resolved by switching to DNS-01 validation.
