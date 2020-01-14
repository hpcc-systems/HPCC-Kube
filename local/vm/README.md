# Deploy HPCC Systems Cluster with Deployment

This is an alternative to HPCCSystem VM single-alone setup. It can be used to local Kubernetes environment.
A small HPCC Systems cluster will be deployed which can be used for testing, development and self-learning.

The HPCC Systems data should be persistant on the host system: /HPCCSystems. The exception is dropzone.
For kubectl command, on Windows some times youo can run kubectl but some environment only kubectl.exe available.

## Prerequisities
- Bootstrap
  ```console
  bin/bootstrap.ps1
  ```
## Deploy HPCC Systems Cluster
```console
###Windows
./start.ps1

#### Linux
./start
```
To make sure they are up:
```console
kubectl get pods
NAME                               READY   STATUS    RESTARTS   AGE
esp-esp1-868bc9dccd-qn849       1/1     Running   0          6m1s
hpcc-admin                      1/1     Running   0          6m2s
roxie-roxie1-6bbb87d4bd-n5wvh   1/1     Running   0          6m
support-594d78df7c-tm6vq        1/1     Running   0          6m1s
thor-thor1-dc9454b48-4wf7b      1/1     Running   0          5m59s
thor-thor1-dc9454b48-w6s8w      1/1     Running   0          5m59s
thormaster-thor1                1/1     Running   0          6m
```
The cluster should be automatically configured and started.
To verify the status
```console
# Windows
bin/cluster_run.ps1 -action status
# Unix
bin/cluster_run.sh status
mydafilesrv     ( pid     1010 ) is running ...
esp1            ( pid     1205 ) is running ...

mydafilesrv     ( pid      997 ) is running ...
roxie1          ( pid     1197 ) is running ...

mydafilesrv     ( pid     1041 ) is running ...
mydali          ( pid     1236 ) is running ...
mydfuserver     ( pid     1449 ) is running ...
myeclagent      ( pid     1665 ) is running ...
myeclccserver   ( pid     1868 ) is running ...
myeclscheduler  ( pid     2085 ) is running ...
mysasha         ( pid     2291 ) is running ...
mytoposerver    ( pid     2507 ) is running ...

mydafilesrv     ( pid      991 ) is running ...

mydafilesrv     ( pid      990 ) is running ...

mydafilesrv     ( pid      998 ) is running ...
thor1           ( pid     1264 ) is running with 2 slave process(es) ...

```
## Get EclWatch port

```console
kubeclt get services
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                                        AGE
configmgr    NodePort    10.108.63.10    <none>        8015:31434/TCP                                 41m
ew-esp1      NodePort    10.97.127.184   <none>        8010:32062/TCP,8002:32647/TCP,8510:30966/TCP   41m
kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP                                        53d
```
EclWatch port above is 32062
You can access EclWatch as http://localhost:32062

## Spray and run ECL sample
You can try to spray and run some ECL code to verify hthor/thor/roxie functions
For example, Anagram2 Examples in "HPCC Systems Instant Cloud for AWS" book.



## Verify persistant data
You can shutdown the cluster and brint it back:
### Windows
./stop.ps1
./start.ps1

### Linux
./stop
./start

Re-execute the ECL code above. It should run successfully
Persistant HPCC Systems data are under host system
### Local Linux
/HPCCSystems

### Minikube
minikube ssh
/HPCCSystems

###Docker Desktop on Windows
docker run --net=host --ipc=host --uts=host --pid=host -it --security-opt=seccomp=unconfined --privileged --rm -v /:/host alpine /bin/sh
/host/HPCCSystems




## Scale up/down (to be tested)
Original roxie-roxie1 cluster has 1 instances. To increase it to 2 instances:
```console
kubeclt scale --replicas 2 StatefulSet/roxie-roxie1
```
To scale it back
```console
kubeclt scale --replicas 1 Deployment/roxie-roxie1
```

## Auto-scaling (to be tested)
A sample autoscaling yaml file is provided. You can modify it and apply it
```console
kubectl apply -f esp-e1-hpa.yaml
```
Increase ESP pod CPU. For example run a big loop and monitor the auto-scaling.

To disable auto-scaling:
```console
kubectl delete -f esp-e1-hpa.yaml
```

## Vertical scaling (to be tested)


## Stop/Start Cluster
stop
```console
# Windows
bin/cluster-run.ps1 stop
# Unix
bin/cluster-run stop
```
start
```console
# Windows
bin/cluster-run.ps1 start
# Unix
bin/cluster-run start
```

Get status
```console
# Windows
bin/cluster-run.ps1 status
# Unix
bin/cluster-run status

```

## Delete Cluster ###
```console
# Windows
./stop.ps1
# Unix
./stop
```

docker run --net=host --ipc=host --uts=host --pid=host -it --security-opt=seccomp=unconfined --privileged --rm -v /:/host alpine /bin/sh
