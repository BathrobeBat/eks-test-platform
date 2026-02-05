### This cluster uses the **AWS Load Balancer Controller** to manage ingress resources. 



An **Application Load Balancer (ALB)** was chosen instead of an **NGINX-based ELB** to leverage native AWS integrations such as managed TLS, path- and host-based routing, and tighter integration with AWS networking. 



**ALB** also reduces operational overhead by relying on a fully managed AWS service. 



The controller is integrated with **AWS IAM** using **OIDC**, allowing Kubernetes service accounts to assume `IAM roles` securely without long-lived credentials.



---



## Why cert-manager is used



We use cert-manager to automate the issuance and management of TLS certificates. 



It integrates seamlessly with Let’s Encrypt via the ACME protocol, allowing us to automatically obtain and renew certificates without manual intervention.



This setup ensures secure HTTPS connections at all times and is an excellent example of practical automation.



DNS management is handled using external-dns in combination with **Amazon Route 53**. 



This enables automatic creation and updates of DNS records based on Kubernetes ingress resources. 



Automating DNS management eliminates manual configuration steps, reducing the risk of human error and configuration drift. 



It also ensures DNS records stay in sync with dynamically created load balancers and application endpoints.

