# EFS Pod
Image: https://quay.io/repository/external_storage/efs-provisioner?tab=tags
## Prerquisities
Need apply bin/bootstrap-aws.sh first (why?)

## Debug
If efs-provisioner pod failed check with:
- kubectl describe pod <pod name>
- kubectl logs <pod name>

### v2.3.0 error
The latest efs-provisioner quay.io/external_storage/efs-provisioner:latest (v2.3.0) fails with error
```console
kubectl logs efs-provisioner-57965c4946-vw8r4
/efs-provisioner flag redefined: log_dir
panic: /efs-provisioner flag redefined: log_dir

goroutine 1 [running]:
flag.(*FlagSet).Var(0xc000086180, 0x159ed00, 0x214fe70, 0x13da152, 0x7, 0x1405662, 0x2f)
        /usr/local/go/src/flag/flag.go:805 +0x529
flag.(*FlagSet).StringVar(0xc000086180, 0x214fe70, 0x13da152, 0x7, 0x0, 0x0, 0x1405662, 0x2f)
        /usr/local/go/src/flag/flag.go:708 +0x8a
github.com/kubernetes-incubator/external-storage/vendor/k8s.io/klog.InitFlags(0xc000086180)
        /go/src/github.com/kubernetes-incubator/external-storage/vendor/k8s.io/klog/klog.go:411 +0x7b
main.main()
        /go/src/github.com/kubernetes-incubator/external-storage/aws/efs/cmd/efs-provisioner/efs-provisioner.go:275 +0x3c
```
