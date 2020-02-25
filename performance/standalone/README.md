# Run Performance Tests

## Deploy
### StatefulSet with EBS
```console
aws/EKS/eks-single.sh
```
```console
cd performance/standalone/
kubectl create -f ss-ebs.yaml
```

### Deploymet with EFS
```console
aws/EKS/eks-single.sh
cd bin
./bootstrap-aws.sh
cd ../efs
./apply.sh
```
```console
cd performance/standalone/
kubectl create -f dp-efs.yaml
```


## Run Test
### Preparation
In directory performance/standalone/
```console
kubectl cp environment.xml <pod name>:/tmp/
kubectl cp run-test.sh <pod name>:/root/
```
```console
kubectl exec -it <pod name> bash
cd /etc/HPCCSystems
cp /tmp/environment.xml
```
### Start HPCC Platform
```console
/etc/init.d/hpcc-init start
```

### Run thor test
```console
cd /root
./run-test.sh
```
### Run thor test
Update run-test.sh to comment thor and uncomment roxie tests
```console
./run-test.sh
```
### Test Results
/tmp/perf_[thor|roxie].out
copy result to host:

```console
kubectl cp <pod name>:/tmp/perf_[thor|roxie].out perf_[thor|roxie].out
```

## Clean up deployment
### Stop Cluster
```console
kubectl delete -f <pod name>
```
Delete pvc for EBS:
```console
kubectl delete pvc <pvc name>
```

### Stop EFS Provisioner
```console
cd efs
./delete.sh
```

### Delete EKS Cluster
```console
cd aws/EKS
eksctl get cluster  # get cluster name
./stop <cluser name>
```
