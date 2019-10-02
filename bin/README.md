# HPCC Systems Kubernetes Command-line Tools

## bootstrap
Grant Kubernetes API roles
Create ConfigMap for environment.xml generation

### AWS:
```console
./bootstrap-aws.sh
```

### Local
On Unix:
```console
./bootstrap-local.sh
```
On Windows
```console
bootstrap.bat
```
### Apply RBAC only
Grant Kubernetes API roles only
```console
./bootstrap-rbac-only.sh
```
User need apply ConfigMap for environment.xml in the start-up cluster script


## Start/Stop/Get Status
### On Unix
```console
./cluster_run.sh  <start|stop|status>
```

### On Windows
```console
./cluster_run.ps1 -action <start|stop|status>
```

## Config Manager
Usually config manager is started on admin Pod. User can create/modify environment.xml and stop cluster, transfer environment.xml and start cluster

### Start config manager
```console
./start_configmgr.sh
```


### Transfer environment.xml
This includes three steps:
- Stop the cluster
- Transfer the environment.xml to every node
- Start the cluster

Normally run as
```console
./cluster_env.sh
```

Run ./cluster_env.sh --help for other options.
