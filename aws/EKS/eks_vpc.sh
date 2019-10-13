#!/bin/bash
################################################################################
#    HPCC SYSTEMS software Copyright (C) 2019 HPCC Systems®   .
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
################################################################################

# [✖]  AWS::EKS::Cluster/ControlPlane: CREATE_FAILED – "Cannot create cluster 'hpcc1' because us-east-1e, the targeted availability zone, does not currently have sufficient capacity to support the cluster. Retry and choose from these availability zones: us-east-1a, us-east-1b, us-east-1c, us-east-1d, us-east-1f (Service: AmazonEKS; Status Code: 400; Error Code: UnsupportedAvailabilityZoneException; Request ID: 94324754-4460-4e06-941a-26553c3c23a0)"
#us-east-1a us-east-1b us-east-1c us-east-1d but not us-east-1e
export KUBE_ZONE=us-east-1b
export KUBE_ZONE2=us-east-1c
eksctl create cluster \
	--name hpcc3 \
	--version 1.13 \
	--nodegroup-name standard-workers \
	--node-type m4.2xlarge \
	--nodes 3 \
	--nodes-min 1 \
	--nodes-max 4 \
	--node-volume-size 100 \
	--node-ami auto \
	--vpc-public-subnets subnet-eaacfdb6 \
	--vpc-public-subnets subnet-9e08ecd3 \
	--node-security-groups sg-397a1a62 \
	--tags "application=hpccsystems,lifecycle=dev,market=hpccsystems" \
	--tags "owner_email=xiaoming.wang@lexisnexis.com" \
	--tags "support_email=xiaoming.wang@lexisnexis.com" \
	--tags "product=hpccsystems,project=hpcc builds,service=ecs"
# --region us-east-1 \
# vpc setting can co-existi with zones settings
