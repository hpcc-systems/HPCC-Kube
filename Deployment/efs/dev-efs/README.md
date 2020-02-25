# Deploy Dali/Sasha/DropZone/Roxie/Thor Pods as Deployment/EFS

Generally this is preferred way to deploy a cluster with EFS since share mode is typically ReadWriteMany.

Current deployment has Sasha/DropZone in support Pod.

Even EFS performance may not be good as EBS but EFS it is very convenient such as:
- Don't need worry about cross AZz
- Easy to share and re-use data
- Don't need to worry about deleting volume after deleting Pod.

EFS is a little more expensive than EBS.

## Persistent Volumes
One EFS server is used for persistent storage.
There are four types of persistent volume claims:
  - efs: /var/lib/HPCCSystems (support node and possible for dali node)
  - efs-data: /var/lib/HPCCSystems/hpcc-data  (dali/roxie/thor)
  - efs-mirror: /var/lib/HPCCSysterms/hpcc-mirror (dali/roxie/thor)
  - efs-queries: /var/lib/HPCCSystems/queries (roxie/thor)

## Performance
### compare EFS and EBS
We did similar performance testing on single node with 32 cores and 128 GB memory.
EBS generally has at lest 5-6 seconds advantage compared with EFS, particular for short during tests.


## Prerequisities
- Bootstrap
  ```console
  bin/bootstrap-aws.sh
  ```
  "bootstrap-aws.sh" includes apply Kubernetes API RBAC roles and sets configmap "hpcc-config" for environment.xml generation.  If configmap "hpcc-config" is not set user can provide configmap under ./hpcc-config and apply it in ./start script. See [aws/configmap/README.md](../../../aws/configmap/README.md) for more detail about configmap settings

- Start NFS server
  in efs/
  ```console
  ./apply.sh
  ```
  apply.sh appl rbac.yaml and manifest.yaml
  To display NFS pod:
  ```console
  kubectl get pods
  NAME                               READY   STATUS    RESTARTS   AGE
  efs-provisioner-57965c4946-7w4b5   1/1     Running   0          2d15h
  ```
  To display PV and PVC:
  ```console
  kubectl get pv
  NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM         STORAGECLASS   REASON   AGE
  pvc-bdf95dd2-d820-11e9-87ee-0e00576dcdfc   1Mi        RWX            Delete           Bound    default/efs   aws-efs                 2d15h

  kubectl get pvc
  NAME   STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
  efs    Bound    pvc-bdf95dd2-d820-11e9-87ee-0e00576dcdfc   1Mi        RWX            aws-efs        2d15h

  The Volume Claim name is "efs". The storage class is "aws-efs"

## Deploy HPCC Systems Cluster
```console
./start
```
To make sure they are up:
```console
kubectl get pods
NAME                               READY   STATUS    RESTARTS   AGE
dali                               1/1     Running   0          51s
efs-provisioner-57965c4946-7w4b5   1/1     Running   0          2d15h
esp-esp1-f5bc48677-znlsv           1/1     Running   0          49s
hpcc-admin                         1/1     Running   0          52s
roxie-roxie1-84f9578895-fbpld      1/1     Running   0          47s
roxie-roxie1-84f9578895-gpf6x      1/1     Running   0          47s
roxie-roxie2-6cf55ffd45-nf2mp      1/1     Running   0          46s
support-db468c5c9-8kqzd            1/1     Running   0          50s
thor-thor1-59876665f5-67p4p        1/1     Running   0          44s
thor-thor1-59876665f5-nn7wc        1/1     Running   0          44s
thormaster-thor1                   1/1     Running   0          45s
```

The cluster should be automatically configured and started.
To verify the status
```console
bin/cluster_run.sh status
Status of dali:
mydafilesrv     ( pid      972 ) is running ...
mydali          ( pid     1166 ) is running ...

Status of esp-esp1-f5bc48677-znlsv:
mydafilesrv     ( pid      991 ) is running ...
esp1            ( pid     1185 ) is running ...

Status of roxie-roxie1-84f9578895-fbpld:
mydafilesrv     ( pid      978 ) is running ...
roxie1          ( pid     1177 ) is running ...

Status of roxie-roxie1-84f9578895-gpf6x:
mydafilesrv     ( pid      978 ) is running ...
roxie1          ( pid     1177 ) is running ...

Status of roxie-roxie2-6cf55ffd45-nf2mp:
mydafilesrv     ( pid      979 ) is running ...
roxie2          ( pid     1178 ) is running ...

Status of support-db468c5c9-8kqzd:
mydafilesrv     ( pid     1010 ) is running ...
mydfuserver     ( pid     1204 ) is running ...
myeclagent      ( pid     1413 ) is running ...
myeclccserver   ( pid     1633 ) is running ...
myeclscheduler  ( pid     1851 ) is running ...
mysasha         ( pid     2059 ) is running ...

Status of thor-thor1-59876665f5-67p4p:
mydafilesrv     ( pid      972 ) is running ...

Status of thor-thor1-59876665f5-nn7wc:
mydafilesrv     ( pid      972 ) is running ...

Status of thormaster-thor1:
mydafilesrv     ( pid      978 ) is running ...
thor1           ( pid     1243 ) is running with 2 slave process(es) ...

```


## Access ECLWatch
Get esp public ip:
```console
kubectl get service
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP                                                               PORT(S)          AGE
ew-esp1      LoadBalancer   10.100.248.99   a0e9629f2da3811e9b1b40aa0a5b6276-2050531242.us-east-1.elb.amazonaws.com   8010:30108/TCP   3m52s

```
ECLWatch URL: http://a0e9629f2da3811e9b1b40aa0a5b6276-2050531242.us-east-1.elb.amazonaws.com:8010

## Scale up/down
Original roxie-roxie1 cluster has 2 instances.
To increase it to 4 instances:
```console
kubeclt scale --replicas 6 StatefulSet/roxie-roxie1

kubeclt get pods
NAME                               READY   STATUS    RESTARTS   AGE
dali                               1/1     Running   0          6m10s
efs-provisioner-57965c4946-7w4b5   1/1     Running   0          2d15h
esp-esp1-f5bc48677-znlsv           1/1     Running   0          6m8s
hpcc-admin                         1/1     Running   0          6m11s
roxie-roxie1-84f9578895-7p4qz      1/1     Running   0          29s
roxie-roxie1-84f9578895-8tpxp      1/1     Running   0          29s
roxie-roxie1-84f9578895-fbpld      1/1     Running   0          6m6s
roxie-roxie1-84f9578895-gpf6x      1/1     Running   0          6m6s
roxie-roxie1-84f9578895-tjlp9      1/1     Running   0          29s
roxie-roxie1-84f9578895-v62dj      1/1     Running   0          29s
roxie-roxie2-6cf55ffd45-nf2mp      1/1     Running   0          6m5s
support-db468c5c9-8kqzd            1/1     Running   0          6m9s
thor-thor1-59876665f5-67p4p        1/1     Running   0          6m3s
thor-thor1-59876665f5-nn7wc        1/1     Running   0          6m3s
thormaster-thor1                   1/1     Running   0          6m4s

```
To scale it back
```console
kubeclt scale --replicas 2 Deployment/roxie-roxie1
```


## Stop/Start Cluster
stop
```console
bin/cluster-run stop
```
start
```console
bin/cluster-run start
```

Get status
```console
bin/cluster-run status

```

## Delete Cluster ###
```console
./stop
```
This does not delete volumes. Either use AWS Client or go to EC2 console to delete them.
