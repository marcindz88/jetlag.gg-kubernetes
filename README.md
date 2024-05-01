# Setup Kubernetes for Jetlag.gg

### Use with terraform and Hetzner cloud
Setu kubernetes on a hetzner server using terraform
[README](https://github.com/kube-hetzner/terraform-hcloud-kube-hetzner)

### Setup Kubernetes namespace
    
```bash
kubectl create namespace jetlag
```

### Configure SSL

- generate origin server certificate on CloudFlare
- create crt and key files in certs directory
- execute script below

```bash
kubectl create secret tls jetlag-cert --namespace jetlag --key=certs/jetlag-tls.key --cert=certs/jetlag-tls.crt -o yaml
```

### Fetch this repository

```bash
git clone https://github.com/marcindz88/jetlag.gg-kubernetes.git
```

### Run setup script

```bash
cd jetlag.gg-kubernetes
sh setup.sh
```
