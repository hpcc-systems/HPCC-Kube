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
```console
./tiller-rbac.sh
```

## Use HELM
### Dry-run
```console
helm install --name hpcc-cluster --dry-run --debug  ./<hpcc-dp | hpcc-ss>
```


### Start a Cluster
```console
helm install --name hpcc-cluster ./<hpcc-dp|hpcc-ss>
```

```console
helm list
```
### Stop the Cluster
```console
helm delete --purge hpcc-cluster
```
