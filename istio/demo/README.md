# ISTIO DEMO

### Prepqre ISTIO ###
Follow https://istio.io/docs/setup/kubernetes/install/kubernetes/ to install Download ISTIO
Unpack downloaded file
export ISTIO_HOME=<ISTIO unpack directory>
Add ${ISTIO_HOME}/bin to PATH

start kubernetes and run bin/bootstrap-local.sh

### Add ISTIO to Kubernetes ###
```console
./install.sh
```
istio-demo-auth.yaml is modified by adding port 8010 to istio-ingressgateway. Nodeport is 31381


### Deploy HPCC System Cluster ###
make sure every pod is at least one service if you want it managed by istio (inject Envoy)
https://istio.io/docs/setup/kubernetes/additional-setup/requirements/

Run following to allow ssh port 22 for ansible. also it enforce mutual TLS which block all traffic except ssh
```console
security/apply.sh
```
Deploy HPCC System cluster
```console
./start
```

Notice esp-e1 start with istio kube-inject which will create another container  (envoy) in this pod
```console
kubectl.sh get pods
```

### Verify esp started but ECLWatch access failed ###
verify hpcc cluster is configured
```console
../bin/cluster-run status

To to nodeport of 8010:
```console
kubectl.sh get service -n istio-system istio-ingressgateway
```
It should be 31381 if istio-ingressgateway not changed

Try http://<host ip>:31387
It should not work


### Allow ECLWatch access ###
In network/
```console
kubectl.sh apply  -f eclwatch-gateway.yaml
```
This wil allow http://localhost:31381 routes to eclwatch but will get RBAC access denied

In secuity/rbac
```console
./apply-eclwatch.sh
```
This will allow accessing eclwath. Run playground sample to verify it works.
