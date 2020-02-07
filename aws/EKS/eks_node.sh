eksctl create nodegroup \
	--cluster hpcc-vpa \
	--version auto \
	--name vpa-workers \
	--node-type m4.2xlarge
	--node-ami auto \
	--nodes 3 \
	--nodes-min 1 \
	--nodes-max 4
