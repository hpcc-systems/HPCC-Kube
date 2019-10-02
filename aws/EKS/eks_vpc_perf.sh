#!/bin/bash
# [✖]  AWS::EKS::Cluster/ControlPlane: CREATE_FAILED – "Cannot create cluster 'hpcc1' because us-east-1e, the targeted availability zone, does not currently have sufficient capacity to support the cluster. Retry and choose from these availability zones: us-east-1a, us-east-1b, us-east-1c, us-east-1d, us-east-1f (Service: AmazonEKS; Status Code: 400; Error Code: UnsupportedAvailabilityZoneException; Request ID: 94324754-4460-4e06-941a-26553c3c23a0)"
#us-east-1a us-east-1b us-east-1c us-east-1d but not us-east-1e
export KUBE_ZONE=us-east-1b
export KUBE_ZONE2=us-east-1c
eksctl create cluster \
	--name hpcc-perf2 \
	--version 1.13 \
	--nodegroup-name standard-workers \
        --node-type m5.12xlarge \
	--nodes 1 \
	--nodes-min 1 \
	--nodes-max 1 \
	--node-volume-size 200 \
	--node-ami auto \
	--vpc-public-subnets subnet-9e08ecd3 \
        --vpc-public-subnets subnet-eaacfdb6 \
	--node-security-groups sg-397a1a62 \
	--tags "application=hpccsystems,lifecycle=dev,market=hpccsystems" \
	--tags "owner_email=xiaoming.wang@lexisnexis.com" \
	--tags "support_email=xiaoming.wang@lexisnexis.com" \
	--tags "product=hpccsystems,project=hpcc builds,service=ecs"
# --region us-east-1 \
# vpc setting can co-existi with zones settings
#  vCPU 8, Mem (GiB) 32
#--node-type m4.2xlarge \
#--node-type m5.12xlarge \
# us-east-1c
#--vpc-public-subnets subnet-eaacfdb6 \
# us-east-1b
#--vpc-public-subnets subnet-9e08ecd3 \
