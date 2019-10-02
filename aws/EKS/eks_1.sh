#!/bin/bash
# [✖]  AWS::EKS::Cluster/ControlPlane: CREATE_FAILED – "Cannot create cluster 'hpcc1' because us-east-1e, the targeted availability zone, does not currently have sufficient capacity to support the cluster. Retry and choose from these availability zones: us-east-1a, us-east-1b, us-east-1c, us-east-1d, us-east-1f (Service: AmazonEKS; Status Code: 400; Error Code: UnsupportedAvailabilityZoneException; Request ID: 94324754-4460-4e06-941a-26553c3c23a0)"
#us-east-1a us-east-1b us-east-1c us-east-1d but not us-east-1e
export KUBE_ZONE=us-east-1b
export KUBE_ZONE2=us-east-1c
eksctl create cluster \
	--name hpcc1 \
	--zones $KUBE_ZONE --zones $KUBE_ZONE2 \
	--version 1.13 \
	--nodegroup-name standard-workers \
	--node-type m4.2xlarge \
	--nodes 3 \
	--nodes-min 1 \
	--nodes-max 4 \
	--node-volume-size 100 \
	--node-ami auto \
	--tags "application=hpccsystems,lifecycle=dev,market=hpccsystems" \
	--tags "owner_email=xiaoming.wang@lexisnexis.com" \
	--tags "support_email=xiaoming.wang@lexisnexis.com" \
	--tags "product=hpccsystems,project=hpcc builds,service=ecs"
