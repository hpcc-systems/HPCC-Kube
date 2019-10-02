# Deploy Dali/Sasha/DropZone/Roxie/Thor Pods as StatefulSet/EBS

Current deployment has Sasha/DropZone in support Pod.

StatefulSet gives capibility to dynamically to create EBS volume to attache to newly added Pod/Container. It uses volumeClaimTemplate and StorageClass to achieve this.
Delete VolumeClaim will automatically remove the volumes from EC2 otherwise user is responible to clean volumes in EC2.

Compare EBS with EFS, EBS supports to have better performance but when cluster deployed cross multiple AZs it may be difficult to re-use these volumes.


## Prerequisities
```console
bin/bootstrap-aws.sh
```
"bootstrap-aws.sh" includes apply Kubernetes API RBAC roles and set configmap "hpcc-config" for environment.xml generation.  If configmap "hpcc-config" not set user can provide configmap under ./hpcc-config and apply it in ./start script. See [aws/configmap/README.md](../../../aws/configmap/README.md) for more detail about configmap settings


## Deploy HPCC Systems Cluster
```console
./start
```
To make sure they are up:
```console
kubectl get pods
NAME                               READY   STATUS    RESTARTS   AGE
dali                               1/1     Running   0          100s
efs-provisioner-57965c4946-7w4b5   1/1     Running   0          2d14h
esp-esp1-69b59769bd-hmzss          1/1     Running   0          98s
hpcc-admin                         1/1     Running   0          101s
roxie-roxie1-0                     1/1     Running   0          97s
roxie-roxie1-1                     1/1     Running   0          68s
roxie-roxie2-0                     1/1     Running   0          96s
support-0                          1/1     Running   0          99s
thor-thor1-0                       1/1     Running   0          94s
thor-thor1-1                       1/1     Running   0          74s
thormaster-thor1                   1/1     Running   0          95s
```

The cluster should be automatically configured and started.
To verify the status
```console
bin/cluster_run.sh status

Status of dali:
mydafilesrv     ( pid      972 ) is running ...
mydali          ( pid     3722 ) is running ...

Status of esp-esp1-69b59769bd-8gdpp:
mydafilesrv     ( pid      990 ) is running ...
esp1            ( pid     5258 ) is running ...

Status of roxie-roxie1-0:
mydafilesrv     ( pid      980 ) is running ...
roxie1          ( pid     4154 ) is running ...

Status of roxie-roxie1-1:
mydafilesrv     ( pid      978 ) is running ...
roxie1          ( pid     4153 ) is running ...

Status of roxie-roxie2-0:
mydafilesrv     ( pid      982 ) is running ...
roxie2          ( pid     4154 ) is running ...

Status of support-0:
mydafilesrv     ( pid     1009 ) is running ...
mydfuserver     ( pid     7232 ) is running ...
myeclagent      ( pid     7427 ) is running ...
myeclccserver   ( pid     7616 ) is running ...
myeclscheduler  ( pid     7820 ) is running ...
mysasha         ( pid     8014 ) is running ...

Status of thor-thor1-0:
mydafilesrv     ( pid      973 ) is running ...

Status of thor-thor1-1:
mydafilesrv     ( pid      972 ) is running ...

Status of thormaster-thor1:
mydafilesrv     ( pid      980 ) is running ...
thor1           ( pid     4208 ) is running with 2 slave process(es) ...
```


## Access ECLWatch ###
Get esp public ic:
```console
kubectl get service

NAME               TYPE           CLUSTER-IP      EXTERNAL-IP                                                               PORT(S)          AGE
ew-esp1            LoadBalancer   10.100.239.98   a88781525d33911e9a3780efce698321-1790757551.us-east-1.elb.amazonaws.com   8010:32534/TCP   78m
kubernetes         ClusterIP      10.100.0.1      <none>                                                                    443/TCP          3h12m
svc-roxie-roxie1   ClusterIP      None            <none>                                                                    <none>           78m
svc-roxie-roxie2   ClusterIP      None            <none>                                                                    <none>           78m
svc-support        ClusterIP      None            <none>                                                                    <none>           78m
svc-thor-thor1     ClusterIP      None            <none>                                                                    <none>           78m

```
ECLWatch URL: http://a88781525d33911e9a3780efce698321-1790757551.us-east-1.elb.amazonaws.com:8010

## Scale up/down ###
Original roxie-roxie1 cluster has 2 instances. To increase it to 4 instances:
```console
kubeclt scale --replicas 4 StatefulSet/roxie-roxie1

kubeclt get pods

ming@BCTWANGXI02-WXL:/mnt/c/work/LexisNexis/Docker_Kubernetes/HPCC-Kubernetes$ kubectl get pods
NAME                        READY   STATUS    RESTARTS   AGE
dali                        1/1     Running   0          76m
esp-esp1-69b59769bd-8gdpp   1/1     Running   0          76m
hpcc-admin                  1/1     Running   0          76m
roxie-roxie1-0              1/1     Running   0          76m
roxie-roxie1-1              1/1     Running   0          76m
roxie-roxie1-2              1/1     Running   0          16m
roxie-roxie1-3              1/1     Running   0          15m
roxie-roxie2-0              1/1     Running   0          76m
support-0                   1/1     Running   0          76m
thor-thor1-0                1/1     Running   0          76m
thor-thor1-1                1/1     Running   0          76m
thormaster-thor1            1/1     Running   0          76m

```
To scale it back
```console
kubeclt scale --replicas 2 StatefulSet/roxie-roxie1
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
