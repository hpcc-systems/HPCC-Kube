# Kubernetes Playground for HPCC Systems Products

This repo has several HPCC Systems Cluster examples on Kubernetes


## Prerequisites

For general kubectl installation reference https://kubernetes.io/docs/tasks/tools/install-kubectl/

We currently tested two cloud environments: [AWS/EKS](./aws/EKS/README.md) and [Local](./local/README.md)


## Bootstrap
Bootstrap will grant access permission for Kubernetes APIs as well create configmap for environmet.xml configuration
Depands on the Kubernetes environment configmap files may be different. Currently there is aws/configmap/hpcc for AWS environment and the other one is local/configmap/hpcc for local deployment.
In bin directory
```sh
# AWS
bin/bootstrap-aws.sh

# Local
bin/bootstrap-local.sh
or on Windows
bootstrap.bat
```
User can modify security/cluster_role.yaml and files under configmap/hpcc

## Pod
Deploy HPCC Systems Platform on single node
Reference [README.md](Pod/README.md)

## Deployment
Deploy HPCC Systems cluster with Deployment Pod definition.
Reference [README.md](Deployment/dp-1/README.md)

## RelicationController
Deploy HPCC Systems cluster with RelicationController Pod definition.
It is recommended to use "Deployment" instead

## [StatefulSet](StatefulSet/README.md)
Deploy HPCC Systems cluster with StatefulSet Pod definition.
It includs ebs and nfs examples
Reference
  . [EBS README.md](StatefulSet/ebs/ebs-1/README.md)
  . [EFS README.md](StatefulSet/efs/efs-1/README.md)

## istio
Show some features of ISTIO on local Kubernetes environment
Reference [README.md](istio/demo/README.md)

## charts

[Helm Charts for HPCC Systems Cluster](charts/README.md)
Mainly two charts:
- hpcc-dp: deploy a cluster with Deployments/EFS.  EFS can be turn off so the cluster can be deployed in local environment
- hpcc-ss: deploy a cluster with StatefulSets/EBS


## local
Local Kubernetes setup instruction

## security
RBAC settings for Kubernetes environment

## aws
AWS related settings

## elastic
Filebeat, Metricbeat, etc example on local Kubernetes environment.
Still in progress ...

## performance
To do
