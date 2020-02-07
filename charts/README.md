# HELM
Currently two types of Helm charts are provided
- StatefulSet/EBS: use StatefulSets as Pod Controller. EBS (ReadWriteOnces) is used for storage. This can be deployed locally without EBS.
- Deployment/EFS: use Deployments as Pod Controller. EFS (ReadWriteMany) is used for storage

## Deployment Options
All deployed yaml files should be under templates/
Helm will base on the type to start them by orderly, i.e. RBAC, ConfigMap will be ahead of Pod/Controller files.
To disable certain deployment rename the file start with "_".

## StatefulSets/EBS
Scalable Pods are defined as StatefulSets. Elastic Block Storage (EBS) is used for storage. Mount type is "ReadWriteOnce". Typically "/var/lib/HPCCSystems" as mount point.

## Deployments/EFS
Scalable Pods are defined as Deployments. Elastic File System (EFS) is used for storage. Mount type is "ReadWriteMany". Thare are four PersistentClaim are provided:
- efs:  normal mount point: /var/lib/HPCCSystems
- efs-data: mount point: /var/lib/HPCCSystems/hpcc-data
- efa-mirror: mount point: /var/lib/HPCCSystems/hpcc-mirror
- efe-queries: mount point: /var/lib/HPCCSystems/queries

There is flag "AWS.EFS.Enabled" control either to use EFS (volume) or not. Using EFS requires a EFS server.
When "AWS.EFS.Enabled" set to "false" efs chart will be not deployed and no volumes will be mounted to dali/support/roxie/thor Pods.

### EFS Server
EFS settings are provided in "global.EFS.xxx" in values.yaml which includes region, id and server.
EFS server chart is under hpcc-dp/charts/efs

## Apply Tiller RBAC
This is not needed for latest Helm. Will double check
#```console
#./tiller-rbac.sh
#```

## Use HELM
### Dry-run
```console
helm install --name hpcc-cluster --dry-run --debug  ./<hpcc-vm|hpcc-dp | hpcc-ss>
```


### Start a Cluster
```console
helm install --name hpcc-cluster ./<hpcc-vm|hpcc-dp|hpcc-ss>
```

```console
helm list
```

### Upgrade a Cluster
```console
helm upgrade --name hpcc-cluster ./<hpcc-vm|hpcc-dp|hpcc-ss> --set <variable name>=<new value>
```
For example, change Docker image from vm to platform
```console
helm upgrade --name hpcc-cluster ./hpcc-vm --set Hpccsystems.Platform.Image="hpccsystems/platform"
Release "hpcc-cluster" has been upgraded. Happy Helming!
NAME: hpcc-cluster
LAST DEPLOYED: Fri Feb  7 13:05:21 2020
NAMESPACE: default
STATUS: deployed
REVISION: 2
TEST SUITE: None

kubectl get pods
NAME                           READY   STATUS    RESTARTS   AGE
esp-esp1-868bc9dccd-48r2k      1/1     Running   0          2m22s
hpcc-admin                     1/1     Running   0          10m
roxie-roxie1-696b49c55-c6gw8   1/1     Running   0          2m22s
roxie-roxie1-696b49c55-vpdxp   1/1     Running   0          2m19s
support-5f66f4c6d5-tglxv       1/1     Running   0          2m22s
thor-thor1-57956cc97-hlvtl     1/1     Running   0          2m18s
thor-thor1-57956cc97-p7b5h     1/1     Running   0          2m22s
thormaster-thor1               1/1     Running   1          10m
```

Notice above thormaster-thor1 "AGE" is not changed it was showed as "RESTARTS" by 1.  This is due the Pod type of "Pod". If you check with "kubectl exec" you should see packages changed.

### Stop the Cluster
```console
helm delete --purge hpcc-cluster
```

### Delete EBS
Delete the cluster will remove EBS in hpcc-ss
To delete the EBS volumes:
```console
delete-ebs.sh
```
