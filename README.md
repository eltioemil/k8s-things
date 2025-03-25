# Local playground k8s

[Secret types](https://kubernetes.io/docs/concepts/configuration/secret/#secret-types)
[Config maps updates](https://kubernetes.io/docs/concepts/configuration/configmap/#mounted-configmaps-are-updated-automatically)

## Equivalent commands
deployment: `kubectl create deploy nginx --image nginx`
service: `kubectl expose deploy nginx --port 80`
namespace: `kubectl create namespace test`

## Helm

`helm create my-awesome-service`

## K8s networking

[Networking](https://kubernetes.io/docs/concepts/services-networking/)

Pod DNS: `pod-ipv4-address.default.pod.cluster.local`
Service DNS: `nginx-service.default.svc.cluster.local`

## k8s Resources

- Tolerations and taints
- Node selector
- Resource allocation
- Argo

[Resources](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/)
[QoS](https://kubernetes.io/docs/tasks/configure-pod-container/quality-service-pod/)
