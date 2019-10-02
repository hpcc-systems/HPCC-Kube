# Deploy Dali/Sasha/DropZone/Roxie/Thor Pods as StatefulSet/EFS

Current deployment has Sasha/DropZone in support Pod.
Attach ReadWriteMany EFS to Pods doesn't need StatefulSet. See Deployment/efs/efs-1/README.md. But for ReadWriteOnce EFS StatefulSet is required which is this setup about.


## Prerequisities
- Bootstrap
  ```console
  bin/bootstrap-aws.sh
  ```
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
```console
kubectl get pods
NAME                               READY   STATUS    RESTARTS   AGE
dali                               1/1     Running   0          71s
efs-provisioner-57965c4946-7w4b5   1/1     Running   0          2d15h
esp-esp1-f5bc48677-p5hgs           1/1     Running   0          69s
hpcc-admin                         1/1     Running   0          72s
roxie-roxie1-0                     1/1     Running   0          68s
roxie-roxie1-1                     1/1     Running   0          58s
roxie-roxie2-0                     1/1     Running   0          67s
support-0                          1/1     Running   0          70s
thor-thor1-0                       1/1     Running   0          64s
thor-thor1-1                       1/1     Running   0          60s
thormaster-thor1                   1/1     Running   0          66s
``

To get PersistentVolumeClaims:
```console
kubectl get pvc
NAME                 STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
efs                  Bound    pvc-bdf95dd2-d820-11e9-87ee-0e00576dcdfc   1Mi        RWX            aws-efs        2d15h
efs-roxie-roxie1-0   Bound    pvc-78b19802-da34-11e9-87ee-0e00576dcdfc   1Mi        RWO            aws-efs        7m13s
efs-roxie-roxie1-1   Bound    pvc-7e418789-da34-11e9-87ee-0e00576dcdfc   1Mi        RWO            aws-efs        7m3s
efs-roxie-roxie2-0   Bound    pvc-794e58c9-da34-11e9-87ee-0e00576dcdfc   1Mi        RWO            aws-efs        7m12s
efs-support-0        Bound    pvc-77771f35-da34-11e9-87ee-0e00576dcdfc   1Mi        RWO            aws-efs        7m15s
efs-thor-thor1-0     Bound    pvc-7a852ef7-da34-11e9-87ee-0e00576dcdfc   1Mi        RWO            aws-efs        7m9s
efs-thor-thor1-1     Bound    pvc-7d1062ef-da34-11e9-87ee-0e00576dcdfc   1Mi        RWO            aws-efs        7m5s
```
To check clustr status:
```console
bin/cluster_run.sh status
```
## Access EclWatch
Get esp public ip:
```console
kubectl get services
NAME               TYPE           CLUSTER-IP      EXTERNAL-IP                                                              PORT(S)          AGE
ew-esp1            LoadBalancer   10.100.244.14   a780e910ada3411e9b1b40aa0a5b6276-615333305.us-east-1.elb.amazonaws.com   8010:30414/TCP   4m38s
kubernetes         ClusterIP      10.100.0.1      <none>                                                                   443/TCP          3d4h
svc-roxie-roxie1   ClusterIP      None            <none>                                                                   <none>           4m37s
svc-roxie-roxie2   ClusterIP      None            <none>                                                                   <none>           4m36s
svc-support        ClusterIP      None            <none>                                                                   <none>           4m39s
svc-thor-thor1     ClusterIP      None            <none>                                                                  <none>           4m34s
```

To access EclWatch : http://a780e910ada3411e9b1b40aa0a5b6276-615333305.us-east-1.elb.amazonaws.com:8010

## Scale up/down
Scale up
```console
kubeclt scale --replicas 4 StatefulSet/roxie-roxie1
NAME                               READY   STATUS    RESTARTS   AGE
dali                               1/1     Running   0          10m
efs-provisioner-57965c4946-7w4b5   1/1     Running   0          2d15h
esp-esp1-f5bc48677-p5hgs           1/1     Running   0          10m
hpcc-admin                         1/1     Running   0          10m
roxie-roxie1-0                     1/1     Running   0          10m
roxie-roxie1-1                     1/1     Running   0          10m
roxie-roxie1-2                     1/1     Running   0          12s
roxie-roxie1-3                     0/1     Pending   0          5s
roxie-roxie2-0                     1/1     Running   0          10m
support-0                          1/1     Running   0          10m
thor-thor1-0                       1/1     Running   0          10m
thor-thor1-1                       1/1     Running   0          10m
thormaster-thor1                   1/1     Running   0          10m
```
Notice scale up EFS is much faster than EBS since no volume need be created.

Scale down
```console
kubeclt scale --replicas 1 StatefulSet/roxie-roxie1
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
