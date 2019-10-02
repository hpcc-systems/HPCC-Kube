
kubectl.exe get pods -n kube-system kube-apiserver-minikube -o yaml > kube-system.yaml

To ssh to pod: from a cmd console (not bash):
kubectl exec -it <pod name> -- /bin/bash


HTTP response body: {"kind":"Status","apiVersion":"v1","metadata":{},"status":"Failure","message":"pods is forbidden: User \"
system:serviceaccount:default:default\" cannot list pods at the cluster scope","reason":"Forbidden","details":{"kind":"pods"}
,"code":403}
Reason: -authorization-mode=Node,RBAC
https://kubernetes.io/docs/reference/access-authn-authz/rbac/

kubectl.exe apply -f (resource).yml
for get_pods.py need:  kubectl.exe apply -f cluster_role.yaml
