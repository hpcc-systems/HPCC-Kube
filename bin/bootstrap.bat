kubectl.exe create configmap hpcc-config --from-file=../local/configmap/hpcc/
kubectl.exe apply -f ../security/cluster_role.yaml
