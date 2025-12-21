# affine-self-hosted

Application: https://affine.pro/

Database: PostgreSQL and Redis

Operators used:
 - [CloudNativePG](https://cloudnative-pg.io/)
 - [Dragonfly](https://www.dragonflydb.io/)

Created a custom Helm chart for the application.

## Before installing

Create certificates:

```bash
mkcert -cert-file affine-local.crt -key-file affine-local.key 'affine.local' '*.affine.local'
```

Create tls secret:

```bash
kubectl create secret tls affine-tls \
  --key ./affine-local.key \
  --cert ./affine-local.crt
```

## Verification

```bash
kubectl get kustomizations -A
```

Output:

```txt
NAMESPACE     NAME                AGE     READY   STATUS
flux-system   affine-production   18m     True    Applied revision: main@sha1:6aec2c8396b6ca9c0fe34e7226d0a5f9d24e1b84
flux-system   affine-staging      67m     True    Applied revision: main@sha1:6aec2c8396b6ca9c0fe34e7226d0a5f9d24e1b84
flux-system   cnpg                2d23h   True    Applied revision: main@sha1:6aec2c8396b6ca9c0fe34e7226d0a5f9d24e1b84
flux-system   dragonfly           2d23h   True    Applied revision: main@sha1:6aec2c8396b6ca9c0fe34e7226d0a5f9d24e1b84
flux-system   flux-system         2d23h   True    Applied revision: main@sha1:6aec2c8396b6ca9c0fe34e7226d0a5f9d24e1b84
```

```bash
kubectl get helmreleases -A
```

Output:

```txt
NAMESPACE     NAME                         AGE     READY   STATUS
flux-system   cnpg-operator-release        2d22h   True    Helm install succeeded for release cnpg-operator-system/cnpg-operator-system-cnpg-operator-release.v1 with chart cloudnative-pg@0.27.0
flux-system   dragonfly-operator-release   2d22h   True    Helm install succeeded for release dragonfly-operator-system/dragonfly-operator.v1 with chart dragonfly-operator@v1.3.1
production    production                   15m     True    Helm install succeeded for release production/production.v1 with chart affine@0.1.0
staging       staging                      31m     True    Helm upgrade succeeded for release staging/staging.v2 with chart affine@0.1.0
```

```bash
kubectl get pods -A
```

Output:

```txt
NAMESPACE                   NAME                                                              READY   STATUS      RESTARTS        AGE
cnpg-operator-system        cnpg-operator-system-cnpg-operator-release-cloudnative-pg-h9p4q   1/1     Running     3 (6m12s ago)   2d22h
dragonfly-operator-system   dragonfly-operator-7f9d4f5d8f-tcdz8                               2/2     Running     6 (6m12s ago)   2d22h
flux-system                 helm-controller-686947699-tp752                                   1/1     Running     3 (6m12s ago)   2d23h
flux-system                 kustomize-controller-5c547787d9-5tkjz                             1/1     Running     3 (6m12s ago)   2d23h
flux-system                 notification-controller-79bbf86dd9-666cl                          1/1     Running     3 (6m12s ago)   2d23h
flux-system                 source-controller-6c6d48dff8-96wh6                                1/1     Running     3 (6m12s ago)   2d23h
kube-system                 coredns-64fd4b4794-tfntm                                          1/1     Running     3 (6m12s ago)   2d23h
kube-system                 helm-install-traefik-c2x2s                                        0/1     Completed   1               2d23h
kube-system                 helm-install-traefik-crd-x776h                                    0/1     Completed   0               2d23h
kube-system                 local-path-provisioner-774c6665dc-h4xzz                           1/1     Running     3 (6m12s ago)   2d23h
kube-system                 metrics-server-7bfffcd44-9n6ch                                    1/1     Running     3 (6m12s ago)   2d23h
kube-system                 svclb-traefik-fa94863e-9bqqz                                      2/2     Running     6 (6m12s ago)   2d23h
kube-system                 traefik-c98fdf6fb-c6l6g                                           1/1     Running     3 (6m2s ago)    2d23h
production                  affine-production-deployment-b9d7d6bb-652dv                       1/1     Running     1 (6m2s ago)    16m
production                  affine-production-deployment-b9d7d6bb-qw4ns                       1/1     Running     1 (6m2s ago)    16m
production                  affine-production-deployment-b9d7d6bb-rpv9x                       1/1     Running     1 (6m2s ago)    16m
production                  cluster-1                                                         1/1     Running     1 (6m2s ago)    16m
production                  cluster-2                                                         1/1     Running     1 (6m12s ago)   16m
production                  cluster-3                                                         1/1     Running     1 (6m12s ago)   13m
production                  dragonfly-0                                                       1/1     Running     1 (6m12s ago)   16m
production                  dragonfly-1                                                       1/1     Running     1 (6m11s ago)   16m
production                  dragonfly-2                                                       1/1     Running     1 (6m11s ago)   16m
staging                     affine-staging-deployment-9f78cb484-vm9b8                         1/1     Running     1 (6m10s ago)   17m
staging                     cluster-1                                                         1/1     Running     1 (6m11s ago)   57m
staging                     dragonfly-0                                                       1/1     Running     1 (6m12s ago)   58m
```

```bash
kubectl get ingress -A
```

Output:

```txt
NAMESPACE    NAME             CLASS     HOSTS                  ADDRESS        PORTS     AGE
production   affine-ingress   traefik   affine.local           192.168.64.2   80, 443   17m
staging      affine-ingress   traefik   staging.affine.local   192.168.64.2   80, 443   33m
```
