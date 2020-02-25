# MiniKube


## Installation

Installation: https://kubernetes.io/docs/tasks/tools/install-minikube/
Start minikube
  1. minikube start -p minikube
  2. change setting:
    1. minikube stop -p minikube
    2. minikube.exe --vm-driver=virtualbox --cpus 4 --disk-size 100g --memory 8192 start -p minikube

## bootstrap
This will setup ConfigMap and grant security permissions
```sh
cd bin/
./bootstrap-local.sh
# or on Windows
./bootstrap.bat
```

## Start and Stop Cluster
All following assume in directory of github project HPCC-Kubernetes.
The Kubernetes client wraper is "kubectl.sh" on Unix and "kubectl.exe" on Windows. In some providers it can be just named "kubectl". "kubectl.sh" is used here.