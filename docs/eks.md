Why EKS was chosen

Amazon Elastic Kubernetes Service (EKS) was chosen because it provides a fully managed Kubernetes solution with high availability, security, and integration with the AWS ecosystem. EKS reduces operational overhead by handling control plane maintenance, upgrades, and patching, allowing the team to focus on application development and research for the thesis.

Why managed node groups

Managed Node Groups were used to simplify worker node management. They automatically handle provisioning, updates, and autoscaling, reducing the risk of errors and ensuring the cluster always has the resources needed for the workloads.

Region selection

The `eu-central-1` (Frankfurt) region was selected because the collaborating companies are located in Mainz. This minimizes network latency and facilitates integration with local systems, while also complying with regional data protection and regulatory requirements.

Reproducible cluster setup (eksctl)

The cluster is created in a reproducible way using eksctl, a command-line tool that automates EKS cluster and managed node group creation. Example command:
```
eksctl create cluster \
  --name my-cluster \
  --region eu-central-1 \
  --nodes 3 \
  --managed
```
This ensures the cluster can be recreated if needed with the same configuration, keeping the setup fully documented as code.

Region eu-central-1 was chosen to meet geographical proximity to the company's operations in Germany as well as potential regulatory requirements (e.g. GDPR).

Existing IAM policy was reused for AWS Load Balancer Controller to comply with the organization's established security policies.