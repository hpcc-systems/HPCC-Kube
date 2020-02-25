# Deploy StatefulSet with FQDN

## Setup Local Kubernetes

### Minikube

Installation: https://kubernetes.io/docs/tasks/tools/install-minikube/
Start minikube
  1) minikube start
  2) set virtualbox resources:
     minikube --vm-drive=virtualbox -cpu 4 --disk-size 100g --memory 8192 start:w


### Linux


## Start and Stop Cluster
All following assume in directory of github project HPCC-Kubernetes.
The Kubernetes client wraper is "kubectl.sh" on Unix and "kubectl.exe". In some providers it can be just named "kubectl". "kubectl.sh" is used here.

### bootstrap
This will setup ConfigMap and grant security permissions
```sh
cd bin/
./bootstrap.sh
```

### Start Cluster
Start one support node (include Dali) and two ESP nodes
```sh
cd local/hpcc_dns
./start
pod/hpcc-admin created
service/svc-support created
statefulset.apps/support created
service/svc-e1 created
service/eclwatch-e1 created
statefulset.apps/esp-e1 created
```

To display pods status
```sh
kubectl.sh get pods
NAME         READY   STATUS    RESTARTS   AGE
esp-e1-0     1/1     Running   0          2m29s
esp-e1-1     1/1     Running   0          2m22s
hpcc-admin   1/1     Running   0          2m32s
support-0    1/1     Running   0          2m31s

```

Pod name format: <HPCC comp>-<cluster name>-<optional ordinal index>
For example esp-e1-0: this is the first node of ESP cluster "e1"

To display services
```sh
kubectl.sh get service
NAME          TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)          AGE
eclwatch-e1   NodePort    10.0.0.45    <none>        8010:32000/TCP   3m50s
kubernetes    ClusterIP   10.0.0.1     <none>        443/TCP          8h
svc-e1        ClusterIP   None         <none>        <none>           3m51s
svc-support   ClusterIP   None         <none>        <none>           3m53s

```

Query FQDN
There is one support node including "Dali" and two ESP nodes deployed. All three can be searched by FQDN. Since current contain image doesn't include nsloop or related, ping can be used.

To check the FQDN settings
kubectl.sh exec -it <pod name> -- cat /etc/resolv.conf
For example
```sh
kubectl.sh exec -it esp-e1-0 -- cat /etc/resolv.conf
nameserver 10.0.0.10
search default.svc.cluster.local svc.cluster.local cluster.local
options ndots:5
```

Get support node ip from FQDN
```sh
kubectl.sh exec -it esp-e1-0 -- ping -c 1 support-0.svc-support
PING support-0.svc-support.default.svc.cluster.local (172.17.0.3) 56(84) bytes of data.
64 bytes from support-0.svc-support.default.svc.cluster.local (172.17.0.3): icmp_seq=1 ttl=64 time=0.073 ms
```
Every "StatefulSet" definition requires a headless service to make FQDN work. Above support Pod has the headless service "svc-support".  We currently deploy everything in Kubernetes default namespace "default". The default domain is "cluster.local". The complete FQDN for support-0 should be "support-0.svc-support.default.svc.cluster.local"


### Configure Cluster
Note: this process will be automated soon
Following will collect all HPCC Systems node names and ips and generate environment.xml, transfer the file to all nodes and start HPCC Systems Cluster
```sh
cd bin/
./cluster_config.sh
```

All availalble HPCC components include Esp are listed.

Access EclWatch
A service "ew-e1" is defined for ESP "e1" cluster. Ideally it should be configured as "LoadBalancer" and get external ip from the network. But this will not be possible in our working environment. In most commercial cloud solution this shouldn't be a problem.

For local solution "NodePort" type service is used.
User can access EclWatch through local kubernetes host and mapped port: 32000.
For minikub run
   minikube service ew-e1
This will display EclWatch on default browser

## Code and Files

Pod/Service definitions: local/hpcc_dns
Help scripts bin/

## Known Problems
### Can't get single Pod not StatefulSet FQDN work
### Can't get Pod FQDN work without provide a service
