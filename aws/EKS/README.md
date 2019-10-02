# Set [Elastic Kubernetes Service (EKS)](https://aws.amazon.com/eks) for HPCC Systems

## Install ##
### IAM User Permissions ###
A IAM user with following permissions:
. IAM_READ_TAG
. AmazonEC2FullAccess
. AWSClooudFormationFullAccess
. AWSEFSFullAccess
. AWSEFSFullAccess (optional, required if use EFS)


### Install the AWS CLI ###
https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html

### Install eksctl kubectl ###
https://docs.aws.amazon.com/eks/latest/userguide/getting-started-eksctl.html


## Run EKS Cluster
### EKS support instance typies
t2, m3, m4, m5, c4, c5, i3, r3, r4, x1, p2 and p3

### Create EKS cluster ###
EKS cluster requires at two Available Zones (AZs).
Two samples are provided:
. eks_1.sh
. eks_vpc.sh: this try to use existing VPC/Subnets but doesn't work. We are working with AWS support on it now

### Query EKS ###
Query EKS cluster
```sh
eksctl get cluster
```
When ESK cluster created successfully it should be in ~/.kube/config.  kubectl need this information to deploy clusters.
If the EKS cluster doesn't exists in ~/.kube/config, for example you are in a different system than the original one to create EKS cluster, you can run following to create this configuration file:
```sh
eksctl utils write-kubeconfig --name <cluster name>
```

### Delete EKS cluster ###
```sh
./stop <cluster name>
```
The default <cluster name> is "hpcc1" which is defined in start script.
