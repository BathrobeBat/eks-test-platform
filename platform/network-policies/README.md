## Egress control

The `apps` namespace enforces default-deny egress policies.

All outbound traffic must be explicitly allowed, including DNS resolution
and service-to-service communication.

This prevents unintended data exfiltration and limits blast radius.

### Frontend → Backend

Explicit egress rules are required for service-to-service communication.

Frontend pods are only allowed to reach backend pods on the required port.
All other traffic is denied by default.
