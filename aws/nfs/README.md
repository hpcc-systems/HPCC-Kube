# HPCC-Kubernetes on AWS

## Persistent Volume
### Create EBS
Will show how to add two types of volumes: 1) indiviual store for each pod 2) shared nfs storage

Create an EBS for individual Storage for /var/lib/HPCCSystems and /var/log/HPCCSystems
```sh
aws ec2 create-volume --availability-zone ap-southeast-1b --size 20 --volume-type gp2
```
Write down the VolumeId.

Create an EBS for nfs server
```sh
aws ec2 create-volume --availability-zone ap-southeast-1b --size 1 --volume-type gp2
```
Write down the VolumeId.


### Setup NFS
Create a ReplicateController for  nfs-server-rc.yaml with above VolumeId  (EBS for nfs server)
```sh
apiVersion: v1
kind: ReplicationController
metadata:
  name: nfs-server
spec:
  replicas: 1
  selector:
    role: nfs-server
  template:
    metadata:
      labels:
        role: nfs-server
    spec:
      containers:
      - name: nfs-server
        image: gcr.io/google-samples/nfs-server:1.1
        ports:
          - name: nfs
            containerPort: 2049
          - name: mountd
            containerPort: 20048
          - name: rpcbind
            containerPort: 111
        securityContext:
          privileged: true
        volumeMounts:
          - mountPath: /exports
            name: hpcc-share
      volumes:
        - name: hpcc-share
          awsElasticBlockStore:
            volumeID: vol-4aa30797
            fsType: ext4
```
Deploy nfs server:
```sh
kubectl create -f nfs-server-rc.yaml
```
Create a service for NFS server:  nfs nfs-server-service.yaml
```sh
apiVersion: v1
kind: Service
metadata:
  name: nfs-server
spec:
  ports:
    - name: nfs
      port: 2049
    - name: mountd
      port: 20048
    - name: rpcbind
      port: 111
  selector:
    role: nfs-server
```
Deploy nfs service
```sh
   kubectl create -f nfs-server-service.yaml
```

Get NFS service IP
```sh
kubectl get service -o json | grep IP
```

Create a Persistent Volume (PV) for NFS storage  nfs-pv.yaml
It will reference NFS service IP
```sh
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nfs
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteMany
  nfs:
    # FIXME: use the right IP
    server: 10.0.202.122
    path: "/exports"

```

Enable it
```sh
kubectl create -f nfs-pv.yaml
```

Create a Persistent Volume Claim (PVC): nfs-pvc.yaml
The PVC should  have the same name as PV
Every pod want to use the NFS will reference this PVC
```sh
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nfs
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Gi
```

Enable it
```sh
kubectl create -f nfs-pvc.yaml
```

### Add Volumes to Pod/ReplicateController
As an example we will add to roxie ReplicateController
It will reference EBS id for individual storage and PVC for NFS storage
roxie-controller.yaml:
```sh
apiVersion: v1
kind: ReplicationController
metadata:
  name: roxie-controller
spec:
  replicas: 1
  selector:
    app: roxie
  template:
    metadata:
      labels:
        app: roxie
    spec:
      containers:
        - name: roxie
          image: "hpccsystems/platform-ce:6.0.2-1trusty"
          volumeMounts:
            - mountPath: "/hpcc-share"
              name: nfs
            - mountPath: "/disk1"
              name: disk1
      volumes:
        - name: nfs
          persistentVolumeClaim:
            claimName: nfs
        - name: disk1
          awsElasticBlockStore:
            volumeID: vol-233c99fe
            fsType: ext4
```
Deploy roxie:
```sh
kubectl create -f roxie-controller.yaml
```

To check if it up:
```sh
kubectl get pods
```
To access to check the volumes:
```sh
kubectl exec -i -t <name> -- bash -il
dk -h
```
