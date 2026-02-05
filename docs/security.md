## Network isolation

The `apps` namespace uses a default-deny NetworkPolicy.

All pod-to-pod traffic is denied unless explicitly allowed.
Each application must define its required communication paths.

This reduces attack surface and enforces service isolation by default.
